//
//  DeformInfoBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseIDHandler.h"
#import "RoadAssetPrice.h"
#import "DeformationCell.h"

@interface DeformInfoBriefViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *deformTableView;
@property (weak, nonatomic) IBOutlet UITableView *citizenPickerView;
@property (nonatomic,copy) NSString * caseID;
@property (nonatomic,weak) id<CaseIDHandler> delegate;
//显示位置标记，在案件主页面显示，整数值为0，在清单编辑页面显示，整数值为1；
@property (nonatomic,assign) NSInteger viewLocal;

-(void)addDeformationForRoadAsset:(RoadAssetPrice *)aRoadAsset andQuantity:(double)quantity withRemark:(NSString *)aRemark;

@end
