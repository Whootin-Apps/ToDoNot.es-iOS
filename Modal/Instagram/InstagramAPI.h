//
//  InstagramAPI.h
//  InstaMemory
//
//  Created by Ivica Aracic on 08.08.11.
//  Copyright 2011 Ivica Aracic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequestDelegate.h"

//======================
extern NSString* ACTION_IMG_DOWNLOAD;
extern NSString* ACTION_GET_USER_MEDIA_RECENT;
extern NSString* ACTION_GET_USER_MEDIA_LIKED;
extern NSString* ACTION_GET_USER_FEED;
extern NSString* ACTION_GET_MEDIA_POPULAR;
extern NSString* ACTION_GET_TAG_MEDIA_RECENT;
extern NSString* ACTION_POST_MEDIA_LIKE;
extern NSString* ACTION_DELETE_MEDIA_LIKE;
extern NSString* ACTION_GET_USER_SELF;
extern NSString* ACTION_POST_USERS_FOLLOW;
extern NSString* ACTION_GET_USERS_SEARCH;

//======================
@protocol InstagramAPIDelegate<NSObject>

- (void)requestFinished:(NSString*)action withResponse:(id)json withUserInfo:(NSDictionary*)dict;
- (void)requestFailed:(NSString*)action withUserInfo:(NSDictionary*)dict;

- (void)invalidAccessTokenWithUserInfo:(NSDictionary*)dict;

- (void)imgDownloadFinishedWithLocalPath:(NSString*)path withUserInfo:(NSDictionary*)dict;
- (void)imgDownloadFailedWithUserInfo:(NSDictionary*)dict;

- (void)loggedUserDataReady:(id)json username:(NSString*)username;

@end

//======================
@interface InstagramAPI : NSObject<ASIHTTPRequestDelegate> {
    NSString* accessToken;
    NSDictionary* userJson;
    NSObject<InstagramAPIDelegate>* reqDelegate;
    
    NSOperationQueue* downloadQueue;
    NSOperationQueue* commandQueue;
    
    NSMutableDictionary* apiCallCache;  // is only used for clientId requests
}

@property (nonatomic, retain) NSString* accessToken;
@property (nonatomic, retain) NSDictionary* userJson;
@property (nonatomic, readonly) NSString* username;
@property (nonatomic, readonly) NSString* profileImg;
@property (nonatomic, retain) NSObject<InstagramAPIDelegate>* reqDelegate;

- (void) loginOrLogout;
- (void) login;
- (void) logout;

- (NSString*) getResponseUrl;
- (NSString*) getLoginUrl;
- (NSString*) getLogoutUrl;

- (BOOL) isSessionValid;

- (BOOL) handleOpenURL:(NSURL*)url;
- (void) accessTokenExpired;

+ (InstagramAPI*) sharedInstance;

#pragma server calls

- (void) execInstagramAPICall:(NSString*)url 
                    andAction:(NSString*)_action 
                 withUserInfo:(NSDictionary*)userInfo;

- (void) execInstagramAPIPostCall:(NSString*)url 
                        andAction:(NSString*)_action 
                     withUserInfo:(NSDictionary*)_userInfo 
                withPostParameter:(NSDictionary*)postParams;

- (void) execInstagramAPIDeleteCall:(NSString*)url 
                          andAction:(NSString*)_action 
                       withUserInfo:(NSDictionary*)_userInfo;


- (void) startImgDownload:(NSString*)imgUrl withUserInfo:(NSDictionary*)userInfo withPutInDownloadQueue:(BOOL)putInDownloadQueue;

- (void) callUserMediaRecent:(NSString*)userId withCount:(int)count withUserInfo:(NSDictionary*)userInfo;
- (void) callUserMediaRecent:(NSString*)userId withCount:(int)count withMaxId:(int)maxId withUserInfo:(NSDictionary*)userInfo;

// works only with "self"
- (void) callUserMediaLikedWithCount:(int)count withUserInfo:(NSDictionary*)userInfo;
- (void) callUserMediaLikedWithCount:(int)count withMaxId:(int)maxId withUserInfo:(NSDictionary*)userInfo;

// works only with "self"
- (void) callUserFeedWithCount:(int)count withUserInfo:(NSDictionary*)userInfo;
- (void) callUserFeedWithCount:(int)count withMaxId:(int)maxId withUserInfo:(NSDictionary*)userInfo;

- (void) callMediaPopularWithUserInfo:(NSDictionary*)userInfo;

- (void) callTagMediaRecent:(NSString*)tag withUserInfo:(NSDictionary*)userInfo;

- (void) callMediaLike:(NSString*)mediaId withUserInfo:(NSDictionary*)userInfo;
- (void) callDeleteMediaLike:(NSString*)mediaId withUserInfo:(NSDictionary*)userInfo;

- (void) callFollowUser:(NSString*)userId;

- (void) callUsersSearch:(NSString*)q withLimit:(int)limit withUserInfo:(NSDictionary*)userInfo;

- (void) purgeDownloadQueue;

#pragma local hooks

- (BOOL) isInstagramInstalled;

- (void) openUser:(NSString*)username;
- (void) openMedia:(NSString*)mediaId;

@end
