//
//  AtonementNoticePrintViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "CasePrintViewController.h"
#import "AtonementNotice.h"
#import "AccInfoPickerViewController.h"

@interface AtonementNoticePrintViewController : CasePrintViewController<setCaseTextDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;
@property (weak, nonatomic) IBOutlet UITextField *textParty;
@property (weak, nonatomic) IBOutlet UITextField *textPartyAddress;
@property (weak, nonatomic) IBOutlet UITextField *textCaseReason;
@property (weak, nonatomic) IBOutlet UITextField *textOrg;
@property (weak, nonatomic) IBOutlet UITextView *textViewCaseDesc;
@property (weak, nonatomic) IBOutlet UITextField *textWitness;
@property (weak, nonatomic) IBOutlet UITextView *textViewPayReason;
@property (weak, nonatomic) IBOutlet UITextField *textPayMode;
@property (weak, nonatomic) IBOutlet UITextField *textCheckOrg;
@property (weak, nonatomic) IBOutlet UILabel *labelDateSend;
@property (weak, nonatomic) IBOutlet UITextField *textBankName;
+ (void)generateDefaultsForNotice:(AtonementNotice *)notice caseId:(NSString*)caseID;
- (IBAction)selectParkingCitizenName:(id)sender;
@end
