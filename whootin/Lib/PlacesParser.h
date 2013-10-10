//
//  PlacesParser.h
//  TBXmlPOC
//
//  Created by R Senthilkumar on 2/23/12.
//  Copyright (c) 2012 DMBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface PlacesParser : NSObject
{

    TBXML *tbxml;
}

- (NSMutableArray*) getUserList:(int) iMode;
- (User*) getUserInfo;
- (NSMutableArray*) getMessages;
@end
