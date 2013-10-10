//
//  NotesViewController.m
//  ToDo
//
//  Created by Whootin on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "NotesViewController.h"
#import "WhootinViewController.h"
#import "JSON.h"
#import "Parse/Parse.h"
#import "Reachability1.h"
#import "FBFeedPost.h"
#import "IFNNotificationDisplay.h"
#import "SBJSON.h"
#import "FbGraphFile.h"
#import <MessageUI/MessageUI.h>



@implementation NotesViewController
@synthesize popOverController;
@synthesize fbGraph,feedPostId;
@synthesize facebookLikeView=_facebookLikeView;
static int tagValue=-1;
static int img_no=0;
static int tagValue_done_note=-1;
static int instruct=1;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
    {
        NSLog(@"welcome to the init");
       
    }
    return self;
}



#pragma mark FBSessionDelegate methods

- (void)fbDidLogin {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

- (void)fbDidLogout {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate methods

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView
{
    NSLog(@"Welcome..asdasdasd");
    [_facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView 
{
    [self.facebookLikeView load];
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
                                                     message:@"You liked TodoNot.es Thanks!"
                                                    delegate:self 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
    [self.facebookLikeView load];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
                                                     message:@"You unliked TodoNot.es"
                                                    delegate:self 
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}





- (void)viewDidLoad
{
    
   /* Switch3DTransition *t1 = [[[Switch3DTransition alloc] init] autorelease];
    t1.transitionType = Switch3DTransitionLeft;
    
    self.transition=t1;*/
    
     _facebook = [[Facebook alloc] initWithAppId:@"351319161630937" andDelegate:self];
	
    self.facebookLikeView.href = [NSURL URLWithString:@"http://todonot.es"];
    self.facebookLikeView.layout = @"button_count";
    self.facebookLikeView.showFaces = NO;
    
    self.facebookLikeView.alpha = 0;
    [self.facebookLikeView load];
    
    
    tbl_friends_list.layer.cornerRadius=5.0;
    [tbl_friends_list setClipsToBounds:YES];
    
     scrollView.delegate=self;
     str_notifiDate=@"";
    
    diff=0;
    isFirst=YES;
    
    webviw_note_detail.opaque=NO;
   
    
    [scrollView1 setMinimumZoomScale:2.0];
    //[scrollView1 setMaximumZoomScale:5.0];
    
    txtView.layer.cornerRadius=10.0;
    txtView.clipsToBounds=YES;
    
 
  
    imgviw_note.layer.cornerRadius=10.0;
    //imgviw_note.layer.borderWidth=2.0;
    imgviw_note.clipsToBounds=YES;
    
    btn_done.layer.cornerRadius=6.0;
    btn_done.clipsToBounds=YES;
    
    
    // Whootin
    btnLogin1.tag=1;
    btnLogin2.tag=1;
    btnLogin3.tag=1;
    
    
    viw_share_prompt.layer.cornerRadius=5.0;
     viw_share_prompt.layer.shadowOffset=CGSizeMake(1,1);
     viw_share_prompt.layer.masksToBounds=NO;
     viw_share_prompt.layer.shadowOpacity=0.7;
     viw_share_prompt.layer.shadowRadius=10;     
     viw_share_prompt.layer.shadowPath=[UIBezierPath bezierPathWithRoundedRect:viw_share_prompt.bounds cornerRadius:10.0].CGPath;
     
        
    [scrollView setContentSize:CGSizeMake(320,460)];
    [scrollView setScrollEnabled:YES];
   
    
     scrollView1.delegate=self;
    [scrollView1 setContentSize:CGSizeMake(280,360)];
    [scrollView1 setScrollEnabled:YES];
    
    
    muarr_rowid         =[[NSMutableArray alloc] init];
    muarr_note_name     =[[NSMutableArray alloc] init];
    muarr_note_detail   =[[NSMutableArray alloc] init];
    muarr_note_date     =[[NSMutableArray alloc] init];
    muarr_settings      =[[NSMutableArray alloc] init];
    muarr_duedate       =[[NSMutableArray alloc] init];
    muarr_settings1     =[[NSMutableArray alloc] init];
    muarr_done          =[[NSMutableArray alloc] init];
    muarr_imgname       =[[NSMutableArray alloc] init];
    muarr_privileg      =[[NSMutableArray alloc] init];
    muarr_share_list    =[[NSMutableArray alloc] init];
    
    
    
    muarr_done_rowid        =[[NSMutableArray alloc] init];
    muarr_done_name         =[[NSMutableArray alloc] init];
    muarr_done_detail       =[[NSMutableArray alloc] init];
    muarr_done_date         =[[NSMutableArray alloc] init];
    muarr_done_settings     =[[NSMutableArray alloc] init];
    muarr_done_duedate      =[[NSMutableArray alloc] init];
    muarr_done_settings1    =[[NSMutableArray alloc] init];
    muarr_done_done         =[[NSMutableArray alloc] init];
    muarr_done_imgname      =[[NSMutableArray alloc] init];
    muarr_done_privilege      =[[NSMutableArray alloc] init];
    muarr_done_share_list    =[[NSMutableArray alloc] init];
    
    
    muarr_temp1=[[NSMutableArray alloc] init];
    muarr_temp2=[[NSMutableArray alloc] init];
    muarr_temp3=[[NSMutableArray alloc] init];
    muarr_temp4=[[NSMutableArray alloc] init];
    muarr_temp5=[[NSMutableArray alloc] init];
    muarr_temp6=[[NSMutableArray alloc] init];
    muarr_temp7=[[NSMutableArray alloc] init];
    muarr_temp8=[[NSMutableArray alloc] init];
    muarr_temp9=[[NSMutableArray alloc] init];
    muarr_temp10=[[NSMutableArray alloc] init];
    muarr_temp11=[[NSMutableArray alloc] init];
    
    muarr_friendsList=[[NSMutableArray alloc] init];
    muarr_friends=[[NSMutableArray alloc] init];
    
    scrviw_note_color.delegate=self;
    scrviw_note_color.scrollEnabled=YES;
    scrviw_note_color.contentSize=CGSizeMake(260,460);
  
    
    muarr_FontList=[[NSMutableArray alloc] initWithCapacity:162];
    NSArray *fontFamilyNames = [UIFont familyNames];
    for (NSString *familyName in fontFamilyNames) {
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        [muarr_FontList addObjectsFromArray:names];
    }
    
    
    pageControl.numberOfPages=2;
    
    // Loading All Color List
    
    muarr_ColorList=[[NSMutableArray alloc]initWithObjects:                    
     
     @"Black",@"DarkGray",@"LightGray",
     @"White",@"Gray",@"Red",
     @"Green",@"Blue",@"Cyan",
     @"Yellow",@"Magenta",@"Orange",
     @"Purple",@"Brown",
     
     nil];
    
    
    //Loading all alignment into array;
    
    muarr_alignment=[[NSMutableArray alloc] initWithObjects:UITextAlignmentLeft,UITextAlignmentRight,UITextAlignmentCenter,nil];
    
    muarr_alignment_list=[[NSMutableArray alloc] init];
    [muarr_alignment_list addObject:@"Left"];
    [muarr_alignment_list addObject:@"Center"];
    [muarr_alignment_list addObject:@"Right"];
    
    // Loading All colors
    
    muarr_color=[[NSMutableArray alloc] initWithObjects:
                 [UIColor blackColor]   ,[UIColor darkGrayColor]    ,[UIColor lightGrayColor],
                 [UIColor whiteColor]   ,[UIColor grayColor]        ,[UIColor redColor],
                 [UIColor greenColor]   ,[UIColor blueColor]        ,[UIColor cyanColor],
                 [UIColor yellowColor]  ,[UIColor magentaColor]     ,[UIColor orangeColor],
                 [UIColor purpleColor]  ,[UIColor brownColor]  ,     nil];
    
    
    // Default Textview Settings
    
    txt_noteName.textColor=[UIColor whiteColor];
    txtviw_note.textColor=[UIColor whiteColor];
    
     str_textname=@"Chalkduster";
     str_text_color=@"White";
     str_textalign=@"Left";
    
    [webviw_note_detail setClearsContextBeforeDrawing:YES];
    
    tbl_note.separatorStyle=UITableViewCellSeparatorStyleNone;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
    {    
      tbl_note.rowHeight=55.0;
        [webviw_note_detail layer].cornerRadius=10.0;
        webviw_note_detail.clipsToBounds=YES;
    }
    else
    {
        tbl_note.rowHeight=85.0;
        [webviw_note_detail layer].cornerRadius=25.0;
        webviw_note_detail.clipsToBounds=YES;
    }
    
  
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    databasePath = [[NSString alloc]initWithString: [documentsDirectory stringByAppendingPathComponent:@"DBToDoList.sqlite"]];
    
    success = [fileManager fileExistsAtPath:databasePath];
    if (success) 
    {
        return;
    }
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DBToDoList.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
    if (!success) 
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
    [self.view addSubview:viw_instruction_menu];

    NSString *likeButtonIframe = @"<iframe src=http://connect.facebook.net/en_US/all.js#xfbml=1&appId=452872201465817 scrolling=no frameborder=0 style=border:none; overflow:hidden; width:282px; height:62px; allowTransparency=true></iframe>";
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];    
    [wbviw_like loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]]; 
    
 
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = scrollView.frame.size.width;
		int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
      
		pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage 
{
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = scrollView.frame.size.width * pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = scrollView.frame.size;
	[scrollView scrollRectToVisible:frame animated:YES];
	
	// Keep track of when scrolls happen in response to the page control
	// value changing. If we don't do this, a noticeable "flashing" occurs
	// as the the scroll delegate will temporarily switch back the page
	// number.
	pageControlBeingUsed = YES;
}





-(void)doubleTap:(UITapGestureRecognizer *)sender
{
    //viw_share.hidden=YES;
    //isShare=NO;
    
    int scrollPositionY = [[webviw_note_detail stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
    int scrollPositionX = [[webviw_note_detail stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
       
    int displayWidth = [[webviw_note_detail   stringByEvaluatingJavaScriptFromString:@"window.outerWidth"] intValue];
    CGFloat scale = webviw_note_detail.frame.size.width / displayWidth;
  
    
    
    CGPoint pt = [sender locationInView:webviw_note_detail];
    pt.x *= scale;
    pt.y *= scale;
    pt.x += scrollPositionX;
    pt.y += scrollPositionY;
    
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString * tagName = [webviw_note_detail stringByEvaluatingJavaScriptFromString:js];
    

    
    if ([tagName isEqualToString:@"IMG"])
    {
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
        
      
        
        imgviw_note.image=[UIImage imageWithContentsOfFile:thumbFilePath];
        
        
        
        viw_img.transform = CGAffineTransformScale(viw_img.transform, 0.1, 0.1);
        viw_img.center = self.view.center;
        // im.center=CGPointMake(10, 30);
        [self.view addSubview:viw_img];
        
        [UIView animateWithDuration:1.0 animations:^(void){
            
            viw_img.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationTransitionCurlUp animations:^(void){
                // viw_img.alpha = 0.0;
            } completion:^(BOOL finished) {
                //[im removeFromSuperview];
            }];
            
        }];
        

    }
     
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{   
    if (gesture==YES)
    {
       return YES; 
    }
    else
    {
        return NO;
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{          
    return YES;
}




-(IBAction)selectNoteSection:(id)sender
{
    int section=[sender tag]; 
    if (section==1001)
    {
        // goto New Notes
    
        instruct=1;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
           imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]]; 
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];  
        }
        [self.view addSubview:viw_inst_detail];
    }
    else if(section==1002)
    {
            
        // Goto Reminder Notes       
        
        instruct=2;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]]; 
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];  
        }
        [self.view addSubview:viw_inst_detail];
    }
    else if(section==1003)
    {
        instruct=3;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]]; 
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];  
        }
        [self.view addSubview:viw_inst_detail];
    }
    else if(section==1004)
    {        
        instruct=4;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]]; 
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];  
        }
        [self.view addSubview:viw_inst_detail];
    }
    else if(section==1005)
    {
        //Goto Trash Notes
        instruct=5;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]]; 
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];  
        }
        [self.view addSubview:viw_inst_detail];
    
    }
    else if(section==1006)
    {
        // Goto Done Notes
    
        instruct=6;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]]; 
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];  
        }
        [self.view addSubview:viw_inst_detail];
    }
    
    CATransition *animation5=[CATransition animation];
    [animation5 setDuration:0.5];
    [animation5 setType:@"cube"];
    [animation5 setSubtype:kCATransitionFromRight];
    [animation5 setDelegate:self];
    [[self.view layer] addAnimation:animation5 forKey:@""];

}


#pragma mark Get all Notes Icons



-(void)getReminderNotes
{
    [muarr_rowid removeAllObjects];
    [muarr_note_date removeAllObjects];
    [muarr_note_detail removeAllObjects];
    [muarr_note_name removeAllObjects];
    [muarr_settings removeAllObjects];
    [muarr_duedate removeAllObjects];
    [muarr_done removeAllObjects];
    [muarr_imgname removeAllObjects];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select rowid,Name,Detail,Date,Settings,DueDate,done,image_name from TblToDoList where not duedate='' and status='1'"];
        // NSLog(@"querySQL=%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString  *str_rowid1=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 0)];
                NSString  *str_note_name=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 1)];
                NSString  *str_note_detail=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 2)];
                NSString  *str_note_date=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 3)];
                NSString  *str_note_settings=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 4)];
                NSString  *str_note_duedate=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 5)];
                 NSString  *str_note_done=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 6)];
                NSString  *str_note_image1=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 7)];
                
                
                [muarr_rowid addObject:str_rowid1];
                [muarr_note_name addObject:str_note_name];
                [muarr_note_detail addObject:str_note_detail];
                [muarr_note_date addObject:str_note_date];
                [muarr_settings addObject:str_note_settings];
                [muarr_duedate addObject:str_note_duedate];
                [muarr_done addObject:str_note_done];
                [muarr_imgname addObject:str_note_image1];
            } 
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }

}


-(void)getTrashNotes
{
    [muarr_rowid removeAllObjects];
    [muarr_note_date removeAllObjects];
    [muarr_note_detail removeAllObjects];
    [muarr_note_name removeAllObjects];
    [muarr_settings removeAllObjects];
    [muarr_duedate removeAllObjects];

    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select rowid,Name,Detail,Date,Settings,DueDate,done from TblToDoList where status='0'"];
        // NSLog(@"querySQL=%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString  *str_rowid1=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 0)];
                NSString  *str_note_name=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 1)];
                NSString  *str_note_detail=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 2)];
                NSString  *str_note_date=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 3)];
                NSString  *str_note_settings=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 4)];
                NSString  *str_note_duedate=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 5)];
                NSString  *str_note_done=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 6)];
             
                
                [muarr_rowid addObject:str_rowid1];
                [muarr_note_name addObject:str_note_name];
                [muarr_note_detail addObject:str_note_detail];
                [muarr_note_date addObject:str_note_date];
                [muarr_settings addObject:str_note_settings];
                [muarr_duedate addObject:str_note_duedate];
                [muarr_done addObject:str_note_done];
            } 
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(void)getDoneNotes
{
    [muarr_done_rowid removeAllObjects];
    [muarr_done_date removeAllObjects];
    [muarr_done_detail removeAllObjects];
    [muarr_done_name removeAllObjects];
    [muarr_done_settings removeAllObjects];
    [muarr_done_duedate removeAllObjects];
    [muarr_done_done removeAllObjects];
    [muarr_done_imgname removeAllObjects];
    [muarr_done_privilege removeAllObjects];
    [muarr_done_share_list removeAllObjects];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
       NSString *querySQL = [NSString stringWithFormat:@"select rowid,Name,Detail,Date,Settings,DueDate,done,image_name,privilege,share_list from TblToDoList where status='1' and done='1'"];
        // NSLog(@"querySQL=%@",querySQL);
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString  *str_rowid1=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 0)];
                NSString  *str_note_name=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 1)];
                NSString  *str_note_detail=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 2)];
                NSString  *str_note_date=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 3)];
                NSString  *str_note_settings=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 4)];
                NSString  *str_note_duedate=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 5)];
                NSString  *str_note_done=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 6)];
               
                
                
                
                const char *imgname=(const char *)sqlite3_column_text(statement, 7);
                NSString  *str_note_image1=imgname==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:imgname];
                
                const char *privg=(const char *)sqlite3_column_text(statement, 8);
                NSString  *str_note_privilage=privg==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:privg];
                
                const char *sharelist=(const char *)sqlite3_column_text(statement, 9);
                NSString  *str_note_share_list=sharelist==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:sharelist];
                
                
                              
                
                [muarr_done_rowid addObject:str_rowid1];
                [muarr_done_name addObject:str_note_name];
                [muarr_done_detail addObject:str_note_detail];
                [muarr_done_date addObject:str_note_date];
                [muarr_done_settings addObject:str_note_settings];
                [muarr_done_duedate addObject:str_note_duedate];
                [muarr_done_done addObject:str_note_done];
                [muarr_done_imgname addObject:str_note_image1];
                [muarr_done_privilege addObject:str_note_privilage];
                [muarr_done_share_list addObject:str_note_share_list];
            } 
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    } 
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:viw_note];
    if (isNotifi)
    {
        if (!CGRectContainsPoint(viw_notifi.frame, location))
        {
            viw_notifi.hidden=YES;
            isNotifi=NO;
        }
    }
    else if(isShare)
    {
        if (!CGRectContainsPoint(viw_share_prompt.frame, location))
        {
            viw_share.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                viw_share.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished){
                [viw_share removeFromSuperview];
                 isShare=NO;
            }];
            viw_entourage.hidden=YES;
        }
    }
}


-(IBAction)btnDone
{
    [self getDoneNotes];
    
    NSArray *subviews=[scr_done_notes subviews];
    for (UIView *subview in subviews)
    {
        [subview removeFromSuperview]; 
    }
    
    [self loadDoneNotes:[muarr_done_rowid count]];
    
    CATransition *animation=[CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:1.0];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"leftSide"];
    
    [self.view addSubview:viw_done_notes];
    
}


-(IBAction)btnNoteColorPressed:(id)sender
{
    btn_no=[sender tag]-1;
    imgPhoto.image=nil;
    isSave=NO;
    
    str_notifiDate=@"";

    
    [viw_select_note removeFromSuperview];
    [btnNoteColor setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat: @"note%d.png",btn_no]] forState:UIControlStateNormal];
    imgviw_note_color.image=[UIImage imageNamed:[NSString stringWithFormat: @"note%d.png",btn_no]];
    CATransition *animation2=[CATransition animation];
    animation2.delegate=self;
    animation2.duration=0.5;
    animation2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation2.type=kCATransitionPush;
    animation2.subtype=kCATransitionFromRight;
    [[self.view layer] addAnimation:animation2 forKey:@"Zooming"];
   // imgviw_note_settings.image=[UIImage imageNamed:[NSString stringWithFormat: @"n%d.png",btn_no]];
    [self.view addSubview:viw_test];
}



-(IBAction)btnSettingsPressed:(id)sender
{
    int setTagValue=[sender tag];
    
    viw_camera.hidden=YES;
    isCameraviw=NO;
    if (setTagValue==500)
    {
        viw_note_settings.hidden=YES;  
    }
    else if(setTagValue==501)
    {
        viw_note_settings.hidden=NO;
        [txtviw_note resignFirstResponder];
         tblid=1;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            tbl_note.rowHeight=44.0;
        }
        else
        {
          tbl_note.rowHeight=55.0;  
        }
        
        imgviw_tbl.image=[UIImage imageNamed:@"popover.png"];
        [tbl_note reloadData];
        
    }
    else if(setTagValue==502)
    {
        viw_note_settings.hidden=NO;
        [txtviw_note resignFirstResponder];
        tblid=2;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            tbl_note.rowHeight=60.0;
        }
        else
        {
            tbl_note.rowHeight=85.0;  
        }
        
         imgviw_tbl.image=[UIImage imageNamed:@"popover2.png"];
        [tbl_note reloadData];
        
    }
    else if(setTagValue==503)
    {
        viw_note_settings.hidden=NO;
        [txtviw_note resignFirstResponder];
        tblid=3;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            tbl_note.rowHeight=44.0;
        }
        else
        {
            tbl_note.rowHeight=55.0;  
        }
        
         imgviw_tbl.image=[UIImage imageNamed:@"popover3.png"];
        [tbl_note reloadData];
    }
    else
    {  
      
    }
    CATransition *animation5=[CATransition animation];
    animation5.delegate=self;
    animation5.duration=0.5;
    animation5.type=@"cube";
    animation5.subtype=kCATransitionFromBottom;
    animation5.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[tbl_note layer] addAnimation:animation5 forKey:@"Cube1"];
}


-(void)loadNoteButton:(int)count2
{
   
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {

     tagValue=-1;
     int count1=count2/2;
        
     [scrollView1 setContentSize:CGSizeMake(280, (count1+1)*135)];
    
    for (int i=0; i<=count1; i++) 
    {
       
        for (int j=0; j<2; j++)
        {
            tagValue++;
            if(tagValue<count2)
            {
              
                //Loading Setting values fontname ,font color, fontalign
              
                NSString *settings=[muarr_settings objectAtIndex:tagValue];
                NSArray *arry1=[settings componentsSeparatedByString:@","];
                
               // NSLog(@"%@",[arry1 objectAtIndex:2]);
            
                viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*145, i*140, 132, 132)];  
                viw_note1.backgroundColor=[UIColor clearColor];
                [viw_note1 setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                [viw_note1 setExclusiveTouch:YES];
                UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnNote setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
            // btnNote.frame=CGRectMake(j*145, i*135, 132, 132);
                 btnNote.frame=CGRectMake(0,0,132,132);
                [btnNote setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"note%@.png",[arry1 objectAtIndex:0]]] forState:UIControlStateNormal];
                btnNote.showsTouchWhenHighlighted=NO;
                btnNote.adjustsImageWhenHighlighted=NO;
                [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
             
                
                // Swipe Gesture set for view_note1
                
                UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
                [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                [viw_note1 addGestureRecognizer:swipeLeft];
                
                
                
                UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiperight:)];
                [swiperight setDirection:UISwipeGestureRecognizerDirectionRight];
                [viw_note1 addGestureRecognizer:swiperight];
                
    
             
                UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(15,45,100, 30)];
                [lblName1 setText:[muarr_note_name objectAtIndex:tagValue]];
                [lblName1 setBackgroundColor:[UIColor clearColor]];
                [lblName1 setTextAlignment:UITextAlignmentCenter];
                [lblName1 setTextColor:[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]]];
                [lblName1 setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:15.0]];
                
                
                // UIPanGestures settings fot Note Button
                
                longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
                [longPress setMinimumPressDuration:0.5];
                [longPress setDelegate:self];
                [viw_note1 addGestureRecognizer:longPress];
                
                
                
                UIButton *btnImage;
                if (![[muarr_imgname objectAtIndex:tagValue] isEqualToString:@""])
                {
                    NSLog(@"Welcome...");
                    btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnImage.frame=CGRectMake(45,72,40,40);
                    btnImage.tag=[[muarr_rowid objectAtIndex:tagValue] intValue];
                    btnImage.layer.cornerRadius=5.0;
                    btnImage.clipsToBounds=YES;
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[muarr_imgname objectAtIndex:tagValue]];
                    [btnImage setBackgroundImage:[UIImage imageWithContentsOfFile:thumbFilePath] forState:UIControlStateNormal];
                    
                    [btnImage addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                //Label Setting  Display a date of note entry
                
                UIButton *btnUser=[UIButton buttonWithType:UIButtonTypeCustom];
               // btnUser.frame=CGRectMake(j*145+15, i*135+105,20,20);
                 btnUser.frame=CGRectMake(5,105,20,20);
                [btnUser setBackgroundImage:[UIImage imageNamed:@"user.png" ]forState:UIControlStateNormal];
                [btnUser setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                [btnUser addTarget:self action:@selector(userBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *lblUserName,*lblStatus;
                UIButton *btnPin;
                if (![[muarr_privileg objectAtIndex:tagValue] isEqualToString:@""]) 
                {
                    NSLog(@"Welcome to if ");
                    
                    NSString *strImageName;
                    
                    lblUserName=[[UILabel alloc] initWithFrame:CGRectMake(25,115,75,12)];
                    [lblUserName setText:[NSString stringWithFormat:@"@%@",[muarr_share_list objectAtIndex:tagValue]]];
                    [lblUserName setFont:[UIFont fontWithName:@"Marker Felt" size:12]];
                    [lblUserName setTextColor:[UIColor darkGrayColor]];
                     lblUserName.backgroundColor=[UIColor clearColor];
                    
                   
                    
                    lblStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,2,70,17)];
                    if ([[muarr_privileg objectAtIndex:tagValue] isEqualToString:@"1" ]) 
                    {
                       [lblStatus setText:@"Public"];
                        strImageName=@"pin1.png";
                    }
                    else
                    {
                        [lblStatus setText:@"Private"];
                        strImageName=@"pin.png";
                    }
                    [lblStatus setFont:[UIFont fontWithName:@"Marker Felt" size:17]];
                    [lblStatus setBackgroundColor:[UIColor clearColor]];
                    [lblStatus setTextColor:[UIColor blackColor]];
                    
                    btnPin=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnPin.frame=CGRectMake(10,0,21,31);
                    [btnPin setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
                    
                }
                else
                {
                   // NSLog(@"Welcome to else");
                }
                
    
                
                UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
               // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                 btnMark.frame=CGRectMake(100,105,20,20);
                    if ([[muarr_done objectAtIndex:tagValue] isEqualToString:@"0"])
                     {
                      [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                     }
                    else
                    {
                     [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                    }
              
                [btnMark setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                [btnMark addTarget:self action:@selector(markBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                btnMark.showsTouchWhenHighlighted=YES;
                
                // Label for diaplay a date of reminder
                
               // lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(j*145,i*135+5,130,40)];
                lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(5,23,125,28)];
                [lbl_date setBackgroundColor:[UIColor clearColor]];
                if(![[muarr_duedate objectAtIndex:tagValue] isEqualToString:@""])
                {
                    NSDate *currDate=[NSDate date];
                    NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                    [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                    NSString *strDate=[formatter1 stringFromDate:currDate];
                    NSDate *today=[formatter1 dateFromString:strDate];
                    
                    NSString *stringDate=[muarr_duedate objectAtIndex:tagValue];
                    NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
                    [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
                    
                    // Comparing the date from curent date to reminder date
                    
                    NSDate *newDate=[formatter dateFromString:stringDate];
                    NSComparisonResult  result;
                    result=[today compare:newDate];
                   
                    // Chcking the date whether a date is expired or not
                    
                    if (result==NSOrderedAscending) 
                    {          
                        
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                         lbl_date.numberOfLines=2;
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                        lbl_date.numberOfLines=2;
                        lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
    
                    }
                    else if(result==NSOrderedDescending)
                    {
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.textColor=[UIColor redColor];
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                        lbl_date.numberOfLines=2;
                       // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                        
                    }
                    else
                    {
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.textColor=[UIColor redColor];
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                        lbl_date.numberOfLines=2;
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                    }
                }
                
                [viw_note1 addSubview:btnNote];
                [viw_note1 addSubview:lblName1];
                [viw_note1 addSubview:btnMark];
                [viw_note1 addSubview:btnUser];
                [viw_note1 addSubview:lbl_date];
                if (![[muarr_privileg objectAtIndex:tagValue] isEqualToString:@""]) 
                {
                [viw_note1 addSubview:lblUserName];
                [viw_note1 addSubview:lblStatus];
                [viw_note1 addSubview:btnPin];
                }
                if (![[muarr_imgname objectAtIndex:tagValue] isEqualToString:@""]) 
                {
                   [viw_note1 addSubview:btnImage];  
                }
               
                [scrollView1 addSubview:viw_note1];
                 
            }
           
        }
    }
    }
    else
    {
        tagValue=-1;
        int count1=count2/2;
        
        [scrollView1 setContentSize:CGSizeMake(600, (count1+1)*250)];
        
        for (int i=0; i<=count1; i++) 
        {
            
            for (int j=0; j<3; j++)
            {
                tagValue++;
                if(tagValue<count2)
                {
                    
                    //Loading Setting values fontname ,font color, fontalign
                    
                    NSString *settings=[muarr_settings objectAtIndex:tagValue];
                    NSArray *arry1=[settings componentsSeparatedByString:@","];
                    
                    // NSLog(@"%@",[arry1 objectAtIndex:2]);
                    
                    viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*222,i*225,200,200)];  
                    viw_note1.backgroundColor=[UIColor clearColor];
                    [viw_note1 setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                    [viw_note1 setExclusiveTouch:YES];
                    UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                    [btnNote setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                    // btnNote.frame=CGRectMake(j*145, i*135, 132, 132);
                    btnNote.frame=CGRectMake(0,0,200,200);
                    [btnNote setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"note%@.png",[arry1 objectAtIndex:0]]] forState:UIControlStateNormal];
                    btnNote.showsTouchWhenHighlighted=NO;
                    btnNote.adjustsImageWhenHighlighted=NO;
                    //  [btnNote setTitle:[muarr_note_name objectAtIndex:tagValue] forState:UIControlStateNormal];
                    
                    // btnNote.titleLabel.font=[UIFont fontWithName:[arry1 objectAtIndex:1] size:17.0];
                    
                    // btnNote.titleLabel.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                    //  btnNote.titleLabel.text=[muarr_note_name objectAtIndex:tagValue];
                    [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    // Swipe Gesture set for button
                    
                    UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
                    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                    [viw_note1 addGestureRecognizer:swipeLeft];
                    
                    
                    
                    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiperight:)];
                    [swiperight setDirection:UISwipeGestureRecognizerDirectionRight];
                    [viw_note1 addGestureRecognizer:swiperight];
                    
                    
                    
                    //  UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(j*145+15, i*135+50,100, 30)];
                    UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(15,75,175,50)];
                    [lblName1 setText:[muarr_note_name objectAtIndex:tagValue]];
                    [lblName1 setBackgroundColor:[UIColor clearColor]];
                    [lblName1 setTextAlignment:UITextAlignmentCenter];
                    [lblName1 setTextColor:[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]]];
                    [lblName1 setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:25.0]];
                    
                    
                    // UIPanGestures settings fot Note Button
                    
                    longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
                    [longPress setMinimumPressDuration:0.5];
                    [longPress setDelegate:self];
                    [viw_note1 addGestureRecognizer:longPress];
                    
                    /*UIPanGestureRecognizer *panRecognizer=[[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)]autorelease];
                     [panRecognizer setDelegate:self];
                     [panRecognizer setMaximumNumberOfTouches:1];
                     [panRecognizer setMinimumNumberOfTouches:1];
                     [viw_note1 addGestureRecognizer:panRecognizer];*/
                    
                    UIButton *btnImage;
                    if (![[muarr_imgname objectAtIndex:tagValue] isEqualToString:@""])
                    {
                        NSLog(@"Welcome...");
                        btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                        btnImage.frame=CGRectMake(70,118,50,50);
                        btnImage.tag=[[muarr_rowid objectAtIndex:tagValue] intValue];
                        btnImage.layer.cornerRadius=5.0;
                        btnImage.clipsToBounds=YES;
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[muarr_imgname objectAtIndex:tagValue]];
                        [btnImage setBackgroundImage:[UIImage imageWithContentsOfFile:thumbFilePath] forState:UIControlStateNormal];
                        
                        [btnImage addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    
                    else
                    {
                        NSLog(@"Ther is No image");
                    }
                    
                   
                    
                    UIButton *btnUser=[UIButton buttonWithType:UIButtonTypeCustom];
                    // btnUser.frame=CGRectMake(j*145+15, i*135+105,20,20);
                    btnUser.frame=CGRectMake(15,160,30,30);
                    [btnUser setBackgroundImage:[UIImage imageNamed:@"user.png" ]forState:UIControlStateNormal];
                    [btnUser setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                    [btnUser addTarget:self action:@selector(userBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    
                    
                    UILabel *lblUserName,*lblStatus;
                    UIButton *btnPin;
                    if (![[muarr_privileg objectAtIndex:tagValue] isEqualToString:@""]) 
                    {
                            //NSLog(@"Welcome to if ");
                        NSString *strImageName;
                        
                        // Display the shared user name...
                         
                        lblUserName=[[UILabel alloc] initWithFrame:CGRectMake(55,170,75,20)];
                        [lblUserName setText:[NSString stringWithFormat:@"@%@",[muarr_share_list objectAtIndex:tagValue]]];
                        [lblUserName setFont:[UIFont fontWithName:@"Marker Felt" size:20]];
                        [lblUserName setTextColor:[UIColor darkGrayColor]];
                        lblUserName.backgroundColor=[UIColor clearColor];
                        
                       
                        // Display The status (Public/Private) of the Note
                        
                        lblStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,10,120,25)];
                        if ([[muarr_privileg objectAtIndex:tagValue] isEqualToString:@"1" ]) 
                        {
                            [lblStatus setText:@"Public"];
                            strImageName=@"pin1.png";
                        }
                        else
                        {
                            [lblStatus setText:@"Private"];
                            strImageName=@"pin.png";
                        }
                        [lblStatus setFont:[UIFont fontWithName:@"Marker Felt" size:25]];
                        [lblStatus setBackgroundColor:[UIColor clearColor]];
                        [lblStatus setTextColor:[UIColor blackColor]];
                        
                        //Display The Pin Button
                        
                        btnPin=[UIButton buttonWithType:UIButtonTypeCustom];
                        btnPin.frame=CGRectMake(10,0,21,31);
                        [btnPin setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                       // NSLog(@"Welcome to else");
                    }
                    

                    
                    
                    
                    
                    
                    UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
                    // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                    btnMark.frame=CGRectMake(150,160,30,30);
                    if ([[muarr_done objectAtIndex:tagValue] isEqualToString:@"0"])
                    {
                        [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                    }
                    
                    [btnMark setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                    [btnMark addTarget:self action:@selector(markBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    btnMark.showsTouchWhenHighlighted=YES;
                    
                    // Label for diaplay a date of reminder
                    
                    // lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(j*145,i*135+5,130,40)];
                    lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(10,30,180,53)];
                    [lbl_date setBackgroundColor:[UIColor clearColor]];
                    if(![[muarr_duedate objectAtIndex:tagValue] isEqualToString:@""])
                    {
                        NSDate *currDate=[NSDate date];
                        NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                        [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                        NSString *strDate=[formatter1 stringFromDate:currDate];
                        NSDate *today=[formatter1 dateFromString:strDate];
                        
                        NSString *stringDate=[muarr_duedate objectAtIndex:tagValue];
                        NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
                        [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
                        
                        // Comparing the date from curent date to reminder date
                        
                        NSDate *newDate=[formatter dateFromString:stringDate];
                        NSComparisonResult  result;
                        result=[today compare:newDate];
                        
                        // Chcking the date whether a date is expired or not
                        
                        if (result==NSOrderedAscending) 
                        {          
                            
                            [lbl_date setTextAlignment:UITextAlignmentCenter];
                            lbl_date.numberOfLines=2;
                            [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                            lbl_date.numberOfLines=2;
                            lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                            if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
                            {
                                [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]]; 
                            }
                            else
                            {
                                 [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:22]];
                            }
                           
                            [viw_note1 addSubview:lbl_date];
                            
                        }
                        else if(result==NSOrderedDescending)
                        {
                            [lbl_date setTextAlignment:UITextAlignmentCenter];
                            lbl_date.textColor=[UIColor redColor];
                            [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                            lbl_date.numberOfLines=2;
                            // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                            if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
                            {
                                [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                            }
                            else
                            {
                                [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:22]];
                            }
                            
                            [viw_note1 addSubview:lbl_date];
                            
                        }
                        else
                        {
                            
                            [lbl_date setTextAlignment:UITextAlignmentCenter];
                            lbl_date.textColor=[UIColor redColor];
                            [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                            lbl_date.numberOfLines=2;
                            // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                            if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
                            {
                                [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                            }
                            else
                            {
                                [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:22]];
                            }
                            
                            [viw_note1 addSubview:lbl_date];
                        }
                        
                    }
                    
                    [viw_note1 addSubview:btnNote];
                    [viw_note1 addSubview:lblName1];
                    [viw_note1 addSubview:btnMark];
                    [viw_note1 addSubview:btnUser];
                    [viw_note1 addSubview:lbl_date];
                    if (![[muarr_privileg objectAtIndex:tagValue] isEqualToString:@""]) 
                    {
                        [viw_note1 addSubview:lblUserName];
                        [viw_note1 addSubview:lblStatus];
                        [viw_note1 addSubview:btnPin];
                    }

                    if (![[muarr_imgname objectAtIndex:tagValue] isEqualToString:@""]) 
                    {
                        [viw_note1 addSubview:btnImage];  
                    }
                    
                    [scrollView1 addSubview:viw_note1];
                    
                }
                
            }
        }
    }
    
}



-(void)imgBtnPressed:(id)sender
{
    UIButton *btnImage=(UIButton *)sender;
    NSLog(@"%d",btnImage.tag
                 );
    imgviw_note.image=btnImage.currentBackgroundImage;
    viw_img.transform = CGAffineTransformScale(viw_img.transform, 0.1, 0.1);
    viw_img.center =self.view.center;
    // im.center=CGPointMake(10, 30);
    [self.view addSubview:viw_img];
    
    [UIView animateWithDuration:1.0 animations:^(void){
        
        viw_img.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationTransitionCurlUp animations:^(void){
            // viw_img.alpha = 0.0;
        } completion:^(BOOL finished) {
           
        }];
        
    }];

    [self.view addSubview:viw_img];
}


-(void)loadDoneNotes:(int)count3
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
    {
    tagValue_done_note=-1;
    int count1=count3/2;
    
    [scr_done_notes setContentSize:CGSizeMake(275, (count1+1)*135)];
    
    for (int i=0; i<=count1; i++) 
    {
        
        for (int j=0; j<2; j++)
        {
            tagValue_done_note++;
            if(tagValue_done_note<count3)
            {
                
                //Loading Setting values fontname ,font color, fontalign
                
                NSString *settings=[muarr_done_settings objectAtIndex:tagValue_done_note];
                NSArray *arry1=[settings componentsSeparatedByString:@","];
                
                // NSLog(@"%@",[arry1 objectAtIndex:2]);
                
                viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*145, i*135, 132, 132)];  
                viw_note1.backgroundColor=[UIColor clearColor];
                [viw_note1 setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                [viw_note1 setExclusiveTouch:YES];
                UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnNote setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                // btnNote.frame=CGRectMake(j*145, i*135, 132, 132);
                btnNote.frame=CGRectMake(0,0,132,132);
                [btnNote setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"note%@.png",[arry1 objectAtIndex:0]]] forState:UIControlStateNormal];
                btnNote.showsTouchWhenHighlighted=NO;
                btnNote.adjustsImageWhenHighlighted=NO;
               
                [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                
                // Swipe Gesture set for button
                
                
                UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
                [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                [viw_note1 addGestureRecognizer:swipeLeft];
                
             
                UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(15,45,100, 30)];
                [lblName1 setText:[muarr_done_name objectAtIndex:tagValue_done_note]];
                [lblName1 setBackgroundColor:[UIColor clearColor]];
                [lblName1 setTextAlignment:UITextAlignmentCenter];
                [lblName1 setTextColor:[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]]];
                [lblName1 setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:15.0]];
                
             
                
                UIButton *btnImage;
                if (![[muarr_done_imgname objectAtIndex:tagValue_done_note] isEqualToString:@""])
                {
                   // NSLog(@"Welcome...");
                    btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnImage.frame=CGRectMake(45,72,40,40);         
                    btnImage.tag=[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue];
                    btnImage.layer.cornerRadius=5.0;
                    btnImage.clipsToBounds=YES;
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[muarr_done_imgname objectAtIndex:tagValue_done_note]];
                    [btnImage setBackgroundImage:[UIImage imageWithContentsOfFile:thumbFilePath] forState:UIControlStateNormal];
                    
                    [btnImage addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                
                else
                {
                   // NSLog(@"Ther is No image");
                }
                
                //Label Setting  Display a date of note entry
                
                UIButton *btnUser=[UIButton buttonWithType:UIButtonTypeCustom];
                // btnUser.frame=CGRectMake(j*145+15, i*135+105,20,20);
                 btnUser.frame=CGRectMake(5,105,20,20);
                [btnUser setBackgroundImage:[UIImage imageNamed:@"user.png" ]forState:UIControlStateNormal];
                [btnUser setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                [btnUser addTarget:self action:@selector(userBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                NSLog(@"Welcome to the USer Button..");
                UILabel *lblUserName,*lblStatus;
                UIButton *btnPin;
                
                if (![[muarr_done_privilege objectAtIndex:tagValue_done_note] isEqualToString:@""] && [muarr_done_privilege objectAtIndex:tagValue_done_note]!=NULL) 
                {
                    
                    NSString *strImageName;
                    
                    lblUserName=[[UILabel alloc] initWithFrame:CGRectMake(25,115,75,12)];
                    [lblUserName setText:[NSString stringWithFormat:@"@%@",[muarr_done_share_list objectAtIndex:tagValue_done_note]]];
                    [lblUserName setFont:[UIFont fontWithName:@"Marker Felt" size:12]];
                    [lblUserName setTextColor:[UIColor darkGrayColor]];
                    lblUserName.backgroundColor=[UIColor clearColor];
                    
                    
                    
                    lblStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,2,70,17)];
                    
                    if ([[muarr_done_privilege objectAtIndex:tagValue_done_note] isEqualToString:@"1" ]) 
                    {
                        [lblStatus setText:@"Public"];
                        strImageName=@"pin1.png";
                    }
                    else
                    {
                        [lblStatus setText:@"Private"]; 
                        strImageName=@"pin.png";
                    }
                    
                    [lblStatus setFont:[UIFont fontWithName:@"Marker Felt" size:17]];
                    [lblStatus setBackgroundColor:[UIColor clearColor]];
                    [lblStatus setTextColor:[UIColor blackColor]];  
                    
                    btnPin=[UIButton buttonWithType:UIButtonTypeCustom];
                    btnPin.frame=CGRectMake(10,0,21,31);
                    [btnPin setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
                    
                }
                else
                    
                {
                     //NSLog(@"End Of the User");
                }
                
                UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
                // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                btnMark.frame=CGRectMake(100,105,20,20);
                if ([[muarr_done_done objectAtIndex:tagValue_done_note] isEqualToString:@"0"])
                {
                    [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                }
                else
                {
                    [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                }
                
                [btnMark setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
               // [btnMark addTarget:self action:@selector(markBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                btnMark.showsTouchWhenHighlighted=YES;
                
                // Label for diaplay a date of reminder
                
                // lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(j*145,i*135+5,130,40)];
                lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(5,23,125,28)];      
                [lbl_date setBackgroundColor:[UIColor clearColor]];
                if(![[muarr_done_duedate objectAtIndex:tagValue_done_note] isEqualToString:@""])
                {
                    NSDate *currDate=[NSDate date];
                    NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                    [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                    NSString *strDate=[formatter1 stringFromDate:currDate];
                    NSDate *today=[formatter1 dateFromString:strDate];
                    
                    NSString *stringDate=[muarr_done_duedate objectAtIndex:tagValue_done_note];
                    NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
                    [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
                    
                    // Comparing the date from curent date to reminder date
                    
                    NSDate *newDate=[formatter dateFromString:stringDate];
                    NSComparisonResult  result;
                    result=[today compare:newDate];
                    
                    // Chcking the date whether a date is expired or not
                    
                    if (result==NSOrderedAscending) 
                    {          
                        
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.numberOfLines=2;
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_done_duedate objectAtIndex:tagValue_done_note]]];
                        lbl_date.numberOfLines=2;
                        lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                        
                    }
                    else if(result==NSOrderedDescending)
                    {
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.textColor=[UIColor redColor];
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_done_duedate objectAtIndex:tagValue_done_note]]];
                        lbl_date.numberOfLines=2;
                        // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                        
                    }
                    else
                    {
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.textColor=[UIColor redColor];
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_done_duedate objectAtIndex:tagValue_done_note]]];
                        lbl_date.numberOfLines=2;
                        // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                    }
                    
                }
                
                NSLog(@"End");
                
                [viw_note1 addSubview:btnNote];
                [viw_note1 addSubview:lblName1];
                [viw_note1 addSubview:btnMark];
                [viw_note1 addSubview:btnUser];
                [viw_note1 addSubview:lbl_date];
                if (![[muarr_done_privilege objectAtIndex:tagValue_done_note] isEqualToString:@""]) 
                {
                [viw_note1 addSubview:lblUserName];
                [viw_note1 addSubview:lblStatus];
                [viw_note1 addSubview:btnPin];
                }
                if (![[muarr_done_imgname objectAtIndex:tagValue_done_note] isEqualToString:@""]) 
                {
                    [viw_note1 addSubview:btnImage];  
                }
                
                [scr_done_notes addSubview:viw_note1];
                
            }
            
        }
    }
    }
    else
    {
        tagValue_done_note=-1;
        int count1=count3/2;
        
        [scr_done_notes setContentSize:CGSizeMake(600, (count1+1)*250)];
        
        for (int i=0; i<=count1; i++) 
        {
            
            for (int j=0; j<3; j++)
            {
                tagValue_done_note++;
                if(tagValue_done_note<count3)
                {
                    
                    //Loading Setting values fontname ,font color, fontalign
                    
                    NSString *settings=[muarr_done_settings objectAtIndex:tagValue_done_note];
                    NSArray *arry1=[settings componentsSeparatedByString:@","];
                    
                    // NSLog(@"%@",[arry1 objectAtIndex:2]);
                    
                    viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*222,i*225,200,200)];   
                    viw_note1.backgroundColor=[UIColor clearColor];
                    [viw_note1 setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                    [viw_note1 setExclusiveTouch:YES];
                    UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                    [btnNote setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                    // btnNote.frame=CGRectMake(j*145, i*135, 132, 132);
                       btnNote.frame=CGRectMake(0,0,200,200);
                    [btnNote setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"note%@.png",[arry1 objectAtIndex:0]]] forState:UIControlStateNormal];
                    btnNote.showsTouchWhenHighlighted=NO;
                    btnNote.adjustsImageWhenHighlighted=NO;
                   [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    // Swipe Gesture set for button
                    
                    
                    UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
                     [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                     [viw_note1 addGestureRecognizer:swipeLeft];
                     
                    
                     UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(15,75,175,50)];
                    [lblName1 setText:[muarr_done_name objectAtIndex:tagValue_done_note]];
                    [lblName1 setBackgroundColor:[UIColor clearColor]];
                    [lblName1 setTextAlignment:UITextAlignmentCenter];
                    [lblName1 setTextColor:[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]]];
                    [lblName1 setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:25.0]];
                    
                    
                  
                    
                    UIButton *btnImage;
                    if (![[muarr_done_imgname objectAtIndex:tagValue_done_note] isEqualToString:@""])
                    {
                        NSLog(@"Welcome...");
                        btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                        btnImage.frame=CGRectMake(70,118,50,50);

                        btnImage.tag=[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue];
                        btnImage.layer.cornerRadius=5.0;
                        btnImage.clipsToBounds=YES;
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[muarr_done_imgname objectAtIndex:tagValue_done_note]];
                        [btnImage setBackgroundImage:[UIImage imageWithContentsOfFile:thumbFilePath] forState:UIControlStateNormal];
                        
                        [btnImage addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                    
                    else
                    {
                        NSLog(@"Ther is No image");
                    }
                    
                    //Label Setting  Display a date of note entry
                    
                    UIButton *btnUser=[UIButton buttonWithType:UIButtonTypeCustom];
                    // btnUser.frame=CGRectMake(j*145+15, i*135+105,20,20);
                     btnUser.frame=CGRectMake(15,160,30,30);
                    [btnUser setBackgroundImage:[UIImage imageNamed:@"user.png" ]forState:UIControlStateNormal];
                    [btnUser setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                    [btnUser addTarget:self action:@selector(userBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    
                    
                    UILabel *lblUserName,*lblStatus;
                    UIButton *btnPin;
                    if (![[muarr_done_privilege objectAtIndex:tagValue_done_note] isEqualToString:@""]) 
                    {
                        //NSLog(@"Welcome to if ");
                        
                        NSString *strImageName;
                        
                        
                        lblUserName=[[UILabel alloc] initWithFrame:CGRectMake(55,170,75,20)];
                        [lblUserName setText:[NSString stringWithFormat:@"@%@",[muarr_done_share_list objectAtIndex:tagValue_done_note]]];
                        [lblUserName setFont:[UIFont fontWithName:@"Marker Felt" size:20]];
                        [lblUserName setTextColor:[UIColor darkGrayColor]];
                        lblUserName.backgroundColor=[UIColor clearColor];
                        
                        
                        
                        lblStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,10,120,25)];
                        if ([[muarr_done_privilege objectAtIndex:tagValue_done_note] isEqualToString:@"1" ]) 
                        {
                            [lblStatus setText:@"Public"];
                            strImageName=@"pin1.png";
                        }
                        else
                        {
                            [lblStatus setText:@"Private"]; 
                            strImageName=@"pin.png";
                        }
                        [lblStatus setFont:[UIFont fontWithName:@"Marker Felt" size:25]];
                        [lblStatus setBackgroundColor:[UIColor clearColor]];
                        [lblStatus setTextColor:[UIColor blackColor]];
                        
                        
                        btnPin=[UIButton buttonWithType:UIButtonTypeCustom];
                        btnPin.frame=CGRectMake(10,0,21,31);
                        [btnPin setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
                        
                    }
                    else
                    {
                       // NSLog(@"Welcome to else");
                    }
                    

                    
                    
                    
                    
                    
                    UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
                    // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                     btnMark.frame=CGRectMake(150,160,30,30);
                    if ([[muarr_done_done objectAtIndex:tagValue_done_note] isEqualToString:@"0"])
                    {
                        [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                    }
                    
                    [btnMark setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                   // [btnMark addTarget:self action:@selector(markBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    btnMark.showsTouchWhenHighlighted=YES;
                    
                    // Label for diaplay a date of reminder
                    
                    // lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(j*145,i*135+5,130,40)];
                     lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(10,30,180,53)];
                    [lbl_date setBackgroundColor:[UIColor clearColor]];
                    if(![[muarr_done_duedate objectAtIndex:tagValue_done_note] isEqualToString:@""])
                    {
                        NSDate *currDate=[NSDate date];
                        NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                        [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                        NSString *strDate=[formatter1 stringFromDate:currDate];
                        NSDate *today=[formatter1 dateFromString:strDate];
                        
                        NSString *stringDate=[muarr_done_duedate objectAtIndex:tagValue_done_note];
                        NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
                        [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
                        
                        // Comparing the date from curent date to reminder date
                        
                        NSDate *newDate=[formatter dateFromString:stringDate];
                        NSComparisonResult  result;
                        result=[today compare:newDate];
                        
                        // Chcking the date whether a date is expired or not
                        
                        if (result==NSOrderedAscending) 
                        {          
                            
                            [lbl_date setTextAlignment:UITextAlignmentCenter];
                            lbl_date.numberOfLines=2;
                            [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_done_duedate objectAtIndex:tagValue_done_note]]];
                            lbl_date.numberOfLines=2;
                            lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                            [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:22]];
                            [viw_note1 addSubview:lbl_date];
                            
                        }
                        else if(result==NSOrderedDescending)
                        {
                            [lbl_date setTextAlignment:UITextAlignmentCenter];
                            lbl_date.textColor=[UIColor redColor];
                            [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_done_duedate objectAtIndex:tagValue_done_note]]];
                            lbl_date.numberOfLines=2;
                            // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                            [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:22]];
                            [viw_note1 addSubview:lbl_date];
                            
                        }
                        else
                        {
                            
                            [lbl_date setTextAlignment:UITextAlignmentCenter];
                            lbl_date.textColor=[UIColor redColor];
                            [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_done_duedate objectAtIndex:tagValue_done_note]]];
                            lbl_date.numberOfLines=2;
                            // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                            [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:22]];
                            [viw_note1 addSubview:lbl_date];
                        }
                        
                    }
                    
                    [viw_note1 addSubview:btnNote];
                    [viw_note1 addSubview:lblName1];
                    [viw_note1 addSubview:btnMark];
                    [viw_note1 addSubview:btnUser];
                    [viw_note1 addSubview:lbl_date];
                    if (![[muarr_done_privilege objectAtIndex:tagValue_done_note] isEqualToString:@""]) 
                    {
                        [viw_note1 addSubview:lblUserName];
                        [viw_note1 addSubview:lblStatus];
                        [viw_note1 addSubview:btnPin];
                    }

                    
                    if (![[muarr_done_imgname objectAtIndex:tagValue_done_note] isEqualToString:@""]) 
                    {
                        [viw_note1 addSubview:btnImage];  
                    }
                    
                    [scr_done_notes addSubview:viw_note1];
                    
                }
                
            }
        }
    }

}


-(void)loadNoteIcon:(int)noOfIcon
{
    
    tagValue=-1;
    int count1=noOfIcon/2;
    
    [scrollView1 setContentSize:CGSizeMake(280, (count1+1)*135)];
    
    for (int i=0; i<=count1; i++) 
    {
        
        for (int j=0; j<2; j++)
        {
            tagValue++;
            if(tagValue<noOfIcon)
            {
                
                //Loading Setting values fontname ,font color, fontalign
                
                NSString *settings=[muarr_settings objectAtIndex:tagValue];
                NSArray *arry1=[settings componentsSeparatedByString:@","];
                
                // NSLog(@"%@",[arry1 objectAtIndex:2]);
                
                viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*145, i*135, 132, 132)];  
                viw_note1.backgroundColor=[UIColor clearColor];
                [viw_note1 setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                [viw_note1 setExclusiveTouch:YES];
                UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnNote setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                // btnNote.frame=CGRectMake(j*145, i*135, 132, 132);
                btnNote.frame=CGRectMake(0,0,132,132);
                [btnNote setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"n%@.png",[arry1 objectAtIndex:0]]] forState:UIControlStateNormal];
                btnNote.showsTouchWhenHighlighted=YES;
                //  [btnNote setTitle:[muarr_note_name objectAtIndex:tagValue] forState:UIControlStateNormal];
                
                // btnNote.titleLabel.font=[UIFont fontWithName:[arry1 objectAtIndex:1] size:17.0];
                
                // btnNote.titleLabel.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                //  btnNote.titleLabel.text=[muarr_note_name objectAtIndex:tagValue];
                [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                
                // Swipe Gesture set for button
                
              /*  UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
                [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                [viw_note1 addGestureRecognizer:swipeLeft];*/
                
                //  UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(j*145+15, i*135+50,100, 30)];
                UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(15,51,100, 30)];
                [lblName1 setText:[muarr_note_name objectAtIndex:tagValue]];
                [lblName1 setBackgroundColor:[UIColor clearColor]];
                [lblName1 setTextAlignment:UITextAlignmentCenter];
                [lblName1 setTextColor:[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]]];
                [lblName1 setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:15.0]];
                
                
                // UIPanGestures settings fot Note Button
                
             /*   longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
                [longPress setMinimumPressDuration:0.5];
                [longPress setDelegate:self];
                [viw_note1 addGestureRecognizer:longPress];
                */
                /*UIPanGestureRecognizer *panRecognizer=[[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)]autorelease];
                 [panRecognizer setDelegate:self];
                 [panRecognizer setMaximumNumberOfTouches:1];
                 [panRecognizer setMinimumNumberOfTouches:1];
                 [viw_note1 addGestureRecognizer:panRecognizer];*/
                
                
                //Label Setting  Display a date of note entry
                
                
                UIButton *btnUser=[UIButton buttonWithType:UIButtonTypeCustom];
                // btnUser.frame=CGRectMake(j*145+15, i*135+105,20,20);
                btnUser.frame=CGRectMake(15,105,20,20);
                [btnUser setBackgroundImage:[UIImage imageNamed:@"user.png" ]forState:UIControlStateNormal];
                
                [btnUser setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                [btnUser addTarget:self action:@selector(userBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
                // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                btnMark.frame=CGRectMake(100,105,20,20);
                if ([[muarr_done objectAtIndex:tagValue] isEqualToString:@"0"])
                {
                    [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                }
                else
                {
                    [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                }
                [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png"] forState:UIControlEventTouchUpInside]; 
                [btnMark setTag:[[muarr_rowid objectAtIndex:tagValue] intValue]];
                btnMark.showsTouchWhenHighlighted=YES;
                //[btnMark addTarget:self action:@selector(markBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
               // [btnMark setEnabled:NO];
                // Label for diaplay a date of reminder
                
                // lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(j*145,i*135+5,130,40)];
                lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(1,5,130,40)];
                [lbl_date setBackgroundColor:[UIColor clearColor]];
                if(![[muarr_duedate objectAtIndex:tagValue] isEqualToString:@""])
                {
                    NSDate *currDate=[NSDate date];
                    NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                    [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                    NSString *strDate=[formatter1 stringFromDate:currDate];
                    NSDate *today=[formatter1 dateFromString:strDate];
                    
                    NSString *stringDate=[muarr_duedate objectAtIndex:tagValue];
                    NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
                    [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
                    
                    // Comparing the date from curent date to reminder date
                    
                    NSDate *newDate=[formatter dateFromString:stringDate];
                    NSComparisonResult  result;
                    result=[today compare:newDate];
                    
                    // Chcking the date whether a date is expired or not
                    
                    if (result==NSOrderedAscending) 
                    {          
                        
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.numberOfLines=2;
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                        lbl_date.numberOfLines=2;
                        lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                        
                    }
                    else if(result==NSOrderedDescending)
                    {
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.textColor=[UIColor redColor];
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                        lbl_date.numberOfLines=2;
                        // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                        
                    }
                    else
                    {
                        
                        [lbl_date setTextAlignment:UITextAlignmentCenter];
                        lbl_date.textColor=[UIColor redColor];
                        [lbl_date setText:[NSString stringWithFormat:@"Due:%@",[muarr_duedate objectAtIndex:tagValue]]];
                        lbl_date.numberOfLines=2;
                        // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                        [lbl_date setFont:[UIFont fontWithName:[arry1 objectAtIndex:1] size:13.0]];
                        [viw_note1 addSubview:lbl_date];
                    }
                    
                }
                
                [viw_note1 addSubview:btnNote];
                [viw_note1 addSubview:lblName1];
                [viw_note1 addSubview:btnMark];
                [viw_note1 addSubview:btnUser];
                [viw_note1 addSubview:lbl_date];
                [scrollView1 addSubview:viw_note1];
                
            }
            
        }
    }
}



- (CAAnimation*)getShakeAnimation 
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CGFloat wobbleAngle = 0.05f;
    
    NSValue* valLeft = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(wobbleAngle, 0.0f, 0.0f, 1.0f)];
    NSValue* valRight = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-wobbleAngle, 0.0f, 0.0f, 1.0f)];
    animation.values = [NSArray arrayWithObjects:valLeft, valRight, nil];
    
    animation.autoreverses = YES;  
    animation.duration = 0.125;
    animation.repeatCount = HUGE_VALF;  
    
    return animation;    
}

-(void)move:(id)sender
{
    UIView *viw2=[(UILongPressGestureRecognizer *)sender view];
    CGPoint point = [sender locationInView:viw2.superview];
    int tagValue1;
    int current_tag=viw2.tag;
    tagValue1=current_tag;
    
    if ([(UILongPressGestureRecognizer *)sender state]==UIGestureRecognizerStateBegan) 
    {
        /*  NSArray *arrViws=[scrollView1 subviews];
         
         for (UIView *viw in arrViws)
         {
         [viw.layer addAnimation:[self getShakeAnimation] forKey:@"transform"];
         }*/
        
        [scrollView1 bringSubviewToFront:viw2];
        /*  viw2.layer.cornerRadius=5.0;
         viw2.layer.shadowOffset=CGSizeMake(1,1);
         viw2.layer.masksToBounds=NO;
         viw2.layer.shadowOpacity=0.7;
         viw2.layer.shadowRadius=10;     
         viw2.layer.shadowPath=[UIBezierPath bezierPathWithRoundedRect:viw2.bounds cornerRadius:10.0].CGPath;*/
        
        viw2.alpha=0.8;
        viw2.transform = CGAffineTransformMakeScale(1.05,1.05);
        [viw2.layer addAnimation:[self getShakeAnimation] forKey:@"transform"];
        
        
        /*[UIView beginAnimations:nil context:NULL];
         [UIView setAnimationDuration:0.9];
         [UIView setAnimationDidStopSelector:@selector(getShakeAnimation)];
         [UIView commitAnimations];*/
        
        
        
        
        
        
        
        
    }
    else if([(UILongPressGestureRecognizer *)sender state]==UIGestureRecognizerStateChanged)
    {
        // NSLog(@"Changed..");
        CGPoint center = viw2.center;
        center.x += point.x - _priorPoint.x;
        center.y += point.y - _priorPoint.y;
        viw2.center = center;
        
    }  
    
    else if([(UILongPressGestureRecognizer *)sender state]==UIGestureRecognizerStateEnded)
    {
        
        [muarr_temp1 removeAllObjects];
        [muarr_temp2 removeAllObjects];
        [muarr_temp3 removeAllObjects];
        [muarr_temp4 removeAllObjects];
        [muarr_temp5 removeAllObjects];
        [muarr_temp6 removeAllObjects];
        [muarr_temp7 removeAllObjects];
        [muarr_temp8 removeAllObjects];
        [muarr_temp9 removeAllObjects];
        [muarr_temp10 removeAllObjects];
        [muarr_temp11 removeAllObjects];
        
        
        // int target_status,current_status;
        
        NSArray  *arr1=[scrollView1 subviews];
        for (UIView *viw1 in arr1)
        {
            if (CGRectIntersectsRect(viw1.frame , viw2.frame) && viw1.tag!=current_tag)
            {
                float different1=viw2.center.x-viw1.center.x;
                float different2=viw2.center.y-viw1.center.y;
                float distance=sqrt((different1 * different1)+(different2*different2));
                if (isFirst)
                {
                    diff=distance;
                    isFirst=NO;
                }
                if (diff>=distance) 
                {  
                    diff=distance;
                    tagValue1=viw1.tag;
                }
            }
        }
        
        isFirst=YES;
        
        
        
        if (tagValue1!=current_tag)
        {
            
            
            if (current_tag-tagValue1>0) 
            {
                
                NSLog(@"UP and Down");
                const char *dbpath=[databasePath UTF8String];
                sqlite3_stmt *statement;
                
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"select * from tbltodolist where rowid=%d",current_tag];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            NSString *str1=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                            NSString *str2=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                            NSString *str3=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                            NSString *str4=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                            const char* heading=(const char*)sqlite3_column_text(statement, 4);
                            
                            NSString *str5=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                            ;
                            
                            const char* share_id=(const char*)sqlite3_column_text(statement, 5);
                            
                            NSString *str6=share_id==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:share_id];
                            ;
                            
                            // NSString *str6=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                            NSString *str7=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                            NSString *str8=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                            
                            const char*imgName=(const char*)sqlite3_column_text(statement, 8);
                            
                            NSString *str9=imgName==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:imgName];
                            
                            const char* priv=(const char*)sqlite3_column_text(statement, 9);
                            
                            NSString *str10=priv==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:priv];
                            
                            const char* sharelist=(const char*)sqlite3_column_text(statement, 10);
                            
                            NSString *str11=sharelist==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:sharelist];
                            
                            
                            [muarr_temp1 addObject:str1];
                            [muarr_temp2 addObject:str2];
                            [muarr_temp3 addObject:str3];
                            [muarr_temp4 addObject:str4];
                            [muarr_temp5 addObject:str5];
                            [muarr_temp6 addObject:str6];
                            [muarr_temp7 addObject:str7];
                            [muarr_temp8 addObject:str8];
                            [muarr_temp9 addObject:str9];
                            [muarr_temp10 addObject:str10];
                            [muarr_temp11 addObject:str11];
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                
                for (int i=0; i<[muarr_temp1 count]; i++)
                {
                    
                }
                
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"delete from tbltodolist where rowid=%d",current_tag];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"select * from tbltodolist where rowid>=%d",tagValue1];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            NSString *str1=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                            NSString *str2=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                            NSString *str3=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                            NSString *str4=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                            const char* heading=(const char*)sqlite3_column_text(statement, 4);
                            
                            NSString *str5=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                            
                            const char* share_id=(const char*)sqlite3_column_text(statement, 5);
                            
                            NSString *str6=share_id==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:share_id];
                            ;
                            NSString *str7=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                            NSString *str8=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                            
                            const char*Str_8=(const char*)sqlite3_column_text(statement, 8);                        
                            NSString *str9=Str_8==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:Str_8];
                            const char* Str_9=(const char*)sqlite3_column_text(statement, 9);                        
                            NSString *str10=Str_9==NULL ? [[NSString alloc] initWithString:nil]:[[NSString alloc] initWithUTF8String:Str_9];
                            
                            const char* Str_10=(const char*)sqlite3_column_text(statement, 10);                        
                            NSString *str11=Str_10==NULL ? [[NSString alloc] initWithString:nil]:[[NSString alloc] initWithUTF8String:Str_10];
                            
                            [muarr_temp1 addObject:str1];
                            [muarr_temp2 addObject:str2];
                            [muarr_temp3 addObject:str3];
                            [muarr_temp4 addObject:str4];
                            [muarr_temp5 addObject:str5];
                            [muarr_temp6 addObject:str6];
                            [muarr_temp7 addObject:str7];
                            [muarr_temp8 addObject:str8];
                            [muarr_temp9 addObject:str9];
                            [muarr_temp10 addObject:str10];
                            [muarr_temp11 addObject:str11];
                            
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"delete from tbltodolist where rowid>=%d",tagValue1];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                count=tagValue1-1;
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    for (int i=0; i<[muarr_temp1 count]; i++)
                    {
                        NSLog(@"%@ %@",[muarr_temp10 objectAtIndex:i],[muarr_temp11 objectAtIndex:i]);
                        count++;
                        NSString *sqlQuery1=[NSString stringWithFormat:@"insert into tbltodolist(rowid,name,detail,date,settings,duedate,share_id,status,done,image_name,privilege,share_list) values(%d,'%@','%@','%@','%@','%@','%d','%@','%@','%@','%@','%@')",count,[muarr_temp1 objectAtIndex:i],[muarr_temp2 objectAtIndex:i],[muarr_temp3 objectAtIndex:i],[muarr_temp4 objectAtIndex:i],[muarr_temp5 objectAtIndex:i],[[muarr_temp6 objectAtIndex:i]intValue],[muarr_temp7 objectAtIndex:i],[muarr_temp8 objectAtIndex:i],[muarr_temp9 objectAtIndex:i],[muarr_temp10 objectAtIndex:i],[muarr_temp11 objectAtIndex:i]];
                        const char *query1=[sqlQuery1 UTF8String];
                        
                        if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                        {
                            while (sqlite3_step(statement)==SQLITE_ROW)
                            {
                                
                            }
                            sqlite3_finalize(statement);
                        } 
                        else
                        {
                            NSLog(@"Error...");
                        }
                    }
                    
                    
                    sqlite3_close(contactDB);
                    
                }
                
            }
            
            else
            {
                
                NSLog(@"Down And Up...");
                
                const char *dbpath=[databasePath UTF8String];
                sqlite3_stmt *statement;
                
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"select * from tbltodolist where rowid=%d",current_tag];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            NSString *str1=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                            NSString *str2=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                            NSString *str3=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                            NSString *str4=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                            const char* heading=(const char*)sqlite3_column_text(statement, 4);
                            
                            NSString *str5=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                            
                            const char* share_id=(const char*)sqlite3_column_text(statement, 5);
                            
                            NSString *str6=share_id==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:share_id];
                            ;
                            NSString *str7=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                            NSString *str8=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                            const char*Str_8=(const char*)sqlite3_column_text(statement, 8);
                            
                            NSString *str9=Str_8==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:Str_8];
                            const char* Str_9=(const char*)sqlite3_column_text(statement, 9);
                            
                            NSString *str10=Str_9==NULL ? [[NSString alloc] initWithString:nil]:[[NSString alloc] initWithUTF8String:Str_9];
                            
                            const char* Str_10=(const char*)sqlite3_column_text(statement, 10);
                            
                            NSString *str11=Str_10==NULL ? [[NSString alloc] initWithString:nil]:[[NSString alloc] initWithUTF8String:Str_10];
                            
                            temp1=str1;
                            temp2=str2;
                            temp3=str3;
                            temp4=str4;
                            temp5=str5;
                            temp6=str6;
                            temp7=str7;
                            temp8=str8;
                            temp9=str9;
                            temp10=str10;
                            temp11=str11;
                            
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"delete from tbltodolist where rowid=%d",current_tag];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"select * from tbltodolist"];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            NSString *str1=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                            NSString *str2=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                            NSString *str3=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                            NSString *str4=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                            const char* heading=(const char*)sqlite3_column_text(statement, 4);
                            
                            NSString *str5=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                            
                            const char* share_id=(const char*)sqlite3_column_text(statement, 5);
                            
                            NSString *str6=share_id==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:share_id];
                            ;
                            
                            NSString *str7=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                            NSString *str8=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                            const char*Str_8=(const char*)sqlite3_column_text(statement, 8);
                            
                            NSString *str9=Str_8==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:Str_8];
                            const char* Str_9=(const char*)sqlite3_column_text(statement, 9);
                            
                            NSString *str10=Str_9==NULL ? [[NSString alloc] initWithString:nil]:[[NSString alloc] initWithUTF8String:Str_9];
                            
                            const char* Str_10=(const char*)sqlite3_column_text(statement, 10);
                            
                            NSString *str11=Str_10==NULL ? [[NSString alloc] initWithString:nil]:[[NSString alloc] initWithUTF8String:Str_10];
                            
                            [muarr_temp1 addObject:str1];
                            [muarr_temp2 addObject:str2];
                            [muarr_temp3 addObject:str3];
                            [muarr_temp4 addObject:str4];
                            [muarr_temp5 addObject:str5];
                            [muarr_temp6 addObject:str6];
                            [muarr_temp7 addObject:str7];
                            [muarr_temp8 addObject:str8];
                            [muarr_temp9 addObject:str9];
                            [muarr_temp10 addObject:str10];
                            [muarr_temp11 addObject:str11];
                            
                        }
                        
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    NSString *sqlQuery1=[NSString stringWithFormat:@"delete  from tbltodolist"];
                    const char *query1=[sqlQuery1 UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                    {
                        while (sqlite3_step(statement)==SQLITE_ROW)
                        {
                            
                        }
                        sqlite3_finalize(statement);
                    }
                    
                    sqlite3_close(contactDB);
                    
                }
                
                count=0;
                int count1=tagValue1-1;
                [muarr_temp1 insertObject:temp1 atIndex:count1];
                [muarr_temp2 insertObject:temp2 atIndex:count1];
                [muarr_temp3 insertObject:temp3 atIndex:count1];
                [muarr_temp4 insertObject:temp4 atIndex:count1];
                [muarr_temp5 insertObject:temp5 atIndex:count1];
                [muarr_temp6 insertObject:temp6 atIndex:count1];
                [muarr_temp7 insertObject:temp7 atIndex:count1];
                [muarr_temp8 insertObject:temp8 atIndex:count1];
                [muarr_temp9 insertObject:temp9 atIndex:count1];
                [muarr_temp10 insertObject:temp10 atIndex:count1];
                [muarr_temp11 insertObject:temp11 atIndex:count1];
                
                
                /*NSLog(@"Temp Count : %d",[muarr_temp1 count]);
                 
                 for (int i=0; i<[muarr_temp1 count]; i++) 
                 {
                 NSLog(@"Name : %@",[muarr_temp1 objectAtIndex:i]);
                 }*/
                
                if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
                {
                    for (int i=0; i<[muarr_temp1 count]; i++)
                    {
                        
                        count++;
                        NSString *sqlQuery1=[NSString stringWithFormat:@"insert into tbltodolist(rowid,name,detail,date,settings,duedate,share_id,status,done,image_name,privilege,share_list) values(%d,'%@','%@','%@','%@','%@','%d','%@','%@','%@','%@','%@')",count,[muarr_temp1 objectAtIndex:i],[muarr_temp2 objectAtIndex:i],[muarr_temp3 objectAtIndex:i],[muarr_temp4 objectAtIndex:i],[muarr_temp5 objectAtIndex:i],[[muarr_temp6 objectAtIndex:i]intValue],[muarr_temp7 objectAtIndex:i],[muarr_temp8 objectAtIndex:i],[muarr_temp9 objectAtIndex:i],[muarr_temp10 objectAtIndex:i],[muarr_temp11 objectAtIndex:i]];
                        const char *query1=[sqlQuery1 UTF8String];
                        
                        if (sqlite3_prepare_v2(contactDB,query1 ,-1,&statement, NULL)==SQLITE_OK)
                        {
                            while (sqlite3_step(statement)==SQLITE_ROW)
                            {
                                
                            }
                            sqlite3_finalize(statement);
                        } 
                        else
                        {
                            NSLog(@"Error...");
                        }
                    }                    
                    sqlite3_close(contactDB);
                    
                }
            }
        }
        
        [self refresh];
    }
    _priorPoint = point;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   // NSLog(@"End...");
}

-(void)markBtnPressed:(id)sender
{
    int btntag=[sender tag];
    
    [self doneNote:btntag];
}

-(void)userBtnPressed:(id)sender
{
   // NSLog(@"%d",[sender tag]);
}


-(void)swipeleft:(id)sender
{
    UIGestureRecognizer  *recognizer=(UIGestureRecognizer *)sender;
    deleteTagValue=recognizer.view.tag;
  
    UIAlertView  *alert1=[[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Do You want delete this Note?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert1 show];
    [alert1 release];
}

-(void)swiperight:(id)sender
{
    UIGestureRecognizer  *recognizer=(UIGestureRecognizer *)sender;
    done=recognizer.view.tag;
    
    UIAlertView  *alert1=[[UIAlertView alloc] initWithTitle:@"Done?" message:@"Do You want  move this Note to Done cork board?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [alert1 show];
    [alert1 release];
}

-(void)swipeleft1
{
    NSLog(@"swipeLeft");
    
    if (instruct<6)
    {
        instruct++;
        
        CATransition *animation=[CATransition animation];
        [animation setType:@"cube"];
        [animation setSubtype:kCATransitionFromRight];
        [animation setDuration:0.5];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[imgviw_instruction layer] addAnimation:animation forKey:@"leftSide"];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]];
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];

        }
        
    }
    
}

-(void)swiperight1
{
    if (instruct>1) 
    {
        instruct--;
        
        CATransition *animation=[CATransition animation];
        [animation setType:@"cube"];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setDuration:0.5];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[imgviw_instruction layer] addAnimation:animation forKey:@"leftSide"];
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_%d.png",instruct]];
        }
        else
        {
            imgviw_instruction.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruct_ipad_%d.png",instruct]];
            
        }
    }
    
}



-(void)doneNote:(int)tagid
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"update TblToDoList set done='1' where rowid=%d",tagid];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
            } 
            
            [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:@"Note successfully moved to Done Cork Board" hideAfter:2.0];     
            
        }
        else
        {
            NSLog(@"Error");
        }
        sqlite3_close(contactDB);
    }
    
    NSLog(@"Get Done Notes");
   [self getDoneNotes];
    
   NSArray *arrSubviews=[scr_done_notes subviews];
    for (UIView *subview in arrSubviews) 
    {
        [subview removeFromSuperview];
    }    
    NSLog(@"Load Done Notes");
    [self loadDoneNotes:[muarr_done_rowid count]];
   
    NSLog(@"Refresh");
    [self refresh];
     NSLog(@"Get All Data");
    [self getAllData];
     NSLog(@"Load Note Button");
    [self loadNoteButton:[muarr_rowid count]];
}

-(void)scrollRight
{
    
    NSLog(@"scroll Right");
    if (!isScrollRight)
    {
        isScrollRight=YES;
        [self getDoneNotes];
        
        NSArray *arrSubviews=[scr_done_notes subviews];
        for (UIView *subview in arrSubviews) 
        {
            [subview removeFromSuperview];
        }    
        [self loadDoneNotes:[muarr_done_rowid count]];
        
        CATransition *animation=[CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setDuration:1.0];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self.view layer] addAnimation:animation forKey:@"leftSide"];
        
        [self.view addSubview:viw_done_notes];
    }
    
   
}


-(void)scrollEnd
{
    [scrollView setContentSize:CGSizeMake(320, 460)]; 
}

-(void)scrollLeft
{    
    isScrollRight=NO;
    CATransition *animation=[CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:1.0];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"leftSide"];
    [viw_done_notes removeFromSuperview];
}

-(CGSize)makeSize:(CGSize)originalSize fitInSize:(CGSize)boxSize
{
    float widthScale = 0;
    float heightScale = 0;
    
    widthScale = boxSize.width/originalSize.width;
    heightScale = boxSize.height/originalSize.height;
    
    float scale = MIN(widthScale, heightScale);
    
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    return newSize;
}

-(void)btnPressed:(id)sender
{
    
    row_id=[sender tag];
    gesture=YES;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
            
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select Name,Detail,Settings,DueDate,image_name,share_id,privilege from TblToDoList where rowid=%d",[sender tag]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                str_noteName=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 0)];
                str_noteDetail=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 1)];
                str_noteSettings=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 2)];
                str_dueDate=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 3)];
                str_note_image=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
                const char *strshare_id=(const char *)sqlite3_column_text(statement, 5);
                
                strShareId=strshare_id==NULL ? [[NSString alloc] initWithString:@""] :[[NSString alloc] initWithUTF8String:strshare_id];
                
                const char *strPrevilage=(const char *)sqlite3_column_text(statement, 6);
               
                privilege=strPrevilage==NULL ? [[NSString alloc] initWithString:@""] : [[NSString alloc ] initWithUTF8String:strPrevilage];
                
                
                //strShareId=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
            } 
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }

    NSArray *array2=[str_noteSettings componentsSeparatedByString:@","];
      
       
       if([str_dueDate isEqualToString:@""])
        {
        lbl_duedate.text=@"No Reminder";
        lbl_duedate.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[array2 objectAtIndex:2]]];
            if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:17.0]; 
            }
            else
            {
                lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:35.0]; 
            }
         
        }
       else
        {
            NSDate *currDate=[NSDate date];
            NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
            [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
            NSString *strDate=[formatter1 stringFromDate:currDate];
            NSDate *today=[formatter1 dateFromString:strDate];
            
            NSString *stringDate=str_dueDate;
            NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
            [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
            
            // Comparing the date from curent date to reminder date
            
            NSDate *newDate=[formatter dateFromString:stringDate];
            NSComparisonResult  result;
            result=[today compare:newDate];
            
            // Chcking the date whether a date is expired or not
            
            if (result==NSOrderedAscending) 
            {
                            
                lbl_duedate.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[array2 objectAtIndex:2]]];
                lbl_duedate.text=str_dueDate;
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                { 
                    lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:17.0];
                }
                else
                {
                     lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:35.0];
                }
               
                
            }
            else if(result==NSOrderedDescending)
            {
                lbl_duedate.textColor=[UIColor redColor];
                lbl_duedate.text=str_dueDate;
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:17.0];
                }
                else
                {
                    lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:35.0];
                }
                
            }
            else
            {
                lbl_duedate.textColor=[UIColor redColor];
                lbl_duedate.text=str_dueDate;
                if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:17.0];
                }
                else
                {
                    lbl_duedate.font=[UIFont fontWithName:@"Marker Felt" size:35.0];
                    
                }
            }
            
        }
    
    btn_no=[[array2 objectAtIndex:0] intValue];
    imgviw_note_color1.image=[UIImage imageNamed:[NSString stringWithFormat:@"note%@.png",[array2 objectAtIndex:0]]];
   
    txtviw_note_name.text=str_noteName;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        txtviw_note_name.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:21.0];
         txtView.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:21.0];

    }
    else
    {
        txtviw_note_name.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:35.0];
        
    }
       txtviw_note_name.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[array2 objectAtIndex:2]]];
   ;
    
    
   /* lbl_note_name.text=str_noteName;
    lbl_note_name.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:21.0];
    lbl_note_name.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[array2 objectAtIndex:2]]];
    */
    
    txtView.text=str_noteDetail;
    txtView.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[array2 objectAtIndex:2]]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
    {
       txtView.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:21.0]; 
    }
    
    else
    {
        txtView.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:35.0];
    }
    
   
    if ([[array2 objectAtIndex:3] isEqualToString:@"Left"])
    {
        txtView.textAlignment=UITextAlignmentLeft;
        
    }
    else if([[array2 objectAtIndex:3]isEqualToString:@"Center"])
    {
        txtView.textAlignment=UITextAlignmentCenter;
    }
    else
    {
        txtView.textAlignment=UITextAlignmentRight;

    }
           
    if (![str_note_image isEqualToString:@""])
    {                
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
        
        UIImage *noteImage=[UIImage imageWithContentsOfFile:thumbFilePath];
    
        int height;
        int width;
        
        height=noteImage.size.height;
        width=noteImage.size.width;

       
        [btn_Note_Image setBackgroundImage:[UIImage imageWithContentsOfFile:thumbFilePath ]forState:UIControlStateNormal];
        
       // btn_Note_Image.hidden=NO;
         [webviw_note_detail reload];
         webviw_note_detail.opaque=NO;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><head><style type=text/css> img{ -webkit-border-radius:7px;}</style></head><body style=color:%@;><img src='file://%@' width='%d' height='%d' align='center' border='1'></img><div border='2'><font face='%@' size=4.5><p style=text-align:%@>%@</p></div></body></html>",[array2 objectAtIndex:2                                                                                                                                                                                                                                                                                                                                                                                                                                            ],thumbFilePath,width,height,[array2 objectAtIndex:1],[array2 objectAtIndex:3],str_noteDetail] baseURL:nil];
 
        }
        else
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><head><style type=text/css> img{ -webkit-border-radius:7px;}</style></head><body style=color:%@;>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='file://%@' width='%d' height='%d' align='middle' border='1'></img><div border='2'><font face='%@' size=6><p style=text-align:%@>%@</p></div></body></html>",[array2 objectAtIndex:2                                                                                                                                                                                                                                                                                                                                                                                                                                                           ],thumbFilePath,width,height,[array2 objectAtIndex:1],[array2 objectAtIndex:3],str_noteDetail] baseURL:nil];

        }
    }
    else
    {
        [webviw_note_detail reload];
        webviw_note_detail.opaque=NO;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><body style=color:%@;><font face='%@' size=4.5><p>%@</p></body></html>",[array2 objectAtIndex:2],[array2 objectAtIndex:1],str_noteDetail] baseURL:nil];
        }
        else
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><body style=color:%@;><font face='%@' size=6><p>%@</p></body></html>",[array2 objectAtIndex:2],[array2 objectAtIndex:1],str_noteDetail] baseURL:nil];
        }
        
        
        [btn_Note_Image setHidden:YES];
    }
    
     // [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><body>%@<p style=text-align:justify;>%@</p></body></html>",temp,str_noteDetail]  baseURL:nil];
    

    imgPhoto.image=nil;
   
    CATransition *animation2=[CATransition animation];
    animation2.delegate=self;
    animation2.duration=0.5;
    animation2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation2.type=kCATransitionPush;
    animation2.subtype=kCATransitionFromRight;
    [[self.view layer] addAnimation:animation2 forKey:@"Zooming"];
    
    
    
    
    [self.view addSubview:viw_note_detail];
}


-(void)getAllData 
 {
     NSLog(@"Welcome To the ");
     
     [muarr_rowid removeAllObjects];
     [muarr_note_date removeAllObjects];
     [muarr_note_detail removeAllObjects];
     [muarr_note_name removeAllObjects];
     [muarr_settings removeAllObjects];
     [muarr_duedate removeAllObjects];
     [muarr_done removeAllObjects];
     [muarr_imgname removeAllObjects];
     [muarr_privileg removeAllObjects];
     [muarr_share_list removeAllObjects];
     

     const char *dbpath = [databasePath UTF8String];
     sqlite3_stmt    *statement;
     
     if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
     {
         NSString *querySQL = [NSString stringWithFormat:@"select rowid,Name,Detail,Date,Settings,DueDate,done,image_name,privilege,share_list from TblToDoList where status='1' and done='0'"];
         
         const char *query_stmt = [querySQL UTF8String];
         
         if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
         {
             while(sqlite3_step(statement) == SQLITE_ROW)
             {
                 NSString  *str_rowid1=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 0)];
                 NSString  *str_note_name=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 1)];
                 NSString  *str_note_detail=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 2)];
                 NSString  *str_note_date=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 3)];
                 NSString  *str_note_settings=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 4)];
                 
                 const char *date1=(const char *)sqlite3_column_text(statement, 5);
                 NSString  *str_note_duedate=date1==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:date1];

                 
                 NSString  *str_note_done=[[NSString alloc] initWithUTF8String:(const char *)  sqlite3_column_text(statement, 6)];
                
                 
                 const char *imgname=(const char *)sqlite3_column_text(statement, 7);
                 NSString  *str_note_image1=imgname==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:imgname];
                 
                 const char *privg=(const char *)sqlite3_column_text(statement, 8);
                 NSString  *str_note_privilage=privg==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:privg];
                 
                 const char *sharelist=(const char *)sqlite3_column_text(statement, 9);
                 NSString  *str_note_share_list=sharelist==NULL?[[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:sharelist];
                
                 [muarr_rowid addObject:str_rowid1];
                 [muarr_note_name addObject:str_note_name];
                 [muarr_note_detail addObject:str_note_detail];
                 [muarr_note_date addObject:str_note_date];
                 [muarr_settings addObject:str_note_settings];
                 [muarr_duedate addObject:str_note_duedate];
                 [muarr_done addObject:str_note_done];
                 [muarr_imgname addObject:str_note_image1];
                 [muarr_privileg addObject:str_note_privilage];
                 [muarr_share_list addObject:str_note_share_list];
                 
             } 
             
             NSLog(@"count %d",[muarr_rowid count]);
             sqlite3_finalize(statement);
         }
         else
         {
             NSLog(@"Something went wrong...");
         }
         sqlite3_close(contactDB);
     }
 }


-(IBAction)btnNoteView
{
    [scrollView setContentOffset:CGPointMake(0, -30) animated:YES];
    [self performSelector:@selector(addNoteSubview) withObject:nil afterDelay:0.5];
    imgPhoto.image=nil;
}

-(void)addNoteSubview
{
     [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    CATransition  *animation1=[CATransition animation];
    animation1.delegate=self;
    animation1.duration=0.5;
    animation1.type=kCATransitionPush;
    animation1.subtype=kCATransitionFromTop;
    animation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[self.view layer] addAnimation:animation1 forKey:@"transition"];
    [self.view addSubview:viw_select_note];
}



-(IBAction)btnSave
{
    if (!isUpdate) 
    {
        // Not Update

    if ([[txt_noteName text] isEqualToString:@""] || [[txtviw_note text] isEqualToString:@""])
    {
        // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning" subtitle:@"You must fill fields values.." hideAfter:2.0];  
    }
    else
    {
        
        [txt_noteName resignFirstResponder];
        [txtviw_note resignFirstResponder];
        NSMutableString  *str_noteName1=[NSMutableString stringWithString:[txt_noteName text]];
        [str_noteName1 replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteName1 length])];
        NSMutableString  *str_noteDesc=[NSMutableString stringWithString:[txtviw_note text]];
        [str_noteDesc replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteDesc length])];
        NSString  *str_settings=[NSString stringWithFormat:@"%d,%@,%@,%@",btn_no,str_textname,str_text_color,str_textalign];
        
        NSString *querySQL;
        NSString *msg;
       // int position;
        NSDate *date=[NSDate date];
        NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM-dd-yyyy"];
        NSString *currentDate=[formatter stringFromDate:date];
        
        NSDateFormatter  *formatter1=[[NSDateFormatter alloc] init];
        
        [formatter1 setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];
        
        NSString *picName=[formatter1 stringFromDate:date];
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        
        NSString *imgName=@"";
        if (isSave)
        {
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
            {
                
                NSString *str_query=[NSString stringWithFormat:@"select count(*) from tbltodolist"];
                
                const char *query_stmt = [str_query UTF8String];
                
                if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    while(sqlite3_step(statement) == SQLITE_ROW)
                    {
                        const char* heading=(const char*)sqlite3_column_text(statement, 0);
                        
                        NSString *strheading=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                        
                        row_id=[strheading intValue];
                        
                    } 
                    
                    sqlite3_finalize(statement);
                    
                }
                else
                {
                    
                }
                sqlite3_close(contactDB);
            }

        }
        
            
        
        if (imgPhoto.image!=nil)
        {     
            NSLog(@"image not nil");
            
            if (isSave)
            {
                
                NSLog(@"isSave");
                NSLog(@"Image Name : %@",str_save_image);
                
            
                if ([str_save_image isEqualToString:@""] || str_save_image==NULL) 
                {
                    NSLog(@" Image Nil");
                    
                    UIImage *image1=imgPhoto.image;
                    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                    NSString *thumbFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName                                                                   ]];
                    imgName=[NSString stringWithFormat:@"Note_%@.png",picName ];
                    NSData *thumbData = UIImagePNGRepresentation(image1);
                    [thumbData writeToFile:thumbFilePath1 atomically:YES];
                    
                    NSString *tempImage=[[NSString alloc] initWithString:imgName];  
                    str_save_image=tempImage;

                }
                else
                {
                    
                    NSLog(@"Image Not Nil");
                    img_no++;
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_save_image];
                    NSError *error=nil;
                    if (![fileManager removeItemAtPath:thumbFilePath error:&error]) 
                    {
                         NSLog(@"Success"); 
                    }
                    else
                    {
                        NSLog(@"%@",error);
                    }
                    
                    UIImage *image1=imgPhoto.image;
                    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                    NSString *thumbFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName                                                                   ]];
                    imgName=[NSString stringWithFormat:@"Note_%@.png",picName ];
                    NSData *thumbData = UIImagePNGRepresentation(image1);
                    [thumbData writeToFile:thumbFilePath1 atomically:YES];
                
                    NSString *tempImage=[[NSString alloc] initWithString:imgName];  
                    str_save_image=tempImage;
                }
                    
            }
            
            else
            {
                
                NSLog(@"Not isSave");
                             img_no++;    
                UIImage *image=imgPhoto.image;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName]];
                imgName=[NSString stringWithFormat:@"Note_%@.png",picName];
                NSData *thumbData = UIImagePNGRepresentation(image);
                [thumbData writeToFile:thumbFilePath atomically:YES];
                NSString *tempImage=[[NSString alloc] initWithString:imgName];

                str_save_image=tempImage;
                
                NSLog(@" Image Name : %@",str_save_image);
                
            }
            
        }
       
        
        //NSLog(@"%@",imgName);
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            if (isSave)
            {
                querySQL = [NSString stringWithFormat:@"update TblToDoList set Name='%@', Detail='%@', settings='%@',DueDate='%@' ,image_name='%@' where rowid=%d",str_noteName1,str_noteDesc,str_settings,str_notifiDate,imgName,row_id]; 
                isUpdate=NO;
                msg=@"Note updated successfully!";
            }
            else
            {
                isSave=YES;
                querySQL = [NSString stringWithFormat:@"insert into TblToDoList(name,detail,date,settings,duedate,image_name,privilege,share_list) values('%@','%@','%@','%@','%@','%@','','')",str_noteName1,str_noteDesc,currentDate,str_settings,str_notifiDate,imgName];
                msg=@"Note added successfully!";
            }
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                } 
                 [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"ToDoNot.es" subtitle:@"ToDoNot.es successfully saved" hideAfter:1.5];
            }
            else
            {
                NSLog(@"Insertion Filure..");
                 [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Error" subtitle:@"Operation couldn't completed..." hideAfter:1.5];
            }
            sqlite3_close(contactDB);
        }
       
    }
        
    }
    else
    {
        [self btnSaveUpdate];
    }

}


-(void)btnSaveUpdate
{
    
    if ([[txt_noteName text] isEqualToString:@""] || [[txtviw_note text] isEqualToString:@""])
    {
        // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning" subtitle:@"You must fill fields values.." hideAfter:2.0];  
    }
    else
    {
        
        isSave=YES;
        
        [txt_noteName resignFirstResponder];
        [txtviw_note resignFirstResponder];
        NSMutableString  *str_noteName1=[NSMutableString stringWithString:[txt_noteName text]];
        [str_noteName1 replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteName1 length])];
        NSMutableString  *str_noteDesc=[NSMutableString stringWithString:[txtviw_note text]];
        [str_noteDesc replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteDesc length])];
        NSString  *str_settings=[NSString stringWithFormat:@"%d,%@,%@,%@",btn_no,str_textname,str_text_color,str_textalign];
        
        NSString *querySQL;
       
        NSDate *date=[NSDate date];
        NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM-dd-yyyy"];
        
        NSString *currentDate=[formatter stringFromDate:date];
        
        NSDateFormatter  *formatter1=[[NSDateFormatter alloc] init];
        
        [formatter1 setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];
        
        NSString *picName=[formatter1 stringFromDate:date];
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        
        NSString *imgName=@"";
       
        
        if (imgPhoto.image!=nil)
        {     
        
            if (isSave)
            {
                
                NSLog(@"isSave");
                NSLog(@"Image Name : %@",str_save_image);
                
                
                if ([str_save_image isEqualToString:@""] || str_save_image==NULL) 
                {
                    NSLog(@" Image Nil");
                    
                    UIImage *image1=imgPhoto.image;
                    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                    NSString *thumbFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName                                                                   ]];
                    imgName=[NSString stringWithFormat:@"Note_%@.png",picName ];
                    NSData *thumbData = UIImagePNGRepresentation(image1);
                    [thumbData writeToFile:thumbFilePath1 atomically:YES];
                    
                    NSString *tempImage=[[NSString alloc] initWithString:imgName];  
                    str_save_image=tempImage;
                    
                }
                else
                {
                    
                    NSLog(@"Image Not Nil");
                    img_no++;
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_save_image];
                    NSError *error=nil;
                    if (![fileManager removeItemAtPath:thumbFilePath error:&error]) 
                    {
                        NSLog(@"Success"); 
                    }
                    else
                    {
                        NSLog(@"%@",error);
                    }
                    
                    UIImage *image1=imgPhoto.image;
                    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                    NSString *thumbFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName                                                                   ]];
                    imgName=[NSString stringWithFormat:@"Note_%@.png",picName ];
                    NSData *thumbData = UIImagePNGRepresentation(image1);
                    [thumbData writeToFile:thumbFilePath1 atomically:YES];
                    
                    NSString *tempImage=[[NSString alloc] initWithString:imgName];  
                    str_save_image=tempImage;
                }
                
            }
            
            else
            {
                
                NSLog(@"Not isSave");
                img_no++;    
                UIImage *image=imgPhoto.image;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName]];
                imgName=[NSString stringWithFormat:@"Note_%@.png",picName];
                NSData *thumbData = UIImagePNGRepresentation(image);
                [thumbData writeToFile:thumbFilePath atomically:YES];
                NSString *tempImage=[[NSString alloc] initWithString:imgName];
                
                str_save_image=tempImage;
                
                NSLog(@" Image Name : %@",str_save_image);
                
            }
            
        }
        else
        {
            imgName=str_note_image;
        }
        
        
        //NSLog(@"%@",imgName);
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
               querySQL = [NSString stringWithFormat:@"update TblToDoList set Name='%@', Detail='%@', settings='%@',DueDate='%@' ,image_name='%@' where rowid=%d",str_noteName1,str_noteDesc,str_settings,str_notifiDate,imgName,row_id]; 
    
               // msg=@"Note updated successfully!";
                
        
           
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                } 
                 [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"ToDoNot.es" subtitle:@"ToDoNot.es successfully saved" hideAfter:1.5];
            }
            else
            {
                NSLog(@"Insertion Filure..");
                 [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Error" subtitle:@"Operation couldn't completed..." hideAfter:1.5];
            }
            sqlite3_close(contactDB);
        }
        
    }
    
}






-(void)addNote
{
    
    if (isUpdate) 
    {
    
    if (!isSave) 
    {
        
    
    if ([[txt_noteName text] isEqualToString:@""] || [[txtviw_note text] isEqualToString:@""])
    {
       // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning" subtitle:@"You must fill fields values.." hideAfter:2.0];  
    }
    else
    {
        
        [txt_noteName resignFirstResponder];
        [txtviw_note resignFirstResponder];
        NSMutableString  *str_noteName1=[NSMutableString stringWithString:[txt_noteName text]];
        [str_noteName1 replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteName1 length])];
        NSMutableString  *str_noteDesc=[NSMutableString stringWithString:[txtviw_note text]];
        [str_noteDesc replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteDesc length])];
        NSString  *str_settings=[NSString stringWithFormat:@"%d,%@,%@,%@",btn_no,str_textname,str_text_color,str_textalign];
        
        NSString *querySQL;
        NSString *msg;
        int position;
        NSDate *date=[NSDate date];
        NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM-dd-yyyy"];
        NSString *currentDate=[formatter stringFromDate:date];
        
        NSDateFormatter  *formatter1=[[NSDateFormatter alloc] init];
        
        [formatter1 setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];
        
        NSString *picName=[formatter1 stringFromDate:date];
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        
        
        NSString *imgName=@"";
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            NSString *str_query=[NSString stringWithFormat:@"select count(*) from tbltodolist"];
             
            const char *query_stmt = [str_query UTF8String];
            
            if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    const char* heading=(const char*)sqlite3_column_text(statement, 0);
                    
                    NSString *strheading=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                   
                    if ([strheading isEqualToString:@""])
                    {
                        position=1;
                    }
                    else
                    {
                        position=[strheading intValue]+1;
                    }
                    
                } 
                
                sqlite3_finalize(statement);
               
            }
            else
            {
               
            }
            sqlite3_close(contactDB);
        }
        
        
        if (imgPhoto.image!=nil)
        {     
            NSLog(@"image not nil");
            
            if (isUpdate)
            {
                
                NSLog(@"Update");
                
                
                if (![str_note_image isEqualToString:@""])
                {
                    // NSLog(@"String not null");
                    img_no++;
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
                    NSError *error=nil;
                    if (![fileManager removeItemAtPath:thumbFilePath error:&error]) 
                    {
                       NSLog(@"Success"); 
                    }
                    else
                    {
                        NSLog(@"%@",error);
                    }
                                        
                    UIImage *image1=imgPhoto.image;
                    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                    NSString *thumbFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName                                                                   ]];
                    imgName=[NSString stringWithFormat:@"Note_%@.png",picName ];
                    NSData *thumbData = UIImagePNGRepresentation(image1);
                    [thumbData writeToFile:thumbFilePath1 atomically:YES];

                }
                else
                {
                    
                   // NSLog(@"String Null");
                    
                    img_no++;
                    UIImage *image=imgPhoto.image;
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName]];
                    imgName=[NSString stringWithFormat:@"Note_%@.png",picName];
                    NSData *thumbData = UIImagePNGRepresentation(image);
                    [thumbData writeToFile:thumbFilePath atomically:YES];

                }
            }
            
            else
            {
                
            NSLog(@"Not Update");
            img_no++;    
            UIImage *image=imgPhoto.image;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName]];
            imgName=[NSString stringWithFormat:@"Note_%@.png",picName];
            NSData *thumbData = UIImagePNGRepresentation(image);
            [thumbData writeToFile:thumbFilePath atomically:YES];
                
            }

        }
        else
        {
            
            NSLog(@"Image null");
            
            if (isUpdate) 
            {
                imgName=str_note_image; 
            }
        }
       
        NSLog(@"%@",imgName);
        
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            if (isUpdate)
            {
                querySQL = [NSString stringWithFormat:@"update TblToDoList set Name='%@', Detail='%@', settings='%@',DueDate='%@' ,image_name='%@' where rowid=%d",str_noteName1,str_noteDesc,str_settings,str_notifiDate,imgName,row_id]; 
                isUpdate=NO;
                msg=@"Note updated successfully!";
                
            }
            else
            {
                querySQL = [NSString stringWithFormat:@"insert into TblToDoList(name,detail,date,settings,duedate,image_name,privilege,share_list) values('%@','%@','%@','%@','%@','%@','','')",str_noteName1,str_noteDesc,currentDate,str_settings,str_notifiDate,imgName];
                msg=@"Note added successfully!";
            }
            
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                } 
               // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:msg hideAfter:1.5];
            }
            else
            {
                NSLog(@"Insertion Filure..");
               // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Error" subtitle:@"Operation couldn't completed..." hideAfter:1.5];
            }
            sqlite3_close(contactDB);
        }
        txtviw_note.text=@"";
        txt_noteName.text=@"";
    }
    str_notifiDate=@"";
    }
    
        else
        {
            // Not Save...
        }
    }
    
    else
    {
        
        // Not Update
        
        
        if (!isSave) 
        {
            
            // is not Save
            
            if ([[txt_noteName text] isEqualToString:@""] || [[txtviw_note text] isEqualToString:@""])
            {
                // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning" subtitle:@"You must fill fields values.." hideAfter:2.0];  
            }
            else
            {
                
                [txt_noteName resignFirstResponder];
                [txtviw_note resignFirstResponder];
                NSMutableString  *str_noteName1=[NSMutableString stringWithString:[txt_noteName text]];
                [str_noteName1 replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteName1 length])];
                NSMutableString  *str_noteDesc=[NSMutableString stringWithString:[txtviw_note text]];
                [str_noteDesc replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str_noteDesc length])];
                NSString  *str_settings=[NSString stringWithFormat:@"%d,%@,%@,%@",btn_no,str_textname,str_text_color,str_textalign];
                
                NSString *querySQL;
                NSString *msg;
                int position;
                NSDate *date=[NSDate date];
                NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"MM-dd-yyyy"];
                NSString *currentDate=[formatter stringFromDate:date];
                
                NSDateFormatter  *formatter1=[[NSDateFormatter alloc] init];
                
                [formatter1 setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];
                
                NSString *picName=[formatter1 stringFromDate:date];
                
                const char *dbpath = [databasePath UTF8String];
                sqlite3_stmt    *statement;
                
                
                NSString *imgName=@"";
                
                if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
                {
                    
                    NSString *str_query=[NSString stringWithFormat:@"select count(*) from tbltodolist"];
                    
                    const char *query_stmt = [str_query UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        while(sqlite3_step(statement) == SQLITE_ROW)
                        {
                            const char* heading=(const char*)sqlite3_column_text(statement, 0);
                            
                            NSString *strheading=heading==NULL ? [[NSString alloc] initWithString:@""]:[[NSString alloc] initWithUTF8String:heading];
                            
                            if ([strheading isEqualToString:@""])
                            {
                                position=1;
                            }
                            else
                            {
                                position=[strheading intValue]+1;
                            }
                            
                        } 
                        
                        sqlite3_finalize(statement);
                        
                    }
                    else
                    {
                        
                    }
                    sqlite3_close(contactDB);
                }
                
                
                if (imgPhoto.image!=nil)
                {     
                    NSLog(@"image not nil");
                    
                    if (isUpdate)
                    {
                        
                        NSLog(@"Update");
                        
                        
                        if (![str_note_image isEqualToString:@""])
                        {
                            // NSLog(@"String not null");
                            img_no++;
                            NSFileManager *fileManager=[NSFileManager defaultManager];
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory = [paths objectAtIndex:0];
                            NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
                            NSError *error=nil;
                            if (![fileManager removeItemAtPath:thumbFilePath error:&error]) 
                            {
                                NSLog(@"Success"); 
                            }
                            else
                            {
                                NSLog(@"%@",error);
                            }
                            
                            UIImage *image1=imgPhoto.image;
                            NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                            NSString *thumbFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName                                                                   ]];
                            imgName=[NSString stringWithFormat:@"Note_%@.png",picName ];
                            NSData *thumbData = UIImagePNGRepresentation(image1);
                            [thumbData writeToFile:thumbFilePath1 atomically:YES];
                            
                        }
                        else
                        {
                            
                            // NSLog(@"String Null");
                            
                            img_no++;
                            UIImage *image=imgPhoto.image;
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory = [paths objectAtIndex:0];
                            NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName]];
                            imgName=[NSString stringWithFormat:@"Note_%@.png",picName];
                            NSData *thumbData = UIImagePNGRepresentation(image);
                            [thumbData writeToFile:thumbFilePath atomically:YES];
                            
                        }
                    }
                    
                    else
                    {
                        
                        NSLog(@"Not Update");
                        img_no++;    
                        UIImage *image=imgPhoto.image;
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Note_%@.png",picName]];
                        imgName=[NSString stringWithFormat:@"Note_%@.png",picName];
                        NSData *thumbData = UIImagePNGRepresentation(image);
                        [thumbData writeToFile:thumbFilePath atomically:YES];
                        
                    }
                    
                }
                else
                {
                    
                    NSLog(@"Image null");
                    
                    if (isUpdate) 
                    {
                        imgName=str_note_image; 
                    }
                }
                
                NSLog(@"%@",imgName);
                
                
                if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
                {
                    
                    if (isUpdate)
                    {
                        querySQL = [NSString stringWithFormat:@"update TblToDoList set Name='%@', Detail='%@', settings='%@',DueDate='%@' ,image_name='%@' where rowid=%d",str_noteName1,str_noteDesc,str_settings,str_notifiDate,imgName,row_id]; 
                        isUpdate=NO;
                        msg=@"Note updated successfully!";
                        
                    }
                    else
                    {
                        querySQL = [NSString stringWithFormat:@"insert into TblToDoList(name,detail,date,settings,duedate,image_name,privilege,share_list) values('%@','%@','%@','%@','%@','%@','','')",str_noteName1,str_noteDesc,currentDate,str_settings,str_notifiDate,imgName];
                        msg=@"Note added successfully!";
                    }
                    
                    
                    const char *query_stmt = [querySQL UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        while(sqlite3_step(statement) == SQLITE_ROW)
                        {
                            
                        } 
                        // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:msg hideAfter:1.5];
                    }
                    else
                    {
                        NSLog(@"Insertion Filure..");
                        // [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Error" subtitle:@"Operation couldn't completed..." hideAfter:1.5];
                    }
                    sqlite3_close(contactDB);
                }
                txtviw_note.text=@"";
                txt_noteName.text=@"";
            }
            str_notifiDate=@"";

        }
        
        else
        {
            // isSave
            
            [self btnSave];
           
        }
        
        
}
}


-(IBAction)close
{
    viw_note_settings.hidden=YES;
}



-(IBAction)back
{    
    
    [muarr_rowid removeAllObjects];
    [muarr_note_date removeAllObjects];
    [muarr_note_detail removeAllObjects];
    [muarr_note_name removeAllObjects];
 
    viw_note_settings.hidden=YES;
    viw_camera.hidden=YES;
    isCameraviw=NO;
    
    [self addNote];
    
    isUpdate=NO;
    isSave=NO;
    str_rowid=@"";
    str_save_image=nil;
    str_save_image=@"";
    
    [self getAllData];
    
    
    
    NSArray  *arrSubviews=[scrollView1 subviews];
    
    for ( UIView *subviw in arrSubviews)
        
    {
        [subviw removeFromSuperview];
    }
    
    tagValue=-1;
    [self loadNoteButton:[muarr_rowid count]];

    [self getDoneNotes];
    
    NSArray *arrSubviews1=[scr_done_notes subviews];
    for (UIView *subview in arrSubviews1) 
    {
        [subview removeFromSuperview];
    }    
    
    [self loadDoneNotes:[muarr_done_rowid count]];

    CATransition  *animation1=[CATransition animation];
    animation1.delegate=self;
    animation1.duration=0.5;
    animation1.type=kCATransitionPush;
    animation1.subtype=kCATransitionFromLeft;
    animation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[self.view layer] addAnimation:animation1 forKey:@"transition"];
    [viw_test removeFromSuperview];
    
    txtviw_note.text=@"";
    txt_noteName.text=@"";
}


-(IBAction)backDetail
{
    CATransition  *animation1=[CATransition animation];
    animation1.delegate=self;
    animation1.duration=0.5;
    animation1.type=kCATransitionPush;
    animation1.subtype=kCATransitionFromLeft;
    animation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[self.view layer] addAnimation:animation1 forKey:@"transition"];
    gesture=NO;
    [viw_test removeFromSuperview];
    [viw_note_detail removeFromSuperview];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *str_title=[alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"%@",str_title);
    if ([str_title isEqualToString:@"Delete"])
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement;
        NSString *str_img;
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"select image_name from TblToDoList where rowid=%d",deleteTagValue];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                   str_img=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    NSLog(@"Image Name : %@",str_img);
                } 
                
            }
            else
            {
                NSLog(@"Error");
            }
            sqlite3_close(contactDB);
        }
        
        
        
        if (![str_img isEqualToString:@""]) 
        {
            NSFileManager *fileManager=[NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_img];
            NSError *error=nil;
            if (![fileManager removeItemAtPath:thumbFilePath error:&error]) 
            {
                NSLog(@"Success"); 
            }
            else
            {
                NSLog(@"%@",error);
            }
           
        }

        
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"update TblToDoList set status=0 where rowid=%d",deleteTagValue];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while(sqlite3_step(statement) == SQLITE_ROW)
                {
                    
                } 
                
             }
            else
            {
                NSLog(@"Error");
            }
            sqlite3_close(contactDB);
        }
   
        
        
        CATransition *animation3=[CATransition animation];
        animation3.delegate=self;
        animation3.duration=0.5;
        animation3.type=@"rippleEffect";
        animation3.timingFunction=[CAMediaTimingFunction functionWithName:
        kCAMediaTimingFunctionEaseInEaseOut];
        [[self.view layer] addAnimation:animation3 forKey:@"animation3"];
        
       
        NSArray  *arrSubviews=[scrollView1 subviews];
        
        for ( UIView *subviw in arrSubviews)
            
        {
            [subviw removeFromSuperview];
        } 
        
        [self getAllData];
     
        [self loadNoteButton:[muarr_rowid count]];
        
        [self getDoneNotes];
        
        NSArray *arrSubviews1=[scr_done_notes subviews];
        for (UIView *subview in arrSubviews1) 
        {
            [subview removeFromSuperview];
        }    
        [self loadDoneNotes:[muarr_done_rowid count]];
       
        
    }
    else if([str_title isEqualToString:@"Done"])
    {        
        [self doneNote:done];
    }
    
    else if([str_title isEqualToString:@"Log out"])
    {
        NSLog(@"Log Out");
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"ACCESS_TOKEN"];
        [defaults setObject:nil forKey:@"Username"];
        [defaults setObject:nil forKey:@"FOLDER_ID"];
        [defaults synchronize];
        [self reloadWhootinSettings]; 
        CATransition *animation6=[CATransition animation];
        [animation6 setType:kCATransitionFade];
        [animation6 setDuration:0.5];
        [animation6 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[btnLogin1 layer] addAnimation:animation6 forKey:@"Fading"];
    }
    else if([str_title isEqualToString:@"Public"])
    {
        
        [self btnWhootinShare:str_title];
    }
    else if([str_title isEqualToString:@"Private"])
    {
          [self btnWhootinShare:str_title];
    }
}



-(IBAction)backFromNoteIcon
{
    [viw_note_icon removeFromSuperview];
}

-(IBAction)backFromNoteColor
{
    
    [viw_select_note removeFromSuperview];
}


-(IBAction)btnBackFromDoneNote
{
    CATransition *animation=[CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:1.0];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"leftSide"];
    
    [self.view addSubview:viw_done_notes];
    [viw_done_notes removeFromSuperview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tblid==1)
    {
        return [muarr_FontList count];
    }
    else if(tblid==2)
    {
        return [muarr_color count];
    }
    else if(tblid==3)
    {
        return [muarr_alignment_list count];
    }
    else if(tblid==4)
    {
        return [muarr_friendsList count];
    }
    else 
    {
        return 0;
    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        if (tblid==4) {
             cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]; 
        }
        
    }
    if (tblid==1) 
    {   
        cell.textLabel.text=[muarr_FontList objectAtIndex:indexPath.row];
      
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            cell.textLabel.font=[UIFont fontWithName:[muarr_FontList objectAtIndex:indexPath.row] size:17.0];
        }
        else
        {
            cell.textLabel.font=[UIFont fontWithName:[muarr_FontList objectAtIndex:indexPath.row] size:25.0];
        }
        
        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    else if(tblid==2)
    {          
        
        cell.textLabel.text=[muarr_ColorList objectAtIndex:indexPath.row];
        
        cell.textLabel.textColor=[UIColor blackColor];
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            CGSize  itemSize=CGSizeMake(55,55);
            UIGraphicsBeginImageContext(itemSize);
            CGRect rectImage=CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            
            UIImage *image_data=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[muarr_ColorList objectAtIndex:[indexPath row                                                                                                        ]]]];
            [image_data drawInRect:rectImage];
            // cell.imageView.image=[muarr_viewtag objectAtIndex:indexPath.row];
            cell.imageView.image=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
             cell.textLabel.font=[UIFont fontWithName:@"Palatino" size:17.0];
        }
        else
        {
            cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[muarr_ColorList objectAtIndex:[indexPath row                                                                                                        ]]]];

            cell.textLabel.font=[UIFont fontWithName:@"Palatino" size:25.0];
        }
       
        
    }
    else if(tblid==3)
    {
        cell.textLabel.text=[muarr_alignment_list objectAtIndex:indexPath.row];
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            
            cell.textLabel.font=[UIFont fontWithName:@"Palatino" size:17.0];
        }
        else
        {
            cell.textLabel.font=[UIFont fontWithName:@"Palatino" size:25.0];
        }
       
        cell.textLabel.textColor=[UIColor blackColor];
        
    }
    else if(tblid==4)
    {
        cell.textLabel.text=[muarr_friendsList objectAtIndex:indexPath.row];
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            cell.textLabel.font=[UIFont fontWithName:@"Marker Felt" size:17.0]; 
        }
        else
        {
            cell.textLabel.font=[UIFont fontWithName:@"Marker Felt" size:25.0]; 
        }
       
    }
    
    /*CATransition *animation4=[CATransition animation];
    animation4.delegate=self;
    animation4.duration=1.0;
    animation4.type=@"cube";
    animation4.subtype=kCATransitionFromBottom;
    animation4.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[cell layer] addAnimation:animation4 forKey:@"Cube"];*/
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // UITableViewCell  *cell1=[tableView cellForRowAtIndexPath:indexPath];
    
    if (tblid==1)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            txtviw_note.font=[UIFont fontWithName:[muarr_FontList objectAtIndex:indexPath.row] size:22.0];
            txt_noteName.font=[UIFont fontWithName:[muarr_FontList objectAtIndex:indexPath.row] size:22.0];
        }
        else
        {
            txtviw_note.font=[UIFont fontWithName:[muarr_FontList objectAtIndex:indexPath.row] size:35.0];
            txt_noteName.font=[UIFont fontWithName:[muarr_FontList objectAtIndex:indexPath.row] size:35.0];
        }
               
        str_textname=[muarr_FontList objectAtIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(tblid==2)
    {
        txtviw_note.textColor=[muarr_color objectAtIndex:indexPath.row];
        txt_noteName.textColor=[muarr_color objectAtIndex:indexPath.row];
        str_text_color=[muarr_ColorList objectAtIndex:indexPath.row];
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(tblid==3)
        
    {
        str_textalign=[muarr_alignment_list objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            txtviw_note.textAlignment=UITextAlignmentLeft; 
        }
        else if(indexPath.row==1)
        {
            txtviw_note.textAlignment=UITextAlignmentCenter; 
        }
        else
        {
            txtviw_note.textAlignment=UITextAlignmentRight;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    else if(tblid==4)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType==UITableViewCellAccessoryNone) 
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            [muarr_friends addObject:[muarr_friendsList objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryNone;
            [muarr_friends removeObject:[muarr_friendsList objectAtIndex:indexPath.row]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{   
    if (!isTextFiled)
    {
        isTextFiled=YES;
        btn_hide.hidden=NO;
        [txtviw_note becomeFirstResponder];
        CGAffineTransform transform=self.view.transform;
        self.view.transform=CGAffineTransformTranslate(transform, 0, -180 );
        viw_settings.hidden=YES; 
    }
    
   
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   /* CGAffineTransform transform=viw_settings.transform;
    viw_settings.transform=CGAffineTransformTranslate(transform, 0, -180 );
    viw_settings.hidden=NO;*/
}

-(IBAction)txtFieldReturn
{
    NSLog(@"TextField");
    [txt_noteName resignFirstResponder];
}

/*-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGAffineTransform transform=self.view.transform;
    self.view.transform=CGAffineTransformTranslate(transform, 0, 100 ); 
    CGAffineTransform transform1=viw_settings.transform;
    viw_settings.transform=CGAffineTransformTranslate(transform1, 0, 80);
    viw_settings.hidden=YES;
    [txt_noteName resignFirstResponder];
}*/

-(IBAction)hideKeyPad
{
    [txtviw_note resignFirstResponder];
    isTextFiled=NO;
    btn_hide.hidden=YES;
    viw_settings.hidden=NO;
    CGAffineTransform transform=self.view.transform;
    self.view.transform=CGAffineTransformTranslate(transform, 0, 180                                                 );
}



-(IBAction)segment:(id)sender
{
    int a=segmenatlCOntrol.selectedSegmentIndex;
    NSLog(@"%d",a);
    if (a==4)
    {
       
            NSLog(@"End");
            CGAffineTransform transform=self.view.transform;
            self.view.transform=CGAffineTransformTranslate(transform, 0, 180                                                 );
            viw_settings.hidden=YES;
            [txtviw_note resignFirstResponder];
            
            [self addNote];
            
    }
}


-(IBAction)btnUpdate
{
  
    NSLog(@"%f",txtView.font.pointSize);;
    isUpdate=YES;
    gesture=NO;
    txtviw_note.text=str_noteDetail;
    txtviw_note.textColor=[txtView textColor];
    txtviw_note.font=[txtView font];
    // str_notifiDate=lbl_duedate.text;
    str_notifiDate=str_dueDate;
    
    str_save_image=str_note_image;
    
    imgPhoto.image=nil;
    
    txt_noteName.text=str_noteName;
    txt_noteName.textColor=[txtView textColor];
    txt_noteName.font=[txtView font];
    
    imgviw_note_color.image=[UIImage imageNamed:[NSString stringWithFormat:@"note%d.png",btn_no]];
    [viw_note_detail removeFromSuperview];
    [self.view addSubview:viw_test];
}


-(IBAction)camera_or_gallery:(id)sender
{
    if ([sender tag]==100)
    {
        viw_camera.hidden=YES;
        isCameraviw=NO;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
            imagePicker.delegate=self;
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
          
            [self presentModalViewController:imagePicker animated:YES]; 
        }
        else
        {
            UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"This device is not compatible" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert1 show];
            [alert1 release];
        }
       
    }
    else
    {
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            viw_camera.hidden=YES;
            isCameraviw=NO;
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
            imagePicker.delegate=self;
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.editing=YES;
            [self presentModalViewController:imagePicker animated:YES]; 
        }
        else
        {
            viw_camera.hidden=YES;
            isCameraviw=NO;
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;  
            [imagePicker setDelegate:self];
            imagePicker.wantsFullScreenLayout=YES;
            popOverController=[[UIPopoverController alloc]initWithContentViewController:imagePicker];
            popOverController.delegate=self;
            //popOverController.popoverContentSize=CGSizeMake(500,500);
            [self.popOverController setPopoverContentSize:CGSizeMake(700,500) animated:YES];
            CGRect selectedRect = CGRectMake(450,790,250,500);
            [self.popOverController presentPopoverFromRect:selectedRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES]; 
        }
        
    }
}


-(IBAction)btnInstPressed:(id)sender
{
    if ([sender tag]==1)
    {
        [UIView beginAnimations:@"flip next " context:nil];
        [UIView setAnimationDuration:1.0];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [self.view addSubview:viw_instruction_menu];

        [UIView commitAnimations];
         }
    else if([sender tag]==2)
    {
        [UIView beginAnimations:@"flip next " context:nil];
        [UIView setAnimationDuration:1.0];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [viw_instruction_menu removeFromSuperview];
        [UIView commitAnimations];
        
    }
    else
    {
        CATransition *animation5=[CATransition animation];
        [animation5 setDuration:0.5];
        [animation5 setType:@"cube"];
        [animation5 setSubtype:kCATransitionFromLeft];
        [animation5 setDelegate:self];
        [[self.view layer] addAnimation:animation5 forKey:@"hide"];
        [viw_inst_detail removeFromSuperview];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Notofication methods


-(IBAction)btnReminder
{
    viw_notifi.hidden=NO;
    viw_note_settings.hidden=YES;
    viw_camera.hidden=YES;
    isCameraviw=NO;
    [txt_noteName resignFirstResponder];
    isNotifi=YES;
}
-(IBAction)btnSetNotifi
{
        str_notifiDate=@"";
    
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        // Get the current date
        NSDate *pickerDate = [datePicker date];
        
        NSDate *date1=pickerDate;
        
        NSDateFormatter  *formatter=[[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
        str_notifiDate=[[NSString alloc] initWithString:[formatter stringFromDate:date1]];
        NSLog(@"%@",str_notifiDate);
      
	
        // Break the date up into components
        NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) 
												   fromDate:pickerDate];
        NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) 
												   fromDate:pickerDate];
	
	// Set up the fire time
        NSDateComponents *dateComps = [[NSDateComponents alloc] init];
        [dateComps setDay:[dateComponents day]];
        [dateComps setMonth:[dateComponents month]];
        [dateComps setYear:[dateComponents year]];
        [dateComps setHour:[timeComponents hour]];
	// Notification will fire in one minute
        [dateComps setMinute:[timeComponents minute]];
        [dateComps setSecond:[timeComponents second]];
        NSDate *itemDate = [calendar dateFromComponents:dateComps];
        [dateComps release];
	
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
        return;
        localNotif.fireDate = itemDate;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
        // Notification details
        localNotif.alertBody = [NSString stringWithFormat:@"%@\n%@",[txt_noteName text],[txtviw_note text]];
        // Set the action button
        localNotif.alertAction = @"View";
        localNotif.hasAction=YES;
        localNotif.userInfo=[NSDictionary dictionaryWithObject:@"Welcome1" forKey:@"1"];
        //localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.soundName=UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
	
	// Specify custom data for the notification
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        localNotif.userInfo = infoDict;
	
	// Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        [localNotif release];
        isNotifi=NO;
        viw_notifi.hidden=YES;
    
}

-(void)refresh
{
    NSArray  *arrSubviews=[scrollView1 subviews];
    
    for ( UIView *subviw in arrSubviews)
        
    {
        [subviw removeFromSuperview];
    }
    
    tagValue=-1;
    [self getAllData];
    [self loadNoteButton:[muarr_rowid count]];
}



-(void)refresh1
{
    NSArray  *arrSubviews=[scrollView1 subviews];
    
    for ( UIView *subviw in arrSubviews)
        
    {
        [subviw removeFromSuperview];
    }
    
    tagValue=-1; 
}


-(IBAction)btnPhoto
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (btn_hide.isHidden)
    {
        if (isCameraviw) 
        {
            isCameraviw=NO;
            viw_camera.hidden=YES;  
        }
        else
        {
            isCameraviw=YES;
            viw_camera.hidden=NO; 
        }
        
    }
    else
    {
        isCameraviw=YES;
        [self hideKeyPad];
        viw_camera.hidden=NO;
    }

        
    }
    else
    {
        if (isCameraviw) 
        {
            isCameraviw=NO;
            viw_camera.hidden=YES;  
        }
        else
        {
            isCameraviw=YES;
            viw_camera.hidden=NO; 
        }
    }
        
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imgPhoto.image=nil;
    UIImage *image1=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    int height;
    int width;
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if (image1.size.width>=240)
        {
            NSLog(@"No Image");
            if (image1.size.width!=image1.size.height)
            {
                    CGSize szFinal=[self makeSize:CGSizeMake(image1.size.width,image1.size.height) fitInSize:CGSizeMake(240, 200)];
                    width=szFinal.width;
                    height=szFinal.height;
            }
            else
            {
                NSLog(@"Same Height and Width");
                height=image1.size.height;
                width=image1.size.width;
            }
        }
        else
        {
            height=image1.size.height;
            width=image1.size.width;
        } 
    }
    else
    {
    if (image1.size.width>=400)
    {
        NSLog(@"No Image");
        if (image1.size.width!=image1.size.height)
        {
                CGSize szFinal=[self makeSize:CGSizeMake(image1.size.width,image1.size.height) fitInSize:CGSizeMake(400, 400)];
                width=szFinal.width;
                height=szFinal.height;
        }
        else
        {
            NSLog(@"Same Height and Width");
            height=image1.size.height;
            width=image1.size.width;
        }
    }
    else
    {
        height=image1.size.height;
        width=image1.size.width;
    }
    
    } 
    

    
    
    
    
    CGSize  itemSize=CGSizeMake(width,height);
    UIGraphicsBeginImageContext(itemSize);
    CGRect rectImage=CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    UIImage *image_data=image1;
    [image_data drawInRect:rectImage];
     imgPhoto.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   UIAlertView *alertSuccess=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Image successfully added to Note!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];  
    [alertSuccess show];
    [alertSuccess release];
    [popOverController dismissPopoverAnimated:YES];
    [self dismissModalViewControllerAnimated:YES]; 
}




-(IBAction)btnClose
{
    viw_img.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viw_img.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [viw_img removeFromSuperview];
        
    }];
}



-(IBAction)btnImgShow
{
    if (![str_note_image isEqualToString:@""])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
        
        NSLog(@"%@",thumbFilePath);
        
        imgviw_note.image=[UIImage imageWithContentsOfFile:thumbFilePath];
        
        
      
        viw_img.transform = CGAffineTransformScale(viw_img.transform, 0.1, 0.1);
        viw_img.center = self.view.center;
        // im.center=CGPointMake(10, 30);
        [self.view addSubview:viw_img];
        
        [UIView animateWithDuration:1.0 animations:^(void){
            
            viw_img.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished)
        {
            
            [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationTransitionCurlUp animations:^(void){
               // viw_img.alpha = 0.0;
            } completion:^(BOOL finished) {
                //[im removeFromSuperview];
            }];
            
        }];
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Image For This Note" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert1 show];
        [alert1 release];
    }
     
}

-(BOOL)internetServicesAvailable
{
    return [[Reachability1 reachabilityForInternetConnection] currentReachabilityStatus];
	
}


-(IBAction)btnShare
{
    
    if (![self internetServicesAvailable]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Internet Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
    else
    {
    
    if ([strShareId isEqualToString:@""])
    {
        btnFriendsList.enabled=NO;
    }
    else
    {
        btnFriendsList.enabled=YES;
    }
        viw_share.transform = CGAffineTransformMakeScale( 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped1)];
        viw_share.transform = CGAffineTransformMakeScale( 1.1, 1.1);
        [UIView commitAnimations]; 
        [self.view addSubview:viw_share];
        isShare=YES;
    }
}


- (void)bounce1AnimationStopped1 
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped2)];
    viw_share.transform = CGAffineTransformMakeScale (0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped2
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    
    viw_share.transform =  CGAffineTransformIdentity;
    [UIView commitAnimations];
    
}


#pragma mark Whootin Login Controls


-(IBAction)btnPostAlert:(id)sender
{
    if ([sender tag]==1)
    {
        viw_share.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viw_share.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            [viw_share removeFromSuperview];
             isShare=NO;
        }];
       
        [self btnWhootinShare:@"Public"];
    }
    else
    {
        viw_share.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            viw_share.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            [viw_share removeFromSuperview];
            isShare=NO;
        }];
        
        [self btnWhootinShare:@"Private"];
    }
}

-(void)btnWhootinShare:(NSString *)mode
{
    NSArray *array2=[str_noteSettings componentsSeparatedByString:@","];

    if (![self internetServicesAvailable]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Internet Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
    else
    {
    
    if ([str_dueDate isEqualToString:@""]) 
    {
        str_dueDate=@" ";
    }
    
    if (kAccessToken)
    {
       
        NSDate *date1=[NSDate date];
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM_dd_YYYY_hh_mm_ss_SS"];
        NSLog(@"Date : %@",[dateFormat stringFromDate:date1]);
        NSString *date2=[dateFormat stringFromDate:date1];
        
        str_note_name1=[NSString stringWithFormat:@"Note_%@",date2];
        

        
             
        NSString *sFolderId = [NSString stringWithFormat:@"%@",kFolderId];
        
        NSLog(@"Folder Id : %@",sFolderId);
        
    
        if (![str_note_image isEqualToString:@""]) 
        {
            
            NSLog(@"Image is there..");
            
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
        UIImage *image1=[UIImage imageWithContentsOfFile:thumbFilePath];
            
        NSData *imageData=UIImagePNGRepresentation(image1);
        
        
               
        NSURL *postURL = [[NSURL alloc] initWithString:@"http:/whootin.com/api/v1/files/new.json"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
        // change type to POST (default is GET)
        [request setHTTPMethod:@"POST"];
        
        // just some random text that will never occur in the body
        NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
        
        // header value
        NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                    stringBoundary];
        
        // set header
        [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
        
        //add body
        NSMutableData *postBody = [NSMutableData data];
        NSLog(@"body made");
        
        //wigi access token 
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"folder_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[sFolderId dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //image
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n",str_note_name1] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [postBody appendData:imageData];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
            NSLog(@"message added");
        
        
        
        // final boundary
        [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // add body to post
        [request setHTTPBody:postBody];
        
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
        
        //NSLog(@"body set");
        // pointers to some necessary objects
        NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
        NSError* error = [[NSError alloc] init] ;
        
        // synchronous filling of data from HTTP POST response
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
         
          
        NSDictionary *json = [newStr JSONValue];
            
            // 
            
        NSString *sError=[json objectForKey:@"error"];
    
        
        if (sError==nil)
        {
            
            NSString *strUrl=[json objectForKey:@"url"];
            
            NSString *string1=strUrl;
            // NSLog(@"%@",string1);
            NSString *string2=@"&";
            // NSLog(@"%@",string2);
            NSMutableString *string3=[NSMutableString stringWithString:string1];
            //[string3 replaceCharactersInRange:[string3 rangeOfString:string2 ] withString:[NSString stringWithFormat:@"<span style=background-color:yellow>%@</span>",string2]];
            [string3 replaceOccurrencesOfString:string2 withString:@"&amp;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string3 length])];         
            
            if ([mode isEqualToString:@"Public"])
            {
                if (isScrollRight)
                {
                      APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]]; 
                }
                else
                {
                      APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]]; 
                }
                
                privilege=@"1";
             
            }
            else
            {
                if (isScrollRight) 
                {
                      APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                }
                else
                {
                     APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                }
                
                privilege=@"0";
              
            }
            
            
            NSLog(@"%@",APP.wMessage);
            
            NSURL *postURL = [[NSURL alloc] initWithString:@"http:/whootin.com/api/v1/files/new.json"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
            // change type to POST (default is GET)
            [request setHTTPMethod:@"POST"];
            
            // just some random text that will never occur in the body
            NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
            
            // header value
            NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                        stringBoundary];
            
            // set header
            [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
            
            //add body
            NSMutableData *postBody = [NSMutableData data];
            NSLog(@"body made");
            
            //wigi access token 
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"folder_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[sFolderId dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //image
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.xml\"\r\n",str_note_name1] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Type: xml/text\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [postBody appendData:[APP.wMessage dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"message added");
            
            
            
            // final boundary
            [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // add body to post
            [request setHTTPBody:postBody];
            
            
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
            
            //NSLog(@"body set");
            // pointers to some necessary objects
            NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
            NSError* error = [[NSError alloc] init] ;
            
            // synchronous filling of data from HTTP POST response
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            
            NSDictionary *json = [newStr JSONValue];
            
            NSLog(@"%@",json); 
            
            NSString *sError=[json objectForKey:@"error"];
           
            if (sError==nil) 
            {
            
                int share_id=[[json objectForKey:@"id"] intValue];
                const char *dbpath = [databasePath UTF8String];
                sqlite3_stmt    *statement;            
                
                if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
                {
                    
                    NSString *str_query=[NSString stringWithFormat:@"update TblToDoList set privilege='%@',share_id=%d,share_list='%@' where rowid=%d",privilege,share_id,kUsername,row_id];
                    
                    const char *query_stmt = [str_query UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        while(sqlite3_step(statement) == SQLITE_ROW)
                        {
                            
                        } 
                        
                        sqlite3_finalize(statement);
                        
                    }
                    else
                    {
                        
                    }
                    sqlite3_close(contactDB);
                }
                
                
                [self getAllData];
                [self loadNoteButton:[muarr_rowid count]];
                
                [self getDoneNotes];
                NSArray *arrSubviews=[scr_done_notes subviews];
                for (UIView *subview in arrSubviews) 
                {
                    [subview removeFromSuperview];
                }    
                [self loadDoneNotes:[muarr_done_rowid count]];
                
                 [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:@"Note successfully shared in ToDoNot.es" hideAfter:2.0]; 
            }
            else
            {
                showAlert(sError);
            }
        }
        
           
        }
        else
        {
            NSLog(@"Welcome to xml file upload...");
            
            
            if ([mode isEqualToString:@"Public"]) 
            {
                if (isScrollRight) 
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]]; 
                }
                else
                {
                     APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                }
                privilege=@"1";
              
            }
            else
            {
                
                if (isScrollRight) 
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note></Notes>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                    
                }
                else
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                }
                privilege=@"0";
                
            }
            
            NSLog(@"%@",APP.wMessage);
            
            NSURL *postURL = [[NSURL alloc] initWithString:@"http:/whootin.com/api/v1/files/new.json"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
            // change type to POST (default is GET)
            [request setHTTPMethod:@"POST"];
            
            // just some random text that will never occur in the body
            NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
            
            // header value
            NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                        stringBoundary];
            
            // set header
            [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
            
            //add body
            NSMutableData *postBody = [NSMutableData data];
            NSLog(@"body made");
            
            //wigi access token 
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"folder_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[sFolderId dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //image
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.xml\"\r\n",str_note_name1] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Type: xml/text\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [postBody appendData:[APP.wMessage dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"message added");
            
            
            
            // final boundary
            [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // add body to post
            [request setHTTPBody:postBody];
            
            
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
            
            //NSLog(@"body set");
            // pointers to some necessary objects
            NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
            NSError* error = [[NSError alloc] init] ;
            
            // synchronous filling of data from HTTP POST response
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            
            NSDictionary *json = [newStr JSONValue];
            
            NSLog(@"%@",json);
            
            NSString *sError=[json objectForKey:@"error"];
            if (sError==nil) 
            {
                int share_id=[[json objectForKey:@"id"] intValue];
                const char *dbpath = [databasePath UTF8String];
                sqlite3_stmt    *statement;            
                
                if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
                {
                    NSString *str_query=[NSString stringWithFormat:@"update TblToDoList set privilege='%@',share_id=%d,share_list='%@' where rowid=%d",privilege,share_id,kUsername,row_id];
                    
                    const char *query_stmt = [str_query UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        while(sqlite3_step(statement) == SQLITE_ROW)
                        {
                            
                        } 
                        sqlite3_finalize(statement);
                        
                    }
                    else
                    {
                        
                    }
                    sqlite3_close(contactDB);
                }
                
                // Refresh  all notes
                
                [self getAllData];
                [self loadNoteButton:[muarr_rowid count]];
                
                // Refresh Done Note
                
                [self getDoneNotes];
                NSArray *arrSubviews=[scr_done_notes subviews];
                for (UIView *subview in arrSubviews) 
                {
                    [subview removeFromSuperview];
                }    
                [self loadDoneNotes:[muarr_done_rowid count]];

                
                
                [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:@"Note successfully shared in ToDoNot.es" hideAfter:2.0]; 
            }
            else
            {
                showAlert(sError);
            }
            
 
        }

    }
}
      
}

-(void)hide
{
    [APP.lbl setText:@"Success"];
    [APP.Alertview setHidden:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self getAllData];
    [self loadNoteButton:[muarr_rowid count]];
    
    
    UITapGestureRecognizer *gs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    gs.numberOfTapsRequired =1;
    gs.delegate = self;
    [webviw_note_detail addGestureRecognizer:gs];
    
    
       
    UISwipeGestureRecognizer *swipeLeft1=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft1)];
    [swipeLeft1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [imgviw_instruction addGestureRecognizer:swipeLeft1];
    
    UISwipeGestureRecognizer *swipeRight2=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiperight1)];
    [swipeRight2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [imgviw_instruction addGestureRecognizer:swipeRight2];
    
    [self reloadWhootinSettings];
     lblUserName1.transform=CGAffineTransformMakeRotation(-M_PI/10);
     lblUserName2.transform=CGAffineTransformMakeRotation(-M_PI/10);
     lblUserName3.transform=CGAffineTransformMakeRotation(-M_PI/10);
    [super viewWillAppear:animated];
}


-(void)reloadWhootinSettings
{
    
    if (kAccessToken)
    {
        [btnLogin1 setBackgroundImage:[UIImage imageNamed:@"logout_btn.png"] forState:UIControlStateNormal];
        [btnLogin2 setBackgroundImage:[UIImage imageNamed:@"logout_btn.png"] forState:UIControlStateNormal];
        [btnLogin3 setBackgroundImage:[UIImage imageNamed:@"logout_btn.png"] forState:UIControlStateNormal];
        btnLogin1.tag=2;
        btnLogin2.tag=2;
        btnLogin3.tag=2;
        lblUserName1.hidden=NO;
        lblUserName2.hidden=NO;
        lblUserName3.hidden=NO;
        
        lblUserName1.text=[NSString stringWithFormat:@"@%@",kUsername];
        lblUserName2.text=[NSString stringWithFormat:@"@%@",kUsername];
        lblUserName3.text=[NSString stringWithFormat:@"@%@",kUsername];
        
        lblUser.text=[NSString stringWithFormat:@"@%@",kUsername];
    
        
        btnShareNotes.hidden=NO;
        
        btnShare.hidden=NO;
        
    }
    else
    {
        [btnLogin1 setBackgroundImage:[UIImage imageNamed:@"login-btn.png"] forState:UIControlStateNormal];
        [btnLogin2 setBackgroundImage:[UIImage imageNamed:@"login-btn.png"] forState:UIControlStateNormal];
        [btnLogin3 setBackgroundImage:[UIImage imageNamed:@"login-btn.png"] forState:UIControlStateNormal];
        
        btnLogin1.tag=1;
        btnLogin2.tag=1;
        btnLogin3.tag=1;
        
        lblUserName1.hidden=YES;
        lblUserName2.hidden=YES;
        lblUserName3.hidden=YES;
        lblUserName1.text=nil;
        lblUserName2.text=nil;
        lblUserName3.text=nil;
        lblUser.text=nil;
        btnShare.hidden=YES;
        btnShareNotes.hidden=YES;
        
    }
 
}





-(IBAction)btnLoginView:(id)sender
{
    if ([sender tag]==1)
    
    {       
        viw_login_or_signup.transform = CGAffineTransformMakeScale( 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        viw_login_or_signup.transform = CGAffineTransformMakeScale( 1.1, 1.1);
        [UIView commitAnimations]; 
        [self.view addSubview:viw_login_or_signup];
 
    }
    
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Log out" message:@"Do you really  want to Log out?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
        alert1.delegate=self;
        [alert1 show];
        [alert1 release];
       
    }
    
}

- (IBAction)bounceView:(id)sender{
    
       
}

- (void)bounce1AnimationStopped 
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    viw_login_or_signup.transform = CGAffineTransformMakeScale (0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    
    viw_login_or_signup.transform =  CGAffineTransformIdentity;
    [UIView commitAnimations];
    
}

-(IBAction)btnLoginORSignup:(id)sender
{
   
    
    if ([sender tag]==1) 
    {
       
        WhootinViewController *login;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
             {
               login=[[WhootinViewController alloc] initWithNibName:@"WhootinViewController_iPhone" bundle:nil];
                            
             }
        else
        {
             login=[[WhootinViewController alloc] initWithNibName:@"WhootinViewController_iPad" bundle:nil];
        }
        
        [self presentModalViewController:login animated:YES];
        
        
       /* [[HMGLTransitionManager sharedTransitionManager] setTransition:transition];
        [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:login onViewController:self];
        [login release];*/
        
    } 
    else
    {
       /* UserSignUp *signup=[[UserSignUp alloc] init];
        [signup setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentModalViewController:signup animated:YES];*/
        WhootinViewController *login;
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
           login=[[WhootinViewController alloc] initWithNibName:@"WhootinViewController_iPhone" bundle:nil];
           [login addSignupView]; 
        }
        else
        {
            login=[[WhootinViewController alloc] initWithNibName:@"WhootinViewController_iPad" bundle:nil];
            [login addSignupView];
        }
        [self presentModalViewController:login animated:YES];

       /* [[HMGLTransitionManager sharedTransitionManager] setTransition:transition];
        [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:login onViewController:self];*/
    }
    
      [viw_login_or_signup removeFromSuperview];
   
}


-(IBAction)btncancel
{
    viw_login_or_signup.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viw_login_or_signup.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [viw_login_or_signup removeFromSuperview];
        
    }];
   
}

-(IBAction)btnGetEntourage
{
    
    if (![self internetServicesAvailable]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Internet Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
    else
    {
    
    if (!viw_entourage.isHidden)
    {
        viw_entourage.hidden=YES;
        isentourage=NO;
    }
    else
    {
        [txtUserList becomeFirstResponder];
        [muarr_friends removeAllObjects];
        viw_entourage.hidden=NO;
        [muarr_friendsList removeAllObjects];
        tblid=4;
        NSURL *url=[NSURL URLWithString:@"http://whootin.com/api/v1/user/entourage.json"];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:[NSString stringWithFormat:@"Bearer %@",kAccessToken] forHTTPHeaderField:@"Authorization"];
        NSData *respone=[NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];
        NSString *strResponse=[[NSString alloc] initWithData:respone encoding:NSUTF8StringEncoding];
        
        NSArray *dict=[strResponse JSONValue];
       
        for (int i=0;i<[dict count];i++)
        {
            [muarr_friendsList addObject:[[dict objectAtIndex:i] objectForKey:@"username"]];
        }
        
        [tbl_friends_list reloadData];
    }
    }
}

-(IBAction)textFieldReturn
{
    [txtUserList resignFirstResponder];
}

-(IBAction)btnShareFreinds
{
    
    if (![self internetServicesAvailable]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Internet Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
    else
    {
    
    NSString *strUserList=txtUserList.text;
    NSLog(@"%@",strUserList);
    
    
    if (![strUserList isEqualToString:@""]) 
    {
        
        NSArray *friendsList=[strUserList componentsSeparatedByString:@";"];
        if ([friendsList count]>0) 
        {
            for (int i=0; i<[friendsList count]; i++)
            {
             NSMutableString *string3=[NSMutableString stringWithString:[friendsList objectAtIndex:i]];
            [string3 replaceOccurrencesOfString:@"@" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string3 length])];
            
                for (int i=0; i<[muarr_friendsList count]; i++)
                {
                    if ([string3 isEqualToString:[muarr_friendsList objectAtIndex:i]]) 
                    {
                        [self fileSharing:string3]; 
                    }
                }
            
            } 
             viw_entourage.hidden=YES;
            [txtUserList resignFirstResponder];
        }
        else
        {
            NSLog(@"NoFriends List");
        }
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"You must Enter The User Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
        [alert1 release];
    }
    }
}


-(void)fileSharing:(NSString *)user_name
{
    NSArray *array2=[str_noteSettings componentsSeparatedByString:@","];
    
    if ([str_dueDate isEqualToString:@""]) 
    {
        str_dueDate=@" ";
    }
    
    if (kAccessToken)
    {
        
        NSDate *date1=[NSDate date];
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM_dd_YYYY_hh_mm_ss_SS"];
        NSLog(@"Date : %@",[dateFormat stringFromDate:date1]);
        NSString *date2=[dateFormat stringFromDate:date1];
        
        str_note_name1=[NSString stringWithFormat:@"Note_%@",date2];
       
        
        
       // NSString *sFolderId = [NSString stringWithFormat:@"%@",kFolderId];
        
        
        
        if (![str_note_image isEqualToString:@""]) 
        {
            
           
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *thumbFilePath = [documentsDirectory stringByAppendingPathComponent:str_note_image];
            UIImage *image1=[UIImage imageWithContentsOfFile:thumbFilePath];
            
            NSData *imageData=UIImagePNGRepresentation(image1);
            
            
            
            NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/direct_messages/new.json"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
            // change type to POST (default is GET)
            [request setHTTPMethod:@"POST"];
            
            // just some random text that will never occur in the body
            NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
            
            // header value
            NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                        stringBoundary];
            
            // set header
            [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
            
            //add body
            NSMutableData *postBody = [NSMutableData data];
            NSLog(@"body made");
            
            //wigi access token 
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[user_name dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //image
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n",str_note_name1] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [postBody appendData:imageData];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"message added");
            
            
            // final boundary
            [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // add body to post
            [request setHTTPBody:postBody];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
            
            //NSLog(@"body set");
            // pointers to some necessary objects
            NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
            NSError* error = [[NSError alloc] init] ;
            
            // synchronous filling of data from HTTP POST response
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            
            NSDictionary *json = [newStr JSONValue];
            
            NSLog(@"%@",newStr);
            
            NSArray *arr1=[json objectForKey:@"uploads"];
          
          
            
            NSString *sError=[json objectForKey:@"error"];
            
            
            if (sError==nil)
            {
                
                NSString *strUrl=[[[arr1 objectAtIndex:0] objectForKey:@"upload"]objectForKey:@"url"];
                
                NSString *string1=strUrl;
                // NSLog(@"%@",string1);
                NSString *string2=@"&";
                // NSLog(@"%@",string2);
                NSMutableString *string3=[NSMutableString stringWithString:string1];
                //[string3 replaceCharactersInRange:[string3 rangeOfString:string2 ] withString:[NSString stringWithFormat:@"<span style=background-color:yellow>%@</span>",string2]];
                [string3 replaceOccurrencesOfString:string2 withString:@"&amp;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string3 length])];         
                
                if ([privilege isEqualToString:@"1"])
                {
                    if (isScrollRight)
                    {
                        APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]]; 
                    }
                    else
                    {
                        APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]]; 
                    }
                    
                }
                else
                {
                    if (isScrollRight) 
                    {
                        APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                    }
                    else
                    {
                        APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl>%@</imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no,string3                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                    }
                    
                 
                }
                
                
                //NSLog(@"%@",APP.wMessage);
                
                NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/direct_messages/new.json"];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:30.0];
                // change type to POST (default is GET)
                [request setHTTPMethod:@"POST"];
                
                // just some random text that will never occur in the body
                NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
                
                // header value
                NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                            stringBoundary];
                
                // set header
                [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
                
                //add body
                NSMutableData *postBody = [NSMutableData data];
                NSLog(@"body made");
                
                //wigi access token 
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[user_name dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"length\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"%i", [APP.wMessage length]] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                //image
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.xml\"\r\n",str_note_name1] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"Content-Type: xml/text\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                
                [postBody appendData:[APP.wMessage dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSLog(@"message added");
                
                
                
                // final boundary
                [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // add body to post
                [request setHTTPBody:postBody];
                
                
                
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
                
                //NSLog(@"body set");
                // pointers to some necessary objects
                NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
                NSError* error = [[NSError alloc] init] ;
                
                // synchronous filling of data from HTTP POST response
                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                
                NSDictionary *json = [newStr JSONValue];
                
              //  NSLog(@"%@",json); 
                
                NSString *sError=[json objectForKey:@"error"];
                
                if (sError==nil) 
                {
                    
                    NSString *strMessage=[NSString stringWithFormat:@"%@ has shared a new ToDoNot.es to %@",kUsername,user_name];
                    
                    [PFPush sendPushMessageToChannelInBackground:@"" withMessage:strMessage];
                    
                    const char *dbpath = [databasePath UTF8String];
                    sqlite3_stmt    *statement;            
                    
                    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
                    {
                        
                        NSString *str_query=[NSString stringWithFormat:@"update TblToDoList set share_list='%@',privilege='%@' where rowid=%d",user_name,privilege,row_id];
                        
                        const char *query_stmt = [str_query UTF8String];
                        
                        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            while(sqlite3_step(statement) == SQLITE_ROW)
                            {
                                
                            } 
                           // NSLog(@"Success update");
                            sqlite3_finalize(statement);
                            
                        }
                        else
                        {
                           // NSLog(@"Error In Update");
                        }
                        sqlite3_close(contactDB);
                    }
        
                    [self getAllData];
                    [self loadNoteButton:[muarr_rowid count]];
                    
                    [self getDoneNotes];
                    NSArray *arrSubviews=[scr_done_notes subviews];
                    for (UIView *subview in arrSubviews) 
                    {
                        [subview removeFromSuperview];
                    }    
                    [self loadDoneNotes:[muarr_done_rowid count]];
                    
                    [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:@"Note successfully shared in ToDoNot.es" hideAfter:2.0]; 
                }
                else
                {
                    showAlert(sError);
                }
            }
            
        }
        else
        {
           // NSLog(@"Welcome to xml file upload...");
            
            
           if ([privilege isEqualToString:@"1"]) 
            {
                if (isScrollRight) 
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>1</done></Note></Notes>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]]; 
                }
                else
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>1</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                }
                privilege=@"1";
                
            }
            else
            {
                
                if (isScrollRight) 
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Notes><Note>\n\t<previlage>0</previlage>\n<notecolor>note%d.png</notecolor>\n<imgurl> </imgurl>\n<name>%@</name>\n<detail>%@</detail>\n<duedate>%@</duedate>\n<settings>\n\t<fontname>%@</fontname>\n<fontcolor>%@</fontcolor>\n<align>%@</align>\n</settings>\n<done>1</done>\n</Note></Notes>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                    
                }
                else
                {
                    APP.wMessage =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><Notes><Note><previlage>0</previlage><notecolor>note%d.png</notecolor><imgurl> </imgurl><name>%@</name><detail>%@</detail><duedate>%@</duedate><settings><fontname>%@</fontname><fontcolor>%@</fontcolor><align>%@</align></settings><done>0</done></Note></Notes>",btn_no                                                                                                                                                                                                                                     ,str_noteName,str_noteDetail,str_dueDate,[array2 objectAtIndex:1],[array2 objectAtIndex:2],[array2 objectAtIndex:3]];
                }
                privilege=@"0";
                
            }
            
           // NSLog(@"%@",APP.wMessage);
            
            NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/direct_messages/new.json"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:30.0];
            // change type to POST (default is GET)
            [request setHTTPMethod:@"POST"];
            
            // just some random text that will never occur in the body
            NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
            
            // header value
            NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                        stringBoundary];
            
            // set header
            [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
            
            //add body
            NSMutableData *postBody = [NSMutableData data];
            NSLog(@"body made");
            
            //wigi access token 
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[user_name dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"length\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"%i", [APP.wMessage length]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //image
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.xml\"\r\n",str_note_name1] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Type: xml/text\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [postBody appendData:[APP.wMessage dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"message added");
            
            
            // final boundary
            [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // add body to post
            [request setHTTPBody:postBody];
            
            
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
            
            //NSLog(@"body set");
            // pointers to some necessary objects
            NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
            NSError* error = [[NSError alloc] init] ;
            
            // synchronous filling of data from HTTP POST response
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
          //  NSLog(@"%@",newStr);
            
            NSDictionary *json = [newStr JSONValue];
            
          //  NSLog(@"%@",json);
            
            NSString *sError=[json objectForKey:@"error"];
            if (sError==nil) 
            {
                
                NSString *strMessage=[NSString stringWithFormat:@"%@ has shared a new ToDoNote.es to %@",kUsername,user_name];
                
                [PFPush sendPushMessageToChannelInBackground:@"" withMessage:strMessage];
                
                
                const char *dbpath = [databasePath UTF8String];
                sqlite3_stmt    *statement;            
                
                if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
                {
                    NSString *str_query=[NSString stringWithFormat:@"update TblToDoList set share_list='%@',privilege='%@' where rowid=%d",user_name,privilege,row_id];
                    
                    const char *query_stmt = [str_query UTF8String];
                    
                    if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        while(sqlite3_step(statement) == SQLITE_ROW)
                        {
                            
                        } 
                       // NSLog(@"Success...");
                        sqlite3_finalize(statement);
                        
                    }
                    else
                    {
                        //NSLog(@"Error in updation...");  
                    }
                    sqlite3_close(contactDB);
                }
                
                // Refresh  all notes
                
                [self getAllData];
                [self loadNoteButton:[muarr_rowid count]];
                
                // Refresh Done Note
                
                [self getDoneNotes];
                NSArray *arrSubviews=[scr_done_notes subviews];
                for (UIView *subview in arrSubviews) 
                {
                    [subview removeFromSuperview];
                }    
                [self loadDoneNotes:[muarr_done_rowid count]];                
                [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Success" subtitle:@"Note successfully shared in ToDoNot.es" hideAfter:2.0]; 
            }
            else
            {
                showAlert(sError);
            }
        }
    }
}

-(IBAction)btnShareCancel

{
    viw_entourage.hidden=YES;
    [txtUserList resignFirstResponder];
}

-(IBAction)btnShareNotes
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
      ShareNotesViewController *shareNotes=[[ShareNotesViewController alloc] initWithNibName:@"ShareNotesViewController-iPhone" bundle:nil];
   // [shareNotes modalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:shareNotes animated:YES];
    }
    else
    {
        ShareNotesViewController *shareNotes=[[ShareNotesViewController alloc] initWithNibName:@"ShareNotesViewController" bundle:nil];
        // [shareNotes modalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:shareNotes animated:YES];
    }
    
}


-(IBAction)btnUserClicked
{
    UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Please Save Note then you can share the note" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert1 show];
    [alert1 release];
}

-(IBAction)btnPush
{
     [PFPush sendPushMessageToChannelInBackground:@"" withMessage:@"You have a new Note"];
}

#pragma mark Social Sharing methods


-(IBAction)btnSocialShare
{
    
    viwSocialShare.transform = CGAffineTransformScale(viwSocialShare.transform, 0.1, 0.1);
    viwSocialShare.center =self.view.center;
    [self.view addSubview:viwSocialShare];
    [UIView animateWithDuration:1.0 animations:^(void){
        
        viwSocialShare.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationTransitionCurlUp animations:^(void){
            // viw_img.alpha = 0.0;
        } completion:^(BOOL finished) 
        {
            
        }];
        
    }];

}

- (IBAction)btnfb
{
    
    [viwSocialShare removeFromSuperview];
    
    if(![self internetServicesAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network Not Found" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
    }
    else
    {
        /*
        
        if(![str_note_image isEqualToString:@""])
        {
            
        [viwSocialShare removeFromSuperview];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],str_note_image];
        UIImage *image=[UIImage imageWithContentsOfFile:path];
  
        [APP.Alertview setHidden:NO];
        [APP.activity startAnimating];
        [APP.lbl setText:@"Connecting to Facebook"];
        [APP.window bringSubviewToFront:APP.Alertview];
        
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* facebookCookies = [cookies cookiesForURL:
                                    [NSURL URLWithString:@"http://login.facebook.com"]];
        
        for (NSHTTPCookie* cookie in facebookCookies) {
            [cookies deleteCookie:cookie];
        }
        NSString *str1 = @"Image successfully posted on Facebook!";
        
        FBFeedPost *post = [[FBFeedPost alloc] initWithPhoto:image name:str1];
       // FBFeedPost *post=[[FBFeedPost alloc] initWithPostMessage:str1];
        [post publishPostWithDelegate:self];
        IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
        display.type = NotificationDisplayTypeLoading;
        display.tag = NOTIFICATION_DISPLAY_TAG;
        }
        else
        {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"No image available!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
         
         */
        
        
        
        /*Facebook Application ID*/
        NSString *client_id = @"351319161630937";
        
        //alloc and initalize our FbGraph instance
        self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
        
        //begin the authentication process.....
        [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
                             andExtendedPermissions:@"user_location,user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
        
        

        
    }
}


- (void)fbGraphCallback:(id)sender {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
		/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"For the simplest code, I've written all output to the 'Debugger Console'." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];*/
        
        [self postPictureButtonPressed];
		
		NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
		
	}
	
}

-(void)postPictureButtonPressed {
	
	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];
	
	//create a UIImage (you could use the picture album or camera too)
	UIImage *picture =[self createImage];
  	//create a FbGraphFile object insance and set the picture we wish to publish on it
	FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:picture];
	
	//finally, set the FbGraphFileobject onto our variables dictionary....
	[variables setObject:graph_file forKey:@"file"];
    
	[variables setObject:@"http://www.nuatransmedia.com" forKey:@"link"];
 	//[variables setObject:@"Testing...." forKey:@"name"];
 	//[variables setObject:@"Hi..tis is senthil just for testing...." forKey:@"description"];
	[variables setObject:str_noteDetail forKey:@"message"];
	
	//the fbGraph object is smart enough to recognize the binary image data inside the FbGraphFile
	//object and treat that is such.....
	FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"117795728310/photos" withPostVars:variables];
	NSLog(@"postPictureButtonPressed:  %@", fb_graph_response.htmlResponse);
	
	
	NSLog(@"Now log into Facebook and look at your profile & photo albums...");
	
}	


+(void)stop
{
    //	[[UIAppDelegate indicator] stopAnimating];    
    [[APP Alertview] setHidden:YES];
    [[APP activity]stopAnimating];
}


#pragma mark -
#pragma mark FBFeedPostDelegate

- (void) failedToPublishPost:(FBFeedPost*) _post {
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeText;
	[display setNotificationText:@"Failed To Post"];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:1.5];
	
    //	[[UIAppDelegate indicator] stopAnimating];
    
    
    [APP.Alertview setHidden:YES];
    [APP.activity stopAnimating];
    
    
    self.view.userInteractionEnabled = YES;
	
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}

- (void) finishedPublishingPost:(FBFeedPost*) _post {
	
    
	UIView *dv = [self.view viewWithTag:NOTIFICATION_DISPLAY_TAG];
	[dv removeFromSuperview];
	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Image successfully posted on Facebook!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [[APP Alertview] setHidden:YES];
    [[APP activity]stopAnimating];
    
	[alert show];
    
    //    [[UIAppDelegate indicator] stopAnimating];
    self.view.userInteractionEnabled = YES;
    //release the alloc'd post
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}


-(IBAction)btnEmail
{
    
    MFMailComposeViewController *mailComposer=[[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) 
    {
        mailComposer.mailComposeDelegate=self;
        [mailComposer setSubject:[NSString stringWithFormat:@""]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],str_note_image];
        
        UIImage *email_image=[self createImage];
        NSData *imageData = UIImagePNGRepresentation(email_image);
            
        [mailComposer addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"todonote.jpg"];
       
        [mailComposer setMessageBody:[NSString stringWithFormat:@"<p><img src=http://www.nuatransmedia.com/Icons/ToDoNotes.png width=30 height=30 align=left>ToDoNot.es</img></p><br><p>You can download ToDoNot.es application just click this url <a href=http://fwdsla.sh/ToDoNotes>http://fwdsla.sh/ToDoNotes</a> and you can visit ToDonot.es website using this URL <a href=http://todonot.es>http://todonot.es</a></p><b>ToDoNot.es Name:</b><br>%@<br><b>ToDoNot.es Description:</b><br>%@<br><b>Remainder Date:</b> &nbsp;&nbsp;%@",txtviw_note_name.text,str_noteDetail,lbl_duedate.text] isHTML:YES];
        [self presentModalViewController:mailComposer animated:YES];
    }
    else
    {
        UIAlertView *mailAlert=[[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Device not Compatible" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [mailAlert show];
        [mailAlert release];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [viwSocialShare removeFromSuperview];
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)btnInsta
{
    
    if(![self internetServicesAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Network Not Found" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        [viwSocialShare removeFromSuperview];
      
            [self instagramIntegration];
       
    }
}
-(void)instagramIntegration
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    }
    else {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    _webView.backgroundColor = [UIColor clearColor];
    
    _webView.delegate = self;
    [self.view addSubview:_webView];
    static NSString *const authUrlString = @"https://api.instagram.com/oauth/authorize/";
    //  static NSString *const tokenUrlString = @"https://api.instagram.com/oauth/access_token/";
    
    // ADD YOUR CLIENT ID AND SECRET HERE
    static NSString *const clientID = @"ffd364b719bd4d2e83f6ce078a2ce1ae";
    //static NSString *const clientSecret = @"51450f522b1e4476bf797800ff678696";
    
    static NSString *const redirectUri = @"http://todonot.es";
    
    static NSString *const scope = @"comments+relationships+likes";
    
    NSString *fullAuthUrlString = [[NSString alloc]
                                   initWithFormat:@"%@/?client_id=%@&redirect_uri=%@&response_type=token",
                                   authUrlString,
                                   clientID,
                                   redirectUri,
                                   scope
                                   ];
    
    
    //    NSLog(@"%@",fullAuthUrlString);
    NSURL *authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",fullAuthUrlString]];
    NSURLRequest *myRequest = [[NSURLRequest alloc] initWithURL:authUrl];
    [_webView loadRequest:myRequest];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    NSLog(@"%@",[_webView.request URL]);
    NSString *URLString = [[request URL] absoluteString]; 
    //    NSLog(@"UrlStr : %@",URLString);
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) { 
        IsInstaLoggedIn = TRUE;
        NSString *accessToken = 
        [[URLString componentsSeparatedByString:@"="] lastObject]; 
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
        [defaults setObject:accessToken forKey:@"access_token"]; 
        [defaults synchronize]; 
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],str_note_image];
        NSLog(@"%@",path);
        Img_Instagram =[self createImage];
       // [UIImageJPEGRepresentation(Img_Instagram, 1.0) writeToFile:path atomically:YES];
        
        UIImage *img = [self imageWithImage:Img_Instagram scaledToSize:CGSizeMake(612, 612)];
        
      
        
        NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path1 = [NSString stringWithFormat:@"%@/%@", [paths1 objectAtIndex:0], @"MyPhoto.ig"];
        
        [UIImageJPEGRepresentation(img, 1.0) writeToFile:path1 atomically:YES];
        
        NSString *fileToOpen=[NSString stringWithFormat:@"%@",path1];
        NSURL *instagramURL = [NSURL URLWithString:@"com.instagram://PhotoTest"];
        NSLog(@"%@",fileToOpen);
        instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            NSData *imageData = UIImageJPEGRepresentation(img,0.1);
            [imageData writeToFile:path1 atomically:YES];
            NSURL *imageUrl = [NSURL fileURLWithPath:path1];
            
            UIDocumentInteractionController * docController = [[UIDocumentInteractionController alloc] init];
            docController.delegate = self;
            [docController retain];
            docController.UTI = @"com.instagram.photo";
            [docController setURL:imageUrl];
            docController.annotation = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"#%@# #ToDoNot.es iPhone application #download url#  #http://fwdsla.sh/ToDoNotes# ",str_noteDetail] forKey:@"InstagramCaption"];
            
            [docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES]; 
            
            [APP.Alertview setHidden:YES];
            [APP.activity stopAnimating];
            
            [_webView removeFromSuperview];
            [_webView release];
            
        }
        else {
            [APP.Alertview setHidden:YES];
            [APP.activity stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ToDoNot.es" message:@"Please install instagram" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
    }
    return YES;
}


-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 612, 612)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}


-(IBAction)btnTwit
{
    
    if (![self internetServicesAvailable]) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Network Not Found" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
        [alert release];
    }
    else
    {
        [viwSocialShare removeFromSuperview];
        
        TWTweetComposeViewController *twitter=[[TWTweetComposeViewController alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],str_note_image];
       // NSLog(@"%@",path);
        Img_Instagram =[self createImage];
        [twitter setInitialText:[NSString stringWithFormat:@"%@",str_noteDetail]];
        [twitter addImage:Img_Instagram];
        [twitter addURL:[NSURL URLWithString:@"http://fwdsla.sh/ToDoNotes"]];
        twitter.completionHandler=^(TWTweetComposeViewControllerResult result)
        {
            [self dismissModalViewControllerAnimated:YES];
        };
        [self presentModalViewController:twitter animated:YES];
    }
    
}

-(UIImage *)createImage
{
    CGRect  rectImage=CGRectMake(0, 0, viwInnerNotesView.frame.size.width, viwInnerNotesView.frame.size.height);
    UIGraphicsBeginImageContext(rectImage.size);
    [viwInnerNotesView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sampleImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return sampleImg;
}

-(IBAction)btnCloseScocial
{
    viwSocialShare.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viwSocialShare.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [viwSocialShare removeFromSuperview];
        
    }];
}



-(void)dealloc
{
    [muarr_done release];
    [muarr_alignment release];
    [muarr_alignment_list release];
    [muarr_color release];
    [muarr_ColorList release];
    [muarr_done_date release];
    [muarr_done_detail release];
    [muarr_done_done release];
    [muarr_done_duedate release];
    [muarr_done_imgname release];
    [muarr_done_name release];
    [muarr_done_privilege release];
    [muarr_done_rowid release];
    [muarr_done_settings release];
    [muarr_done_settings1 release];
    [muarr_done_share_list release];
    [muarr_duedate release];
    [muarr_FontList release];
    [muarr_imgname release];
    [muarr_note_date release];
    [muarr_note_detail release];
    [muarr_note_name release];
    [muarr_privileg release];
    [muarr_rowid release];
    [muarr_settings release];
    [muarr_settings1 release];
    [muarr_share_list release];
    [muarr_temp1 release];
    [muarr_temp10 release];
    [muarr_temp11 release];
    [muarr_temp2 release];
    [muarr_temp3 release];
    [muarr_temp4 release];
    [muarr_temp5 release];
    [muarr_temp6 release];
    [muarr_temp7 release];
    [muarr_temp8 release];
    [muarr_temp9 release];
    [tbl_note release];
    [webviw_note_detail release];
    [imgPhoto release];
    [imgviw_instruction release];
    [imgviw_note release];
    [imgviw_note_color release];
    [imgviw_note_color1 release];
    [imgviw_note_settings release];
    [imgviw_tbl release];    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

@end
