//
//  User.h
//  WalkieTalkieRadio
//
//  Created by Senthilkumar R on 26/09/12.
//  Copyright (c) 2012 DMBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>
{
	NSString* sId, *sName, *sUsername, *sProfileImg;
}

@property (strong, nonatomic) NSString* sId, *sName, *sUsername, *sProfileImg;

@end
