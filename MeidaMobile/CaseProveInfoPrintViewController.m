//
//  CaseProveInfoPrintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseProveInfoPrintViewController.h"
#import "RoadSegment.h"
#import "UserInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"

static NSString * const xmlName = @"ProveInfoTable";

@interface CaseProveInfoPrintViewController ()
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
@property (nonatomic, retain) NSString *autoNumber;
@property (nonatomic,strong) UIPopoverController *pickerPopover;
@end

@implementation CaseProveInfoPrintViewController

@synthesize caseID = _caseID;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
//    self.textstart_date_time.delegate = self;
    
    /*
     *modify by lxm 不能实时更新
     *
     if (![self.caseID isEmpty]) {
     self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
     if (self.caseProveInfo.event_desc == nil || [self.caseProveInfo.event_desc isEmpty]) {
     [self generateDefaultInfo:self.caseProveInfo];
     }
     //        self.autoNumber = [Citizen allCitizenNameForCase:self.caseID]
     [self pageLoadInfo];
     }
     */
    if (![self.caseID isEmpty]) {
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self generateDefaultInfo:self.caseProveInfo];
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"ProveInfoTable"];
        for (UITextView * aTextView in [self.view subviews]) {
            if ([aTextView isKindOfClass:[UITextView class]]) {
                [aTextView.text drawInRect:aTextView.frame withFont:aTextView.font];
            }
        }
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

//根据案件记录，完整勘验信息
//FIXME lxm
- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo{
    if (caseProveInfo.end_date_time==nil) {
        caseProveInfo.end_date_time=[NSDate date];
    }
    
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if ([caseProveInfo.prover length] <= 0) {
        if (inspectorArray.count < 1) {
            // modified by cjl
            if (caseProveInfo.prover == nil) {
                caseProveInfo.prover = currentUserName;
            }
        } else {
            NSString *inspectorName = @"";
            for (NSString *name in inspectorArray) {
                if ([inspectorName isEmpty]) {
                    inspectorName = name;
                } else {
                    inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
                }
            }
            caseProveInfo.prover = inspectorName;
        }
    }
    
    if (caseProveInfo.recorder == nil) {
        caseProveInfo.recorder = currentUserName;        
    }

    if ([caseProveInfo.event_desc length] <= 0) {
        caseProveInfo.event_desc = [CaseProveInfo generateEventDescForCase:self.caseID];
    }

    [[AppDelegate App] saveContext];
}

- (IBAction)reFormEvetDesc:(UIButton *)sender {
    [self pageSaveInfo];
    self.textevent_desc.text = [CaseProveInfo generateEventDescForCase:self.caseID];
}



/*add by lxm
 *2013.05.02
 */
- (void)pageLoadInfo
{
    //案号
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    // 当事人
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
    
    self.textMark2.text = caseInfo.case_mark2;
    self.textMark3.text = caseInfo.full_case_mark3;
    
    //案由
    // self.textcase_short_desc.text = self.caseProveInfo.case_short_desc;
    self.textcase_short_desc.text = [NSString stringWithFormat:@"%@%@因交通事故%@", citizen.automobile_number, citizen.automobile_pattern, self.caseProveInfo.case_short_desc];
    
    //勘验时间 没有时默认为当前时间 zhenlintie 2014-03-31
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置时间显示的格式。
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    
    NSDate *sDate = self.caseProveInfo.start_date_time? self.caseProveInfo.start_date_time:[NSDate date];
    NSDate *eDate = self.caseProveInfo.end_date_time?self.caseProveInfo.end_date_time:[NSDate date];

    self.textstart_date_time.text = [dateFormatter stringFromDate:sDate];
    self.textend_date_time.text = [dateFormatter stringFromDate:eDate];
    
    //勘验场所
    self.textprover_place.text = self.caseProveInfo.remark;
    
    //天气情况
    self.textorganizer.text = caseInfo.weater;
    
    //分割字符串
    NSArray *chunks = [self.caseProveInfo.prover componentsSeparatedByString: @","];
    if(chunks && [chunks count]>=2)
    {
        //勘验人1 单位职务
        self.textprover1.text = [chunks objectAtIndex:0];
        self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:0]];
        
        //勘验人2 单位职务
        self.textprover2.text = [chunks objectAtIndex:1];
        self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:[chunks objectAtIndex:1]];
    }
    else
    {
        self.textprover1.text = self.caseProveInfo.prover;
        if (self.caseProveInfo.prover) {
            self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.prover];
        }
        
        self.textprover2.text = self.caseProveInfo.secondProver;
        if ([self.caseProveInfo.secondProver length] > 0) {
            self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.secondProver];
        }
    }
    
    //当事人(车牌号) 单位职务
    self.textcitizen_name.text = self.caseProveInfo.citizen_name;

    self.textcitizen_duty.text = [NSString stringWithFormat:@"%@%@", citizen.org_name?![citizen.org_name isEmpty]?citizen.org_name:@"":@"", citizen.org_principal_duty?![citizen.org_principal_duty isEmpty]?citizen.org_principal_duty:@"":@""];
    
    //当事人代理人 单位职务
    self.textparty.text = [self.caseProveInfo.organizer length] > 0 ? self.caseProveInfo.organizer : @"无";
    self.textparty_org_duty.text = [self.caseProveInfo.organizer_org_duty length] > 0? self.caseProveInfo.organizer_org_duty : @"无";
    
    //被邀请人 单位职务
    self.textinvitee.text = [self.caseProveInfo.invitee length] > 0? self.caseProveInfo.invitee : @"无";
    self.textInvitee_org_duty.text = [self.caseProveInfo.invitee_org_duty length] > 0 ? self.caseProveInfo.invitee_org_duty : @"无";
    
    //记录人 单位职务
    self.textrecorder.text = self.caseProveInfo.recorder;
    self.textrecorder_duty.text = [UserInfo orgAndDutyForUserName:self.caseProveInfo.recorder];
    
    //勘验情况及结果
    self.textevent_desc.text = self.caseProveInfo.event_desc;
}

- (BOOL)pageSaveInfo
{
    //案由
    self.caseProveInfo.case_long_desc = self.textcase_short_desc.text;
    
    //勘验时间FIXME by lxm
    // zhenlintie 2014-03-31
    /**/
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     NSString *format = @"yyyy年MM月dd日HH时mm分";
     [dateFormatter setDateFormat:format];
     self.caseProveInfo.start_date_time = [dateFormatter dateFromString:self.textstart_date_time.text];
     self.caseProveInfo.end_date_time = [dateFormatter dateFromString:self.textend_date_time.text];
    
    //self.caseProveInfo.case_mark2 = self.textMark2.text;
    //self.caseProveInfo.case_mark3 = self.textMark3.text;
    
    //勘验场所
    self.caseProveInfo.remark = self.textprover_place.text;
    
    //勘验人1 单位职务
    if([self.textprover2.text length]==0)
    {
        self.caseProveInfo.prover = self.textprover1.text;
    }
    else if(([self.textprover2.text length]==0)&&(([self.textprover1.text length]==0)))
    {
        self.caseProveInfo.prover=@"";
    }
    else if(([self.textprover2.text length]!=0)&&(([self.textprover1.text length]!=0)))
    {
        self.caseProveInfo.prover=[NSString stringWithFormat:@"%@,%@",self.textprover1.text,self.textprover2.text];
    }
    else if([self.textprover1.text length]==0)
    {
        self.caseProveInfo.prover=self.textprover2.text;
    }
    
    // modified by cjl
//    self.caseProveInfo.prover = self.textprover1.text;
    self.caseProveInfo.secondProver = self.textprover2.text;
    
    //当事人 单位职务
    self.caseProveInfo.citizen_name = self.textcitizen_name.text;
    
    //当事人代理人 单位职务
    self.caseProveInfo.organizer  =   self.textparty.text ;
    self.caseProveInfo.organizer_org_duty  =   self.textparty_org_duty.text;
    
    //被邀请人 单位职务
    self.caseProveInfo.invitee   =   self.textinvitee.text;
    self.caseProveInfo.invitee_org_duty = self.textInvitee_org_duty.text;
    
    //记录人 单位职务
    self.caseProveInfo.recorder = self.textrecorder.text;
    
    //勘验情况及结果
    self.caseProveInfo.event_desc = self.textevent_desc.text;
    
    // 更新
    //CaseInfo* caseInfo = [CaseInfo caseInfoForID:self.caseID];
    //caseInfo.happen_date = self.caseProveInfo.start_date_time;
    
    Citizen *citizen = [Citizen citizenForCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
    citizen.party = self.caseProveInfo.citizen_name;
    
    [[AppDelegate App] saveContext];
    return TRUE;
}

//-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
//    [self pageSaveInfo];
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:xmlName];
//        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
//        UIGraphicsEndPDFContext();
//        
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
//}
//
//-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
//    [self pageSaveInfo];
//    if (![filePath isEmpty]) {
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
//        UIGraphicsEndPDFContext();
//        
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
//}

#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
   if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.textFieldTag = self.textstart_date_time.tag;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showPastDate:self.caseProveInfo.start_date_time];
   }else if ([segueIdentifier isEqualToString:@"toDateTimePicker2"]) {
       DateSelectController *dsVC=segue.destinationViewController;
       dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
       dsVC.delegate=self;
       dsVC.pickerType=1;
       dsVC.textFieldTag = self.textend_date_time.tag;
       dsVC.datePicker.maximumDate=[NSDate date];
       [dsVC showPastDate:self.caseProveInfo.end_date_time];
   }
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender
{
    UITextField* textField = (UITextField* )sender;
    switch (textField.tag) {
        case 100:
            [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
            break;
        case 101:
            [self performSegueWithIdentifier:@"toDateTimePicker2" sender:self];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 100:
        case 101:
        case 200:
        case 201:
        case 202:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

- (void)setPastDate:(NSDate *)date withTag:(int)tag
{
    if (tag == self.textstart_date_time.tag) {
        self.caseProveInfo.start_date_time = date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textstart_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    }else if (tag == self.textend_date_time.tag) {
        self.caseProveInfo.end_date_time = date;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    }
}

- (IBAction)userSelect:(UITextField *)sender {
    self.textFieldTag = sender.tag;
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 200)];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    if (self.textFieldTag == 200) {
        self.textprover1.text = name;
        self.textprover1_duty.text = [UserInfo orgAndDutyForUserName:name];
    }else if (self.textFieldTag == 201){
        self.textprover2.text = name;
        self.textprover2_duty.text = [UserInfo orgAndDutyForUserName:name];
    }else if (self.textFieldTag == 202){
        self.textrecorder.text = name;
        self.textrecorder_duty.text = [UserInfo orgAndDutyForUserName:name];
    }
}

- (NSString *)templateNameKey
{
    return DocNameKeyPei_AnJianKanYanJianChaBiLu;
}

- (id)dataForPDFTemplate
{
    id caseData = @{};
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        caseData = @{
                     @"mark2": caseInfo.case_mark2,
                     @"mark3": [NSString stringWithFormat:@"%@",caseInfo.full_case_mark3],
                     @"weather": caseInfo.weater,
                     };
    }
    id caseProveData = @{};
    if (self.caseProveInfo) {
//        NSString *sDateString = NSStringFromNSDateAndFormatter(self.caseProveInfo.start_date_time, NSDateFormatStringCustom1);
//        NSString *eDateString = NSStringFromNSDateAndFormatter(self.caseProveInfo.end_date_time, NSDateFormatStringCustom1);
        id sDateData = DateDataFromDateString(self.textstart_date_time.text);
        if (sDateData == nil) {
            sDateData = @{};
        }
        id eDateData = DateDataFromDateString(self.textend_date_time.text);
        if (eDateData == nil) {
            eDateData = @{};
        }
        
        id inspector1Data = @{};
        id inspector2Data = @{};
        NSArray *inspectors = [self.caseProveInfo.prover componentsSeparatedByString: @","];
        for (int i = 0; i < inspectors.count; i++) {
            NSString *name = inspectors[i];
            name = (!name||[name isEmpty] ? @"": name);
            NSString *org_duty = [UserInfo orgAndDutyForUserName:name];
            org_duty = (!org_duty||[org_duty isEmpty] ? @"": org_duty);
            if (i == 0) {
                inspector1Data = @{
                                   @"name": [name defaultEmpty],
                                   @"org_duty": [org_duty defaultEmpty]
                                   };
            } else if (i == 1) {
                inspector2Data = @{
                                   @"name": [name defaultEmpty],
                                   @"org_duty": [org_duty defaultEmpty]
                                   };
            }
        }
        if (!self.caseProveInfo.secondProver || [self.caseProveInfo.secondProver isEmpty]) {
            inspector2Data = @{
                               @"name": @"无",
                               @"org_duty": @"无"
                               };
        }
        
        id partyData = [@{} mutableCopy];
        if (self.caseProveInfo.citizen_name != nil) {
            [partyData setObject:[self.caseProveInfo.citizen_name defaultEmpty] forKey:@"name"];
        }
        Citizen *citizen = [Citizen citizenForCitizenName:self.caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        if (citizen) {
            NSString *citizen_org_duty = [[NSString stringWithFormat:@"%@%@", citizen.org_name?![citizen.org_name isEmpty]?citizen.org_name:@"":@"", citizen.org_principal_duty?![citizen.org_principal_duty isEmpty]?citizen.org_principal_duty:@"":@""] defaultEmpty];
            [partyData setObject:citizen_org_duty forKey:@"org_duty"];
        }
        
        
        id attorneyData = [@{} mutableCopy];
        if (self.caseProveInfo.organizer != nil) {
            if ([self.caseProveInfo.organizer isEqualToString:@"无"]) {
                [attorneyData setObject:@"无" forKey:@"name"];
            }else
            {
                [attorneyData setObject:self.caseProveInfo.organizer forKey:@"name"];
            }
        }
        if (self.caseProveInfo.organizer_org_duty != nil) {
            
            if ([self.caseProveInfo.organizer_org_duty isEqualToString:@"无"]) {
                [attorneyData setObject:@"无" forKey:@"org_duty"];
            }else
            {
                [attorneyData setObject:self.caseProveInfo.organizer_org_duty forKey:@"org_duty"];
            }
        
        }
        
        id inviteeData = [@{} mutableCopy];
        if (self.caseProveInfo.invitee != nil) {
            if ([self.caseProveInfo.invitee isEqualToString:@"无"]) {
                [inviteeData setObject:@"无" forKey:@"name"];
            }else
            {
                [inviteeData setObject:self.caseProveInfo.invitee forKey:@"name"];
            }
        }
        if (self.caseProveInfo.invitee_org_duty != nil) {
            if ([self.caseProveInfo.invitee_org_duty isEqualToString:@"无"]) {
                [inviteeData setObject:@"无" forKey:@"org_duty"];
            }else
            {
                [inviteeData setObject:self.caseProveInfo.invitee_org_duty forKey:@"org_duty"];
            }
        }
        
        id recorderData = [@{} mutableCopy];
        if (self.caseProveInfo.recorder != nil) {
            [recorderData setObject:self.caseProveInfo.recorder forKey:@"name"];
        }
        if (self.caseProveInfo.recorder_org_duty != nil) {
            [recorderData setObject:self.caseProveInfo.recorder_org_duty forKey:@"org_duty"];
        }
        
        id inspect_resultData = @"";
        if (self.caseProveInfo.event_desc != nil) {
            inspect_resultData = [NSString stringWithFormat:@"\b\b%@",self.caseProveInfo.event_desc];
        }
        
        caseProveData = @{
                          //@"description": self.caseProveInfo.case_short_desc,
                          @"description":self.textcase_short_desc.text,
                          @"sDate": sDateData,
                          @"eDate": eDateData,
                          @"inpect_place": self.caseProveInfo.remark,
                          @"inspector1": inspector1Data,
                          @"inspector2": inspector2Data,
                          @"party": partyData,
                          @"attorney": attorneyData,
                          @"invitee": inviteeData,
                          @"recorder": recorderData,
                          @"inspect_result": inspect_resultData,
                          };
    }
    
    id data = @{
                @"case": caseData,
                @"caseProve": caseProveData,
                };
    return data;
    
}

@end
