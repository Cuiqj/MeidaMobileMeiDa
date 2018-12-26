//
//  NewInspectionViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-5.
//
//

#import <UIKit/UIKit.h>
#import "CheckItemDetails.h"
#import "CheckItems.h"
#import "InspectionHandler.h"
#import "InspectionCheck.h"
#import "Inspection.h"
#import "TempCheckItem.h"
#import "InspectionCheckPickerViewController.h"
#import "DateSelectController.h"
#import "InspectionOutCheck.h"

@interface NewInspectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,InspectionPickerDelegate,DatetimePickerHandler,UITextFieldDelegate,UITextViewDelegate>
- (IBAction)btnCancel:(UIBarButtonItem *)sender;
- (IBAction)btnSave:(UIBarButtonItem *)sender;
- (IBAction)btnOK:(UIBarButtonItem *)sender;
- (IBAction)btnDismiss:(UIBarButtonItem *)sender;
- (IBAction)textTouch:(UITextField *)sender;
- (IBAction)checkDeliverText:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITableView *tableCheckItems;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCheckItemDetails;
@property (weak, nonatomic) IBOutlet UITextField *textDetail;
@property (weak, nonatomic) IBOutlet UITextField *textDate;
@property (weak, nonatomic) IBOutlet UITextField *textAutoNumber;
@property (weak, nonatomic) IBOutlet UITextField *textWeather;
@property (weak, nonatomic) IBOutlet UITextField *textWorkShift;
@property (weak, nonatomic) IBOutlet UITextView *textViewDeliverText;
@property (weak, nonatomic) id<InspectionHandler> delegate;
@property (nonatomic,assign) InspectionCheckState pickerState;
@end
