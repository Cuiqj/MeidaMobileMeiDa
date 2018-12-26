//
//  CancelParkingNodePrintVC.h
//  ShanMeiMobile
//
//  Created by xiaoxiaojia on 17/8/25.
//
//

#import "CasePrintViewController.h"
#import "ParkingNode.h"
#import "DateSelectController.h"
#import "AccInfoPickerViewController.h"
@interface CancelParkingNodePrintVC : CasePrintViewController<UITextFieldDelegate,UIAlertViewDelegate,DatetimePickerHandler,setCaseTextDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldCitizenName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCaseReason;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHappenDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAutomobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPlacePrefix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStationStart;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCaseShortDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldParkingNodeAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPeriodLimit;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfficeAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSendDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldResume_date;

- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender;
//时间选择
- (IBAction)selectDateAndTime:(id)sender;
- (IBAction)selectParkingCitizenName:(id)sender ;
@end
