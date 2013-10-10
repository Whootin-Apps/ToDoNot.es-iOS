//
//  Utils.m
//  WalkieTalkieRadio
//
//  Created by Senthilkumar R on 26/09/12.
//  Copyright (c) 2012 Manthan Systems. All rights reserved.
//

#import "Utils.h"

@implementation Utils

void showAlert (NSString* sMessage)
{
	UIAlertView *theAlertView = [[UIAlertView alloc] initWithTitle:kAppName message:sMessage delegate:NULL cancelButtonTitle:@"Ok" otherButtonTitles:NULL, nil];
    [theAlertView show];
}

@end
