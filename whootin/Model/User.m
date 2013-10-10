//
//  User.m
//  WalkieTalkieRadio
//
//  Created by Senthilkumar R on 26/09/12.
//  Copyright (c) 2012 DMBC. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize sId;
@synthesize sName;
@synthesize sUsername;
@synthesize sProfileImg;

- (void)encodeWithCoder:(NSCoder *)encoder
{
	
    if ([encoder isKindOfClass:[NSKeyedArchiver class]]) {
        [encoder encodeObject:self.sId forKey:@"id"];
		[encoder encodeObject:self.sName forKey:@"name"];
		[encoder encodeObject:self.sUsername forKey:@"username"];
		[encoder encodeObject:self.sProfileImg forKey:@"profileimg"];

    }
    else {
        [NSException raise:NSInvalidArchiveOperationException
                    format:@"Only supports NSKeyedArchiver coders"];
    }
	
	
}
- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if( self != nil )
	{
        //decode properties, other class vars
		self.sId = [decoder decodeObjectForKey:@"id"];
		self.sName = [decoder decodeObjectForKey:@"name"];
		self.sUsername = [decoder decodeObjectForKey:@"username"];
		self.sProfileImg = [decoder decodeObjectForKey:@"profileimg"];
	}
	return self;
}


@end
