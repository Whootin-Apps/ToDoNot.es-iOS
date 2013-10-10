//
//  AnimationView.h
//  CountAndLearn
//
//  Created by macmini05 on 28/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationView : NSObject{
    UIView *vwTemp;
}
@property(strong,nonatomic)UIView *vwTemp;
+(void)addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs;
+ (void) moveTo:(CGPoint)destination duration:(float)secs: (UIView*)view;
+ (void) moveBubble:(CGPoint)destination duration:(float)secs: (UIView*)view;
-(void)showAlertView;
+(void)removeAlert:(UIView *)criteriaView;
@end
