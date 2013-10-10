//
//  ShareNotesViewController.h
//  ToDo
//
//  Created by Support Nua on 26/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface ShareNotesViewController : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *scr_shareNotes;    // Scerollview to load all share Notes
    NSMutableArray *muarr_ShareNotes;        // Load all share notes into array
    IBOutlet UIView *viw_note1,*viw_detail,*viw_bigImage;
    IBOutlet UIWebView  *webviw_note_detail;
    IBOutlet UILabel       *lbl_duedate;
    IBOutlet UILabel *lbl_date,*lbl_senderName;
    IBOutlet UIImageView *imgView,*imgviw_note;
    IBOutlet UITextView *textView;
    BOOL gesture;

}


-(void)loadShareNotes:(int)count;                  // Load all share notes as like a grid view
-(void)getAllShareNotes;                // Get all shared Notes by others
-(void)xmlParse:(NSData *)data withSender:(NSString *)userName;         // Parsing shared notes Xml data 
-(void)btnPressed:(id)sender;
-(IBAction)btnBack;
-(IBAction)btnClose;
-(IBAction)btnHome;

@end
