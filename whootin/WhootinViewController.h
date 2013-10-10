//
//  WhootinViewController.h
//  Whootin
//
//  Created by Whootin on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesAppDelegate.h"
//#import "HMGLTransitionManager.h"

@protocol WhootinViewControllerDelegate;

@interface WhootinViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField  *txt_username,*txt_password;
    IBOutlet UIView *viw_login,*viw_signup,*viw_user;
    
    IBOutlet UILabel *lbl_username,*lbl_name;
    IBOutlet UIImageView *imgviw_profile;
    
    IBOutlet UITextField *txt_sname,*txt_semail,*txt_susername,*txt_spassword,*txt_confirm_pass;
 
    BOOL mIsKeyBoard;
    int count;
    NSString *message;
    
    // Progress Hud
    IBOutlet UIView *viw_progress,*viw_progress2;
   IBOutlet UIActivityIndicatorView *activity;
    
    int note_no;
   
   
    id <WhootinViewControllerDelegate> delegate;
    
  //  HMGLTransition *transition;
   

}

@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) int minutes;
 @property (nonatomic, retain) id <WhootinViewControllerDelegate> delegate;

-(IBAction)btnSubmit;
-(IBAction)btnSignup;
-(IBAction)btnLogout;
-(IBAction)btnDone;
-(IBAction)btnBack;
-(void)setViewMovedUp:(BOOL)movedUp;
-(IBAction)btnFolder;
-(IBAction)btnPost;
-(IBAction)btnCancel;
-(void)setMessageBody:(NSString *)msg;
-(void)addSignupView;
-(IBAction)home;

@end

@protocol WhootinViewControllerDelegate <NSObject>

- (void)modalControllerDidFinish:(WhootinViewController*)modalController;

@end

