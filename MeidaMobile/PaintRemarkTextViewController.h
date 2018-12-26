//
//  PaintRemarkTextViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-7-10.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintHeader.h"
#import "CaseMap.h"
#import "DateSelectController.h"
#import "InspectionCheckPickerViewController.h"

@interface PaintRemarkTextViewController : UIViewController<UITextViewDelegate,DatetimePickerHandler,InspectionPickerDelegate,UITextFieldDelegate>
- (IBAction)btnBack:(id)sender;
- (IBAction)btnSave:(id)sender;

- (IBAction)selectRoadType:(id)sender;
- (IBAction)selectUserName:(UITextField *)sender;
- (IBAction)selectTime:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UITextField *textRoadType;
@property (weak, nonatomic) IBOutlet UITextField *textDraftMan;
@property (weak, nonatomic) IBOutlet UITextField *textDraftTime;
@property (nonatomic,copy) NSString *caseID;
@end
