//
//  NewInspectionViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-5.
//
//


#import "NewInspectionViewController.h"
#import "UserInfo.h"

@interface NewInspectionViewController ()
@property (nonatomic,retain) NSArray *itemArray;
@property (nonatomic,retain) NSArray *detailArray;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@implementation NewInspectionViewController
@synthesize inputView;
@synthesize tableCheckItems;
@synthesize pickerCheckItemDetails;
@synthesize textDetail;
@synthesize textDate;
@synthesize textAutoNumber;
@synthesize textWeather;
@synthesize textWorkShift;
@synthesize textViewDeliverText;
@synthesize delegate;
@synthesize pickerState;
@synthesize pickerPopover;

- (void)viewDidLoad
{
    NSArray *inspectionArray=[Inspection inspectionForID:@""];
    if (inspectionArray.count>0) {
        self.textViewDeliverText.text=[[inspectionArray lastObject] valueForKey:@"delivertext"];
        NSString *preInspectionID=[[inspectionArray lastObject] valueForKey:@"myid"];
        NSArray *outCheckArray=[InspectionOutCheck outChecksForInspection:preInspectionID];
        NSMutableArray *tempMutableArray=[[NSMutableArray alloc] initWithCapacity:outCheckArray.count];
        for (InspectionOutCheck *outCheck in outCheckArray) {
            TempCheckItem *tempItem=[[TempCheckItem alloc] init];
            tempItem.checkText=outCheck.checktext;
            tempItem.remarkText=outCheck.remark;
            tempItem.checkResult=outCheck.checkresult;
            [tempMutableArray addObject:tempItem];
        }
        /*NSArray *checkItems=[CheckItems allCheckItemsForType:1];
         *modify by lxm
         *？type=2 type=1 区别
         */
        NSArray *checkItems=[CheckItems allCheckItemsForType:2];
        for (int i=0; i<checkItems.count; i++) {
            TempCheckItem *tempItem=[tempMutableArray objectAtIndex:i];
            CheckItems *checkItem=[checkItems objectAtIndex:i];
            tempItem.itemID=checkItem.myid;
        }
        self.itemArray=[NSArray arrayWithArray:tempMutableArray];
    } else {
        self.textViewDeliverText.text=@"";
        /*NSArray *checkItems=[CheckItems allCheckItemsForType:1];
         *modify by lxm
         *？type=2 type=1 区别
         */
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
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setInputView:nil];
    [self setTableCheckItems:nil];
    [self setPickerCheckItemDetails:nil];
    [self setTextDetail:nil];
    [self setTextDate:nil];
    [self setTextAutoNumber:nil];
    [self setTextWeather:nil];
    [self setTextWorkShift:nil];
    [self setDelegate:nil];
    [self setPickerPopover:nil];
    [self setTextViewDeliverText:nil];
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


#pragma mark - IBActions
- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    [self.delegate popBackToMainView];
    [self dismissModalViewControllerAnimated:NO];    
}

- (IBAction)btnSave:(UIBarButtonItem *)sender {
    BOOL isBlank=NO;
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if ([textField.text isEmpty]) {
                isBlank=YES;
            }
        }
    }
    if (!isBlank) {
        Inspection *newInspection=[Inspection newDataObjectWithEntityName:@"Inspection"];
        NSString *newInspectionID=newInspection.myid;
        [[NSUserDefaults standardUserDefaults] setValue:newInspectionID forKey:INSPECTIONKEY];        
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [formatter setLocale:[NSLocale currentLocale]];
        newInspection.date_inspection=[formatter dateFromString:self.textDate.text];
        newInspection.time_start=[formatter dateFromString:self.textDate.text];
        newInspection.weather=self.textWeather.text;
        newInspection.carcode=self.textAutoNumber.text;
        newInspection.classe=self.textWorkShift.text;
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
        if (inspectorArray.count < 1) {
            newInspection.inspectionor_name = currentUserName;
        } else {
            NSString *inspectorName = @"";
            for (NSString *name in inspectorArray) {
                if ([inspectorName isEmpty]) {
                    inspectorName = name;
                } else {
                    inspectorName = [inspectorName stringByAppendingFormat:@",%@",name];
                }
            }
            newInspection.inspectionor_name = inspectorName;
        }
        newInspection.recorder_name = currentUserName;
        newInspection.isdeliver=@(NO);
        [[AppDelegate App] saveContext];
        for (TempCheckItem *checkItem in self.itemArray) {
            InspectionCheck *newCheck=[InspectionCheck newDataObjectWithEntityName:@"InspectionCheck"];
            newCheck.inspectionid=newInspectionID;
            newCheck.checktext=checkItem.checkText;
            newCheck.remark=checkItem.remarkText;
            newCheck.checkresult=checkItem.checkResult;
            [[AppDelegate App] saveContext];
        }
        [self dismissModalViewControllerAnimated:YES];
        [self.delegate setInspectionDelegate:newInspectionID];
        [self.delegate addObserverToKeyBoard];
    }
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
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            [self.inputView setAlpha:0.0];
                            [self.view sendSubviewToBack:self.inputView];
                        }
                        completion:^(BOOL finished){
                            [self.inputView setHidden:YES];
                        }];
    });
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [UIView transitionWithView:self.view
                          duration:0.3
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            CGRect newRect=self.tableCheckItems.frame;
                            newRect.size.height=396;
                            [self.tableCheckItems setFrame:newRect];
                        } completion:nil];
    });

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
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            break;
        case 101:
            [self pickerPresentPickerState:kWeatherPicker fromRect:sender.frame];
            break;
        case 102:
            [self pickerPresentPickerState:kCarCode fromRect:sender.frame];
            break;
        case 103:
            [self pickerPresentPickerState:kWorkShifts fromRect:sender.frame];
            break;
        default:
            break;
    }    
}

- (IBAction)checkDeliverText:(UIButton *)sender {
    if ([self.textViewDeliverText isHidden]) {
        [UIView transitionWithView:self.textViewDeliverText
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^(void){
                            [self.textViewDeliverText setHidden:NO];
                            [self.view bringSubviewToFront:self.textViewDeliverText];
                        }
                        completion:nil];
    } else {
        [UIView transitionWithView:self.tableCheckItems
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^(void){
                            [self.view sendSubviewToBack:self.textViewDeliverText];
                        }
                        completion:^(BOOL finished){
                            [self.textViewDeliverText setHidden:YES];
                        }];
    }
}

#pragma mark - InspectionPicker Delegate
- (void)setCheckText:(NSString *)checkText{
    switch (pickerState) {
        case kCarCode:
            self.textAutoNumber.text=checkText;
            break;
        case kWeatherPicker:
            self.textWeather.text=checkText;
            break;
        case kWorkShifts:
            self.textWorkShift.text=checkText;
            break;
        default:
            break;
    }
}

- (void)setDate:(NSString *)date{
    self.textDate.text=date;
}
//弹窗
- (void)pickerPresentPickerState:(InspectionCheckState)state fromRect:(CGRect)rect{
    if ((state==self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState=state;
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

#pragma mark - own methods
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
@end
