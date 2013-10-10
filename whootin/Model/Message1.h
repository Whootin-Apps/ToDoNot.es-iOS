//
//  Message.h
//  WalkieTalkieRadio
//
//  Created by Senthilkumar R on 26/09/12.
//  Copyright (c) 2012 DMBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message1 : NSObject
{
	NSString *sCreated, *sId, *sRecipientId, *sSenderId, *sMessage, *sAudioUrl, *sTime, *sLength;
	User* sender;
}

@property (strong, nonatomic) NSString *sCreated, *sId, *sRecipientId, *sSenderId, *sMessage, *sAudioUrl, *sTime, *sLength;

@property (strong, nonatomic) User* sender;

@end
