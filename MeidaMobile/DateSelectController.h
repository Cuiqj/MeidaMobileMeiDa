//
//  DateSelectController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatetimePickerHandler;

@interface DateSelectController : UIViewController

@property (nonatomic,weak) IBOutlet UIDatePicker *datePicker;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (void)showdate:(NSString *)date;
- (void)showPastDate:(NSDate* )date;
@property (weak,nonatomic) id<DatetimePickerHandler> delegate;
@property (copy,nonatomic) NSString *datefrom;
@property (weak,nonatomic)UIPopoverController *dateselectPopover;
//时间选择器类型标识，为0时只选择日期，为1时可选择日期和具体时间
@property (assign,nonatomic) NSInteger pickerType;
@property (nonatomic, strong) NSDate* pastDate;
@property (nonatomic, assign) int textFieldTag;
@end

@protocol DatetimePickerHandler <NSObject>
@optional
-(void)setDate:(NSString *)date;
-(void)setPastDate:(NSDate *)date withTag:(int)tag;
@end
