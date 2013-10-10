//
//  AnimationView.m
//  CountAndLearn
//
//  Created by macmini05 on 28/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationView.h"
static CGFloat kTransitionDuration = 0.3;

@implementation AnimationView
@synthesize vwTemp;
+(void)addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs {
        // first reduce the view to 1/100th of its original dimension
        CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
        view.transform = trans;	// do it instantly, no animation
        //[self addSubview:view];
        // now return the view to normal dimension, animating this tranformation
        [UIView animateWithDuration:secs delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
                         }
                         completion:nil];
	//[UIView commitAnimations];
}
+ (void) moveTo:(CGPoint)destination duration:(float)secs: (UIView*)view
    {
        [UIView animateWithDuration:secs delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             view.frame = CGRectMake(destination.x,destination.y, view.frame.size.width, view.frame.size.height);
                         }
                         completion:nil];
    
    
     //[UIView commitAnimations];

}
+ (void) moveBubble:(CGPoint)destination duration:(float)secs: (UIView*)view
{
    [UIView animateWithDuration:secs delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         view.frame = CGRectMake(destination.x,destination.y, view.frame.size.width, view.frame.size.height);
                     }
                     completion:nil];
    
    
    //[UIView commitAnimations];
    
}
-(void)showAlertView{
   // criteriaView.hidden=NO;
    
    vwTemp.transform = CGAffineTransformMakeScale( 0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	vwTemp.transform = CGAffineTransformMakeScale( 1.1, 1.1);
    
	[UIView commitAnimations];	


}

- (void)bounce1AnimationStopped 
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	vwTemp.transform = CGAffineTransformMakeScale (0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];

	vwTemp.transform =  CGAffineTransformIdentity;
	[UIView commitAnimations];
}
+(void)removeAlert:(UIView *)criteriaView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];  
    criteriaView.transform = CGAffineTransformMakeScale( 0.001, 0.001); 
    [UIView setAnimationDidStopSelector:@selector(removeCriteriaView:)];
    [UIView commitAnimations]; 
}
-(void)removeCriteriaView:(UIView *)criteriaView{
    [criteriaView removeFromSuperview];
}
@end
