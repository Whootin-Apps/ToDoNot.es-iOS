//
//  InstagramAPI.m
//  InstaMemory
//
//  Created by Ivica Aracic on 08.08.11.
//  Copyright 2011 Ivica Aracic. All rights reserved.
//

 
#import "InstagramAPI.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "NSString+SBJSON.h"

//=========================
// CLIENT SPECIFIC CONFIG

#define kAppId @""
#define RESPONSE_URL (@"http://callbackuri.com/")

// API CACHE
#define REQUEST_CACHE_INTERVAL_SEC 60       // in s

// IMAGE CACHE
#define CACHE_MAX_SIZE (8*1024*1024)   // 8MB
#define DOWNLOAD_QUEUE_MAX_CONCURRENT_OPS 3

#define API_SCOPE @"likes+comments+relationships"

//==========================

#define ACCESS_TOKEN_KEY            @"instagram-accessToken"
#define ACCESS_LOGGED_USER_JSON     @"instagram-logged-user-json"

#define BASE_URL @"https://api.instagram.com/v1"


NSString* ACTION_IMG_DOWNLOAD = @"ACTION_IMG_DOWNLOAD";
NSString* ACTION_GET_USER_MEDIA_RECENT = @"ACTION_GET_USER_MEDIA_RECENT";
NSString* ACTION_GET_USER_MEDIA_LIKED = @"ACTION_GET_USER_MEDIA_LIKED";
NSString* ACTION_GET_USER_FEED = @"ACTION_GET_USER_FEED";
NSString* ACTION_GET_MEDIA_POPULAR = @"ACTION_GET_MEDIA_POPULAR";
NSString* ACTION_GET_TAG_MEDIA_RECENT = @"ACTION_GET_TAG_MEDIA_RECENT";
NSString* ACTION_POST_MEDIA_LIKE = @"ACTION_POST_MEDIA_LIKE";
NSString* ACTION_DELETE_MEDIA_LIKE = @"ACTION_DELETE_MEDIA_LIKE";
NSString* ACTION_GET_USER_SELF = @"ACTION_GET_USER_SELF";
NSString* ACTION_POST_USERS_FOLLOW = @"ACTION_POST_USERS_FOLLOW";
NSString* ACTION_GET_USERS_SEARCH = @"ACTION_GET_USERS_SEARCH";


static NSString* USER_INFO_KEY_ACTION = @"action";
static NSString* USER_INFO_KEY_IMG_ID = @"imgId";
static NSString* USER_INFO_KEY_USER_INFO = @"userInfo";

//==========================

@interface InstagramCacheItem : NSObject {
    NSString* filename;
    NSDictionary* attributes;
}

@property (nonatomic, retain) NSString* filename;
@property (nonatomic, retain) NSDictionary* attributes;
@property (nonatomic, readonly) NSNumber* fileSize;
@property (nonatomic, readonly) NSDate* modificationDate;

- (id) initWithFilename:(NSString*)_filename withAttributes:(NSDictionary*)attrs;

@end
// ---------------------------
@implementation InstagramCacheItem 
@synthesize filename, attributes;

- (id) initWithFilename:(NSString*)_filename withAttributes:(NSDictionary*)attrs {
    if((self = [super init])) {
        self.filename = _filename;
        self.attributes = attrs;
    }
    
    return self;
}

- (void) dealloc {
    [filename release];
    [attributes release];
    
    [super dealloc];
}

- (NSNumber*) fileSize {
    return [attributes objectForKey:NSFileSize];   
}

- (NSDate*) modificationDate {
    return [attributes objectForKey:NSFileModificationDate];   
}

@end

//==========================

@interface ApiRequestCacheItem : NSObject {
    NSDate* timestamp;
    id obj;
}

@property (readonly, nonatomic) BOOL valid;
@property (readonly, nonatomic) NSDate* timestamp;
@property (readonly, nonatomic) id obj;

@end
// ---------------------------
@implementation ApiRequestCacheItem 

@synthesize timestamp, obj;

- (BOOL) valid {
    NSTimeInterval timeInterval = [timestamp timeIntervalSinceNow];
    BOOL res = timeInterval + REQUEST_CACHE_INTERVAL_SEC > 0;
    
    if(!res) {
        NSLog(@"apiCallCache: invalid entry detected (timeInterval=%f)", timeInterval);
    }
    
    return res;
}

- (id) initWithObj:(id)_obj {
    if((self = [super init])) {
        timestamp = [[NSDate alloc] init];
        obj = [_obj retain];
    }
    
    return self;
}

- (void) dealloc {
    [timestamp release];
    [obj release];
    [super dealloc];
}

@end
//==========================

@interface InstagramAPI () 
- (void) checkCacheFolder:(NSString*)folder checkNowFlag:(BOOL)flag;
@end

@implementation InstagramAPI

@synthesize accessToken, userJson, reqDelegate;

- (id) init {
    if((self = [super init])) {
        downloadQueue = [[NSOperationQueue alloc] init];
        downloadQueue.maxConcurrentOperationCount = DOWNLOAD_QUEUE_MAX_CONCURRENT_OPS;
        
        commandQueue = [[NSOperationQueue alloc] init];
        commandQueue.maxConcurrentOperationCount = 1;
        
        apiCallCache = [[NSMutableDictionary alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
        self.userJson = [defaults objectForKey:ACCESS_LOGGED_USER_JSON];
        
        // check if we have a cache folder in Document
        NSError* error = nil;
        
        NSFileManager* fm = [NSFileManager defaultManager];
        
        NSArray *_cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *_cacheDirectory = [_cachePaths objectAtIndex:0]; 
        
        NSString* cacheFolder = [NSString stringWithFormat:@"%@cache/", _cacheDirectory];
        
        if(![fm fileExistsAtPath:cacheFolder]) {
            NSLog(@"making cache directory");
            [fm createDirectoryAtPath:cacheFolder withIntermediateDirectories:NO attributes:nil error:&error];
        }
        
        // check cache on init
        [self checkCacheFolder:cacheFolder checkNowFlag:YES];
    }
    
    return self;
}

- (void) dealloc {
    [apiCallCache release];
    
    [accessToken release];
    [userJson release];
    [reqDelegate release];
    
    [downloadQueue release];
    
    [commandQueue release];
    
    [super dealloc];
}

- (void) loadSettings {
}

- (NSString*) username {
    NSString* res = nil;
    
    if(userJson != nil) {
        res = [userJson objectForKey:@"username"];
    }
    
    return res;
}

- (NSString*) profileImg {
    NSString* res = nil;
    
    if(userJson != nil) {
        res = [userJson objectForKey:@"profile_image"];
    }
    
    return res;
}

- (void) loginOrLogout {
    if([self isSessionValid]) {
		[self logout];
	}
	else {
		[self login];
	}
}

- (NSString*) getResponseUrl {
    return RESPONSE_URL;
}

- (NSString*) getLoginUrl {
    NSString* responseUrl = [[self getResponseUrl] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString* reqUrl = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&display=touch", 
                        kAppId, responseUrl,API_SCOPE];
    
    return reqUrl;
}

- (NSString*) getLogoutUrl {
    return @"https://instagram.com/accounts/logout/";
}


- (void) login {
    if([self isSessionValid]) return;
    
    NSString* reqUrl = [self getLoginUrl];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reqUrl]];   
}

- (void) logout {
    self.accessToken = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:ACCESS_TOKEN_KEY];
    
    [defaults synchronize];
}

- (BOOL) isSessionValid {
    return accessToken != nil;
}

- (NSDictionary*)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

- (BOOL) handleOpenURL:(NSURL*)url {
    /*
    STEP TWO: RECEIVE THE REDIRECT FROM INSTAGRAM
    Once a user successfully authenticates and authorizes your application, we will redirect the user to your redirect_uri with a code parameter that you'll use in step three.
    
    http://your-redirect-uri?code=CODE
    If this request for approval is denied, then we will redirect the user to your redirect_uri with the following parameters:
    
    error: access_denied
    error_reason: user_denied
    error_description: The user denied your request
    http://your-redirect-uri?error=access_denied&error_reason=user_denied&error_description=The+user+denied+your+request
    It is your responsibility to fail gracefully in this situation and display a corresponding error message to your user.
    */
    
    NSString *query = [url fragment];
    
    if (!query) {
        query = [url query];
    }
    
    NSDictionary* params = [self parseURLParams:query];
    self.accessToken = [params valueForKey:@"access_token"];
    
    if (accessToken != nil) {
        NSLog(@"Instagram Access Token Obtained = %@", accessToken);
        
        NSString* apiCall = [NSString stringWithFormat:BASE_URL @"/users/self?access_token=%@", accessToken];
        [self execInstagramAPICall:apiCall andAction:ACTION_GET_USER_SELF withUserInfo:nil];
    }
    else {
        NSString *errorReason = [params valueForKey:@"error"];
        
        NSLog(@"Instagram Auth ERROR: %@", errorReason);
    }
    
    return YES;
}

- (void) accessTokenExpired {
    [self logout];
}

static InstagramAPI* INSTANCE = nil;
+ (InstagramAPI*) sharedInstance {
    if(INSTANCE == nil) {
        INSTANCE = [[InstagramAPI alloc] init];
    }
    
    return INSTANCE;
}

- (void) touchFileInCache:(NSString*)file {
    NSError* error = nil;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSDate* now = [[NSDate alloc] init];
    
    [fm setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:now, NSFileModificationDate, nil] 
         ofItemAtPath:file 
                error:&error];
    
    [now release];
}

- (void) checkCacheFolder:(NSString*)cacheFolder checkNowFlag:(BOOL)checkNowFlag {
    #define CHECK_COUNTER 48
    static int counter = CHECK_COUNTER;
    
    NSError* error = nil;
    
    if(counter <= 0 || checkNowFlag) {
        // do the check
        counter = CHECK_COUNTER;
        
        NSLog(@"!!! checkCacheFolder !!!");
        
        NSFileManager* fm = [NSFileManager defaultManager];
        
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:cacheFolder];
        
        NSString* file;
        
        int cacheSizeSum = 0;
        
        NSMutableArray* cacheItems = [[NSMutableArray alloc] init];
        
        while ((file = [dirEnum nextObject])) {
            NSString* fullPath = [cacheFolder stringByAppendingString:file];
            NSDictionary* attrs = [fm attributesOfItemAtPath:fullPath error:&error];
    
            InstagramCacheItem* cacheItem = [[InstagramCacheItem alloc] initWithFilename:fullPath withAttributes:attrs];
            [cacheItems addObject:cacheItem];
            
            NSNumber* fileSize = cacheItem.fileSize;
            
            cacheSizeSum += [fileSize intValue];
            
            [cacheItem release];
        }
        
        if(cacheSizeSum > CACHE_MAX_SIZE) {
            NSLog(@"!! starting clearing cache (size=%d)", cacheSizeSum);
            // sort by the modification date (oldest first)
            NSArray* cacheItemsSorted = 
            [cacheItems sortedArrayUsingComparator:^NSComparisonResult(id i1, id i2) {
                NSTimeInterval d1 = [[i1 modificationDate] timeIntervalSinceReferenceDate];
                NSTimeInterval d2 = [[i2 modificationDate] timeIntervalSinceReferenceDate];
                
                if (d1 < d2) return NSOrderedAscending;
                else if (d1 > d2) return NSOrderedDescending;
                else return NSOrderedSame;   
            }];
            
            for(InstagramCacheItem* cacheItem in cacheItemsSorted) {
                NSLog(@"\tremoving cache item %@ (%@, %@)", cacheItem.filename, cacheItem.fileSize, cacheItem.modificationDate);

                [fm removeItemAtPath:cacheItem.filename error:&error];
                cacheSizeSum -= [cacheItem.fileSize intValue];
                
                if(cacheSizeSum < CACHE_MAX_SIZE) {
                    NSLog(@"\tcache size reduced to %d", cacheSizeSum);
                    break;
                }
            }
        }
        
        
        [cacheItems release];
    }
    
    counter--;
}

- (void) startImgDownload:(NSString*)imgUrl withUserInfo:(NSDictionary*)_userInfo withPutInDownloadQueue:(BOOL)putInDownloadQueue {
    
    NSString* imgId = [imgUrl lastPathComponent];
    
    NSLog(@"instagram api img download = (%@) '%@'", imgId, imgUrl);
    
  //  NSError* error = nil;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    
    NSArray *_cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_cacheDirectory = [_cachePaths objectAtIndex:0]; 
    
    NSString* cacheFolder = [NSString stringWithFormat:@"%@cache/", _cacheDirectory];
    
  //  NSString* cacheFolder = [DOCUMENTS_FOLDER stringByAppendingString:@"cache/"];
    
    NSString* imgFilePath = [cacheFolder stringByAppendingString:imgId];

    if([fm fileExistsAtPath:imgFilePath]) {
        NSLog(@".... already downloaded.");
        [self touchFileInCache:imgFilePath];
        
        [reqDelegate imgDownloadFinishedWithLocalPath:imgFilePath withUserInfo:_userInfo];
    }
    else {
        ASIHTTPRequest* req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:imgUrl]];
        req.downloadDestinationPath = imgFilePath;
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  ACTION_IMG_DOWNLOAD, USER_INFO_KEY_ACTION, 
                                  imgId, USER_INFO_KEY_IMG_ID,
                                  _userInfo, USER_INFO_KEY_USER_INFO,
                                  nil];
        
        req.userInfo = userInfo;
        
        req.delegate = self;
        
        if(putInDownloadQueue) {
            [downloadQueue addOperation:req];
        }
        else {
            [req startAsynchronous];
        }
    }
    
    [self checkCacheFolder:cacheFolder checkNowFlag:NO];
}

- (void) purgeDownloadQueue {
    [downloadQueue cancelAllOperations];
}

- (void) _removeFirstInvalidApiCallCacheEntry {
    for(NSString* key in [apiCallCache allKeys]) {
        ApiRequestCacheItem* item = [apiCallCache objectForKey:key];
        
        if(!item.valid) {
            [apiCallCache removeObjectForKey:key];
            NSLog(@"apiCallCache: _removeFirstInvalidApiCallCacheEntry: '%@', items=%d", key, [apiCallCache count]);
            break;
        }
    }
}

- (void) execInstagramAPICall:(NSString*)url andAction:(NSString*)_action withUserInfo:(NSDictionary*)_userInfo {
    NSLog(@"execInstagramAPICall: '%@'", url);
    
    if(![self isSessionValid]) {
        // check if we have something in cache
        ApiRequestCacheItem* item = [apiCallCache objectForKey:url];
        
        if(item != nil) {
            if(item.valid) {
                NSLog(@"apiCallCache: returning cached item");
                [reqDelegate requestFinished:_action
                                withResponse:item.obj 
                                withUserInfo:_userInfo];
                return;
            }
            else {
                NSLog(@"apiCallCache: removing an invalid item from cache");
                [apiCallCache removeObjectForKey:url];
            }
        }
    }
    
    ASIHTTPRequest* req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_action, USER_INFO_KEY_ACTION, _userInfo, USER_INFO_KEY_USER_INFO, nil];
    
    req.userInfo = userInfo;
    
    req.delegate = self;
    
    [commandQueue addOperation:req];
    //[req startAsynchronous];
}

- (void) execInstagramAPIPostCall:(NSString*)url 
                        andAction:(NSString*)_action 
                     withUserInfo:(NSDictionary*)_userInfo 
                withPostParameter:(NSDictionary*)postParams {
    NSLog(@"execInstagramAPIPostCall: '%@'", url);
    
    ASIFormDataRequest* req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_action, USER_INFO_KEY_ACTION, _userInfo, USER_INFO_KEY_USER_INFO, nil];
    
    req.userInfo = userInfo;
    
    for(NSString* key in [postParams allKeys]) {
        [req setPostValue:[postParams objectForKey:key] forKey:key];
    }
    
    req.delegate = self;
    
    [commandQueue addOperation:req];
    //[req startAsynchronous];
}

- (void) execInstagramAPIDeleteCall:(NSString*)url 
                        andAction:(NSString*)_action 
                     withUserInfo:(NSDictionary*)_userInfo {
    NSLog(@"execInstagramAPIDeleteCall: '%@'", url);
    
    ASIHTTPRequest* req = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_action, USER_INFO_KEY_ACTION, _userInfo, USER_INFO_KEY_USER_INFO, nil];
    
    req.userInfo = userInfo;
    
    req.requestMethod = @"DELETE";
    
    req.delegate = self;
    
    [commandQueue addOperation:req];
    //[req startAsynchronous];
}

- (void) callUserMediaRecent:(NSString*)userId withCount:(int)count withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/%@/media/recent?access_token=%@&count=%d", userId, accessToken, count];
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USER_MEDIA_RECENT withUserInfo:userInfo];
}

- (void) callUserMediaRecent:(NSString*)userId withCount:(int)count withMaxId:(int)maxId withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/%@/media/recent?access_token=%@&count=%d&max_id=%d", userId, accessToken, count, maxId];
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USER_MEDIA_RECENT withUserInfo:userInfo];
}

- (void) callUserMediaLikedWithCount:(int)count withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/self/media/liked?access_token=%@&count=%d", accessToken, count];
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USER_MEDIA_LIKED withUserInfo:userInfo];
}

- (void) callUserMediaLikedWithCount:(int)count withMaxId:(int)maxId withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/self/media/liked?access_token=%@&count=%d&max_id=%d", accessToken, count, maxId];
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USER_MEDIA_LIKED withUserInfo:userInfo];
}

- (void) callUserFeedWithCount:(int)count withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/self/feed?access_token=%@&count=%d", accessToken, count];
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USER_FEED withUserInfo:userInfo];
}

- (void) callUserFeedWithCount:(int)count withMaxId:(int)maxId withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/self/feed?access_token=%@&count=%d&max_id=%d", accessToken, count, maxId];
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USER_FEED withUserInfo:userInfo];
}

- (void) callMediaPopularWithUserInfo:(NSDictionary*)userInfo {
    NSString* url = nil;
    
    if([self isSessionValid]) {
        url = [NSString stringWithFormat:BASE_URL @"/media/popular?access_token=%@", accessToken];    
    }
    else {
        url = [NSString stringWithFormat:BASE_URL @"/media/popular?client_id=%@", kAppId];    
    }

    [self execInstagramAPICall:url andAction:ACTION_GET_MEDIA_POPULAR withUserInfo:userInfo];
}

- (void) callTagMediaRecent:(NSString*)_tag withUserInfo:(NSDictionary*)userInfo{
    NSString* tag = [_tag stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
    NSString* url = nil;
    
    if([self isSessionValid]) {
        url = [NSString stringWithFormat:BASE_URL @"/tags/%@/media/recent?access_token=%@", tag, accessToken];
    }
    else {
        url = [NSString stringWithFormat:BASE_URL @"/tags/%@/media/recent?client_id=%@", tag, kAppId];
    }
    
   [self execInstagramAPICall:url andAction:ACTION_GET_TAG_MEDIA_RECENT withUserInfo:userInfo];
}

- (void) _removeRedundantMediaLikeUnlikeCalls:(NSString*)mediaId {
    // go through the commandQueue and remove all operations that are related to this like request
    [commandQueue setSuspended:YES];
    
    for(ASIHTTPRequest* op in commandQueue.operations) {
        NSString* urlStr = op.url.absoluteString;
        
        NSRange textRange = [urlStr rangeOfString:[NSString stringWithFormat:@"/media/%@/likes", mediaId]];
        
        if(textRange.location != NSNotFound) {
            NSLog(@"cancel operation: '%@', method='%@'", urlStr, op.requestMethod);
            [op cancel];
        }
    }
    
    [commandQueue setSuspended:NO];
}

- (void) callMediaLike:(NSString*)mediaId withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/media/%@/likes/", mediaId];
    
    [self _removeRedundantMediaLikeUnlikeCalls:mediaId];
    
    [self execInstagramAPIPostCall:url andAction:ACTION_POST_MEDIA_LIKE withUserInfo:userInfo withPostParameter:[NSDictionary dictionaryWithObjectsAndKeys:accessToken, @"access_token", nil]]; 
}

- (void) callDeleteMediaLike:(NSString*)mediaId withUserInfo:(NSDictionary*)userInfo {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/media/%@/likes?access_token=%@", mediaId, accessToken];
    
    [self _removeRedundantMediaLikeUnlikeCalls:mediaId];
    
    [self execInstagramAPIDeleteCall:url andAction:ACTION_DELETE_MEDIA_LIKE withUserInfo:userInfo]; 
}

- (void) callFollowUser:(NSString*)userId {
    NSString* url = [NSString stringWithFormat:BASE_URL @"/users/%@/relationship", userId];
    
    [self execInstagramAPIPostCall:url andAction:ACTION_POST_USERS_FOLLOW withUserInfo:nil withPostParameter:[NSDictionary dictionaryWithObjectsAndKeys:accessToken, @"access_token", @"follow", @"action", nil]]; 
}

- (void) callUsersSearch:(NSString*)q withLimit:(int)limit withUserInfo:(NSDictionary*)userInfo {
    q = [q stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    NSString* url = nil;
    
    if([self isSessionValid]) {
         url = [NSString stringWithFormat:BASE_URL @"/users/search?q=%@&count=%d&access_token=%@", q, limit, accessToken];
    }
    else {
        url = [NSString stringWithFormat:BASE_URL @"/users/search?q=%@&count=%d&client_id=%@", q, limit, kAppId];
    }
        
    
    [self execInstagramAPICall:url andAction:ACTION_GET_USERS_SEARCH withUserInfo:userInfo];
}


// ===========
#pragma mark asihttp callbacks

- (void)requestStarted:(ASIHTTPRequest *)request {
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString* action = [request.userInfo objectForKey:USER_INFO_KEY_ACTION];
    
    NSLog(@"request finished (%@)", action);
    
#ifndef APPSTOREFINAL
    NSDictionary* responseHeaders = request.responseHeaders;
    
    NSString* rateLimitRemaining = [responseHeaders objectForKey:@"X-Ratelimit-Remaining"];

    if(rateLimitRemaining != nil) {
        NSLog(@"!!RATE LIMIT REMAINING: %@", rateLimitRemaining);
    }
#endif
    
    NSString* resString = [request responseString];
        
    NSDictionary* userInfo = [request.userInfo objectForKey:USER_INFO_KEY_USER_INFO];
    
    if([action isEqualToString:ACTION_IMG_DOWNLOAD]) {
        //NSString* imgId = [request.userInfo objectForKey:USER_INFO_KEY_IMG_ID];
        
        [reqDelegate imgDownloadFinishedWithLocalPath:request.downloadDestinationPath withUserInfo:userInfo];
    }
    else if([action isEqualToString:ACTION_GET_USER_SELF]) {
        
        id json = [resString JSONValue];
        
        self.userJson = [json objectForKey:@"data"];
        
        NSLog(@"storing user info: access_token=%@, username=%@", self.accessToken, self.username);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:accessToken forKey:ACCESS_TOKEN_KEY];
        [defaults setValue:userJson forKey:ACCESS_LOGGED_USER_JSON];
        
        [defaults synchronize];
        
        [reqDelegate loggedUserDataReady:userJson username:self.username];
    }
    else {
        id obj = [resString JSONValue];
        
        if(![self isSessionValid]) {
            ApiRequestCacheItem* item = [[ApiRequestCacheItem alloc] initWithObj:obj];
            
            NSString* url = request.url.absoluteString;
            
            [apiCallCache setObject:item forKey:url];
            
            [self _removeFirstInvalidApiCallCacheEntry];
            
            NSLog(@"apiCallCache: caching '%@' (items=%d)", url, [apiCallCache count]);
            
            [item release];
        }
        
        [reqDelegate requestFinished:action
                        withResponse:obj
                        withUserInfo:userInfo];
    }
    
    [request release];    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSString* action = [request.userInfo objectForKey:USER_INFO_KEY_ACTION];
        
    if(![request isCancelled]) {
        //NSError* error = [request error];
        NSLog(@"request failed (%@)", action);
        
        NSDictionary* userInfo = [request.userInfo objectForKey:USER_INFO_KEY_USER_INFO];
        
        if([action isEqualToString:ACTION_IMG_DOWNLOAD]) {
            //NSString* imgId = [request.userInfo objectForKey:USER_INFO_KEY_IMG_ID];
            
            [reqDelegate imgDownloadFailedWithUserInfo:userInfo];
        }
        else {
            [reqDelegate requestFailed:action withUserInfo:userInfo];
        }
    }
    else {
        NSLog(@"request cancelled (%@)", action);
    }

    [request release];
}

- (void)requestRedirected:(ASIHTTPRequest *)request {
}


#pragma mark local hooks

- (void) openUser:(NSString*)_username {
    NSString* urlString = nil;
    
    if([self isInstagramInstalled]) {
        urlString = [NSString stringWithFormat:@"instagram://user?username=%@", _username];
    }
    else {
        urlString = [NSString stringWithFormat:@"http://web.stagram.com/n/%@/", _username];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void) openMedia:(NSString*)mediaId {
    NSString* urlString = nil;
    
    if([self isInstagramInstalled]) {
        urlString = [NSString stringWithFormat:@"instagram://media?id=%@", mediaId];
    }
    else {
        // no way to link a photo in webstagram?
        return;
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (BOOL) isInstagramInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://app"]];
}

@end
