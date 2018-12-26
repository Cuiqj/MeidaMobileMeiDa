//
//  CancelParkingNodePrintVC.m
//  ShanMeiMobile
//
//  Created by xiaoxiaojia on 17/8/25.
//
//

#import "CancelParkingNodePrintVC.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "ParkingNode.h"
#import "CaseProveInfo.h"
#import "Systype.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "AccInfoPickerViewController.h"
#import "CasePrintController.h"

#import "DateSelectController.h"
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


@interface CancelParkingNodePrintVC ()
@property (nonatomic,strong)ParkingNode * parkingNode;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@end

@implementation CancelParkingNodePrintVC
@synthesize pickerPopover=_pickerPopover;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self assignTagsToUIControl];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)pageLoadInfo
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    Citizen * citizen = [Citizen citizenForName:self.parkingNode.citizen_name nexus:@"当事人" case:self.caseID];
    if (caseInfo) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSString *dateString = [dateFormatter stringFromDate:caseInfo.happen_date];
        [self.textFieldHappenDate setText:dateString];
        [self.textFieldSendDate setText:dateString];
        self.textFieldResume_date.text=[dateFormatter stringFromDate: self.parkingNode.resume_date];
        RoadSegment *roadSegment = [RoadSegment roadSegmentFromSegmentID:caseInfo.roadsegment_id];
        if (roadSegment) {
            [self.textFieldPlacePrefix  setText:roadSegment.place_prefix1];
        }
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            self.textFieldCaseReason.text=caseProveInfo.case_short_desc;
        }
        self.textFieldPlacePrefix.text=self.parkingNode.address;
        self.textFieldCitizenName.text=citizen.party;
        self.textFieldAutomobileNumber.text=self.parkingNode.citizen_name;
    }
}

- (IBAction)textFieldAutomobileNumber_touched:(UITextField *)sender {
    
    ListSelectViewController *listSelectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPoPover"];
    listSelectViewController.delegate = self;
    NSArray * parkings = [ParkingNode parkingNodesForCase:self.caseID];
    listSelectViewController.data = [parkings valueForKeyPath:@"@unionOfObjects.citizen_name"];
    
    if ([self.popover isPopoverVisible] && (self.popoverIndex != sender.tag)) {
        [self.popover dismissPopoverAnimated:YES];
        return;
    }
    
    if (self.popover == nil) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:listSelectViewController];
    } else {
        if([self.popover isPopoverVisible])
            [self.popover setContentViewController:listSelectViewController];
        else{
            self.popover=nil;
            [self.popover setContentViewController:listSelectViewController];
        }
    }
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
- (BOOL)shouldGenereateDefaultDoc {
    return NO;
}

#pragma mark - CasePrintProtocol

- (NSString *)templateNameKey
{
    
    return DocNameKeyPei_JieChu_ZeLingCheLiangTingShiTongZhiShu;
}

- (id)dataForPDFTemplate
{
    id data = @{};
    NSString *citizenName = @"";
    id resume_date = @{};
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
        NSString *dateString = self.textFieldResume_date.text;
        NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"年月日"]];
        if (dateComponents.count > 2) {
            resume_date = @{
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
        
        
        
         }
       data =@{
             @"citizenName": citizenName,
             @"caseReason": self.textFieldCaseReason.text,
             @"resume_date": resume_date,
             @"sendDate": sendDate,
             @"automobileNumber": automobileNumber,
             @"placePrefix": self.textFieldPlacePrefix.text,
//             @"stationStart": stationStart,
//             @"caseDescription": caseDescription,
             @"parkingAddress": parkingAddress,
             @"periodLimit": periodLimit,
             @"officeAddress": officeAddress
             };
    return data;
    }
}

#pragma mark - ListSelectPopoverDelegate
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
- (BOOL)pageSaveInfo
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.parkingNode.resume_date=[dateFormatter dateFromString:self.textFieldResume_date.text];
         [[AppDelegate App] saveContext];
    return TRUE;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == kTextFieldTagAutoMobileNumber) {
        [self loadParkingInfoWithAutomobileNumber:textField.text];
    }
}
- (IBAction)selectDateAndTime:(id)sender {
    [self performSegueWithIdentifier:@"toParkingDateTimePicker" sender:self];
}
//显示所选时间
- (void)setDate:(NSString *)date{
    self.textFieldResume_date.text=date;
    [self.pickerPopover dismissPopoverAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
