//
//  AddNewInspectRecordViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddNewInspectRecordViewController.h"
#import "Global.h"
#import "RoadInspectViewController.h"

@interface AddNewInspectRecordViewController ()
@property (nonatomic,retain) NSString *roadSegmentID;

- (void)keyboardWillHide:(NSNotification *)aNotification;

- (void)keyboardWillShow:(NSNotification *)aNotification;

@property (nonatomic, assign) BOOL isStartTime;

@end

@implementation AddNewInspectRecordViewController
@synthesize contentView;
@synthesize textCheckType;
@synthesize textCheckReason;
@synthesize textCheckHandle;
@synthesize textCheckStatus;
@synthesize textSide;
//@synthesize textWeather;
@synthesize textDate;
@synthesize textSegement;
//@synthesize textSide;
@synthesize textPlace;
@synthesize textStationStartKM;
@synthesize textStationStartM;
@synthesize viewNormalDesc;
@synthesize textTimeStart;
//@synthesize textTimeEnd;
@synthesize textRoad;
@synthesize textPlaceNormal;
@synthesize textDescNormal;
@synthesize textViewNormalDesc;
@synthesize descState;
@synthesize isStartTime;
//@synthesize textStationEndKM;
//@synthesize textStationEndM;

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.contentView setDelaysContentTouches:NO];
    self.descState = kAddNewRecord;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contentView setContentSize:self.contentView.frame.size];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.descState == kAddNewRecord) {
        [self.contentView setContentSize:CGSizeMake(self.contentView.frame.size.width,self.contentView.frame.size.height+200)];
    }
}


- (void)viewDidUnload
{
    [self setTextCheckType:nil];
    [self setTextCheckReason:nil];
    [self setTextCheckHandle:nil];
    [self setTextCheckStatus:nil];
    [self setPickerPopover:nil];
    [self setCheckTypeID:nil];
    //    [self setTextWeather:nil];
    [self setTextDate:nil];
    [self setTextSegement:nil];
    [self setTextPlace:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    //    [self setTextStationEndKM:nil];
    //    [self setTextStationEndM:nil];
    [self setRoadSegmentID:nil];
    [self setContentView:nil];
    [self setViewNormalDesc:nil];
    [self setTextTimeStart:nil];
//    [self setTextTimeEnd:nil];
    [self setTextRoad:nil];
    [self setTextPlaceNormal:nil];
    [self setTextDescNormal:nil];
    [self setTextViewNormalDesc:nil];
    [self setTextSide:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnSwitch:(UIButton *)sender {
    if (self.descState == kAddNewRecord) {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonSwitch setTitle:@"返回" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"返回" forState:UIControlStateHighlighted];
                             [self.viewNormalDesc setHidden:NO];
                             [self.view bringSubviewToFront:self.viewNormalDesc];
                             [self.contentView setHidden:YES];
                         }
                         completion:nil];
        self.descState = kNormalDesc;
    } else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateNormal];
                             [self.uibuttonSwitch setTitle:@"无异常情况" forState:UIControlStateHighlighted];
                             [self.contentView setHidden:NO];
                             [self.view bringSubviewToFront:self.contentView];
                             [self.viewNormalDesc setHidden:YES];
                         }
                         completion:nil];
        self.isStartTime = YES;
        self.descState = kAddNewRecord;
    }
}

- (IBAction)btnDismiss:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {
    if (self.descState == kAddNewRecord) {
        BOOL isBlank =NO;
//        for (id obj in self.contentView.subviews) {
//            if ([obj isKindOfClass:[UITextField class]]) {
//                if ([[(UITextField *)obj text] isEmpty]) {
//                    
//                    if ([obj tag] < 111 ) {
//                        isBlank=YES;
//                    }
//                }
//            }
//        }
        if ([self.textDate.text isEmpty]) {
            isBlank=YES;
        }
        if (!isBlank) {
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.fix=self.textSide.text;
            inspectionRecord.inspection_type=self.textCheckType.text;
            inspectionRecord.inspection_item=self.textCheckReason.text;
            inspectionRecord.location=self.textPlace.text;
            inspectionRecord.measure=self.textCheckHandle.text;
            inspectionRecord.status=self.textCheckStatus.text;
            inspectionRecord.inspection_id=self.inspectionID;
            inspectionRecord.relationid = @"0";
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            inspectionRecord.start_time=[dateFormatter dateFromString:self.textDate.text];
            
            [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
            NSString *remark=[[NSString alloc] initWithFormat:@"%@ 巡至%@%@K%d+%03dm处时，在公路%@%@，巡逻班组%@。",timeString,self.textSegement.text,self.textSide.text,self.textStationStartKM.text.integerValue,self.textStationStartM.text.integerValue,self.textPlace.text,self.textCheckReason.text,self.textCheckStatus.text];
            self.textCheckHandle.text=[self.textCheckHandle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![self.textCheckHandle.text isEmpty]) {
                remark=[remark stringByAppendingFormat:@"%@。",self.textCheckHandle.text];
            }
            inspectionRecord.station=@(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue);
            inspectionRecord.remark=remark;
            [[AppDelegate App] saveContext];
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            [self dismissModalViewControllerAnimated:YES];
        }
    } else {
        BOOL isBlank =NO;
        for (id obj in self.viewNormalDesc.subviews) {
            if ([obj isKindOfClass:[UITextField class]]) {
                if ([[(UITextField *)obj text] isEmpty]) {
                    isBlank=YES;
                }
            }
        }
        if (!isBlank) {
            if ([self.textViewNormalDesc.text isEmpty]) {
                self.textViewNormalDesc.text = [NSString stringWithFormat:@"%@，巡查%@%@，%@",self.textTimeStart.text,self.textRoad.text,self.textPlaceNormal.text,self.textDescNormal.text];
            }
            InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
            inspectionRecord.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
            inspectionRecord.fix=self.textPlaceNormal.text;
            inspectionRecord.inspection_type=@"日常巡查";
            inspectionRecord.inspection_item= @"无异常";
            inspectionRecord.location=self.textPlaceNormal.text;
            inspectionRecord.measure=@"";
            inspectionRecord.status=@"";
            inspectionRecord.inspection_id=self.inspectionID;
            inspectionRecord.relationid = @"0";
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            inspectionRecord.start_time = [dateFormatter dateFromString:self.textTimeStart.text];
            inspectionRecord.remark=self.textViewNormalDesc.text;
            [[AppDelegate App] saveContext];
            [self.delegate reloadRecordData];
            [self.delegate addObserverToKeyBoard];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

//弹窗
- (void)pickerPresentPickerState:(InspectionCheckState)state fromRect:(CGRect)rect{
    if ((state==self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState=state;
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState=state;
        icPicker.checkTypeID=self.checkTypeID;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState=state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:rect fromView:self.contentView];
        } else {
            rect = [self.view convertRect:rect fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (IBAction)textTouch:(UITextField *)sender {
    switch (sender.tag) {
        case 100:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                [datePicker showdate:self.textDate.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                CGRect rect;
                if (self.descState == kAddNewRecord) {
                    rect = [self.view convertRect:sender.frame fromView:self.contentView];
                } else {
                    rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
                }
                [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            break;
        case 102:
            [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
            break;
        case 103:
            [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
            break;
        case 104:
            [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
            break;
        case 109:
            [self pickerPresentPickerState:kCheckType fromRect:sender.frame];
            break;
        case 110:
            [self pickerPresentPickerState:kCheckReason fromRect:sender.frame];
            break;
        case 111:
            [self pickerPresentPickerState:kCheckStatus fromRect:sender.frame];
            break;
        case 112:
            [self pickerPresentPickerState:kCheckHandle fromRect:sender.frame];
            break;
        default:
            break;
    }
}

- (IBAction)toCaseView:(id)sender {
    //UIViewController *caseView = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseView"];
    [self.delegate addObserverToKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"inspectToCaseView" sender:self];
}

#pragma mark - Delegate Implement

- (void)setCheckType:(NSString *)typeName typeID:(NSString *)typeID{
    self.checkTypeID=typeID;
    self.textCheckType.text=typeName;
}

- (void)setCheckText:(NSString *)checkText{
    switch (self.pickerState) {
        case kCheckStatus:
            self.textCheckStatus.text=checkText;
            break;
        case kCheckHandle:
            self.textCheckHandle.text=checkText;
            break;
        case kCheckReason:
            self.textCheckReason.text=checkText;
            break;
        case kDescription:
            self.textDescNormal.text = checkText;
            break;
        default:
            break;
    }
}

- (void)setDate:(NSString *)date{
    if (self.descState == kAddNewRecord) {
        self.textDate.text=date;
    } else {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *temp=[dateFormatter dateFromString:date];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        NSString *dateString=[dateFormatter stringFromDate:temp];
        if (self.isStartTime) { self.textTimeStart.text = dateString;}
        //else { self.textTimeEnd.text = dateString;}
    }
}

- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    if (self.descState == kAddNewRecord) {
        self.roadSegmentID=aRoadSegmentID;
        self.textSegement.text=roadName;
    } else {
        self.roadSegmentID = aRoadSegmentID;
        self.textRoad.text = roadName;
    }
}

- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName{
    if (self.descState == kAddNewRecord) {
        self.roadSegmentID=aRoadID;
        self.textSegement.text=roadName;
    } else {
        self.roadSegmentID = aRoadID;
        self.textRoad.text = roadName;
    }
}

- (void)setRoadPlace:(NSString *)place{
    if (self.descState == kAddNewRecord) {
        self.textPlace.text=place;
    }
}

- (void)setRoadSide:(NSString *)side{
    if (self.descState == kAddNewRecord) {
        self.textSide.text = side;
    } else {
        self.textPlaceNormal.text = side;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==100 || textField.tag == 1001 || textField.tag == 1002) {
        return NO;
    } else
        return YES;
}

- (IBAction)btnFormNormalDesc:(id)sender {
    self.textViewNormalDesc.text = [NSString stringWithFormat:@"%@，巡查%@%@，%@",self.textTimeStart.text,self.textRoad.text,self.textPlaceNormal.text,self.textDescNormal.text];
}

- (IBAction)viewNormalTextTouch:(UITextField *)sender {
    if (sender.tag == 1001) {
        self.isStartTime = YES;
    }
    if (sender.tag == 1002) {
        self.isStartTime = NO;
    }
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        if (self.isStartTime) {
            [datePicker showdate:self.textTimeStart.text];
        } else {
            //[datePicker showdate:self.textTimeEnd.text];
        }
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect;
        if (self.descState == kAddNewRecord) {
            rect = [self.view convertRect:sender.frame fromView:self.contentView];
        } else {
            rect = [self.view convertRect:sender.frame fromView:self.viewNormalDesc];
        }
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
}

- (IBAction)viewNormalRoadTouch:(id)sender {
    if ([sender tag] == 1003) {
        [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:[(UITextField *)sender frame]];
    }
    if ([sender tag] == 1004) {
        [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:[(UITextField *)sender frame]];
    }
}

- (IBAction)pickerNormalDesc:(id)sender {
    [self pickerPresentPickerState:kDescription fromRect:[(UITextField *)sender frame]];    
}

- (IBAction)addCounstructionChangeBack:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toCounstructionChangeBack" sender:self];
    }];
}

- (IBAction)addTrafficRecord:(id)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissViewControllerAnimated:YES completion:^{
        [((RoadInspectViewController*)self.delegate) performSegueWithIdentifier:@"toTrafficRecord" sender:self];
    }];
}

@end
