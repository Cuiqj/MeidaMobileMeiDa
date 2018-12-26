//
//  DynamicInfoViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoadClosePickerViewController.h"
#import "DateSelectController.h"
#import "RoadSegmentPickerViewController.h"
#import "WebServiceHandler.h"
#import "UserPickerViewController.h"

@interface DynamicInfoViewController : UIViewController<UserPickerDelegate,WebServiceReturnString,DatetimePickerHandler,RoadPickerDelegate,RoadSegmentPickerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic) RoadClosePickerState pickerState;
@property (assign,nonatomic) RoadSegmentPickerState roadSegmentPickerState;
@property (weak, nonatomic) IBOutlet UIButton *uiBtnSave;
@property (weak, nonatomic) IBOutlet UIButton *uiBtnPromulgate;
@property (weak, nonatomic) IBOutlet UITableView *tableCloseList;
@property (weak, nonatomic) IBOutlet UITextField *textTitle;
@property (weak, nonatomic) IBOutlet UITextField *textSegmentID;
@property (weak, nonatomic) IBOutlet UITextField *textSide;
@property (weak, nonatomic) IBOutlet UITextField *textStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStartM;
@property (weak, nonatomic) IBOutlet UITextField *textEndKM;
@property (weak, nonatomic) IBOutlet UITextField *textEndM;
@property (weak, nonatomic) IBOutlet UITextField *textTimeStart;
@property (weak, nonatomic) IBOutlet UITextField *textTimeEnd;
@property (weak, nonatomic) IBOutlet UITextField *textCreator;
@property (weak, nonatomic) IBOutlet UITextField *textCompany;
@property (weak, nonatomic) IBOutlet UITextField *textDuty;
@property (weak, nonatomic) IBOutlet UITextField *textTele;
@property (weak, nonatomic) IBOutlet UITextField *textClosedWay;
@property (weak, nonatomic) IBOutlet UITextField *textType;
@property (weak, nonatomic) IBOutlet UITextField *textImportance;
@property (weak, nonatomic) IBOutlet UISwitch *swithPromulgate;
@property (weak, nonatomic) IBOutlet UITextView *textViewCloseReason;
@property (weak, nonatomic) IBOutlet UITextView *textViewCloseResult;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollContent;

- (IBAction)btnAddNew:(UIButton *)sender;
- (IBAction)btnSave:(UIButton *)sender;
- (IBAction)btnPromulgate:(UIButton *)sender;
- (IBAction)textTouch:(UITextField *)sender;
- (IBAction)btnFormReason:(UIButton *)sender;


@end
