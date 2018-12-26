//
//  InspectionOutViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-13.
//
//

#import <UIKit/UIKit.h>
#import "CheckItemDetails.h"
#import "CheckItems.h"
#import "TempCheckItem.h"
#import "DateSelectController.h"
#import "InspectionOutCheck.h"
#import "Inspection.h"
#import "InspectionHandler.h"
#import "InspectionRecord.h"

@interface InspectionOutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,DatetimePickerHandler>
- (IBAction)btnCancel:(UIBarButtonItem *)sender;
- (IBAction)btnSave:(UIBarButtonItem *)sender;
- (IBAction)btnOK:(UIBarButtonItem *)sender;
- (IBAction)btnDismiss:(UIBarButtonItem *)sender;
- (IBAction)textTouch:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITableView *tableCheckItems;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCheckItemDetails;
@property (weak, nonatomic) IBOutlet UITextField *textDetail;
@property (weak, nonatomic) IBOutlet UITextView *textDeliver;
@property (weak, nonatomic) IBOutlet UITextField *textEndDate;
@property (weak, nonatomic) IBOutlet UITextField *textMile;

@property (weak, nonatomic) id<InspectionHandler> delegate;

@end
