//
//  RoadInspectViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoadInspectViewController.h"
#import "InspectionPath.h"
#import "Global.h"
#import "CaseConstructionChangeBackViewController.h"
#import "TrafficRecordViewController.h"
#import "CaseViewController.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "RoadSegment.h"
#import "CaseDeformation.h"

@interface RoadInspectViewController ()
@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic,retain) UIPopoverController *pickerPopover;


//判断当前显示的巡查是否是正在进行的巡查
@property (nonatomic,assign) BOOL isCurrentInspection;
- (void)loadInspectionInfo;
- (void)saveRemark;
@end

@implementation RoadInspectViewController
@synthesize pathView = _pathView;
@synthesize labelInspectionInfo = _labelInspectionInfo;
@synthesize textViewRemark = _textViewRemark;
@synthesize tableRecordList = _tableRecordList;
@synthesize labelRemark = _labelRemark;
@synthesize inspectionSeg = _inspectionSeg;
@synthesize textCheckTime = _textCheckTime;
@synthesize textStationName = _textStationName;
@synthesize inspectionID = _inspectionID;
@synthesize isCurrentInspection = _isCurrentInspection;
@synthesize state = _state;
@synthesize pickerPopover = _pickerPopover;
@synthesize textCheckStatus = _textCheckStatus;

InspectionCheckState inspectionState;

- (void)viewDidLoad
{
    self.state = kRecord;
    UIFont *segFont = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.inspectionSeg setTitleTextAttributes:attributes
                                      forState:UIControlStateNormal];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    self.isCurrentInspection = YES;
    BOOL isJiangzhong = [[[AppDelegate App].projectDictionary objectForKey:@"projectname"] isEqualToString:@"zhongjiang"];
    if (([self.inspectionID isEmpty] || self.inspectionID==nil) && !isJiangzhong) {
        [self performSegueWithIdentifier:@"toNewInspection" sender:nil];
    } else {
        [self loadInspectionInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [self setTextViewRemark:nil];
    [self setTableRecordList:nil];
    [self setLabelRemark:nil];
    [self setLabelInspectionInfo:nil];
    [self setPathView:nil];
    [self setUiButtonAddNew:nil];
    [self setUiButtonSave:nil];
    [self setUiButtonDeliver:nil];
    [self setPickerPopover:nil];
    [self setInspectionSeg:nil];
    [self setTextCheckTime:nil];
    [self setTextStationName:nil];
    [self setTextCheckStatus:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *segueIdentifer=[segue identifier];
    if ([segueIdentifer isEqualToString:@"toAddNewInspectionRecord"]) {
        AddNewInspectRecordViewController *newRCVC=segue.destinationViewController;
        newRCVC.inspectionID=self.inspectionID;
        newRCVC.delegate=self;
    } else if ([segueIdentifer isEqualToString:@"toNewInspection"]) {
        NewInspectionViewController *niVC=[segue destinationViewController];
        niVC.delegate=self;
    } else if ([segueIdentifer isEqualToString:@"toInspectionOut"]) {
        InspectionOutViewController *ioVC=[segue destinationViewController];
        ioVC.delegate=self;
    } else if ([segueIdentifer isEqualToString:@"toCounstructionChangeBack"]){
        CaseConstructionChangeBackViewController *caseVC=segue.destinationViewController;
        [caseVC setRel_id:self.inspectionID];
    } else if ([segueIdentifer isEqualToString:@"toTrafficRecord"]){
        TrafficRecordViewController *trVC = segue.destinationViewController;
        [trVC setRel_id:self.inspectionID];
        [trVC setRoadVC:self];
    } else if ([segueIdentifer isEqualToString:@"inspectToCaseView"]){
        CaseViewController *caseVC = segue.destinationViewController;
        [caseVC setInspectionID:self.inspectionID];
        [caseVC setRoadInspectVC:self];
    }
}


#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer=@"InspectionRecordCell";
    InspectionRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (self.state == kRecord) {
        InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
        cell.labelRemark.text=record.remark;
        NSInteger stationStartM=record.station.integerValue%1000;
        NSString *stationStartKMString=[NSString stringWithFormat:@"%d", record.station.integerValue/1000];
        NSString *stationString=[NSString stringWithFormat:@"K%@+%03d处",stationStartKMString,stationStartM];
        cell.labelStation.hidden = NO;
        cell.labelStation.text=stationString;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        cell.labelTime.text=[dateFormatter stringFromDate:record.start_time];
    } else {
        InspectionPath *path = [self.data objectAtIndex:indexPath.row];
        cell.labelRemark.text = path.stationname;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        cell.labelTime.text = [dateFormatter stringFromDate:path.checktime];
        cell.labelStation.text = @"";
        cell.labelStation.hidden = YES;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj=[self.data objectAtIndex:indexPath.row];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    [context deleteObject:obj];
    [self.data removeObjectAtIndex:indexPath.row];
    [[AppDelegate App] saveContext];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
    
    //add by lxm
    //清除巡查描述内容
    self.textViewRemark.text=@"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.state == kRecord) {
        InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
        self.textViewRemark.text=record.remark;
    } else {
        InspectionPath *path = [self.data objectAtIndex:indexPath.row];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textCheckTime.text = [dateFormatter stringFromDate:path.checktime];
        
        NSString *tmp = [path.stationname substringToIndex:2];
        NSString *stationName = path.stationname;
        if ([tmp isEqualToString:@"经过"] || [tmp isEqualToString:@"回到"]) {
            self.textCheckStatus.text = tmp;
            stationName = [path.stationname substringFromIndex:[tmp length]];
        }
        NSRange found = [stationName rangeOfString:@"沿途状况正常"];
        if (found.location != NSNotFound) {
            stationName = [stationName substringToIndex:found.location];
        }
        self.textStationName.text = stationName;
    }
}

#pragma mark - InspectionHandler

- (void)reloadRecordData{
    if (self.state == kRecord) {
        self.data=[[InspectionRecord recordsForInspection:self.inspectionID] mutableCopy];
        [self.pathView setHidden:YES];
        [self.view sendSubviewToBack:self.pathView];
    } else {
        self.data=[[InspectionPath pathsForInspection:self.inspectionID] mutableCopy];
        [self.pathView setHidden:NO];
        [self.view bringSubviewToFront:self.pathView];
    }
    [self.tableRecordList reloadData];
}

- (void)setInspectionDelegate:(NSString *)aInspectionID{
    self.inspectionID=aInspectionID;
    [self loadInspectionInfo];
}

- (void)popBackToMainView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addObserverToKeyBoard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - own methods
//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (self.state == kRecord) {
        CGRect newFrame = self.textViewRemark.frame;
        newFrame.origin.y=454;
        newFrame.size.height = 230;
        //    CGFloat offset=self.textViewRemark.frame.origin.y-newFrame.origin.y;
        self.textViewRemark.frame = newFrame;
    }
    [self saveRemark];
    [UIView commitAnimations];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (self.state == kRecord) {
        CGRect newFrame = self.textViewRemark.frame;
        newFrame.origin.y=86;
        //newFrame.size.height = self.view.frame.size.height - (self.view.frame.origin.y + newFrame.origin.y) - keyboardEndFrame.size.width-5;
        //    CGFloat offset=self.textViewRemark.frame.origin.y-newFrame.origin.y;
        self.textViewRemark.frame = newFrame;
    }
    [UIView commitAnimations];
}


- (IBAction)btnSaveRemark:(UIButton *)sender {
    if (self.state == kRecord) {
        [self saveRemark];
    } else {
        if (![self.textCheckTime.text isEmpty] && ![self.textStationName.text isEmpty] && ![self.textCheckStatus.text isEmpty]) {
            
            NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
            InspectionPath *newPath;
            if (index==nil) {
                newPath = [InspectionPath newDataObjectWithEntityName:@"InspectionPath"];
                [self.data addObject:newPath];
            } else {
                newPath = [self.data objectAtIndex:index.row];
            }
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            newPath.checktime = [dateFormatter dateFromString:self.textCheckTime.text];
            newPath.stationname = self.textStationName.text;
            newPath.inspectionid = self.inspectionID;
            [[AppDelegate App] saveContext];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否生成巡查记录?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];

        }
        [self reloadRecordData];
    }
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //过站记录生成巡查记录
        InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
        inspectionRecord.relationid = @"0";
        inspectionRecord.inspection_id=self.inspectionID;
        inspectionRecord.roadsegment_id = @"0";
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        inspectionRecord.start_time=[dateFormatter dateFromString:self.textCheckTime.text];
        [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
        
        NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
        
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Systype" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@ && type_value == %@",@"过站状况", self.textCheckStatus.text]];
        NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
        NSString *strFormat = @"%@ %@";
        if (result && [result count]>0) {
            NSString *remark = [[result objectAtIndex:0] remark];
            if (![remark isEmpty]) {
                strFormat = [NSString stringWithFormat:@"%@ %@", @"%@", [remark stringByReplacingOccurrencesOfString:@"[站]" withString:@"%@"]];
            }
        }
        NSString *remark=[NSString stringWithFormat:strFormat, timeString, self.textStationName.text];
        inspectionRecord.remark=remark;
        [[AppDelegate App] saveContext];
        [self reloadRecordData];
    }else{
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}

- (void)saveRemark{
    if (![self.textViewRemark.text isEmpty]) {
        NSIndexPath *indexPath=[self.tableRecordList indexPathForSelectedRow];
        if (indexPath!=nil) {
            InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
            record.remark=self.textViewRemark.text;
            [[AppDelegate App] saveContext];
            [self.tableRecordList beginUpdates];
            [self.tableRecordList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableRecordList endUpdates];
            [self.tableRecordList selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

        }
    }
}

- (IBAction)btnInpectionList:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionListViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionList"];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(270, 352)];
        [self.pickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        acPicker.popover=self.pickerPopover;
    }
}
- (IBAction)btnAddNew:(id)sender {
    if (self.state == kRecord) {
        [self performSegueWithIdentifier:@"toAddNewInspectionRecord" sender:nil];
    } else {
        for (UITextField *textField in self.pathView.subviews) {
            if ([textField isKindOfClass:[UITextField class]]) {
                textField.text = @"";
            }
        }
        NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
        if (index) {
            [self.tableRecordList deselectRowAtIndexPath:index animated:YES];
        }
    }
}

- (IBAction)btnDeliver:(UIButton *)sender {
    if (self.isCurrentInspection) {
        [self performSegueWithIdentifier:@"toInspectionOut" sender:nil];
    } else {
        self.isCurrentInspection = YES;
        [UIView transitionWithView:self.view
                          duration:0.3
                           options:UIViewAnimationCurveLinear
                        animations:^{
                            CGRect rect = self.uiButtonDeliver.frame;
                            rect.size.width = 72;
                            [self.uiButtonDeliver setFrame:rect];
                            [sender setTitle:@"交班" forState:UIControlStateNormal];
                            [self.uiButtonAddNew setAlpha:1.0];
                            [self.uiButtonSave setAlpha:1.0];
                        }
                        completion:^(BOOL finish){
                            [self.uiButtonSave setEnabled:YES];
                            [self.uiButtonAddNew setEnabled:YES];
                        }];
        self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
        [self loadInspectionInfo];
    }
}

- (IBAction)segSwitch:(id)sender {
    //add by 李晓明 2013.05.09
    //选择switch的时候，取消焦点
    [self.textViewRemark resignFirstResponder];
    if (self.inspectionSeg.selectedSegmentIndex == 0) {
        self.state = kRecord;
    } else {
        self.state = kPath;
    }
    [self reloadRecordData];
}

- (IBAction)selectionStation:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState=kStation;
        inspectionState = kStation;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.pathView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (IBAction)selectTime:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        [datePicker showdate:self.textCheckTime.text];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect = [self.view convertRect:[sender frame] fromView:self.pathView];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
}

- (IBAction)selectCheckStatus:(id)sender{
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState=kStationCheckStatus;
        inspectionState = kStationCheckStatus;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.pathView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)loadInspectionInfo{
    NSArray *temp=[Inspection inspectionForID:self.inspectionID];
    if (temp.count>0) {
        Inspection *inspection=[temp objectAtIndex:0];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        self.labelInspectionInfo.text=[[NSString alloc] initWithFormat:@"%@   %@   巡查车辆:%@   巡查人:%@   记录人:%@",[formatter stringFromDate:inspection.date_inspection],inspection.weather,inspection.carcode,inspection.inspectionor_name,inspection.recorder_name];
    }
    for (UITextField *textField in self.pathView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text = @"";
        }
    }
    NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
    if (index) {
        [self.tableRecordList deselectRowAtIndexPath:index animated:YES];
    }
    self.textViewRemark.text = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self reloadRecordData];
}

- (void)setCurrentInspection:(NSString *)inspectionID{
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationCurveLinear
                    animations:^{
                        CGRect rect = self.uiButtonDeliver.frame;
                        rect.size.width = 126;
                        [self.uiButtonDeliver setFrame:rect];
                        [self.uiButtonDeliver setTitle:@"返回当前巡查" forState:UIControlStateNormal];
                        [self.uiButtonAddNew setAlpha:0.0];
                        [self.uiButtonSave setAlpha:0.0];
                    }
                    completion:^(BOOL finish){
                        [self.uiButtonSave setEnabled:NO];
                        [self.uiButtonAddNew setEnabled:NO];
                    }];
    self.isCurrentInspection = NO;
    self.inspectionID = inspectionID;
    [self loadInspectionInfo];
}

- (void)setCheckText:(NSString *)checkText{
    if (self.state == kPath) {
        if (inspectionState == kStationCheckStatus) {
            self.textCheckStatus.text = checkText;
        }else{
            self.textStationName.text = checkText;
        }
    }
}

- (void)setDate:(NSString *)date{
    self.textCheckTime.text = date;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void) createRecodeByCaseID:(NSString *)caseID{
    if ([caseID isEmpty]) {
        return;
    }
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
    //CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:caseID];
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id= caseInfo.roadsegment_id;
    inspectionRecord.location= caseInfo.place;
    inspectionRecord.station = caseInfo.station_start;
    inspectionRecord.inspection_id = self.inspectionID;
    inspectionRecord.relationid = @"0";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    inspectionRecord.start_time = caseInfo.happen_date;
    
    [dateFormatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
    NSString *timeString=[dateFormatter stringFromDate:inspectionRecord.start_time];
    NSMutableString *remark=[[NSMutableString alloc] initWithFormat:@"%@ 巡至%@往%@方向K%@+%@m处时，发现%@驾驶%@%@在%@发生交通事故，",timeString, [RoadSegment roadNameFromSegment:caseInfo.roadsegment_id], caseInfo.side, [caseInfo station_start_km], [caseInfo station_start_m], citizen.party, citizen.automobile_number, citizen.automobile_pattern, caseInfo.place];
    if ([caseInfo.fleshwound_sum intValue]==0 && [caseInfo.badwound_sum intValue]==0 && [caseInfo.death_sum intValue]==0) {
        [remark appendString:@"无人员伤亡，"];
    }else{
        [remark appendFormat:@"轻伤%@人，重伤%@人，死亡%@人，", caseInfo.fleshwound_sum, caseInfo.badwound_sum, caseInfo.death_sum];
    }
    NSArray *deformArray=[CaseDeformation deformationsForCase:caseID forCitizen:citizen.automobile_number];
    if (deformArray.count>0) {
        NSString *deformsString=@"";
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
        [remark appendFormat:@"损坏路产如下：%@。",deformsString];
    } else {
        [remark appendString:@"无路产损坏。"];
    }
    [remark appendFormat:@"已立案处理（案号：%@高赔（%@）第（%@）号）。", [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.case_mark2, [caseInfo full_case_mark3]];
    inspectionRecord.remark=remark;
    
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
}

- (void) createRecodeByTrafficRecord:(TrafficRecord *)trafficRecord{
    InspectionRecord *inspectionRecord=[InspectionRecord newDataObjectWithEntityName:@"InspectionRecord"];
    inspectionRecord.roadsegment_id = @"0";
    inspectionRecord.fix = trafficRecord.fix;
    inspectionRecord.inspection_id = self.inspectionID;
    inspectionRecord.relationid = @"0";
    inspectionRecord.start_time = trafficRecord.happentime;
    inspectionRecord.station = trafficRecord.station;
    NSString* stationString = [NSString stringWithFormat:@"K%d+%dm", trafficRecord.station.integerValue/1000, trafficRecord.station.integerValue%1000];
    NSString *remark = @"";
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *timeStr = [dateFormatter stringFromDate:inspectionRecord.start_time];
    if ([trafficRecord.infocome isEqualToString:@"交警"]) {
//        remark = [NSString stringWithFormat:@"%@接交警报%@K%@路段有交通事故，路政人员立即前往。", timeStr, inspectionRecord.fix, trafficRecord.station];
        remark = [NSString stringWithFormat:@"%@ 接交警报方向%@发现交通事故", timeStr, stationString];
    }else if ([trafficRecord.infocome isEqualToString:@"监控"]) {
        remark = [NSString stringWithFormat:@"%@ 接监控中心报方向%@发现交通事故，", timeStr, stationString];
    }else if ([trafficRecord.infocome isEqualToString:@"路政"]) {
//        remark = [NSString stringWithFormat:@"%@巡查至%@K%@路段发现有交通事故。", timeStr, inspectionRecord.fix, trafficRecord.station];
        remark = [NSString stringWithFormat:@"%@ 巡查至方向%@发现交通事故，", timeStr, stationString];
    }
    
    if (trafficRecord.car) {
        remark = [remark stringByAppendingFormat:@"，肇事车辆：%@", trafficRecord.car];
    }
    
    if (trafficRecord.infocome) {
        remark = [remark stringByAppendingFormat:@"，事故消息来源：%@", trafficRecord.infocome];
    }
    
    if (trafficRecord.fix) {
        remark = [remark stringByAppendingFormat:@"，事故方向：%@", trafficRecord.fix];
    }
    
    if (stationString) {
        remark = [remark stringByAppendingFormat:@"，事故发生地点（桩号）：%@", stationString];
    }
    
    if (trafficRecord.property) {
        remark = [remark stringByAppendingFormat:@"，事故性质：%@", trafficRecord.property];
    }
    
    if (trafficRecord.type) {
        remark = [remark stringByAppendingFormat:@"，事故分类：%@", trafficRecord.type];
    }
    
    if (trafficRecord.roadsituation) {
        remark = [remark stringByAppendingFormat:@"，事故封道情况：%@", trafficRecord.roadsituation];
    }
    
    if (trafficRecord.wdsituation) {
        remark = [remark stringByAppendingFormat:@"，事故伤亡情况：%@", trafficRecord.wdsituation];
    }
    
    if (trafficRecord.lost) {
        remark = [remark stringByAppendingFormat:@"，路产损失金额：%@", trafficRecord.lost];
    }
    
    if (trafficRecord.isend) {
        remark = [remark stringByAppendingFormat:@"，是否结案：%@", trafficRecord.isend];
    }
    
    if (trafficRecord.paytype) {
        remark = [remark stringByAppendingFormat:@"，索赔方式：%@", trafficRecord.paytype];
    }
    
    if (trafficRecord.zjstart) {
        remark = [remark stringByAppendingFormat:@"，拯救处理开始时间：%@", [dateFormatter stringFromDate:trafficRecord.zjstart]];
    }
    
    if (trafficRecord.zjend) {
        remark = [remark stringByAppendingFormat:@"，拯救处理结束时间：%@", [dateFormatter stringFromDate:trafficRecord.zjend]];
    }
    
    if (trafficRecord.zjend) {
        remark = [remark stringByAppendingFormat:@"，拯救处理结束时间：%@", [dateFormatter stringFromDate:trafficRecord.zjend]];
    }
    
    if (trafficRecord.clstart) {
        remark = [remark stringByAppendingFormat:@"，事故处理开始时间：%@", [dateFormatter stringFromDate:trafficRecord.clstart]];
    }
    
    if (trafficRecord.clend ) {
        remark = [remark stringByAppendingFormat:@"，事故处理结束时间：%@", [dateFormatter stringFromDate:trafficRecord.clend]];
    }
    
    if (trafficRecord.remark) {
        remark = [remark stringByAppendingFormat:@"，备注：%@", trafficRecord.remark];
    }
    
    remark = [remark stringByAppendingFormat:@"。"];
    inspectionRecord.remark = remark;
    
    [[AppDelegate App] saveContext];
    [self reloadRecordData];
}
@end
