//
//  PhotoImageView.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-27.
//
//

#import "PhotoImageView.h"

@implementation PhotoImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
