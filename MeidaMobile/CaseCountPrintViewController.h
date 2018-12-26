//
//  CaseCountPrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-4.
//
//

#import "CasePrintViewController.h"
#import "CaseCountDetailCell.h"
#import "CaseCountDetailEditorViewController.h"

@interface CaseCountPrintViewController : CasePrintViewController<UITableViewDataSource,UITableViewDelegate,CaseCountDetailEditorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelHappenTime;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelParty;
@property (weak, nonatomic) IBOutlet UILabel *labelTele;
@property (weak, nonatomic) IBOutlet UILabel *labelAutoPattern;
@property (weak, nonatomic) IBOutlet UILabel *labelAutoNumber;
@property (weak, nonatomic) IBOutlet UITextField *textfieldCaseAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableCaseCountDetail;
@property (weak, nonatomic) IBOutlet UITextField *textBigNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelPayReal;
@property (weak, nonatomic) IBOutlet UITextView *textRemark;
@end
