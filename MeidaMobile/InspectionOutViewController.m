//
//  InspectionOutViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-13.
//
//

#import "InspectionOutViewController.h"
#import "InspectionPath.h"
#import "Global.h"
#import "HandleStrings.h"

@interface InspectionOutViewController ()<UIAlertViewDelegate>
@property (nonatomic,retain) NSArray *itemArray;
@property (nonatomic,retain) NSArray *detailArray;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@implementation InspectionOutViewController
@synthesize itemArray;
@synthesize detailArray;
@synthesize inputView;
@synthesize tableCheckItems;
@synthesize pickerCheckItemDetails;
@synthesize textDetail;
@synthesize textDeliver;
@synthesize textEndDate;
@synthesize textMile;
@synthesize pickerPopover;
@synthesize delegate;


- (void)viewDidLoad
{
    NSArray *checkItems=[CheckItems allCheckItemsForType:2];
    NSMutableArray *tempMutableArray=[[NSMutableArray alloc] initWithCapacity:checkItems.count];
    for (CheckItems *checkItem in checkItems) {
        TempCheckItem *tempItem=[[TempCheckItem alloc] init];
        tempItem.checkText=checkItem.checktext;
        tempItem.remarkText=checkItem.remark;
        tempItem.checkResult=checkItem.remark;
        tempItem.itemID=checkItem.myid;
        [tempMutableArray addObject:tempItem];
    }
    self.itemArray=[NSArray arrayWithArray:tempMutableArray];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextDeliver:nil];
    [self setTextEndDate:nil];
    [self setTextMile:nil];
    [self setItemArray:nil];
    [self setDetailArray:nil];
    [self setPickerPopover:nil];
    [self setInputView:nil];
    [self setTableCheckItems:nil];
    [self setPickerCheckItemDetails:nil];
    [self setTextDetail:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer=@"CheckItemCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    id obj=[self.itemArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[obj checkText];
	cell.detailTextLabel.text=[obj remarkText];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *checkItemID=[[self.itemArray objectAtIndex:indexPath.row] valueForKey:@"itemID"];
    self.detailArray=[CheckItemDetails detailsForItem:checkItemID];
    if ([self.inputView isHidden]) {
        [UIView beginAnimations:@"inputViewShow" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [self.inputView setHidden:NO];
        [self.inputView setAlpha:1.0];
        [self.view bringSubviewToFront:self.inputView];
        CGFloat height=self.inputView.frame.origin.y-self.tableCheckItems.frame.origin.y-5;
        CGRect newRect=self.tableCheckItems.frame;
        newRect.size.height=height;
        [self.tableCheckItems setFrame:newRect];
        [UIView commitAnimations];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    self.textDetail.text=[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    [self.pickerCheckItemDetails reloadAllComponents];
    [self.pickerCheckItemDetails selectRow:0 inComponent:0 animated:NO];
    self.textDetail.text=[self resultTextFromPickerView:self.pickerCheckItemDetails selectedRow:0 inComponent:0];
}

#pragma mark - pickerview delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return self.detailArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id obj=[self.detailArray objectAtIndex:row];
    return [obj caption];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.textDetail.text=[self resultTextFromPickerView:pickerView selectedRow:row inComponent:component];
}

- (void)showAlert{
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"确定提交？"
                               delegate:self
                      cancelButtonTitle:@"否"
                      otherButtonTitles:@"是", nil] show];
}

- (void)submit{
    BOOL isBlank=NO;
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if ([textField.text isEmpty]) {
                isBlank=YES;
            }
        }
    }
    if (!isBlank) {
        NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
        NSArray *temp=[Inspection inspectionForID:inspectionID];
        if (temp.count>0) {
            Inspection *inspection=[temp objectAtIndex:0];
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [formatter setLocale:[NSLocale currentLocale]];
            //[formatter setTimeZone:[NSTimeZone systemTimeZone]];
            inspection.time_end=[formatter dateFromString:self.textEndDate.text];
            if (!inspection.yjsj) {
                inspection.yjsj = inspection.time_end;
            }
            inspection.inspection_milimetres=@(self.textMile.text.floatValue);
            inspection.isdeliver=@(YES);
            inspection.delivertext=self.textDeliver.text;
            NSString *description=@"";
            NSArray *recordArray=[InspectionRecord recordsForInspection:inspectionID];
            for (int i=0; i<recordArray.count; i++) {
                InspectionRecord *record=[recordArray objectAtIndex:i];
                NSString * tempStr = record.remark;
                /*
                tempStr = @"09:58 巡至长深高速往福建方向K68+900m处时，在公路主车道有抛洒物，巡逻班组在其前摆放交安设施警示过往车辆并通知养护队清理。已恢复正常通车。14:20 巡至长深高速往福建方向K45+900m处时，在公路主车道有路产被人为损坏，现场未发现可疑人员，经现场勘查认定路产损失为：，巡逻班组报监控中心通知各站协助拦截并追至收费站未发现可疑车。经现场勘查认定路产损失为：。已到当地派出所报案，拿报警回执报保险理赔。";
                
                tempStr = @"10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案， 拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑 救。已到当地派出所报案，拿报警回执报保险理赔。";
                
                tempStr = @"09:58 巡至长深高速往福建方向K68+900m处时，在公路主车道有抛洒物，巡逻班组在其前摆放交安设施警示过往车辆并通知养护队清理。已恢复正常通车。14:20 巡至长深高速往福建方向K45+900m处时，在公路主车道有路产被人为损坏，现场未发现可疑人员，经现场勘查认定路产损失为：，巡逻班组报监控中心通知各站协助拦截并追至收费站未发现可疑车。经现场勘查认定路产损失为：。已到当地派出所报案，拿报警回执报保险理赔。";
                
                tempStr = @"10:38 巡至长深高速往福建方向K46+900m处时，在公路主车道有路产被人为损坏，现场未发现可疑人员，经现场勘查认定路产损失为：，巡逻班组报监控中心通知各站协助拦截并追至收费站未发现可疑车。经现场勘查认定路产损失为：。已到当地派出所报案，拿报警回执报保险理赔。很扯并产生耐药性温暖活动结束的活动后初见端倪许多农村一定能促进，村督促你所有承诺后。";
               
                tempStr = @"10:42 巡至长深高速往福建方向K68+900m处时，在公路主车道事故障车辆已拖驶离现场，巡逻班组在其前摆放交安设施警示过往车辆并通知养护队清理。已恢复正常通车。海德堡成吉思汗，粗大聚餐呢后，此地才能督促宁静，杜恩杜恩杜，觉得奴才能大喊大叫觉得每次加德满都烦恼。记得那程度仅次于神农架扽，杜恩的还是觉得好四面出击，杜恩杜我肯定不饿觉得，爹妈的哈萨克发布会上看";
                
                tempStr = @"10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑救。已到当地派出所报案，拿报警回执报保险理赔。10:14 巡至天汕段中央隔离带K122+333m处时，在公路主车道损坏路产逃逸情况，巡逻班组赶往现场进行扑 救。已到当地派出所报案，拿报警回执报保险理赔。";
               
                
                tempStr = @"11:41 巡至长深高速往汕头方向K11+022m处时，在公路城东收费站出口右侧有路产被人为损坏，现场未发现可疑人员，经现场勘查认定路产损失为：，巡逻班组水泥钢筋砼盖板：平方米（规格：0.5米×0.75米×块）。已到当地派出所报案，拿报警回执报保险理赔。11:41 巡至长深高速往汕头方向K11+022m处时，在公路城东收费站出口右侧有路产被人为损坏，现场未发现可疑人员，经现场勘查认定路产损失为：，巡逻班组水泥钢筋砼盖板：平方米（规格：0.5米×0.75米×块）。已到当地派出所报案，拿报警回执报保险理赔。11:41 巡至长深高速往汕头方向K11+022m处时，在公路城东收费站出口右侧有路产被人为损坏，现场未发现可疑人员，经现场勘查认定路产损失为：，巡逻班组水泥钢筋砼盖板：平方米（规格：0.5米×0.75米×块）。已到当地派出所报案，拿报警回执报保险理赔。";
                
                tempStr = @"15:42 巡至S12梅龙高速往福建武平方向K32+900m处时，在公路超车道接监控中心（值班队长、交警）电话通知：S12梅龙高速往福建**方向有交通事故发生，巡查班组立即前往处理。，巡逻班组巡查班组立即下车按规范摆放好临时交安设施，以预防二次事故的发生，并及时将现场情况汇报监控中心，经现场勘查，事故未造成路产损失，未造成人员伤亡，未造成交通堵塞与分流。。0:0拯救队到达现场，0:0交警到达现场，0;0救护车到达现场，按一般（重大、特大）事故处理程序处理。0;0事故车辆被拯救队拖离现场，事故处理完毕，交通恢复正常。。S12梅龙高速往福建永定方向K44+900m处时，在公路收费站连接线出口发现有铁丝网被人为损坏，现场未发现有可疑人员，巡逻班组现场火势较大，当班人员用随车灭火器灭火的同时立即报火警119处理，XX时XX分火警到达现场将火控制。经勘查：单面波形钢板（长4米）XX片、XXXX被盗，现场未发现有可疑人员及车辆。";
                 
                tempStr = @"15:53 巡至S12梅龙高速往福建武平方向K33+030m处时，在公路主车道接监控中心（值班队长、交警）电话通知：S12梅龙高速往福建**方向有交通事故发生，巡查班组立即前往处理。，巡逻班组巡查班组立即下车按规范摆放好临时交安设施，以预防二次事故的发生，并及时将现场情况汇报监控中心，经现场勘查，事故未造成路产损失，事故造成交通堵塞，造成XX人轻伤、XX人重伤、XX人死亡。0;0交警到达现场，0;0拯救队到达现场，按一般（重大、特大）事故处理程序处理。0;0事故车辆被拯救队拖离现场，事故处理完毕，交通恢复正常。";
                 */
                UIFont *font = [UIFont fontWithName:@"SimSun" size:12.0];
                CGFloat width = [[NSString stringWithFormat:@"%d.09:57 ", i + 1 ] getStringWith:font];
                NSString *space = [@"" getSpecifiedWidthSpace:width font:font];
                
                CGFloat width2 = 492;
                if (i + 1 >= 10){
                    width2 = width2 - 6;
                }
                if (i + 1 >= 100){
                    width2 = width2 - 6;
                }
                if (i + 1 >= 1000){
                    width2 = width2 - 6;
                }
                CGFloat width3 = 456;
                if (i + 1 >= 10){
                    width3 = width3 - 6;
                }
                if (i + 1 >= 100){
                    width3 = width3 - 6;
                }
                if (i + 1 >= 1000){
                    width3 = width3 - 6;
                }
                HandleStrings *hangStrings = [tempStr getSpecifiedWidthString2:font lineWith:width2 horizontalAlignment:UITextAlignmentLeft];
                tempStr = [NSString stringWithFormat:@"%d.%@\r\n", i + 1, hangStrings.returnString ];
                while (![hangStrings.handleString isEmpty]) {
                    hangStrings = [hangStrings.handleString getSpecifiedWidthString2:font lineWith:width3 horizontalAlignment:UITextAlignmentLeft];
                    tempStr = [NSString stringWithFormat:@"%@%@%@\r\n", tempStr, space,hangStrings.returnString ];
                }
                description=[description stringByAppendingFormat:@"%@",tempStr];
            }

            NSLog(@"\n%@",description);
            inspection.inspection_description=description;
            NSString *pathString = @"";
            NSArray *pathArray = [InspectionPath pathsForInspection:inspectionID];
            for (InspectionPath *path in pathArray) {
                if ([pathString isEmpty]) {
                    pathString = path.stationname;
                } else {
                    pathString = [pathString stringByAppendingFormat:@"--%@",path.stationname];
                }
            }
            if (![pathString isEmpty]) {
                pathString = [[NSString alloc] initWithFormat:@"，途经：%@",pathString];
            }
            [formatter setDateFormat:DATE_FORMAT_HH_MM_COLON];
            pathString = [[NSString alloc] initWithFormat:@"%@出发%@，%@结束巡查",[formatter stringFromDate:inspection.time_start],pathString,[formatter stringFromDate:inspection.time_end]];
            inspection.inspection_place = pathString;
            [[AppDelegate App] saveContext];
        }
        for (TempCheckItem *checkItem in self.itemArray) {
            InspectionOutCheck *outCheck=[InspectionOutCheck newDataObjectWithEntityName:@"InspectionOutCheck"];
            outCheck.inspectionid=inspectionID;
            outCheck.checktext=checkItem.checkText;
            outCheck.remark=checkItem.remarkText;
            outCheck.checkresult=checkItem.checkResult;
            [[AppDelegate App] saveContext];
        }
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:INSPECTIONKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate popBackToMainView];
        [self dismissModalViewControllerAnimated:NO];
    }
}

#pragma mark - IBActions
- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    [self.delegate addObserverToKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(UIBarButtonItem *)sender {
    [self showAlert];
}

- (IBAction)btnOK:(UIBarButtonItem *)sender {
    NSIndexPath *index=[self.tableCheckItems indexPathForSelectedRow];
    TempCheckItem *item=[self.itemArray objectAtIndex:index.row];
    item.remarkText=self.textDetail.text;
    [self.tableCheckItems beginUpdates];
    [self.tableCheckItems reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableCheckItems endUpdates];
    [self.tableCheckItems selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.inputView setAlpha:0.0];
                        [self.view sendSubviewToBack:self.inputView];
                        CGRect newRect=self.tableCheckItems.frame;
                        newRect.size.height=440;
                        [self.tableCheckItems setFrame:newRect];
                    }
                    completion:^(BOOL finished){
                        [self.inputView setHidden:YES];
                    }];
}

- (IBAction)textTouch:(UITextField *)sender {
    //时间选择
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        [datePicker showdate:self.textEndDate.text];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
}

- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *resultText=[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
    if (resultText.integerValue>0) {
        NSString *temp=self.textDetail.text;
        NSCharacterSet *leftCharSet=[NSCharacterSet characterSetWithCharactersInString:@"（("];
        NSRange range=[temp rangeOfCharacterFromSet:leftCharSet options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            NSInteger index=range.location+1;
            NSString *header=[temp substringToIndex:index];
            NSCharacterSet *rightCharSet=[NSCharacterSet characterSetWithCharactersInString:@")）"];
            range=[temp rangeOfCharacterFromSet:rightCharSet];
            NSString *tail;
            if (range.location != NSNotFound) {
                tail=[temp substringFromIndex:range.location];
            } else {
                tail=[temp substringFromIndex:index];
            }
            resultText=[NSString stringWithFormat:@"%@%d%@",header,resultText.integerValue,tail];
        }
    }
    return resultText;
}


- (void)setDate:(NSString *)date{
    self.textEndDate.text=date;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1 == buttonIndex){
        [self submit];
    }
    else if (0 == buttonIndex){
        [self btnCancel:nil];
    }
    
}

@end
