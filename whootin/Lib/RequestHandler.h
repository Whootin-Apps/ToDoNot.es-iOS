//
//  RequestHandler.h
//  WalkieTalkieRadio
//
//  Created by Senthilkumar R on 27/10/12.
//  Copyright (c) 2012 Manthan Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHandler : NSObject
{
	id mTarget;
    SEL mSelector;
}

- (NSMutableData *) PerformRequest:(NSMutableDictionary*) requestDict RequestUrl : (NSString *) sUrl;

@end
