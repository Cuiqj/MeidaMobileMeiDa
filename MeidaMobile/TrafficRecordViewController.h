//
//  TrafficRecordViewController.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-9.
//
//

#import <UIKit/UIKit.h>
#import "DateSelectController.h"
//#import "SystemTypeListViewController.h"
#import "ListSelectViewController.h"
#import "RoadInspectViewController.h"
#import "RoadSegmentPickerViewController.h"

@interface TrafficRecordViewController : UIViewController <UITextFieldDelegate, DatetimePickerHandler, ListSelectPopoverDelegate, RoadSegmentPickerDelegate>

//肇事车辆
@property (weak, nonatomic) IBOutlet UITextField *textCar;
//事故来源
@property (weak, nonatomic) IBOutlet UITextField *textInfocom;
//方向
@property (weak, nonatomic) IBOutlet UITextField *textFix;
//发生地点（桩号）
@property (weak, nonatomic) IBOutlet UITextField *textStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStartM;
//发生时间
@property (weak, nonatomic) IBOutlet UITextField *textHappentime;
//事故性质
@property (weak, nonatomic) IBOutlet UITextField *textProperty;
//事故分类
@property (weak, nonatomic) IBOutlet UITextField *textType;
//封道情况
@property (weak, nonatomic) IBOutlet UITextField *textRoadsituation;
//伤亡情况
@property (weak, nonatomic) IBOutlet UITextField *textWdsituation;
//损失金额
@property (weak, nonatomic) IBOutlet UITextField *textLost;
//是否结案
@property (weak, nonatomic) IBOutlet UITextField *textIsend;
//索赔方式
@property (weak, nonatomic) IBOutlet UITextField *textPaytype;
//拯救处理开始时间
@property (weak, nonatomic) IBOutlet UITextField *textZjend;
//拯救处理开始时间
@property (weak, nonatomic) IBOutlet UITextField *textZjstart;
//事故处理开始时间
@property (weak, nonatomic) IBOutlet UITextField *textClstart;
//事故处理结束时间
@property (weak, nonatomic) IBOutlet UITextField *textClend;
//备注
@property (weak, nonatomic) IBOutlet UITextField *textRemark;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//拯救处理开关
@property (weak, nonatomic) IBOutlet UISwitch *switchZJCLDate;
//事故处理开关
@property (weak, nonatomic) IBOutlet UISwitch *switchSGCLDate;

//巡查记录ID
@property (nonatomic, strong) NSString *rel_id;
@property (nonatomic, strong) RoadInspectViewController *roadVC;

- (IBAction)btnSave:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)textTouch:(UITextField *)sender;
@end
