//
//  WhootinViewController.m
//  Whootin
//
//  Created by Whootin on 24/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WhootinViewController.h"
#import "User.h"
#import "JSON.h"
#import "PlacesParser.h"
#import "Reachability.h"

#define kOFFSET_FOR_KEYBOARD 140.0


@implementation WhootinViewController

@synthesize minutes,seconds,delegate;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)internetServicesAvailable
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
	
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
     
   /* Switch3DTransition *t1=[[Switch3DTransition alloc] init];
    t1.transitionType=Switch3DTransitionRight;
    
    transition=t1;*/
    
    [txt_username becomeFirstResponder];
    minutes=0;
    seconds=0;
    viw_progress2.clipsToBounds=YES;
    message=[[NSString alloc] init];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

// This method used for selec the Login View Or Sign up View

-(IBAction)btnSignup
{
   [self.view addSubview:viw_signup];
}


// Login Method

-(IBAction)btnSubmit
{
    if (![self internetServicesAvailable]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Internet Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
    else
    {
    
	if (txt_username.text.length == 0 || txt_password.text.length == 0) {
		showAlert(@"Username or Password should not be empty.");
	} else {
		NSString *theURLString = @"http://whootin.com/oauth/token";
		
		NSURL *theURL = [[NSURL alloc] initWithString: [theURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
		
		
		NSString *theMessage = [NSString stringWithFormat: @"grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",WH_CLIENT_ID, WH_CLIENT_SECRET, txt_username.text, txt_password.text];
		
		NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
		[theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
		//  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
		[theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPMethod:@"POST"];
		[theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
		[theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
		
		NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
		
		NSString* newStr = [[NSString alloc] initWithData:response
												 encoding:NSUTF8StringEncoding];
		//NSLog(@"Response %@", newStr);
		
		NSDictionary *json = [newStr JSONValue];
		
		NSLog(@"Value %@", json);
		
		NSString* sError = [json objectForKey:@"error"];
		
		if (sError == nil) {
			//NSLog(@"access_token %@", [json objectForKey:@"access_token"]);
			
			
			NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
			
			[defaults setObject:[json objectForKey:@"access_token"] forKey:@"ACCESS_TOKEN"];
			
			
			PlacesParser *oParser = [PlacesParser new];
			
			 User* oUser = [oParser getUserInfo];
			[defaults setObject:oUser.sId forKey:@"UserId"];
			[defaults setObject:oUser.sUsername forKey:@"Username"];
			[defaults setObject:oUser.sName forKey:@"Name"];
			[defaults setObject:oUser.sProfileImg forKey:@"ProfileImg"];
			[defaults synchronize];
            
            
            [defaults objectForKey:@"UserId"];
			                     
           // [self btnPost];
            
          /*  if (!kFolderId) 
            {
                NSURL *theURL = [[NSURL alloc] initWithString: [kCreateFolder stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
                NSString *theMessage = [NSString stringWithFormat: @"name=ToDoNotes"];
                
                NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
                [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                //  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
                [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
                [theRequest setHTTPMethod:@"POST"];
                [theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
                [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
                
                [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [theRequest setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
                
                NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
                
                NSString* newStr = [[NSString alloc] initWithData:response
                                                         encoding:NSUTF8StringEncoding];
                //NSLog(@"Response %@", newStr);
                
                NSDictionary *json = [newStr JSONValue];
                
                [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"id"] forKey:@"FOLDER_ID"];
                
                
                NSLog(@"Value %@", json);
                //[self btnPost];
               
                             
            }*/
            
            NSString *string_url=[NSString stringWithFormat:@"http://whootin.com/api/v1/file?name=ToDoNotes&access_token=%@",kAccessToken];
            
            
            NSURL *theURL = [[NSURL alloc] initWithString: [string_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
            //NSString *theMessage = [NSString stringWithFormat: @"name=ToDoNotes"];
            
           // NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
            //[theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
              //[theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
           // [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
            [theRequest setHTTPMethod:@"GET"];
            //[theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
            [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
            
            NSLog(@"setMessage body");
            [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            //[theRequest setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
             NSLog(@"JSon Value Added");
            NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
            NSLog(@"Response");
            NSString* newStr = [[NSString alloc] initWithData:response
                                                     encoding:NSUTF8StringEncoding];
           // NSLog(@"Response %@", newStr);
            
            NSDictionary *json = [newStr JSONValue];
            
           // 

            NSString *sError=[json objectForKey:@"error"];
            if (sError==nil) 
            {
                if ([[json objectForKey:@"type"] isEqualToString:@"folder"])
                {
                    NSLog(@"Already Folder is there...");
                     [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"id"] forKey:@"FOLDER_ID"];
                }
                else
                {
                    if (!kFolderId) 
                    {
                        
                        NSLog(@"If That is not folder...");
                        
                        NSURL *theURL = [[NSURL alloc] initWithString: [kCreateFolder stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
                        NSString *theMessage = [NSString stringWithFormat: @"name=ToDoNotes"];
                        
                        NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
                        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                        //  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
                        [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
                        [theRequest setHTTPMethod:@"POST"];
                        [theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
                        [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
                        
                        [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                        [theRequest setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
                        
                        NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
                        
                        NSString* newStr = [[NSString alloc] initWithData:response
                                                                 encoding:NSUTF8StringEncoding];
                        //NSLog(@"Response %@", newStr);
                        
                        NSDictionary *json = [newStr JSONValue];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"id"] forKey:@"FOLDER_ID"];
                        
                        
                        NSLog(@"Value %@", json);
                        //[self btnPost];
                        
                        
                    } 

                }
               
            }
            else
            {
                if (!kFolderId) 
                {
                    NSLog(@"There is no folder...");
                    NSURL *theURL = [[NSURL alloc] initWithString: [kCreateFolder stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
                    NSString *theMessage = [NSString stringWithFormat: @"name=ToDoNotes"];
                    
                    NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
                    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                    //  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
                    [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
                    [theRequest setHTTPMethod:@"POST"];
                    [theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
                    [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
                    
                    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [theRequest setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
                    
                    NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
                    
                    NSString* newStr = [[NSString alloc] initWithData:response
                                                             encoding:NSUTF8StringEncoding];
                    //NSLog(@"Response %@", newStr);
                    
                    NSDictionary *json = [newStr JSONValue];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"id"] forKey:@"FOLDER_ID"];
                    
                    
                     NSLog(@"Value %@", json);
                    //[self btnPost];
                    
                    
                } 
            }
            [self home];             			
		} 
        else 
        {
			showAlert(@"Invalid Username or Password.");
		}
        
	}
    }

}


-(IBAction)btnLogout
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ACCESS_TOKEN"];
    [viw_user removeFromSuperview];
}

-(IBAction)btnDone
{
   
    if (![self internetServicesAvailable]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"ToDoNot.es" message:@"Internet Required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
	}
    else
    {
    
    if (txt_semail.text.length == 0 || txt_sname.text.length == 0 || txt_susername.text.length == 0 || txt_spassword.text.length == 0) 
    {
		showAlert(@"Please enter all the values.");
	}
    else 
    {
        
        if ([[txt_spassword text] isEqualToString:[txt_confirm_pass text]])
        {
            
    
		NSString *theURLString = @"http:/whootin.com/api/v1/users/new.json";
		
		NSURL *theURL = [[NSURL alloc] initWithString: [theURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
		
		
		NSString *theMessage =[NSString stringWithFormat: @"username=%@&password=%@&name=%@&email=%@", txt_susername.text, txt_spassword.text, txt_sname.text, txt_semail.text];;
		
		NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
		[theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
		//  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
		[theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
		[theRequest setHTTPMethod:@"POST"];
		[theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
		[theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
		
		NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
		
		NSString* newStr = [[NSString alloc] initWithData:response
												 encoding:NSUTF8StringEncoding];
		//NSLog(@"Response %@", newStr);
		
		NSDictionary *json = [newStr JSONValue];
		
		//NSLog(@"Value %@", json);
		
		NSString* sError = [json objectForKey:@"error"];
		
		if (sError == nil) {
            
            NSLog(@"Successfully Reg..");
            //			showAlert(@"Successfully Registered.");
            //			UserLogin *oUserLogin = [[UserLogin alloc] initWithNibName:@"UserLogin" bundle:nil];
            //			[self.navigationController pushViewController:oUserLogin animated:NO];
			
			NSString *theURLString = @"http://whootin.com/oauth/token";
			
			NSURL *theURL = [[NSURL alloc] initWithString: [theURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			
			NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
			
			
			NSString *theMessage = [NSString stringWithFormat: @"grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",WH_CLIENT_ID, WH_CLIENT_SECRET, txt_susername.text, txt_spassword.text];
			
			NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
			[theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
			//  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
			[theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
			[theRequest setHTTPMethod:@"POST"];
			[theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
			[theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
			
			NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
			
			NSString* newStr = [[NSString alloc] initWithData:response
													 encoding:NSUTF8StringEncoding];
			//NSLog(@"Response %@", newStr);
			
			NSDictionary *json = [newStr JSONValue];
			
			NSLog(@"Value %@", json);
			
			sError = [json objectForKey:@"error"];
			
			if (sError == nil) {
                
                NSLog(@"Succsssfully Logined !...");
                
				NSLog(@"access_token %@", [json objectForKey:@"access_token"]);
				
				
				NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
				
				[defaults setObject:[json objectForKey:@"access_token"] forKey:@"ACCESS_TOKEN"];
				
                
				
				PlacesParser *oParser = [PlacesParser new];
				
				User* oUser = [oParser getUserInfo];
				[defaults setObject:oUser.sId forKey:@"UserId"];
				[defaults setObject:oUser.sUsername forKey:@"Username"];
				[defaults setObject:oUser.sName forKey:@"Name"];
				[defaults setObject:oUser.sProfileImg forKey:@"ProfileImg"];
				[defaults synchronize];
                
              /*  lbl_username.text = kUsername;
                lbl_name.text = kName;
                
                NSString* sProfileImg = [kProfileImg stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sProfileImg]]];
                
                
                imgviw_profile.image = image;
                [viw_signup removeFromSuperview];
                [self.view addSubview:viw_user];*/
                              
                
                if (!kFolderId) 
                {
                    NSURL *theURL = [[NSURL alloc] initWithString: [kCreateFolder stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc ] initWithURL:theURL];
                    NSString *theMessage = [NSString stringWithFormat: @"name=ToDoNotes"];
                    
                    NSString *theMsgLength = [[NSString alloc ] initWithFormat:@"%d", [theMessage length]];
                    [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
                    //  [theRequest addValue:@""  forHTTPHeaderField:@"SOAPAction"];
                    [theRequest addValue: theMsgLength forHTTPHeaderField:@"Content-Length"];
                    [theRequest setHTTPMethod:@"POST"];
                    [theRequest setHTTPBody: [theMessage dataUsingEncoding:NSUTF8StringEncoding]];
                    [theRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
                    
                    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                    [theRequest setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"];
                    
                    NSData *response = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:NULL error:NULL]; 
                    
                    NSString* newStr = [[NSString alloc] initWithData:response
                                                             encoding:NSUTF8StringEncoding];
                    //NSLog(@"Response %@", newStr);
                    
                    NSDictionary *json = [newStr JSONValue];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"id"] forKey:@"FOLDER_ID"];
                    NSLog(@"Value %@", json);
                   // [self btnPost];
                    [self home];
          }                
    } 
} 
        
        else 
        {
            NSLog(@"succes");
            
			NSDictionary *details = [json objectForKey:@"details"];
            
			NSArray * arrMessage = [details objectForKey:@"username"];
			NSString* sMessage = @"";
			
			if (arrMessage != nil && arrMessage.count > 0) {
				sMessage = [NSString stringWithFormat:@"Username %@", [arrMessage objectAtIndex:0]];
			} else {
				arrMessage = [details objectForKey:@"email"];
				if (arrMessage != nil && arrMessage.count > 0) 
					sMessage = [NSString stringWithFormat:@"Email %@", [arrMessage objectAtIndex:0]];
			}
            
            showAlert(sMessage);
			// [self keyboardWillHide];
			[txt_sname resignFirstResponder];
			[txt_semail resignFirstResponder];
			[txt_susername resignFirstResponder];
			[txt_password resignFirstResponder];
			
		//	[self setViewMovedUp:NO];
			//showAlert(sMessage);
			
			
		}
	  }
        else
        {
            showAlert(@"Password missmatch");
        }
    }
    }
    
 
}

-(IBAction)home
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];
    
  /*  [[HMGLTransitionManager sharedTransitionManager] setTransition:transition];		
	[[HMGLTransitionManager sharedTransitionManager] dismissModalViewController:self];*/
}

-(IBAction)btnBack
{
    [viw_signup removeFromSuperview]; 
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
    return YES;
}

-(void)setMessageBody:(NSString *)msg
{
    APP.wMessage=msg;
}



-(IBAction)btnPost
{ 
	
	//NSURL *postURL = [[NSURL alloc] initWithString:@"http://whootin.com/api/v1/statuses/update.json"];
    
   
    
    
    NSLog(@"APP.wMessage : %@",APP.wMessage);
  
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   
    NSString *inc=[defaults objectForKey:@"NOTE_NO"];
    NSLog(@"%@",inc);
    if ([inc isEqualToString:@""] || inc==nil) 
    {
         note_no=100;
         NSString *str1=[NSString stringWithFormat:@"%d",note_no];
         [defaults setValue:str1 forKey:@"NOTE_NO"];
    }
    else
    {
        NSLog(@"Welcome to NOTE_NO");

        note_no=[[defaults objectForKey:@"NOTE_NO"]intValue];
        note_no++;
        NSString *str1=[NSString stringWithFormat:@"%d",note_no];
        [defaults setValue:str1 forKey:@"NOTE_NO"];
    }
    
  /*  NSURL *postURL = [[NSURL alloc] initWithString:kNewMessage];
	
	
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
	NSString *inUsername=kUsername;
    NSLog(@"%@",kUsername);
    NSLog(@"note _no : %d",note_no);
   
   
    
    int iLength=[APP.wMessage length];
	// set header
	[request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
	
	//add body
	NSMutableData *postBody = [NSMutableData data];
	NSLog(@"body made");
	//wigi access token 
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[inUsername dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"length\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"%i", iLength] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	
		//image
		[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSString *strContent=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"Notes%d.xml\"\r\n",note_no];
		[postBody appendData:[strContent dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[@"Content-Type: xml\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
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
	
	NSLog(@"body set");
	// pointers to some necessary objects
	NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
	NSError* error = [[NSError alloc] init] ;
	
	// synchronous filling of data from HTTP POST response
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
   
    
	if (responseData)
    {
        [self performSelector:@selector(exit)];
    }*/
    
    
    
    
	NSString *sFolderId = [NSString stringWithFormat:@"%@",kFolderId];
	//	NSError *err = nil;
	//NSURL *fileUrl = [NSURL fileURLWithPath:inImageUrl];
	
   // NSString *NotesData=@"Welcome This is used for folder creation Example";
	
	//NSData *AudioData = [NSData dataWithContentsOfFile:[fileUrl path] options: 0 error:&err];
	
	//NSURL *postURL = [[NSURL alloc] initWithString:@"http:/whootin.com/api/v1/files/new.json"];
	
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
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"Notes%d.xml\"\r\n",note_no] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: text/xml\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
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
	
	if (responseData) {
		
		NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
		NSLog(@"JSON %@", newStr);
		
	}

      [self dismissModalViewControllerAnimated:YES];
    
    
    
    
			
}

-(void)exit
{
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)btnFolder
{
 
  
    
}

-(IBAction)btnCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
		mIsKeyBoard = NO;
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
		if (rect.origin.y >= 0) {
			rect.origin.y -= kOFFSET_FOR_KEYBOARD;
			rect.size.height += kOFFSET_FOR_KEYBOARD;
		}
    }
    else
    {
		mIsKeyBoard = YES;
        // revert back to the normal state.
		if (rect.origin.y < 0) {
			rect.origin.y += kOFFSET_FOR_KEYBOARD;
			rect.size.height -= kOFFSET_FOR_KEYBOARD;
		}
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:txt_semail])
    {
		[self setViewMovedUp:YES];
    } else if ([sender isEqual:txt_susername] && mIsKeyBoard == YES) {
		mIsKeyBoard = NO;
		[self setViewMovedUp:YES];
	} else if ([sender isEqual:txt_spassword] && mIsKeyBoard == YES) {
		mIsKeyBoard = NO;
		[self setViewMovedUp:YES];
	}

}

-(void)addSignupView
{
    [txt_username resignFirstResponder];
    [self.view addSubview:viw_signup];
}

- (void)modalControllerDidFinish:(WhootinViewController*)modalController;
{
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
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
