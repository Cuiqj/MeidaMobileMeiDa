//
//  MoveableImage.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintHeader.h"
#import "CasePaintDelegate.h"

@interface MoveableImage : UIImageView<UIGestureRecognizerDelegate>
@property (nonatomic,weak) id<CasePaintDelegate> delegate;
//记录图像ID及录入的文字
@property (nonatomic,retain) NSString *iconModelID;
//记录旋转角度
@property (nonatomic,assign) CGFloat rotation;
//保存是否为文字
@property (nonatomic,assign) BOOL isText;
//文字大小
@property (nonatomic,assign) CGFloat fontSize;
//图像大小
@property (nonatomic,assign) CGSize imageSize;
@end
