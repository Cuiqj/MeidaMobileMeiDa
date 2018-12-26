//
//  AddNewInspectRecordViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionCheckPickerViewController.h"
#import "DateSelectController.h"
#import "InspectionRecord.h"
#import "InspectionHandler.h"
#import "RoadSegmentPickerViewController.h"

typedef enum {
    kAddNewRecord = 0,
    kNormalDesc
}DescState;

@interface AddNewInspectRecordViewController : UIViewController<InspectionPickerDelegate,DatetimePickerHandler,UITextFieldDelegate,RoadSegmentPickerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *contentView;
@property (nonatomic,copy) NSString *inspectionID;
@property (nonatomic,assign) RoadSegmentPickerState roadSegmentPickerState;
@property (nonatomic,assign) InspectionCheckState pickerState;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,retain) NSString *checkTypeID;
@property (weak, nonatomic) IBOutlet UITextField *textCheckType;
@property (weak, nonatomic) IBOutlet UITextField *textCheckReason;
@property (weak, nonatomic) IBOutlet UITextField *textCheckHandle;
@property (weak, nonatomic) IBOutlet UITextField *textCheckStatus;
@property (weak, nonatomic) IBOutlet UITextField *textSide;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonSwitch;

@property (weak, nonatomic) IBOutlet UITextField *textDate;
@property (weak, nonatomic) IBOutlet UITextField *textSegement;

@property (weak, nonatomic) IBOutlet UITextField *textPlace;
@property (weak, nonatomic) IBOutlet UITextField *textStationStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationStartM;

@property (weak, nonatomic) IBOutlet UIView *viewNormalDesc;
@property (weak, nonatomic) IBOutlet UITextField *textTimeStart;
//@property (weak, nonatomic) IBOutlet UITextField *textTimeEnd;
@property (weak, nonatomic) IBOutlet UITextField *textRoad;
@property (weak, nonatomic) IBOutlet UITextField *textPlaceNormal;
@property (weak, nonatomic) IBOutlet UITextField *textDescNormal;
@property (weak, nonatomic) IBOutlet UITextView *textViewNormalDesc;
- (IBAction)btnFormNormalDesc:(id)sender;
- (IBAction)viewNormalTextTouch:(UITextField *)sender;
- (IBAction)viewNormalRoadTouch:(id)sender;
- (IBAction)pickerNormalDesc:(id)sender;
- (IBAction)addCounstructionChangeBack:(id)sender;
- (IBAction)addTrafficRecord:(id)sender;

@property (weak, nonatomic) id<InspectionHandler> delegate;
@property (assign, nonatomic) DescState descState;
- (IBAction)btnSwitch:(UIButton *)sender;

- (IBAction)btnDismiss:(id)sender;
- (IBAction)btnSave:(id)sender;
//点击文本框，弹出选择窗口
- (IBAction)textTouch:(UITextField *)sender;
- (IBAction)toCaseView:(id)sender;


@end

/*
#import <UIKit/UIKit.h>
#import "InspectionCheckPickerViewController.h"
#import "DateSelectController.h"
#import "InspectionRecord.h"
#import "InspectionHandler.h"
#import "RoadSegmentPickerViewController.h"

@interface AddNewInspectRecordViewController : UIViewController<InspectionPickerDelegate,DatetimePickerHandler,UITextFieldDelegate,RoadSegmentPickerDelegate>
@property (nonatomic,copy) NSString *inspectionID;
@property (nonatomic,assign) RoadSegmentPickerState roadSegmentPickerState;
@property (nonatomic,assign) InspectionCheckState pickerState;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,retain) NSString *checkTypeID;
@property (weak, nonatomic) IBOutlet UITextField *textCheckType;
@property (weak, nonatomic) IBOutlet UITextField *textCheckReason;
@property (weak, nonatomic) IBOutlet UITextField *textCheckHandle;
@property (weak, nonatomic) IBOutlet UITextField *textCheckStatus;
@property (weak, nonatomic) IBOutlet UITextField *textWeather;
@property (weak, nonatomic) IBOutlet UITextField *textDate;
@property (weak, nonatomic) IBOutlet UITextField *textSegement;
@property (weak, nonatomic) IBOutlet UITextField *textSide;
@property (weak, nonatomic) IBOutlet UITextField *textPlace;
@property (weak, nonatomic) IBOutlet UITextField *textStationStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationStartM;
@property (weak, nonatomic) IBOutlet UITextField *textStationEndKM;
@property (weak, nonatomic) IBOutlet UITextField *textStationEndM;

@property (weak, nonatomic) id<InspectionHandler> delegate;

- (IBAction)btnDismiss:(id)sender;
- (IBAction)btnSave:(id)sender;
//点击文本框，弹出选择窗口
- (IBAction)textTouch:(UITextField *)sender;


@end
*/
