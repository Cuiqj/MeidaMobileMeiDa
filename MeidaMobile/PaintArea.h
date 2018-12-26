//
//  paintArea.h
//  test
//
//  Created by yu hongwu on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWStroke.h"
#import "CasePaintDelegate.h"
#import "PaintHeader.h"

@interface PaintArea : UIView
//绘图操作数组，保存所有的操作内容
@property (nonatomic,retain)    NSMutableArray *dwStrokes;

@property (nonatomic,assign)    NSInteger selectedType;
@property (nonatomic,assign)    NSInteger selectedTool;
@property (nonatomic,weak)      id<CasePaintDelegate> delegate;
@end
