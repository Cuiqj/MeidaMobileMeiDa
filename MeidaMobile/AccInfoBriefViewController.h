//
//  AccInfoBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseInfo.h"

#import "CaseIDHandler.h"
#import "CaseProveInfo.h"
#import "AccInfoPickerViewController.h"
#import "ParkingNode.h"
#import "DateSelectController.h"

@interface AccInfoBriefViewController : UIViewController<UITextFieldDelegate,setCaseTextDelegate,DatetimePickerHandler>

@property (nonatomic,copy) NSString * caseID;

@property (nonatomic, weak) IBOutlet UITextField *textbadcar;
@property (nonatomic, weak) IBOutlet UITextField *textbadwound;
@property (nonatomic, weak) IBOutlet UITextField *textdeath;
@property (nonatomic, weak) IBOutlet UITextField *textreason;
@property (nonatomic, weak) IBOutlet UITextField *textfleshwound;
@property (weak, nonatomic) IBOutlet UITextField *textCaseStyle;
@property (weak, nonatomic) IBOutlet UITextField *textCaseType;
@property (weak, nonatomic) IBOutlet UILabel *labelParkingCarName;
@property (weak, nonatomic) IBOutlet UITextField *textParkingCarName;
@property (weak, nonatomic) IBOutlet UILabel *labelParkingLocation;
@property (weak, nonatomic) IBOutlet UITextField *textParkingLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UISwitch *swithIsParking;

@property (nonatomic,weak) id<CaseIDHandler> delegate;

- (IBAction)selectParkingCitizenName:(id)sender;
- (IBAction)selectCaseStyle:(id)sender;
- (IBAction)selectCaseReason:(id)sender;
- (IBAction)selectCaseType:(id)sender;
- (IBAction)selectTime:(id)sender;
- (IBAction)selectParkingLocation:(id)sender;
- (IBAction)textChanged:(id)sender;
- (IBAction)parkingChanged:(UISwitch *)sender;
- (void)saveDataForCase:(NSString *)caseID;
- (void)loadDataForCase:(NSString *)caseID;
- (void)newDataForCase:(NSString *)caseID;
@end
