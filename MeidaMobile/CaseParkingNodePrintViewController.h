//
//  CaseParkingNodePrintViewController.h
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//

#import "CasePrintViewController.h"
#import "ParkingNode.h"
#import "DateSelectController.h"
#import "AccInfoPickerViewController.h"

@interface CaseParkingNodePrintViewController : CasePrintViewController<UITextFieldDelegate,UIAlertViewDelegate,DatetimePickerHandler,setCaseTextDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldCitizenName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldHappenDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAutomobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPlacePrefix;
@property (weak, nonatomic) IBOutlet UITextField *textFieldStationStart;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCaseShortDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldParkingNodeAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPeriodLimit;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOfficeAddress;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSendDate;

- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender;
//时间选择
- (IBAction)selectDateAndTime:(id)sender;
- (IBAction)selectParkingCitizenName:(id)sender ;
@end
