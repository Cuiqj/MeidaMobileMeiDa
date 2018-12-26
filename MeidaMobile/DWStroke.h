//
//  DWStroke.h
//  test
//
//  Created by yu hongwu on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintHeader.h"


@interface DWStroke : NSObject

//自建绘图类，保存绘图设定信息
@property (nonatomic,strong)   UIBezierPath    *path; //绘图路径
@property (nonatomic,assign)   BOOL            isErasing;
@property (nonatomic,strong)   UIColor         *brushColor; //画线颜色，设定为clearColor时为橡皮擦
@property (nonatomic,assign)   BOOL             fillModeON; //是否填充路径内部
@property (nonatomic,assign)   CGPoint p1;
@property (nonatomic,assign)   CGPoint p2;
@property (nonatomic,assign)   NSInteger pathType;

-(void)draw;

-(void)addDotAtP1:(CGPoint)Point1;

-(void)addLineP1:(CGPoint)Point1 
              P2:(CGPoint)Point2;  
-(void)addEllipseP1:(CGPoint)Point1
                 P2:(CGPoint)Point2;
-(void)addRectangleP1:(CGPoint)Point1
                   P2:(CGPoint)Point2;
-(void)addArrowP1:(CGPoint)Point1
               P2:(CGPoint)Point2;
-(void)addDoubleArrowP1:(CGPoint)Point1
                     P2:(CGPoint)Point2;
-(void)addDashLineP1:(CGPoint)Point1
                  P2:(CGPoint)Point2;
-(void)addGrassP1:(CGPoint)Point1
               P2:(CGPoint)Point2;
-(void)addGuardRailP1:(CGPoint)Point1
                   P2:(CGPoint)Point2;
-(void)addDashRect:(CGRect)DashRect;

- (void)addPathWithType:(NSInteger)type
                     P1:(CGPoint)point1
                     P2:(CGPoint)point2;
@end
