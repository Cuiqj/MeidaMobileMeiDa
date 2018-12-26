//
//  paintArea.m
//  test
//
//  Created by yu hongwu on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintArea.h"


//设定连续画线时的最小保存间隔，即相对于前一点偏移多少后，才将该点保存，目的在于减少绘图操作数组的大小，减少内存使用。值越小，线条越平滑，但内存使用越大。
#define PointMinimumOffset 1.0f

@interface PaintArea(){
    CGPoint gP1,gP2;
}
- (void)panGestureRecognize:(UIPanGestureRecognizer *)gestureRecognizer;
@end

@implementation PaintArea
@synthesize dwStrokes=_dwStrokes;
@synthesize selectedTool=_selectedTool;
@synthesize selectedType=_selectedType;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognize:)];
        [self addGestureRecognizer:panGestureRecognizer];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        panGestureRecognizer.minimumNumberOfTouches = 1;
        self.dwStrokes=[[NSMutableArray alloc] initWithCapacity:1];
        self.selectedType=-1;
        self.selectedTool=-1;
        self.frame=frame;
        // Initialization code
    }
    return self;
}

-(void)dealloc{
    [self setDelegate:nil];
    [self setDwStrokes:nil];
}

//点击捕捉
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (touches.count == 1) {
        UITouch *touch= [touches anyObject];
        DWStroke *stroke=[[DWStroke alloc] init];
        stroke.path=[UIBezierPath bezierPath];
        stroke.isErasing=NO;
        stroke.path.lineWidth=drawLineWidth;
        stroke.brushColor=BRUSHCOLOR;
        if (self.selectedType==3) {
            stroke.pathType = self.selectedTool;
            gP1 = [touch locationInView:self];
            switch (self.selectedTool) {
                case 3:
                    //点
                {
                    [self.dwStrokes addObject:stroke];
                    [stroke addDotAtP1:gP1];
                    NSInteger currentPage=[self.delegate getCurrentPageDelegate];
                    CGRect currentRect;
                    currentRect.origin=CGPointMake(currentPage*PaintAreaWidth, 0);
                    currentRect.size=self.frame.size;
                    [self setNeedsDisplayInRect:currentRect];
                }
                    break;
                case 11:
                    //橡皮
                {
                    stroke.isErasing=YES;
                    stroke.path.lineWidth=eraserWidth;
                    stroke.brushColor=[UIColor clearColor];
                    [self.dwStrokes addObject:stroke];
                }
                    break;
                case 0:
                case 1:
                case 2:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 10:
                    //直线，圆，矩形，曲线，箭头，双向箭头，虚线，护栏，草坪
                {
                    stroke.path.lineWidth=drawLineWidth;
                    [self.dwStrokes addObject:stroke]; 
                }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)panGestureRecognize:(UIPanGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.numberOfTouches<2) {
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
            CGPoint touchPoint=[gestureRecognizer locationInView:self];
            NSInteger currentPage=[self.delegate getCurrentPageDelegate];
            CGFloat currentWidth=[self.delegate getCurrentContentSize];
            if (touchPoint.x>10 && touchPoint.x<currentWidth-10) {
                if (touchPoint.x>(currentPage+1)*PaintAreaWidth-10) {
                    [self.delegate autoScrollPage:(currentPage+1)*PaintAreaWidth];
                }
                if (touchPoint.x<currentPage*PaintAreaWidth+10) {
                    [self.delegate autoScrollPage:(currentPage-1)*PaintAreaWidth];
                }  
            }         
            if (self.selectedType==3) {                
                switch(self.selectedTool){
                    case 3:
                        //点
                        break;
                    case 4:
                        //曲线
                    {
                        CGFloat offset = sqrtf((touchPoint.x-gP1.x)*(touchPoint.x-gP1.x)+(touchPoint.y-gP1.y)*(touchPoint.y-gP1.y));
                        if (offset > PointMinimumOffset) {
                            DWStroke *lastStroke=[self.dwStrokes lastObject];
                            [lastStroke addLineP1:gP1 P2:touchPoint];
                            DWStroke *newStroke=[[DWStroke alloc] init];
                            newStroke.path=[UIBezierPath bezierPath];
                            newStroke.isErasing=NO;
                            newStroke.path.lineWidth=drawLineWidth;
                            newStroke.brushColor=BRUSHCOLOR;
                            newStroke.pathType = self.selectedTool;
                            gP1 = gP2 = touchPoint;
                            [self.dwStrokes addObject:newStroke];
                        }
                    }
                        break;
                    case 11:
                        //橡皮
                    {
                        CGFloat offset = sqrtf((touchPoint.x-gP1.x)*(touchPoint.x-gP1.x)+(touchPoint.y-gP1.y)*(touchPoint.y-gP1.y));
                        if (offset > PointMinimumOffset) {
                            gP2 = touchPoint;
                            DWStroke *lastStroke=[self.dwStrokes lastObject];
                            [lastStroke addLineP1:gP1 P2:touchPoint];
                            DWStroke *newStroke=[[DWStroke alloc] init];
                            newStroke.path=[UIBezierPath bezierPath];
                            newStroke.isErasing=YES;
                            newStroke.path.lineWidth=eraserWidth;
                            newStroke.brushColor=[UIColor clearColor];
                            newStroke.pathType = self.selectedTool;
                            gP1 = gP2 = touchPoint;
                            [self.dwStrokes addObject:newStroke];
                        }
                    }
                        break;
                    case 0:
                    case 5:
                    case 6:
                    case 7:
                    case 8:    
                    {
                        DWStroke *tempStroke=[self.dwStrokes lastObject];
                        [tempStroke addDashLineP1:gP1 P2:touchPoint];
                        NSInteger currentPage=[self.delegate getCurrentPageDelegate];
                        CGRect currentRect;
                        currentRect.origin=CGPointMake(currentPage*PaintAreaWidth, 0);
                        currentRect.size=self.frame.size;          
                    }
                        break;
                    case 1:
                    case 2:
                    case 9:
                    case 10:
                    {
                        DWStroke *tempStroke=[self.dwStrokes lastObject];
                        CGRect tempRect=CGRectMake(gP1.x<touchPoint.x?gP1.x:touchPoint.x,gP1.y<touchPoint.y?gP1.y:touchPoint.y,ABS(gP1.x-touchPoint.x),ABS(gP1.y-touchPoint.y) );
                        [tempStroke addDashRect:tempRect];
                    }    
                        break;
                    default:
                        break;
                }
            }          
        }
        if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
            DWStroke *stroke=[self.dwStrokes lastObject];
            gP2=[gestureRecognizer locationInView:self];
            if (self.selectedType==3) {
                switch (self.selectedTool) {
                    case 0:
                        //直线  
                        [stroke addLineP1:gP1 P2:gP2];
                        break;
                    case 1:
                        //圆
                        [stroke addEllipseP1:gP1 P2:gP2];
                        break;
                    case 2:
                        //矩形
                        [stroke addRectangleP1:gP1 P2:gP2];
                        break;
                    case 5:
                        //箭头
                        [stroke addArrowP1:gP1 P2:gP2];
                        break;
                    case 6:
                        //双向箭头
                        [stroke addDoubleArrowP1:gP1 P2:gP2];
                        break;
                    case 7:
                        //虚线
                        [stroke addDashLineP1:gP1 P2:gP2];
                        break;
                    case 8:
                        //护栏
                        [stroke addGuardRailP1:gP1 P2:gP2];
                        break;
                    case 9:
                        //草坪
                        [stroke addGrassP1:gP1 P2:gP2];
                        break;
                        //文字
                    case 10:{
                        [self.dwStrokes removeObject:stroke];
                        CGRect tempRect=CGRectMake(gP1.x<gP2.x?gP1.x:gP2.x,gP1.y<gP2.y?gP1.y:gP2.y,ABS(gP1.x-gP2.x),ABS(gP1.y-gP2.y));
                        [self.delegate addMoveTextInRect:tempRect];
                    }
                        break;
                    case 4:
                    case 11:{
                        DWStroke *lastStroke=[self.dwStrokes lastObject];
                        [lastStroke addLineP1:gP1 P2:gP2];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        NSInteger currentPage=[self.delegate getCurrentPageDelegate];
        CGRect currentRect;
        currentRect.origin=CGPointMake(currentPage*PaintAreaWidth, 0);
        currentRect.size=self.frame.size;
        [self setNeedsDisplayInRect:currentRect];
    } 
}

//考虑更有效率的绘图方法
- (void)drawRect:(CGRect)rect
{
    for (DWStroke *stroke in self.dwStrokes) {
        [stroke draw];
    }
}


@end
