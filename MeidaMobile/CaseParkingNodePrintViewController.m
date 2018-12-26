//
//  CaseParkingNodePrintViewController.m
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-9-3.
//
//

#import "CaseParkingNodePrintViewController.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "ParkingNode.h"
#import "CaseProveInfo.h"
#import "Systype.h"
#import "OrgInfo.h"


NSString *const defautUnitAddress = @"广东省公路管理局梅大高速公路路政大队";

typedef enum _kTextFieldTag {
    kTextFieldTagCitizenName = 0x10,
    kTextFieldTagHappenDate,
    kTextFieldTagAutoMobileNumber,
    kTextFieldTagPlacePrefix,
    kTextFieldTagStationStart,
    kTextFieldTagCaseShortDescription,
    kTextFieldTagParkingNodeAddress,
    kTextFieldTagPeriodLimit,
    kTextFieldTagOfficeAddress,
    kTextFieldTagSendDate
} kTextFieldTag;

@interface CaseParkingNodePrintViewController () <UITextFieldDelegate>

@property (nonatomic,strong)ParkingNode * parkingNode;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@end

@implementation CaseParkingNodePrintViewController
@synthesize pickerPopover=_pickerPopover;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self assignTagsToUIControl];
    [self.textFieldCitizenName setDelegate:self];
    [self.textFieldParkingNodeAddress setDelegate:self];
    [self.textFieldSendDate setDelegate:self];
    if (self.caseID) {
        NSArray *array = [ParkingNode parkingNodesForCase:self.caseID];
        if (array && [array count] > 0){
            self.parkingNode = [array objectAtIndex:0];
        }
        [self pageLoadInfo];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextFieldCitizenName:nil];
    [self setTextFieldHappenDate:nil];
    [self setTextFieldAutomobileNumber:nil];
    [self setTextFieldPlacePrefix:nil];
    [self setTextFieldStationStart:nil];
    [self setTextFieldCaseShortDescription:nil];
    [self setTextFieldParkingNodeAddress:nil];
    [self setTextFieldPeriodLimit:nil];
    [self setTextFieldOfficeAddress:nil];
    [self setTextFieldSendDate:nil];
    [super viewDidUnload];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag ==888){
        return NO;
    }
    if (textField.tag == 16 || textField.tag == 22 ) {
        if (!textField.text || [textField.text isEqualToString:@""]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"请先选择驾驶牌号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)assignTagsToUIControl
{
    self.textFieldCitizenName.tag = kTextFieldTagCitizenName;
    self.textFieldHappenDate.tag = kTextFieldTagHappenDate;
    self.textFieldAutomobileNumber.tag = kTextFieldTagAutoMobileNumber;
    self.textFieldPlacePrefix.tag = kTextFieldTagPlacePrefix;
    self.textFieldStationStart.tag = kTextFieldTagStationStart;
    self.textFieldCaseShortDescription.tag = kTextFieldTagCaseShortDescription;
    self.textFieldParkingNodeAddress.tag = kTextFieldTagParkingNodeAddress;
    self.textFieldPeriodLimit.tag = kTextFieldTagPeriodLimit;
    self.textFieldOfficeAddress.tag = kTextFieldTagOfficeAddress;
    self.textFieldHappenDate.tag = kTextFieldTagHappenDate;
}

- (void)loadParkingInfoWithAutomobileNumber:(NSString *)automobileNumber
{
    
    [self.textFieldCitizenName setText:@""];
    [self.textFieldParkingNodeAddress setText:@""];
    [self.textFieldSendDate setText:@""];
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        Citizen * citizen = [Citizen citizenForName:automobileNumber nexus:@"当事人" case:self.caseID];
        if (citizen) {
            [self.textFieldCitizenName setText:citizen.party];
        }
        
        NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
        if (parkings.count > 0) {
            for (ParkingNode *parking in parkings) {
                if ([parking.citizen_name isEqualToString:automobileNumber]) {
                    if (parking.officeAddress){
                        [self.textFieldOfficeAddress setText:parking.officeAddress];
                    }
                    [self.textFieldParkingNodeAddress setText:parking.address];
                    NSDate *sendDate = parking.date_send;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                    [dateFormatter setLocale:[NSLocale currentLocale]];
                    NSString *dateString = [dateFormatter stringFromDate:sendDate];
                    [self.textFieldSendDate setText:dateString];
                }
            }
        }
        
    }
}

#pragma mark - Methods from superclass

- (void)pageLoadInfo
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
        [self.textFieldHappenDate setText:dateString];
        [self.textFieldSendDate setText:dateString];
        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
        if (roadSegment) {
            [self.textFieldPlacePrefix  setText:roadSegment.place_prefix1];
        }
        
        [self.textFieldStationStart setText:[[caseInfo fullCaseMarkAfterK:NO] stringByAppendingFormat:@"m%@",caseInfo.side]];
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
           if(self.parkingNode.stop_reason ==nil)
            [self.textFieldCaseShortDescription setText:[@"交通事故" stringByAppendingFormat:@"%@",caseProveInfo.case_short_desc]];
           else
               self.textFieldCaseShortDescription.text=self.parkingNode.stop_reason;
        }
        
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            [self.textFieldPeriodLimit setText:typeValue];
        } else {
            [self.textFieldPeriodLimit setText:@"七"];
        }
        
        
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo) {
            [self.textFieldOfficeAddress setText:orgInfo.orgshortname];
        }
    }
}
//时间选择
- (IBAction)selectDateAndTime:(id)sender {
    [self performSegueWithIdentifier:@"toParkingDateTimePicker" sender:self];
}
//显示所选时间
- (void)setDate:(NSString *)date{
    self.textFieldSendDate.text=date;
}
#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toParkingDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=3;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showdate:self.textFieldSendDate.text];
    }
}
- (BOOL)pageSaveInfo
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    
    //名字
    
    //日期
    
    //车牌号
    NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
    if (parkings.count > 0) {
        
        for (ParkingNode *parking in parkings) {
            if ([parking.citizen_name isEqualToString:self.textFieldAutomobileNumber.text]) {
                parking.address=self.textFieldParkingNodeAddress.text;
                parking.officeAddress = self.textFieldOfficeAddress.text;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                parking.date_send =[dateFormatter dateFromString:self.textFieldSendDate.text];
                
                parking.stop_reason=self.textFieldCaseShortDescription.text;
                
            }
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有车辆需要做责令停驶通知书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return FALSE;
    }
   /*
    //公路名称
    RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
    roadSegment.place_prefix1=self.textFieldPlacePrefix.text;
    
   
    
    //违法事件
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    if (caseProveInfo) {
        caseProveInfo.case_short_desc = self.textFieldCaseShortDescription.text;
    }
    //停放地址

    //处理单位
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    orgInfo.orgshortname = self.textFieldOfficeAddress.text;
    */
    [[AppDelegate App] saveContext];
    return TRUE;
}
- (BOOL)shouldGenereateDefaultDoc {
    return NO;
}

#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
    
    return DocNameKeyPei_ZeLingCheLiangTingShiTongZhiShu;
}

- (id)dataForPDFTemplate
{
    
    NSString *citizenName = @"";
    id happenDate = @{};
    id sendDate = @{};
    NSString *automobileNumber = @"";
    NSString *placePrefix = @"";
    NSString *stationStart = @"";
    NSString *caseDescription = @"";
    NSString *parkingAddress = @"";
    NSString *periodLimit = @"";
    NSString *officeAddress = @"";
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        Citizen * citizen = [Citizen citizenForName:self.textFieldAutomobileNumber.text nexus:@"当事人" case:self.caseID];
        if (citizen) {
            citizenName = citizen.party == nil? @"" : citizen.party;
            automobileNumber = citizen.automobile_number;
        }
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
//        NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
        NSString *dateString = self.textFieldHappenDate.text;
        NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日"]];
        if (dateComponents.count > 2) {
            happenDate = @{
                           @"year": dateComponents[0],
                           @"month": dateComponents[1],
                           @"day": dateComponents[2],
                           };
        }
        
        
        dateString = self.textFieldSendDate.text;
        dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日"]];
        if (dateComponents.count > 2) {
            sendDate = @{
                           @"year": dateComponents[0],
                           @"month": dateComponents[1],
                           @"day": dateComponents[2],
                           };
        }
        
        
        
        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
        if (roadSegment) {
            placePrefix = roadSegment.place_prefix1;
        }
        
        stationStart = self.textFieldStationStart.text;
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            caseDescription = caseProveInfo.case_short_desc;
        }
        
        OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
        if (orgInfo) {
            officeAddress = orgInfo.orgshortname;
        }
        
        
        NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
        if (parkings.count > 0) {
            for (ParkingNode *parking in parkings) {
                if ([parking.citizen_name isEqualToString:self.textFieldAutomobileNumber.text]) {
                    parkingAddress = parking.address;
                    if (parking.officeAddress){
                        officeAddress = parking.officeAddress;
                    }

                }
            }
        }
        
        NSArray *typeValues = [Systype typeValueForCodeName:@"停驶期限"];
        if (typeValues.count > 0) {
            NSString *typeValue = typeValues[0];
            periodLimit = typeValue;
        } else {
            periodLimit = @"七";
        }
        

        
    }
    // caseDescription = [@"交通事故" stringByAppendingFormat:@"%@",caseDescription];
    caseDescription=self.textFieldCaseShortDescription.text;
    return @{
             @"citizenName": citizenName,
             @"happenDate": happenDate,
             @"sendDate": sendDate,
             @"automobileNumber": automobileNumber,
             @"placePrefix": placePrefix,
             @"stationStart": stationStart,
             @"caseDescription": caseDescription,
             @"parkingAddress": parkingAddress,
             @"periodLimit": periodLimit,
             @"officeAddress": officeAddress,
             };
}

#pragma mark - ListSelectPopoverDelegate

- (void)setSelectData:(NSString *)data {
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if (self.popoverIndex == textField.tag) {
                [textField setText:data];
                [textField resignFirstResponder];
            }
        }
    }
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == kTextFieldTagAutoMobileNumber) {
        [self loadParkingInfoWithAutomobileNumber:textField.text];
    }
}


#pragma mark - IBAction

- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender {
    
    ListSelectViewController *listSelectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPoPover"];
    listSelectViewController.delegate = self;
    NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
    listSelectViewController.data = [parkings valueForKeyPath:@"@unionOfObjects.citizen_name"];
    
    if ([self.popover isPopoverVisible] && (self.popoverIndex != sender.tag)) {
        [self.popover dismissPopoverAnimated:YES];
        return;
    }
//    else{
//        self.popover=nil;
//    }
    
    if (self.popover == nil) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:listSelectViewController];
   } else {
        [self.popover setContentViewController:listSelectViewController];
   }
  /*
    if(self.popover){
        if([self.popover isPopoverVisible]&& (self.popoverIndex != sender.tag)){
            [self.popover setContentViewController:listSelectViewController animated:YES];
        }
        else
            self.popover=nil;
    }else {
        self.popover= [[UIPopoverController alloc ]initWithContentViewController:listSelectViewController];
     
    }
   */
    listSelectViewController.pickerPopover=self.popover;
    self.popoverIndex = sender.tag;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.popover setPopoverContentSize:CGSizeMake(CGRectGetWidth(listSelectViewController.view.bounds), 100) animated:YES];
    
}
//弹窗
-(void)pickerPresentForIndex:(CGRect)rect{
    if ([_pickerPopover isPopoverVisible]) {
        [_pickerPopover dismissPopoverAnimated:YES];
    } else {
        
        AccInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"AccInfoPicker"];
        acPicker.pickerType = 6;
        acPicker.delegate = self;
        acPicker.caseID=self.caseID;
        _pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [_pickerPopover setPopoverContentSize:CGSizeMake(450, 150)];
        [_pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        acPicker.pickerPopover=_pickerPopover;
    }
}

- (IBAction)selectParkingCitizenName:(id)sender {
    [self pickerPresentForIndex:[(UITextField*)sender frame]];
}
-(void)setCaseText:(NSString *)aText{
    self.textFieldOfficeAddress.text = aText;
}
@end
