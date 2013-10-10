//
//  PlacesParser.m
//  TBXmlPOC
//
//  Created by Senthilkumar R on 2/23/12.
//  Copyright (c) 2012 DMBC. All rights reserved.
//

#import "PlacesParser.h"


@implementation PlacesParser


- (NSMutableArray*) getUserList:(int) iMode
{
	NSMutableArray* arrOutput = [NSMutableArray new];
	
	NSURL* url = nil; 
	
	if (iMode == 1) {
		url = [NSURL URLWithString:@"http:/whootin.com/api/v1/users.xml?count=200"];
	} else {
		url = [NSURL URLWithString:kGetUsers];
	}
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"]; 
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL]; 
	
	//	NSString* newStr = [[NSString alloc] initWithData:response
	//											 encoding:NSUTF8StringEncoding];
	//	
	//	NSLog(@"XML %@", newStr);
	
	if (response) {
		tbxml = [[TBXML alloc] initWithXMLData:response];
		
		if (tbxml.rootXMLElement)
		{
			TBXMLElement *elementFirst = tbxml.rootXMLElement;
			
			TBXMLElement *element = [TBXML childElementNamed:@"user" parentElement:elementFirst];
			if (element) {
			do {
				
				if (element && [[TBXML elementName:element] isEqualToString:@"user"]) {
					
					TBXMLElement *idElement = [TBXML childElementNamed:@"id" parentElement:element];
					TBXMLElement *usernameElement = [TBXML childElementNamed:@"username" parentElement:element];
					TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:element];
					//TBXMLElement *urlElement = [TBXML childElementNamed:@"avatar-url" parentElement:element];
					
					User *oUser = [User new];
					
					oUser.sId = [TBXML textForElement:idElement];
					oUser.sUsername = [TBXML textForElement:usernameElement];
					oUser.sName = [TBXML textForElement:nameElement];
					oUser.sProfileImg = @"";//[TBXML textForElement:urlElement];
					
					
					[arrOutput addObject:oUser];
					
					oUser = nil;
				}
				} while ((element = element->nextSibling));  
		}
		}
		
	}
	
	return arrOutput;
}

- (User*) getUserInfo
{
	User* oUser = [User new];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kUserProfile]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"]; 
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL]; 
	
//	NSString* newStr = [[NSString alloc] initWithData:response
//											 encoding:NSUTF8StringEncoding];
//	
//	NSLog(@"XML %@", newStr);
	
	if (response) {
		tbxml = [[TBXML alloc] initWithXMLData:response];
		
		if (tbxml.rootXMLElement)
		{
			TBXMLElement *element = tbxml.rootXMLElement;
			if (element) {
				do {
				
				if (element && [[TBXML elementName:element] isEqualToString:@"user"]) {
					
					TBXMLElement *idElement = [TBXML childElementNamed:@"id" parentElement:element];
					TBXMLElement *usernameElement = [TBXML childElementNamed:@"username" parentElement:element];
					TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:element];
					TBXMLElement *urlElement = [TBXML childElementNamed:@"avatar-url" parentElement:element];
					
					User *oUser = [User new];
					
					oUser.sId = [TBXML textForElement:idElement];
					oUser.sUsername = [TBXML textForElement:usernameElement];
					oUser.sName = [TBXML textForElement:nameElement];
					oUser.sProfileImg = [TBXML textForElement:urlElement];
					

					return oUser;
				}
				} while ((element = element->nextSibling));  
			}
			
		}
		
	}
	
	return oUser;
}

- (NSMutableArray*) getMessages
{
	NSMutableArray* arrOutput = [NSMutableArray new];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kMessages]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", kAccessToken] forHTTPHeaderField:@"Authorization"]; 
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:NULL]; 
	
	//NSString* newStr = [[NSString alloc] initWithData:response
											 //encoding:NSUTF8StringEncoding];
	
	//NSLog(@"XML %@", newStr);
	
	if (response) {
		tbxml = [[TBXML alloc] initWithXMLData:response];
		
		if (tbxml.rootXMLElement)
		{
			TBXMLElement *elementFirst = tbxml.rootXMLElement;
			
			TBXMLElement *element = [TBXML childElementNamed:@"message" parentElement:elementFirst];
			if (element) 
			{
				do {
				
				if ([[TBXML elementName:element] isEqualToString:@"message"]) 
				{
					NSString* sAudioUrl = nil;
					NSString* sLength = @"00:00";
					
					NSString* sText = @"";
					
					TBXMLElement *idElement = [TBXML childElementNamed:@"id" parentElement:element];
					TBXMLElement *textElement = [TBXML childElementNamed:@"text" parentElement:element];
					TBXMLElement *createdElement = [TBXML childElementNamed:@"created-at" parentElement:element];
					
					if (textElement) {
						sText = [TBXML textForElement:textElement];
					}
					
					
					TBXMLElement *senderElement = [TBXML childElementNamed:@"sender" parentElement:element];
					TBXMLElement *uploadsElement = [TBXML childElementNamed:@"uploads" parentElement:element];
					
					Message1* oMessage = [Message1 new];
					oMessage.sId = [TBXML textForElement:idElement];
					oMessage.sMessage = sText;

					if (senderElement != nil) { 
						TBXMLElement *useridElement = [TBXML childElementNamed:@"id" parentElement:senderElement];
						TBXMLElement *usernameElement = [TBXML childElementNamed:@"username" parentElement:senderElement];
						TBXMLElement *nameElement = [TBXML childElementNamed:@"name" parentElement:senderElement];
						TBXMLElement *urlElement = [TBXML childElementNamed:@"avatar-url" parentElement:senderElement];
						
						User *oUser = [User new];
						
						oUser.sId = [TBXML textForElement:useridElement];
						oUser.sUsername = [TBXML textForElement:usernameElement];
						oUser.sName = [TBXML textForElement:nameElement];
						oUser.sProfileImg = [TBXML textForElement:urlElement];
						oMessage.sender = oUser;
					}
					
					if (uploadsElement != nil) {
						TBXMLElement *uploadElement = [TBXML childElementNamed:@"upload" parentElement:uploadsElement];
						
						if (uploadElement != nil) {
							
							TBXMLElement *lengthElement = [TBXML childElementNamed:@"length" parentElement:uploadElement];
							if (lengthElement) {
								int iLength = [[TBXML textForElement:lengthElement] intValue];
								
								int iMin = iLength / 60;
								int iSec = iLength % 60;
								
								NSString *sMin = (iMin < 10) ? [NSString stringWithFormat:@"0%i", iMin] : [NSString stringWithFormat:@"%i", iMin];
								
								NSString *sSec = (iSec < 10) ? [NSString stringWithFormat:@"0%i", iSec] : [NSString stringWithFormat:@"%i", iSec];
								
								sLength = [NSString stringWithFormat:@"%@:%@", sMin, sSec];
								
							}
							
							
							TBXMLElement *urlidElement = [TBXML childElementNamed:@"url" parentElement:uploadElement];
							if (urlidElement) {
								sAudioUrl = [TBXML textForElement:urlidElement];
							}
							
						}
					}
					
					if (sAudioUrl) {
						oMessage.sLength = sLength;
						oMessage.sTime = [TBXML textForElement:createdElement];
						oMessage.sAudioUrl = sAudioUrl;
						[arrOutput addObject:oMessage];
					}
					
					oMessage = nil;
				}
				} while ((element = element->nextSibling));  
			}
			
		}
		
	}
	
	return arrOutput;
}


 

@end
