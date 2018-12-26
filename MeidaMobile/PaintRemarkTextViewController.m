//
//  PaintRemarkTextViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-7-10.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "PaintRemarkTextViewController.h"
#import "UserInfo.h"
#import "CaseMap.h"
#import "CaseProveInfo.h"

@interface PaintRemarkTextViewController ()
@property (nonatomic,assign) BOOL remarkSaved;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,assign) InspectionCheckState pickerState;
-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;

@end

@implementation PaintRemarkTextViewController
@synthesize remarkTextView = _remarkTextView;
@synthesize textRoadType = _textRoadType;
@synthesize textDraftMan = _textDraftMan;
@synthesize textDraftTime = _textDraftTime;
@synthesize remarkSaved = _remarkSaved;
@synthesize caseID=_caseID;
@synthesize pickerPopover = _pickerPopover;
@synthesize pickerState = _pickerState;


- (void)viewDidLoad
{
    //监视键盘出现和隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (![self.caseID isEmpty]) {
        CaseMap *map = [CaseMap caseMapForCase:self.caseID];
        if (map) {
            self.textDraftMan.text = map.draftsman_name;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.textDraftTime.text = [formatter stringFromDate:map.draw_time];
            self.textRoadType.text = map.road_type;
            self.remarkTextView.text = map.remark;
        } else {
            NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
            self.textDraftMan.text = [[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
            self.textRoadType.text = @"沥青";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.textDraftTime.text = [formatter stringFromDate:[NSDate date]];
            self.remarkTextView.text = [CaseProveInfo generateEventDescForCase:self.caseID];
        }
    }
    self.remarkSaved=NO;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setRemarkTextView:nil];
    [self setTextRoadType:nil];
    [self setTextDraftMan:nil];
    [self setTextDraftTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {
    if (![self.caseID isEmpty]) {
        CaseMap *casemap = [CaseMap caseMapForCase:self.caseID];
        if (casemap == nil) {
            casemap = [CaseMap newDataObjectWithEntityName:@"CaseMap"];
            casemap.caseinfo_id = self.caseID;
            casemap.map_item = @"";
        }
        casemap.remark = self.remarkTextView.text;
        casemap.road_type = self.textRoadType.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        casemap.draw_time = [formatter dateFromString:self.textDraftTime.text];
        casemap.draftsman_name = self.textDraftMan.text;
        [[AppDelegate App] saveContext];
    }
    _remarkSaved=YES;
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectRoadType:(id)sender {
    [self pickerPresentPickerState:kRoadType fromRect:[sender frame]];
}

- (IBAction)selectUserName:(UITextField *)sender {
    [self pickerPresentPickerState:kUser fromRect:[sender frame]];
}

- (IBAction)selectTime:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        [datePicker showdate:self.textDraftTime.text];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        CGRect rect = [sender frame];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }

}

-(void)textViewDidChange:(UITextView *)textView{
    _remarkSaved=NO;
}

//键盘出现和消失时，变动TextView的大小
-(void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up{
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
    CGRect newFrame = self.remarkTextView.frame;
    if (up) {
        newFrame.size.height = 581 - keyboardEndFrame.size.width-5;
    } else {
        newFrame.size.height = 433;
    }
    self.remarkTextView.frame = newFrame;

    [UIView commitAnimations];   
}

-(void)keyboardWillShow:(NSNotification *)aNotification{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void)setDate:(NSString *)date{
    self.textDraftTime.text = date;
}

- (void)setCheckText:(NSString *)checkText{
    if (self.pickerState == kRoadType) {
        self.textRoadType.text = checkText;
    } else {
        self.textDraftMan.text = checkText;
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
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
@end
