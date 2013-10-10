//
//  NotesAppDelegate.h
//  ToDo
//
//  Created by Whootin on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesViewController;

#define APP ((NotesAppDelegate *)[[UIApplication sharedApplication]delegate])

@interface NotesAppDelegate : UIResponder <UIApplicationDelegate>

{
    NSString *wMessage;
    
    
    UIActivityIndicatorView *activity;
    UIView *Alertview;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NotesViewController *viewController;

@property(nonatomic,retain) NSString *wMessage;
@property (nonatomic, retain) UIView *Alertview;
@property (nonatomic, retain)  UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *lbl;


@end
