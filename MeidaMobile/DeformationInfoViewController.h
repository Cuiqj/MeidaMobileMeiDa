//
//  DeformationInfoViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoadAssetCell.h"
#import "DeformInfoBriefViewController.h"
#import "CaseIDHandler.h"
#import "RoadAssetPrice.h"

@interface DeformationInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CaseIDHandler>
@property (nonatomic,copy) NSString * caseID;
@property (weak, nonatomic) IBOutlet UITableView *roadAssetListView;
@property (weak, nonatomic) IBOutlet UIPickerView *labelPicker;
@property (nonatomic,retain) DeformInfoBriefViewController *deformInfoVC;

@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UITextField *textQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelLength;
@property (weak, nonatomic) IBOutlet UITextField *textLength;
@property (weak, nonatomic) IBOutlet UILabel *labelWidth;
@property (weak, nonatomic) IBOutlet UITextField *textWidth;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDeform;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

//自定义路产视图outlet
@property (weak, nonatomic) IBOutlet UIView *customRoadAssetSubView;
@property (weak, nonatomic) IBOutlet UITextField *customRoadAssetNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *customRoadAssetSpecTextField;
@property (weak, nonatomic) IBOutlet UITextField *customRoadAssetUnitTextField;
@property (weak, nonatomic) IBOutlet UITextField *customRoadAssetUnitPriceTextField;

- (IBAction)textNumberChanged:(id)sender;
- (IBAction)btnAddDeformation:(id)sender;
- (IBAction)btnDismiss:(id)sender;

//- (IBAction)btnSave:(id)sender;
@end
