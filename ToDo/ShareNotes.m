//
//  ShareNotes.m
//  ToDo
//
//  Created by Support Nua on 26/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ShareNotes.h"

@implementation ShareNotes
@synthesize nPrevilege,nNoteImage,nImageURL,nName,nDescription,nFontname,nFontcolor,nAlign,nDuedate,nDone,nSender;
-(void)dealloc
{
    nPrevilege=nil;
    nNoteImage=nil;
    nImageURL=nil;
    nName=nil;
    nDescription=nil;
    nFontname=nil;
    nFontcolor=nil;
    nAlign=nil;
    nDuedate=nil;
    nDone=nil;
    nSender=nil;
}

@end
