//
//  NotesViewController.h
//  ToDo
//
//  Created by Whootin on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import "NotesAppDelegate.h"
#import "MKInfoPanel.h"
#import "WhootinViewController.h"
#import "ShareNotesViewController.h"
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"
#import "FacebookLikeView.h"
#import "FbGraph.h"

#define APP ((NotesAppDelegate *)[[UIApplication sharedApplication]delegate])
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface NotesViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIDocumentInteractionControllerDelegate,FBSessionDelegate,FacebookLikeViewDelegate>
{
    
    Facebook *_facebook;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIScrollView *scrollView1;
    IBOutlet UIScrollView *scrviw_note_color;
    
    IBOutlet UIImageView *imgviw_note_color,*imgviw_note_color1;
    IBOutlet UIImageView *imgviw_note_settings;
    IBOutlet UIView     *viw_test;
    IBOutlet UIView     *viw_select_note;
    IBOutlet UIView     *viw_settings;
    IBOutlet UIView     *viw_note_icon;
    
 
    
    NotesAppDelegate *delegate;
    
    BOOL isScrollable;
    
    sqlite3  *contactDB;
    NSString *databaseName;
    NSString *databasePath;
    
    IBOutlet UITextView  *txtviw_note;
    IBOutlet UITextField *txt_noteName;
    IBOutlet UILabel *lbl_note_name;
    IBOutlet UITextView *txtviw_note_name;
 
    IBOutlet UIWebView  *webviw_note_detail;
    IBOutlet UITextView *txtView;
    IBOutlet UIView  *viw_note_detail;
    
    IBOutlet UISegmentedControl *segmenatlCOntrol;
    
    NSMutableArray  *muarr_rowid,*muarr_note_name,*muarr_note_detail,*muarr_note_date,*muarr_settings,*muarr_duedate,*muarr_settings1,*muarr_done,*muarr_imgname,*muarr_privileg,*muarr_share_list;
    
    NSMutableArray  *muarr_done_rowid,*muarr_done_name,*muarr_done_detail,*muarr_done_date,*muarr_done_settings,*muarr_done_duedate,*muarr_done_settings1,*muarr_done_done,*muarr_done_imgname,*muarr_done_privilege,*muarr_done_share_list;
    
    
    NSString *str_rowid, *str_noteName,*str_noteDetail,*str_noteDate,*str_noteSettings,*str_dueDate,*str_notifiDate,*str_note_image,*str_save_image;
    
   
    
    
    int row_id;
    int deleteTagValue;
    BOOL isUpdate;
    BOOL isTextFiled;
    BOOL isNotifi;
    
    
    UILongPressGestureRecognizer *longPress;
    UIPanGestureRecognizer *panRecognizer;
    
    
    IBOutlet UIDatePicker  *datePicker;
    IBOutlet UIView        *viw_notifi;
    IBOutlet UILabel       *lbl_duedate;

      UILabel *lbl_date;
    
    // Note Settings
    
    IBOutlet UIButton  *btnNoteColor;
    IBOutlet UITextView *txtviw_note_desc;
    IBOutlet UITableView *tbl_note;
    IBOutlet UIView    *viw_note_settings;
    IBOutlet UIView *viw_note;
    IBOutlet UIButton *btn_hide;
    
    BOOL isHide;
    int tblid;
    
    NSMutableArray  *muarr_alignment;
    NSMutableArray  *muarr_alignment_list;
    NSMutableArray  *muarr_color;   
    NSMutableArray  *muarr_FontList;
    NSMutableArray  *muarr_ColorList;
    
    NSString *str_textname,*str_text_color,*str_textalign,*strShareId;
    int btn_no;
    
    NSString *temp1,*temp2,*temp3,*temp4,*temp5,*temp6,*temp7,*temp8,*temp9,*temp10,*temp11,*temp12;
    
    NSMutableArray *muarr_temp1,*muarr_temp2,*muarr_temp3,*muarr_temp4,*muarr_temp5,*muarr_temp6,*muarr_temp7,*muarr_temp8,*muarr_temp9,*muarr_temp10,*muarr_temp11,*muarr_temp12;
    
    CGFloat _firstX;
	CGFloat _firstY;
    
    float diff;
    
    int diff_x,diff_y;
    UIView *viw_note1;
    CGPoint _priorPoint;
    BOOL isFirst;
    int count;
    IBOutlet UIButton *btnDrag;
    IBOutlet UIImageView *imgPhoto; 
    NSMutableString *imageName;
    
    IBOutlet UIView *viw_img;
    IBOutlet UIImageView *imgviw_note;
    IBOutlet UIView *viw_camera;
    BOOL isCameraviw;
    IBOutlet UIButton *btn_Note_Image;
    IBOutlet UIImageView *imgviw_tbl;
    
    int note_no;
    int done;    // this is used for getting note tag value for done note
    
    
    BOOL gesture;
    IBOutlet UIScrollView *scr_done_notes;
    IBOutlet UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
    IBOutlet UIView *viw_done_notes;
    IBOutlet UIButton *btn_done;
    
    BOOL isPaging;
    
    IBOutlet UIView *viw_instruction_menu,*viw_inst_detail;
    IBOutlet UIImageView *imgviw_instruction;
    
    
    // Whootin
       
    IBOutlet UIView *viw_login_or_signup;
    
    IBOutlet UIButton *btnLogin1,*btnLogin2,*btnLogin3,*btnShare,*btnFriendsList,*btnShareNotes;
    IBOutlet UILabel *lblUserName1, *lblUserName2, *lblUserName3;
    NSString *str_note_name1;
    NSMutableArray *muarr_friendsList,*muarr_friends;
    UIPopoverController *popOverController;
    BOOL isScrollRight;

    IBOutlet UIView *viw_share,*viw_share_prompt,*viw_share1,*viw_entourage;
    BOOL isShare;
    BOOL isentourage;
    IBOutlet UITextField *txtUserList;
    IBOutlet UITableView *tbl_friends_list;
    
     
    
    //HMGLTransition *transition; 
    
     NSString *privilege,*shareList;
     IBOutlet UILabel *lblUser;
    BOOL isSave;
    
    
    IBOutlet UIView *viwSocialShare;
    IBOutlet UIView *viwInnerNotesView;
    UIWebView *_webView;
    BOOL IsInstaLoggedIn;
    UIImage *Img_Instagram;
    IBOutlet UIImage *lblimage;
    IBOutlet UIWebView *wbviw_like;
    
    
    //Graph Api
    
    
	FbGraph *fbGraph;
    NSString *feedPostId;
    
    
}

@property(nonatomic,retain) UIPopoverController *popOverController;
@property(nonatomic,retain) IBOutlet FacebookLikeView *facebookLikeView;
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *feedPostId;

-(IBAction)back;
-(IBAction)backDetail;
-(IBAction)backFromNoteColor;
-(IBAction)btnNoteView;
-(void)loadNoteButton:(int)count;     // Tis method only used for all notes icons..
-(void)addNote;
-(IBAction)btnSettingsPressed:(id)sender;
-(void)getAllData;

-(IBAction)btnUpdate;
-(IBAction)hideKeyPad;
-(IBAction)btnNoteColorPressed:(id)sender;
-(IBAction)btnSetNotifi;
-(IBAction)btnReminder;
-(void)refresh;

-(IBAction)close;
-(IBAction)backFromNoteIcon;
-(IBAction)selectNoteSection:(id)sender;
-(void)loadNoteIcon:(int)noOfIcon;    // Tis Mehtod Used to get Reminder ,moved and deleted notes
-(void)getReminderNotes;
-(void)getTrashNotes;
-(void)getDoneNotes;
-(void)refresh1;

-(IBAction)btnPhoto;
-(IBAction)btnClose;
-(IBAction)btnImgShow;
-(IBAction)camera_or_gallery:(id)sender;
-(void)btnWhootinShare:(NSString *)mode;
-(void)loadDoneNotes:(int)count;
-(void)doneNote:(int)tagid;
-(IBAction)btnDone;

-(IBAction)scrollRight;
-(IBAction)scrollLeft;


-(IBAction)btnInstPressed:(id)sender;

-(IBAction)btnLoginView:(id)sender;
-(IBAction)btnLoginORSignup:(id)sender;
-(void)reloadWhootinSettings;
-(IBAction)btnGetEntourage;
-(IBAction)btncancel;
-(IBAction)btnShare;

-(IBAction)btnShareFreinds;
-(void)fileSharing:(NSString *)user_name;
-(IBAction)btnShareCancel;
-(IBAction)textFieldReturn;
-(IBAction)btnShareNotes;
-(IBAction)btnUserClicked;

-(IBAction)btnPush;

-(IBAction)btnSave;
-(void)btnSaveUpdate;

// Social sharing methods

-(IBAction)btnfb;
-(IBAction)btnEmail;
-(IBAction)btnTwit;
-(IBAction)btnInsta;
-(IBAction)btnCloseScocial;
-(IBAction)btnSocialShare;
-(void)instagramIntegration;
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(UIImage *)createImage;

-(void)postPictureButtonPressed;

@end
