//
//  DateSelectController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateSelectController.h"

@interface DateSelectController ()
@property (nonatomic,readonly) NSDateFormatter *formatter;
@end

@implementation DateSelectController
@synthesize datePicker=_datePicker;
@synthesize delegate=_delegate;
@synthesize datefrom=_datefrom;
@synthesize formatter=_formatter;
@synthesize dateselectPopover=_dateselectPopover;
//时间选择器类型标识，为0时只选择日期，为1时可选择日期和具体时间
@synthesize pickerType=_pickerType;

- (NSDateFormatter *)formatter{
    if (_formatter==nil) {
        _formatter=[[NSDateFormatter alloc] init];
        [_formatter setLocale:[NSLocale currentLocale]];
        if (_pickerType == 0) {
            [_formatter setDateFormat : @"yyyy-MM-dd"];
        } else if (_pickerType == 1) {
            [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        } else if (_pickerType == 3) {
            [_formatter setDateFormat:@"yyyy年MM月dd日"];
        }
    }
    return _formatter;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{   
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_pickerType==0) {
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    } else if (_pickerType==1) {
        _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    }
    if ([self.datefrom isEmpty]){
        NSDate *datenew=[NSDate date];
        [self.datePicker setDate:datenew];
    }else{
        NSDate *dateTime = [self.formatter dateFromString:_datefrom];
        if (dateTime==nil) {
            dateTime=[NSDate date];
        }
        [self.datePicker setDate:dateTime];
    }
    
    if (self.pastDate) {
        [self.datePicker setDate:self.pastDate];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnSave:(id)sender {
    if (self.pastDate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setPastDate: withTag:)]) {
            [self.delegate setPastDate:[self.datePicker date] withTag:self.textFieldTag];;
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setDate:)]) {
            [self.delegate setDate:[self.formatter stringFromDate:[self.datePicker date]]];
        }
    }
    
    [self.dateselectPopover dismissPopoverAnimated:YES];
}

- (IBAction)btnCancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setDate:)]) {
        [self.delegate setDate:@""];   
    }
 
    [self.dateselectPopover dismissPopoverAnimated:YES];
}

-(void)showdate:(NSString *)date{
    self.datefrom=date;
}

- (void)showPastDate:(NSDate* )date{
    self.pastDate = date;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.preferredContentSize = CGSizeMake(300.0, 220.0);
}
@end
