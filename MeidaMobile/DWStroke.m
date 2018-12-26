//
//  DWStroke.m
//  test
//
//  Created by yu hongwu on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DWStroke.h"

@implementation DWStroke

@synthesize brushColor=_brushColor;
@synthesize fillModeON=_fillModeON;
@synthesize path=_path;
@synthesize isErasing=_isErasing;


- (void)dealloc {
	[self setPath:nil];
    [self setBrushColor:nil];
}

-(void)draw{
    if (self.fillModeON) {
        [self.brushColor setFill];
        [self.path fillWithBlendMode:kCGBlendModeNormal alpha:1.0];
    } else {
        [self.brushColor setStroke];
        if (self.isErasing) {
            [self.path strokeWithBlendMode:kCGBlendModeDestinationIn alpha:1.0];
        } else {
            [self.path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        }
    }
}


//绘图方法

//画点
-(void)addDotAtP1:(CGPoint)Point1{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointZero;
    self.fillModeON=YES;
    [self.path moveToPoint:Point1];
    [self.path addArcWithCenter:Point1 radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
}

//直线
-(void)addLineP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x, Point2.y-RoadModelOffSet);
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    [self.path removeAllPoints];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:Point2];
}

//圆
-(void)addEllipseP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x - Point1.x, Point2.y - Point1.y);
    CGFloat lineWidth=self.path.lineWidth;
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    [self.path removeAllPoints];
    [self setPath:nil];    
    CGRect ellipseRect=CGRectMake(Point1.x<Point2.x?Point1.x:Point2.x,Point1.y<Point2.y?Point1.y:Point2.y,ABS(Point1.x-Point2.x),ABS(Point1.y-Point2.y)); 
    self.path=[UIBezierPath bezierPathWithOvalInRect:ellipseRect];
    self.path.lineWidth=lineWidth;
}

//矩形
-(void)addRectangleP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x - Point1.x, Point2.y - Point1.y);

    CGFloat lineWidth=self.path.lineWidth;
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    CGRect rectangle=CGRectMake(Point1.x<Point2.x?Point1.x:Point2.x,Point1.y<Point2.y?Point1.y:Point2.y,ABS(Point1.x-Point2.x),ABS(Point1.y-Point2.y) );
    [self.path removeAllPoints];
    [self setPath:nil];
    self.path=[UIBezierPath bezierPathWithRect:rectangle];
    self.path.lineWidth=lineWidth;
}

//箭头
-(void)addArrowP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x, Point2.y-RoadModelOffSet);
    const float arrowAngle=M_PI/6;
    const int   arrowLen=8;
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    [self.path removeAllPoints];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:Point2];
    float lineAngle=atanf(ABS(Point2.y-Point1.y)/ABS(Point2.x-Point1.x));
    float arrowLine=arrowLen/cosf(arrowAngle);
    CGPoint p3,p4;
    if (Point1.x<Point2.x){
        p3.x=Point2.x-arrowLine*sinf(M_PI/2-lineAngle-arrowAngle);
        p4.x=Point2.x-arrowLine*cosf(lineAngle-arrowAngle);
    } else {
        p3.x=Point2.x+arrowLine*sinf(M_PI/2-lineAngle-arrowAngle);
        p4.x=Point2.x+arrowLine*cosf(lineAngle-arrowAngle);
    }
    if (Point1.y<Point2.y) {
        p3.y=Point2.y-arrowLine*cosf(M_PI/2-lineAngle-arrowAngle);
        p4.y=Point2.y-arrowLine*sinf(lineAngle-arrowAngle);
    } else {
        p3.y=Point2.y+arrowLine*cosf(M_PI/2-lineAngle-arrowAngle);
        p4.y=Point2.y+arrowLine*sinf(lineAngle-arrowAngle);
    }
    [self.path moveToPoint:Point2];
    [self.path addLineToPoint:p3];
    [self.path moveToPoint:Point2];
    [self.path addLineToPoint:p4];
}

//双向箭头
-(void)addDoubleArrowP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x, Point2.y-RoadModelOffSet);
    const float arrowAngle=M_PI/6;
    const int   arrowLen=8;
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    [self.path removeAllPoints];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:Point2];
    float lineAngle=atanf(ABS(Point2.y-Point1.y)/ABS(Point2.x-Point1.x));
    float arrowLine=arrowLen/cosf(arrowAngle);
    CGPoint p3,p4,p5,p6;
    if (Point1.x<Point2.x){
        p3.x=Point2.x-arrowLine*sinf(M_PI/2-lineAngle-arrowAngle);
        p4.x=Point2.x-arrowLine*cosf(lineAngle-arrowAngle);
        p5.x=Point1.x+arrowLine*sinf(M_PI/2-lineAngle-arrowAngle);
        p6.x=Point1.x+arrowLine*cosf(lineAngle-arrowAngle);
    } else {
        p3.x=Point2.x+arrowLine*sinf(M_PI/2-lineAngle-arrowAngle);
        p4.x=Point2.x+arrowLine*cosf(lineAngle-arrowAngle);
        p5.x=Point1.x-arrowLine*sinf(M_PI/2-lineAngle-arrowAngle);
        p6.x=Point1.x-arrowLine*cosf(lineAngle-arrowAngle);
    }
    if (Point1.y<Point2.y) {
        p3.y=Point2.y-arrowLine*cosf(M_PI/2-lineAngle-arrowAngle);
        p4.y=Point2.y-arrowLine*sinf(lineAngle-arrowAngle);
        p5.y=Point1.y+arrowLine*cosf(M_PI/2-lineAngle-arrowAngle);
        p6.y=Point1.y+arrowLine*sinf(lineAngle-arrowAngle);
    } else {
        p3.y=Point2.y+arrowLine*cosf(M_PI/2-lineAngle-arrowAngle);
        p4.y=Point2.y+arrowLine*sinf(lineAngle-arrowAngle);
        p5.y=Point1.y-arrowLine*cosf(M_PI/2-lineAngle-arrowAngle);
        p6.y=Point1.y-arrowLine*sinf(lineAngle-arrowAngle);
    }
    [self.path moveToPoint:Point2];
    [self.path addLineToPoint:p3];
    [self.path moveToPoint:Point2];
    [self.path addLineToPoint:p4];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:p5];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:p6];
}

//虚线
-(void)addDashLineP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x, Point2.y-RoadModelOffSet);
    CGFloat lineWidth=self.path.lineWidth;
    CGFloat dashPattern[2]={6.0,6.0};
    [self.path setLineDash:dashPattern count:2 phase:0];
    [self.path removeAllPoints];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:Point2];
    self.path.lineWidth=lineWidth;
}

//虚线矩形框
-(void)addDashRect:(CGRect)DashRect{
    CGFloat lineWidth=self.path.lineWidth;
    [self.path removeAllPoints];
    [self setPath:nil];
    self.path=[UIBezierPath bezierPathWithRect:DashRect];
    CGFloat dashPattern[2]={6.0,6.0};
    [self.path setLineDash:dashPattern count:2 phase:0];
    self.path.lineWidth=lineWidth;
}

//草坪
-(void)addGrassP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x - Point1.x, Point2.y - Point1.y);

    const int   grassHeight =55;
    const int   grassWidth  =55;
    const int   grassLineLen=12;
    const float grassAngle  =M_PI/4;
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    [self.path removeAllPoints];    
    int numRow =(int)ABS(Point1.x-Point2.x)/grassWidth;
    int numLine=(int)ABS(Point1.y-Point2.y)/grassHeight;
    for (int line=0; line<=numLine; line++) {
        for (int row=0; row<=numRow; row++) {
            CGPoint pOoC,p0,p1,p2,p3;
            pOoC.x=Point1.x<Point2.x?Point1.x:Point2.x;
            pOoC.y=Point1.y<Point2.y?Point1.y:Point2.y;
            for (int count=0; count<=1; count++) {
                if (count % 2 == 0) {
                    p0.x=pOoC.x+grassWidth/2*0.618+grassWidth*row;
                    p0.y=pOoC.y+grassHeight/2*0.618+grassHeight*line;
                } else {
                    p0.x=pOoC.x+grassWidth/2*1.618+grassWidth*row;
                    p0.y=pOoC.y+grassHeight/2*1.618+grassHeight*line;
                }
                if ((p0.x<(pOoC.x+ABS(Point1.x-Point2.x))) && (p0.y<(pOoC.y+ABS(Point1.y-Point2.y)))) {
                    [self.path moveToPoint:p0];
                    p1.x=p0.x;
                    p1.y=p0.y-grassLineLen;
                    [self.path addLineToPoint:p1];
                    [self.path moveToPoint:p0];
                    p2.x=p0.x-grassLineLen*sinf(grassAngle);
                    p2.y=p0.y-grassLineLen*cosf(grassAngle);
                    [self.path addLineToPoint:p2];
                    [self.path moveToPoint:p0];
                    p3.x=p0.x+grassLineLen*sinf(grassAngle);
                    p3.y=p2.y;
                    [self.path addLineToPoint:p3];
                }
            }
        }
    }
}

//护栏
-(void)addGuardRailP1:(CGPoint)Point1 P2:(CGPoint)Point2{
    self.p1 = CGPointMake(Point1.x, Point1.y-RoadModelOffSet);
    self.p2 = CGPointMake(Point2.x, Point2.y-RoadModelOffSet);
    const int railSpace=30;
    const int railHeight=25;
    CGPoint p3,p4;
    CGFloat dashNormal[0]={};
    [self.path setLineDash:dashNormal count:0 phase:0];
    [self.path removeAllPoints];
    [self.path moveToPoint:Point1];
    [self.path addLineToPoint:Point2];
    float lineAngle=atanf(ABS(Point2.y-Point1.y)/ABS(Point2.x-Point1.x));
    int num=(int)floorf((sqrtf((Point1.x-Point2.x)*(Point1.x-Point2.x)+(Point1.y-Point2.y)*(Point1.y-Point2.y))/railSpace));
    if (Point1.x<Point2.x) {        
        for (int i=1; i<=num; i++) {
            p3.x=Point1.x+railSpace*i*cosf(lineAngle);
            if (Point1.y<Point2.y) {
                p4.x=p3.x+railHeight*sinf(lineAngle);
                p3.y=Point1.y+railSpace*i*sinf(lineAngle);                
                p4.y=p3.y-railHeight*cosf(lineAngle);
            } else {
                p4.x=p3.x-railHeight*sinf(lineAngle);
                p3.y=Point1.y-railSpace*i*sinf(lineAngle);
                p4.y=p3.y-railHeight*cosf(lineAngle);
            }
            [self.path moveToPoint:p3];
            [self.path addLineToPoint:p4];
        }
    } else {
        for (int i=1; i<=num; i++) {
            p3.x=Point2.x+railSpace*i*cosf(lineAngle);
            if (Point1.y<Point2.y) {
                p4.x=p3.x+railHeight*sinf(lineAngle);
                p3.y=Point2.y-railSpace*i*sinf(lineAngle);
                p4.y=p3.y+railHeight*cosf(lineAngle);
            } else {
                p4.x=p3.x-railHeight*sinf(lineAngle);
                p3.y=Point2.y+railSpace*i*sinf(lineAngle);
                p4.y=p3.y+railHeight*cosf(lineAngle);
            }
            [self.path moveToPoint:p3];
            [self.path addLineToPoint:p4];
        }
    }
}

- (void)addPathWithType:(NSInteger)type P1:(CGPoint)point1 P2:(CGPoint)point2{
    if (self.path == nil) {
        self.path = [UIBezierPath bezierPath];
    }
    self.isErasing=NO;
    self.path.lineWidth=drawLineWidth;
    self.brushColor=BRUSHCOLOR;
    self.pathType = type;
    switch (type) {
        case 0:
            //直线
            [self addLineP1:point1 P2:point2];
            break;
        case 1:{
            //圆
            point2.x = (point1.x + point2.x);
            point2.y = (point1.y + point2.y);
            [self addEllipseP1:point1 P2:point2];
        }
            break;
        case 2:{
            //矩形
            point2.x = (point1.x + point2.x);
            point2.y = (point1.y + point2.y);
            [self addRectangleP1:point1 P2:point2];
        }
            break;
        case 3:
            //点
            [self addDotAtP1:point1];
            break;
        case 4:
            //曲线
            [self addLineP1:point1 P2:point2];
            break;
        case 5:
            //箭头
            [self addArrowP1:point1 P2:point2];
            break;
        case 6:
            //双向箭头
            [self addDoubleArrowP1:point1 P2:point2];
            break;
        case 7:
            //虚线
            [self addDashLineP1:point1 P2:point2];
            break;
        case 8:
            //护栏
            [self addGuardRailP1:point1 P2:point2];
            break;
        case 9:{
            //草坪
            point2.x = (point1.x + point2.x);
            point2.y = (point1.y + point2.y);
            [self addGrassP1:point1 P2:point2];
        }
            break;
        case 11:{
            //橡皮
            self.isErasing = YES;
            self.brushColor = [UIColor clearColor];
            self.path.lineWidth = eraserWidth;
            [self addLineP1:point1 P2:point2];
        }
            break;
        default:
            break;
    }
}

@end
