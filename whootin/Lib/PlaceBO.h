//
//  PlaceBO.h
//  SaxParserPOC
//
//  Created by Gopinath on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceBO : NSObject
{
    NSString *strName;
    NSString *strVicinity;
}
@property(nonatomic,retain) NSString *strName;
@property(nonatomic,retain) NSString *strVicinity;

@end
