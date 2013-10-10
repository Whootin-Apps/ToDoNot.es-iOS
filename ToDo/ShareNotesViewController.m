//
//  ShareNotesViewController.m
//  ToDo
//
//  Created by Support Nua on 26/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ShareNotesViewController.h"
#import "TBXML.h"
#import "ShareNotes.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShareNotesViewController

static NSString *kItem=@"Note";
static NSString *kPrevilege=@"previlage";
static NSString *KNoteColor=@"notecolor";
static NSString *kImageURL=@"imgurl";
static NSString *kTitle=@"name";
static NSString *kDetail=@"detail";
static NSString *kDueDate=@"duedate";
static NSString *kDone=@"done";
static NSString *kSettings=@"settings";
static NSString *kFontName=@"fontname";
static NSString *kFontColor=@"fontcolor";
static NSString *kAlign=@"align";

static int tagValue_done_note=0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)loadShareNotes:(int)count
{
    
        if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone) 
        {
            tagValue_done_note=-1;
            int count1=count/2;
            
            [scr_shareNotes setContentSize:CGSizeMake(275, (count1+1)*135)];
            
            for (int i=0; i<=count1; i++) 
            {
                
                for (int j=0; j<2; j++)
                {
                    tagValue_done_note++;
                    if(tagValue_done_note<count)
                    {
                        
                        ShareNotes *shareNote=[muarr_ShareNotes objectAtIndex:tagValue_done_note];
                        
                        viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*145, i*135, 132, 132)];  
                        viw_note1.backgroundColor=[UIColor clearColor];
                        [viw_note1 setTag:tagValue_done_note];
                        [viw_note1 setExclusiveTouch:YES];
                        UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                        [btnNote setTag:tagValue_done_note];
                      
                        btnNote.frame=CGRectMake(0,0,132,132);
                        [btnNote setBackgroundImage:[UIImage imageNamed:shareNote.nNoteImage] forState:UIControlStateNormal];
                        btnNote.showsTouchWhenHighlighted=NO;
                        btnNote.adjustsImageWhenHighlighted=NO;
                        
                        [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(10,45,100, 30)];
                        [lblName1 setText:shareNote.nName];
                        [lblName1 setBackgroundColor:[UIColor clearColor]];
                        [lblName1 setTextAlignment:UITextAlignmentCenter];
                        [lblName1 setTextColor:[UIColor whiteColor]];
                        [lblName1 setFont:[UIFont fontWithName:shareNote.nFontname size:15.0]];
                        
                        UIButton *btnImage;
                        if (![shareNote.nImageURL isEqualToString:@""])
                        {
                           
                            btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                            btnImage.frame=CGRectMake(45,72,40,40);         
                            btnImage.tag=tagValue_done_note;
                            btnImage.layer.cornerRadius=5.0;
                            btnImage.clipsToBounds=YES;
                           
                            [btnImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareNote.nImageURL]]] forState:UIControlStateNormal];
                            
                            [btnImage addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                        
                        }
                        
                        else
                        {
                            // NSLog(@"Ther is No image");
                        }
                     
                       
                        UILabel *lblUserName,*lblStatus;
                        UIButton *btnPin;
                        
                        if (![shareNote.nPrevilege isEqualToString:@""]) 
                        {
                            
                            NSString *strImageName;
                            
                            lblUserName=[[UILabel alloc] initWithFrame:CGRectMake(10,115,100,12)];
                            [lblUserName setText:[NSString stringWithFormat:[NSString stringWithFormat:@"From - @%@",shareNote.nSender]]];
                            [lblUserName setFont:[UIFont fontWithName:@"Marker Felt" size:12]];
                            [lblUserName setTextColor:[UIColor darkGrayColor]];
                            lblUserName.backgroundColor=[UIColor clearColor];
                            
                            
                            
                            lblStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,2,70,17)];
                            
                            if ([shareNote.nPrevilege isEqualToString:@"1" ]) 
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
                            
                        }
                        
                        UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
                        // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                        btnMark.frame=CGRectMake(100,110,20,20);
                        if ([shareNote.nDone isEqualToString:@"0"])
                        {
                            [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                        }
                      
                        btnMark.showsTouchWhenHighlighted=YES;
                        
                        
                        lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(5,23,125,28)];      
                        [lbl_date setBackgroundColor:[UIColor clearColor]];
                        if(![shareNote.nDuedate isEqualToString:@""])
                        {
                            NSDate *currDate=[NSDate date];
                            NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                            [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                            NSString *strDate=[formatter1 stringFromDate:currDate];
                            NSDate *today=[formatter1 dateFromString:strDate];
                            
                            NSString *stringDate=shareNote.nDuedate;
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
                                [lbl_date setText:[NSString stringWithFormat:@"Due:%@",shareNote.nDuedate]];
                                lbl_date.numberOfLines=2;
                                lbl_date.textColor=[UIColor whiteColor];
                                [lbl_date setFont:[UIFont fontWithName:shareNote.nFontname size:13.0]];
                                [viw_note1 addSubview:lbl_date];
                                
                            }
                            else if(result==NSOrderedDescending)
                            {
                                [lbl_date setTextAlignment:UITextAlignmentCenter];
                                lbl_date.textColor=[UIColor redColor];
                                [lbl_date setText:[NSString stringWithFormat:@"Due:%@",shareNote.nDuedate]];
                                lbl_date.numberOfLines=2;
                                // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                                [lbl_date setFont:[UIFont fontWithName:shareNote.nFontname size:13.0]];
                                [viw_note1 addSubview:lbl_date];
                                
                            }
                            else
                            {
                                [lbl_date setTextAlignment:UITextAlignmentCenter];
                                lbl_date.textColor=[UIColor redColor];
                                [lbl_date setText:[NSString stringWithFormat:@"Due:%@",shareNote.nDuedate]];
                                lbl_date.numberOfLines=2;
                                // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                                [lbl_date setFont:[UIFont fontWithName:shareNote.nFontname size:13.0]];
                                [viw_note1 addSubview:lbl_date];
                            }
                            
                        }
                        
                        NSLog(@"End");
                        
                        [viw_note1 addSubview:btnNote];
                        [viw_note1 addSubview:lblName1];
                        [viw_note1 addSubview:btnMark];
                       // [viw_note1 addSubview:btnUser];
                        [viw_note1 addSubview:lbl_date];
                        if (![shareNote.nPrevilege isEqualToString:@""]) 
                        {
                            [viw_note1 addSubview:lblUserName];
                            [viw_note1 addSubview:lblStatus];
                            [viw_note1 addSubview:btnPin];
                        }
                        if (![shareNote.nImageURL isEqualToString:@""]) 
                        {
                            [viw_note1 addSubview:btnImage];  
                        }
                        
                        [scr_shareNotes addSubview:viw_note1];
                        
                    }
                    
                }
            }
        }
        else
        {
           tagValue_done_note=-1;
            int count1=count/2;
            
            [scr_shareNotes setContentSize:CGSizeMake(600, (count1+1)*250)];
            
            for (int i=0; i<=count1; i++) 
            {
                
                for (int j=0; j<3; j++)
                {
                    tagValue_done_note++;
                    if(tagValue_done_note<count)
                    {
                    
                        ShareNotes *shareNote=[muarr_ShareNotes objectAtIndex:tagValue_done_note];
                        
                        viw_note1=[[UIView alloc] initWithFrame:CGRectMake(j*222,i*225,200,200)];   
                        viw_note1.backgroundColor=[UIColor clearColor];
                        [viw_note1 setTag:tagValue_done_note];
                        [viw_note1 setExclusiveTouch:YES];
                        UIButton  *btnNote=[UIButton buttonWithType:UIButtonTypeCustom];
                        [btnNote setTag:tagValue_done_note];
                        // btnNote.frame=CGRectMake(j*145, i*135, 132, 132);
                        btnNote.frame=CGRectMake(0,0,200,200);
                        [btnNote setBackgroundImage:[UIImage imageNamed:shareNote.nNoteImage] forState:UIControlStateNormal];
                        btnNote.showsTouchWhenHighlighted=NO;
                        btnNote.adjustsImageWhenHighlighted=NO;
                        [btnNote addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
                        
                        
                        // Swipe Gesture set for button
                        
                        
                        UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
                        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                        [viw_note1 addGestureRecognizer:swipeLeft];
                        
                        
                        UILabel *lblName1=[[UILabel alloc]initWithFrame:CGRectMake(15,75,175,50)];
                        [lblName1 setText:shareNote.nName];
                        [lblName1 setBackgroundColor:[UIColor clearColor]];
                        [lblName1 setTextAlignment:UITextAlignmentCenter];
                        [lblName1 setTextColor:[UIColor whiteColor]];
                        [lblName1 setFont:[UIFont fontWithName:shareNote.nFontname size:25.0]];
                        
                        
                        
                        
                        UIButton *btnImage;
                        if (![shareNote.nImageURL isEqualToString:@""])
                        {
                           
                            btnImage=[UIButton buttonWithType:UIButtonTypeCustom];
                            btnImage.frame=CGRectMake(70,118,50,50);
                            
                            btnImage.tag=tagValue_done_note;
                            btnImage.layer.cornerRadius=5.0;
                            btnImage.clipsToBounds=YES;
                            
                            [btnImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareNote.nImageURL]]] forState:UIControlStateNormal];
                            
                            [btnImage addTarget:self action:@selector(imgBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        else
                        {
                            NSLog(@"Ther is No image");
                        }
                       
                        
                        UILabel *lblUserName,*lblStatus;
                        UIButton *btnPin;
                        if (![shareNote.nPrevilege isEqualToString:@""]) 
                        {
                            //NSLog(@"Welcome to if ");
                            
                            NSString *strImageName;
                            
                            
                            lblUserName=[[UILabel alloc] initWithFrame:CGRectMake(10,170,150,20)];
                            [lblUserName setText:[NSString stringWithFormat:@"From - @%@",shareNote.nSender]];
                            [lblUserName setFont:[UIFont fontWithName:@"Marker Felt" size:20]];
                            [lblUserName setTextColor:[UIColor darkGrayColor]];
                            lblUserName.backgroundColor=[UIColor clearColor];
                            
                            
                            
                            lblStatus=[[UILabel alloc] initWithFrame:CGRectMake(40,10,120,25)];
                            if ([shareNote.nPrevilege isEqualToString:@"1" ]) 
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
                            NSLog(@"Welcome to else");
                        }
                        
                        UIButton *btnMark=[UIButton buttonWithType:UIButtonTypeCustom];
                        // btnMark.frame=CGRectMake(j*145+100, i*135+105,20,20);
                        btnMark.frame=CGRectMake(150,160,30,30);
                        if ([shareNote.nDone isEqualToString:@"0"])
                        {
                            [btnMark setBackgroundImage:[UIImage imageNamed:@"mark1.png" ]forState:UIControlStateNormal];
                        }
                        else
                        {
                            [btnMark setBackgroundImage:[UIImage imageNamed:@"mark2.png" ]forState:UIControlStateNormal]; 
                        }
                        
                        //[btnMark setTag:[[muarr_done_rowid objectAtIndex:tagValue_done_note] intValue]];
                        // [btnMark addTarget:self action:@selector(markBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                        btnMark.showsTouchWhenHighlighted=YES;
                        
                        // Label for diaplay a date of reminder
                        
                        // lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(j*145,i*135+5,130,40)];
                        lbl_date=[[UILabel alloc] initWithFrame:CGRectMake(10,30,180,53)];
                        [lbl_date setBackgroundColor:[UIColor clearColor]];
                        if(![shareNote.nDuedate isEqualToString:@""])
                        {
                            NSDate *currDate=[NSDate date];
                            NSDateFormatter *formatter1=[[[NSDateFormatter alloc] init] autorelease];
                            [formatter1 setDateFormat:@"MM-dd-yyyy hh:mm a"];
                            NSString *strDate=[formatter1 stringFromDate:currDate];
                            NSDate *today=[formatter1 dateFromString:strDate];
                            
                            NSString *stringDate=shareNote.nDuedate;
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
                                [lbl_date setText:[NSString stringWithFormat:@"Due:%@",shareNote.nDuedate]];
                                lbl_date.numberOfLines=2;
                                lbl_date.textColor=[UIColor whiteColor];
                                [lbl_date setFont:[UIFont fontWithName:shareNote.nFontname size:22]];
                                [viw_note1 addSubview:lbl_date];
                                
                            }
                            else if(result==NSOrderedDescending)
                            {
                                [lbl_date setTextAlignment:UITextAlignmentCenter];
                                lbl_date.textColor=[UIColor redColor];
                                [lbl_date setText:[NSString stringWithFormat:@"Due:%@",shareNote.nDuedate]];
                                lbl_date.numberOfLines=2;
                                // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                                [lbl_date setFont:[UIFont fontWithName:shareNote.nFontname size:22]];
                                [viw_note1 addSubview:lbl_date];
                                
                            }
                            else
                            {
                                
                                [lbl_date setTextAlignment:UITextAlignmentCenter];
                                lbl_date.textColor=[UIColor redColor];
                                [lbl_date setText:[NSString stringWithFormat:@"Due:%@",shareNote.nDuedate]];
                                lbl_date.numberOfLines=2;
                                // lbl_date.textColor=[muarr_color objectAtIndex:[muarr_ColorList indexOfObject:[arry1 objectAtIndex:2]]];
                                [lbl_date setFont:[UIFont fontWithName:shareNote.nFontname size:22]];
                                [viw_note1 addSubview:lbl_date];
                            }
                            
                        }
                        
                        [viw_note1 addSubview:btnNote];
                        [viw_note1 addSubview:lblName1];
                        [viw_note1 addSubview:btnMark];
                        //[viw_note1 addSubview:btnUser];
                        [viw_note1 addSubview:lbl_date];
                        if (![shareNote.nPrevilege isEqualToString:@""]) 
                        {
                            [viw_note1 addSubview:lblUserName];
                            [viw_note1 addSubview:lblStatus];
                            [viw_note1 addSubview:btnPin];
                        }
                        
                        
                        if (![shareNote.nImageURL isEqualToString:@""]) 
                        {
                            [viw_note1 addSubview:btnImage];  
                        }
                        
                        [scr_shareNotes addSubview:viw_note1];
                        
                    }
                    
                }
            }
        }
        
    
}


-(void)btnPressed:(id)sender
{
    
    
    ShareNotes *shareNote=[muarr_ShareNotes objectAtIndex:[sender tag]];
       
    
      gesture=YES;
    
    
    // NSString *temp =@"<font face=\"%@\" color=\"%@\" size=\"4\" >";
    
    //  NSString *temp=[NSString stringWithFormat:@"<font face=\"%@\" color=\"%@\" size=\"4\" >",[array2 objectAtIndex:1],[[array2 objectAtIndex:2] substringWithRange:NSMakeRange(0, [[array2 objectAtIndex:2] length]-5)]];
    
    imgviw_note.image=[UIImage imageNamed:shareNote.nNoteImage];
    

    lbl_senderName.text=[NSString  stringWithFormat:@"Shared By : @%@",shareNote.nSender];
    
    
    if([shareNote.nDuedate isEqualToString:@""])
    {
        lbl_duedate.text=@"No Reminder";
        lbl_duedate.textColor=[UIColor whiteColor];
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
        
        NSString *stringDate=shareNote.nDuedate;
        NSDateFormatter *formatter=[[[NSDateFormatter alloc]  init] autorelease];
        [formatter setDateFormat:@"MM-dd-yyyy hh:mm a"];
        
        // Comparing the date from curent date to reminder date
        
        NSDate *newDate=[formatter dateFromString:stringDate];
        NSComparisonResult  result;
        result=[today compare:newDate];
        
        // Chcking the date whether a date is expired or not
        
        if (result==NSOrderedAscending) 
        {
            
            lbl_duedate.textColor=[UIColor whiteColor];
            lbl_duedate.text=shareNote.nDuedate;
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
            lbl_duedate.text=shareNote.nDuedate;
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
            lbl_duedate.text=shareNote.nDuedate;
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
    
  
    imgView.image=[UIImage imageNamed:shareNote.nNoteImage];
    
    textView.text=shareNote.nName;
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        textView.font=[UIFont fontWithName:shareNote.nFontname size:21.0];
      //  txtView.font=[UIFont fontWithName:[array2 objectAtIndex:1] size:21.0];
        
    }
    else
    {
        textView.font=[UIFont fontWithName:shareNote.nFontname size:35.0];
        
    }
    textView.textColor=[UIColor whiteColor];
    
    
    if ([shareNote.nAlign isEqualToString:@"Left"])
    {
        textView.textAlignment=UITextAlignmentLeft;
        
    }
    else if([shareNote.nAlign isEqualToString:@"Center"])
    {
        textView.textAlignment=UITextAlignmentCenter;
    }
    else
    {
        textView.textAlignment=UITextAlignmentRight;
        
    }
    
    if (![shareNote.nImageURL isEqualToString:@""])
    {                
       
        
        NSLog(@"Welcome to the html image ");
        
       // [btn_Note_Image setBackgroundImage:[UIImage imageWithContentsOfFile:thumbFilePath ]forState:UIControlStateNormal];
        
        // btn_Note_Image.hidden=NO;
        [webviw_note_detail reload];
        webviw_note_detail.opaque=NO;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><head><style type=text/css> img{ -webkit-border-radius:7px;}</style></head><body style=color:%@;>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp<img src='%@' width='75' height='75' align='middle' border='1'></img><div border='2'><font face='%@' size=4.5><p style=text-align:%@>%@</p></div></body></html>",shareNote.nFontcolor,shareNote.nImageURL,shareNote.nFontname,shareNote.nAlign,shareNote.nDescription] baseURL:nil];
            
        }
        else
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><head><style type=text/css> img{ -webkit-border-radius:7px;}</style></head><body style=color:%@;>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='%@' width='150' height='150' align='middle' border='1'></img><div border='2'><font face='%@' size=6><p style=text-align:%@>%@</p></div></body></html>",shareNote.nFontcolor,shareNote.nImageURL,shareNote.nFontname,shareNote.nAlign,shareNote.nDescription] baseURL:nil];
            
        }
    }
    else
    {
        [webviw_note_detail reload];
        webviw_note_detail.opaque=NO;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><body style=color:%@;><font face='%@' size=4.5><p>%@</p></body></html>",shareNote.nFontcolor,shareNote.nFontname,shareNote.nDescription] baseURL:nil];
        }
        else
        {
            [webviw_note_detail loadHTMLString:[NSString stringWithFormat:@"<html><body style=color:%@;><font face='%@' size=6><p>%@</p></body></html>",shareNote.nFontcolor,shareNote.nFontname,shareNote.nDescription] baseURL:nil];
        }
        
    }
    
   
    
    CATransition *animation2=[CATransition animation];
    animation2.delegate=self;
    animation2.duration=0.5;
    animation2.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation2.type=kCATransitionPush;
    animation2.subtype=kCATransitionFromRight;
    [[self.view layer] addAnimation:animation2 forKey:@"Zooming"];
    
    [self.view addSubview:viw_detail];
}

-(IBAction)btnBack
{
    CATransition  *animation1=[CATransition animation];
    animation1.delegate=self;
    animation1.duration=0.5;
    animation1.type=kCATransitionPush;
    animation1.subtype=kCATransitionFromLeft;
    animation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [[self.view layer] addAnimation:animation1 forKey:@"transition"];
    gesture=NO;
    [viw_detail removeFromSuperview];
}

-(IBAction)btnClose
{
    viw_bigImage.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        viw_bigImage.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [viw_bigImage removeFromSuperview];
        
    }];
}



-(void)getAllShareNotes
{
    [muarr_ShareNotes removeAllObjects];
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMessages]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"]; 
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL];  
    // NSLog(@"%@",response);
    NSString *newStr=[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    // NSString *json=[newStr JSONValue];   
    NSArray *dict=[newStr JSONValue];
     NSLog(@"%@",dict);
    
    for (int i=0; i<[dict count]; i++)
    {
        
        NSString *strURL=[[[[[dict objectAtIndex:i] objectForKey:@"uploads"] objectAtIndex:0]objectForKey:@"upload"] objectForKey:@"url"];
        
        NSString *sender=[[[dict objectAtIndex:i] objectForKey:@"sender"]  objectForKey:@"username"];
        NSLog(@"%@",sender);
        
        NSArray *arr2=[strURL componentsSeparatedByString:@"/"];
        for (int  i=0;i<[arr2 count];i++)
        {
            
            if ([[arr2 objectAtIndex:i] hasPrefix:@"Note"])
            {
                if ([[arr2 objectAtIndex:i] rangeOfString:@".xml"].location!=NSNotFound)
                {
                    
                    NSURL *url=[[NSURL alloc] initWithString:strURL];
                    
                    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
                    
                    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                                       
                    [self xmlParse:data withSender:sender];
                }
            }
        }
        
    }
}

-(void)xmlParse:(NSData *)data withSender:(NSString *)userName
{
       
    TBXML *tbxml=[[TBXML alloc] initWithXMLData:data];
    TBXMLElement *root=tbxml.rootXMLElement;
    
 
    if (root)
    {
        
        TBXMLElement *Note=[TBXML childElementNamed:kItem parentElement:root];
        
        if (Note) 
        {
            while ( Note!=nil) 
            {
                
                TBXMLElement *strPrevilage=[TBXML childElementNamed:kPrevilege parentElement:Note];
                TBXMLElement *strImageURL=[TBXML childElementNamed:kImageURL parentElement:Note];
                TBXMLElement *strTitle=[TBXML childElementNamed:kTitle parentElement:Note];
                TBXMLElement *strDesc=[TBXML childElementNamed:kDetail parentElement:Note];
                TBXMLElement *strNoteColor=[TBXML childElementNamed:KNoteColor parentElement:Note];
                TBXMLElement *strDueDate=[TBXML childElementNamed:kDueDate parentElement:Note];

                TBXMLElement *strSettings=[TBXML childElementNamed:kSettings parentElement:Note];
                TBXMLElement *strFontName=[TBXML childElementNamed:kFontName parentElement:strSettings];
                TBXMLElement *strFontColor=[TBXML childElementNamed:kFontColor parentElement:strSettings];
                TBXMLElement *strAlign=[TBXML childElementNamed:kAlign parentElement:strSettings];
                TBXMLElement *strDone=[TBXML childElementNamed:kDone parentElement:Note];
                ShareNotes *shareNote=[[ShareNotes alloc] init];
                
                
                NSString *strUrl=[[NSString alloc] initWithString:[TBXML textForElement:strImageURL]];
                NSMutableString *muString=[[NSMutableString alloc] initWithString:strUrl];
                [muString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strUrl length])];
              
                
                shareNote.nPrevilege=[TBXML textForElement:strPrevilage];
                shareNote.nNoteImage=[TBXML textForElement:strNoteColor];
                shareNote.nImageURL=muString;
                shareNote.nName=[TBXML textForElement:strTitle];
                shareNote.nDescription=[TBXML textForElement:strDesc];
                shareNote.nDuedate=[TBXML textForElement:strDueDate];
                shareNote.nFontname=[TBXML textForElement:strFontName];
                shareNote.nFontcolor=[TBXML textForElement:strFontColor];
                shareNote.nAlign=[TBXML textForElement:strAlign];
                shareNote.nDone=[TBXML textForElement:strDone];
                
                shareNote.nSender=userName;
                
                [muarr_ShareNotes addObject:shareNote];
                
                Note = [TBXML nextSiblingNamed:kItem searchFromElement:Note];
                
            }
        }
    }
}


-(void)imgBtnPressed:(id)sender
{
    
    ShareNotes *shareNote=[muarr_ShareNotes objectAtIndex:[sender tag]];
    
    imgviw_note.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareNote.nImageURL]]];
    
    viw_bigImage.transform = CGAffineTransformScale(viw_bigImage.transform, 0.1, 0.1);
    viw_bigImage.center =self.view.center;
    // im.center=CGPointMake(10, 30);
    [self.view addSubview:viw_bigImage];
    
    [UIView animateWithDuration:1.0 animations:^(void){
        
        viw_bigImage.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationTransitionCurlUp animations:^(void){
            // viw_img.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
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
    
    NSLog(@"%@",tagName);
    
    
    if ([tagName isEqualToString:@"IMG"])
    {
        NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString * url = [webviw_note_detail stringByEvaluatingJavaScriptFromString:js];
        
        imgviw_note.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        
        viw_bigImage.transform = CGAffineTransformScale(viw_bigImage.transform, 0.1, 0.1);
        viw_bigImage.center = self.view.center;
        // im.center=CGPointMake(10, 30);
        [self.view addSubview:viw_bigImage];
        
        [UIView animateWithDuration:1.0 animations:^(void){
            
            viw_bigImage.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationTransitionCurlUp animations:^(void){
                // viw_img.alpha = 0.0;
            } completion:^(BOOL finished) {
                //[im removeFromSuperview];
            }];
            
        }];
        
        
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    imgviw_note.layer.cornerRadius=15.0;
    imgviw_note.clipsToBounds=YES;
    
    muarr_ShareNotes=[[NSMutableArray alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self getAllShareNotes];
    if ([muarr_ShareNotes count]>0) 
    {
          [self loadShareNotes:[muarr_ShareNotes count]];
    }
    else
    {
        UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Notes Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alert1 show];
        [alert1 release];
    }
  
    UITapGestureRecognizer *gs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    gs.numberOfTapsRequired =1;
    gs.delegate = self;
    
    [webviw_note_detail addGestureRecognizer:gs];
}


-(IBAction)btnHome
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

@end
