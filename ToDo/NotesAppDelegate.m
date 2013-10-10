//
//  NotesAppDelegate.m
//  ToDo
//
//  Created by Whootin on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesAppDelegate.h"

#import "NotesViewController.h"
#import "Parse/Parse.h"
#import "JSON.h"

@implementation NotesAppDelegate
@synthesize activity,Alertview,lbl;
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize wMessage;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Notification Recieved");
    NSLog(@"%@",notification.userInfo);
    NSLog(@"%@",notification.alertBody);
    [_viewController refresh];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [Parse setApplicationId:@"js8QrkIvLWpGb7FiJVexyAKz87vUI9YUCU1nX9ge" clientKey:@"UP1wqV46fJ0zgob68GZamtxBgG8WG07CTAgeKKHU"];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[NotesViewController alloc] initWithNibName:@"NotesViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[NotesViewController alloc] initWithNibName:@"NotesViewController_iPad" bundle:nil] autorelease];
    }
    
    
    Alertview = [[UIView alloc]initWithFrame:CGRectMake(100, 160, 100, 100)];
    Alertview.center = self.window.center;
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	Alertview.backgroundColor=[UIColor blackColor];
    Alertview.alpha = 0.699999988079071;
    Alertview.layer.cornerRadius = 8.0;
    [activity setFrame:CGRectMake(25, 7, 50, 50)];
    [activity setHidesWhenStopped:YES];
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 51, 96, 41)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setNumberOfLines:2];
    [lbl setFont:[UIFont systemFontOfSize:17]];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setTextColor:[UIColor whiteColor]];
    [Alertview addSubview:lbl];
    [Alertview addSubview:activity];
    [self.window addSubview:Alertview];
    [Alertview setHidden:YES];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [PFPush storeDeviceToken:deviceToken];
   
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            NSLog(@"Successfully subscribed to broadcast channel!");
        else
            NSLog(@"Failed to subscribe to broadcast channel; Error: %@",error);
    }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for push, %@",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
