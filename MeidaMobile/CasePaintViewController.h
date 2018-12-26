//
//  CasePaintViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintHeader.h"
#import "MoveableImage.h"
#import "PaintArea.h"
#import "IconModels.h"
#import "IconItems.h"
#import "IconTexts.h"
#import "RoadModelBoard.h"
#import "TBXML.h"
#import "TouchedScrollView.h"
#import "CasePaintDelegate.h"
#import "PaintRemarkTextViewController.h"
#import "TextInputViewController.h"

#import "DDXML.h"
#import "NSString+DDXML.h"
#import "DDXMLNode+CDATA.h"

@protocol ReloadPaintDelegate;

@interface CasePaintViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CasePaintDelegate,TextInputDelegate>
@property (nonatomic,copy)    NSString *caseID;
@property (nonatomic,weak)    IBOutlet UITableView *IconType;//模版，路产等大类选择列表
@property (nonatomic,weak)    IBOutlet UITableView *IconModelName;//类别下工具选择列表

@property (weak, nonatomic)     IBOutlet TouchedScrollView *contentScrollView;
@property (weak, nonatomic)     IBOutlet UISegmentedControl *segWidth;
@property (weak, nonatomic)     IBOutlet UIPageControl *pageIndicator;

@property (nonatomic,retain)    RoadModelBoard *roadModelBoard;//车道模版视图

@property (nonatomic,retain)    PaintArea *paintBoard;//手绘区域视图

@property (nonatomic,weak) id <ReloadPaintDelegate> delegate;

//@property (nonatomic,retain)    BackgroundView *backGroundView;//绘图长度标尺背景视图

//@property (nonatomic,retain)    NSMutableArray *moveableImageArray;//保存路产等图标信息

- (IBAction)btnBack:(id)sender;
- (IBAction)chooseWidth:(id)sender;
- (IBAction)btnSave:(UIBarButtonItem *)sender;


@end

@protocol ReloadPaintDelegate <NSObject>

- (void)reloadPaint;

@end
