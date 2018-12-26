//
//  TouchedScrollView.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-26.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "TouchedScrollView.h"

#define lineHeight 16.0
#define charFontSize 19.0



@implementation TouchedScrollView

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    if (self) {
        //设定只有双指拖动才能翻页
        for (UIGestureRecognizer *mgestureRecognizer in self.gestureRecognizers) {     
            if ([mgestureRecognizer  isKindOfClass:[UIPanGestureRecognizer class]])
            {
                UIPanGestureRecognizer *mpanGR = (UIPanGestureRecognizer *) mgestureRecognizer;
                mpanGR.minimumNumberOfTouches = 2; 
                mpanGR.maximumNumberOfTouches = 2;
                
            }            
            if ([mgestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
            {
                UISwipeGestureRecognizer *mswipeGR = (UISwipeGestureRecognizer *) mgestureRecognizer;
                mswipeGR.numberOfTouchesRequired = 2;
            }
        }
        self.layer.cornerRadius=4;
        self.layer.masksToBounds=YES;
        [self setBackgroundColor:BGCOLOR];
    }   
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging && touches.count==1) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}


@end
