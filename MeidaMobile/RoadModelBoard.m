//
//  RoadModelBoard.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-7-11.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "RoadModelBoard.h"

#define lineWidth 2.0
#define lineHeight 12.0
#define charFontSize 19.0

@implementation RoadModelBoard
@synthesize iconModelID = _iconModelID;

-(void)setImage:(UIImage *)image{
    [super setImage:nil];
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextSetStrokeColorWithColor(context, [BRUSHCOLOR CGColor]);
    CGContextSetFillColorWithColor(context, [BRUSHCOLOR CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, 2.0, lineHeight);
    CGContextAddLineToPoint(context, self.frame.size.width-2, lineHeight);
    NSInteger lineCount=(((int)self.frame.size.width)/PaintAreaWidth)*20/5*2;
    CGFloat lineLength=self.frame.size.width/(double)lineCount;
    for (int i=1; i<=lineCount-1; i++) {
        CGPoint p1,p2;
        p1.x=lineLength*i;
        p2.x=lineLength*i;
        if (i % 2 ==0) {
            p1.y=lineHeight-8;
            p2.y=lineHeight+8;
            CGContextSetTextDrawingMode(context, kCGTextFill);
            NSString * numberText=[NSString stringWithFormat:@"%d",i/2*5];
            [numberText drawAtPoint:CGPointMake((p2.x-6-(numberText.length-1)*5), p2.y) withFont:[UIFont fontWithName:@"Helvetica" size:charFontSize]];
        } else {
            p1.y=lineHeight-4;
            p2.y=lineHeight+4;
        }
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
    }
    CGContextStrokePath(context);
    
    if (image) {
        CGSize singleImageSize=CGSizeMake(PaintAreaWidth, ModelHeight);
        UIImage *singleImage;
        if (CGSizeEqualToSize(singleImageSize, image.size)) {
            singleImage=image;
        } else {
            CGRect singleImageRect=CGRectMake(0, PaintAreaHeight - ModelHeight, PaintAreaWidth, ModelHeight);
            CGImageRef singleCGImageRef=CGImageCreateWithImageInRect(image.CGImage, singleImageRect);
            singleImage=[[UIImage alloc] initWithCGImage:singleCGImageRef];
            CGImageRelease(singleCGImageRef);
        }
        NSInteger numberOfClones=(NSInteger)self.frame.size.width/(NSInteger)PaintAreaWidth;
        for (int i=0;i<numberOfClones;i++){
            CGRect increaseRect=CGRectMake(i*PaintAreaWidth, PaintAreaHeight - ModelHeight, PaintAreaWidth, ModelHeight);
            [singleImage drawInRect:increaseRect];
        }
    }

    UIImage *finalImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [super setImage:finalImage];    
}

@end
