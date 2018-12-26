//
//  PaintHeader.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-29.
//
//


//共同定义背景颜色和画图颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define BGCOLOR RGBA(215,219,224,1.0)
#define BRUSHCOLOR [UIColor blackColor]

#define eraserWidth 40.0
#define drawLineWidth 2.0
#define dotRadius 3.0
#define PaintAreaWidth 720.0
#define PaintAreaHeight 580.0
#define ModelHeight 540.0
#define RoadModelOffSet (PaintAreaHeight-ModelHeight)