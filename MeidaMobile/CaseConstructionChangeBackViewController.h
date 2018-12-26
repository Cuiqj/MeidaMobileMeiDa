//
//  CaseConstructionChangeBackViewController.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-9.
//
//

#import "CasePrintViewController.h"
#import "DateSelectController.h"

@interface CaseConstructionChangeBackViewController : CasePrintViewController <DatetimePickerHandler, UITextFieldDelegate, UIPrintInteractionControllerDelegate>

@property(weak, nonatomic) IBOutlet UITextField *textNo;
@property(weak, nonatomic) IBOutlet UITextField *textSendname;
@property(weak, nonatomic) IBOutlet UITextField *textSendate;
@property(weak, nonatomic) IBOutlet UITextField *textSendNO;
@property(weak, nonatomic) IBOutlet UITextView *textRemark;

@property (nonatomic,retain) UIPopoverController *pickerPopover;

@property (nonatomic, retain) NSString *rel_id;


- (IBAction)btnPrint:(id)sender;
- (IBAction)btnBack:(id)sender;

- (IBAction)textTouch:(UITextField *)sender;
-(void)setDate:(NSString *)date;

@end
