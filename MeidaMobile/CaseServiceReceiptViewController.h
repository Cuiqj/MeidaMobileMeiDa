//
//  CaseServiceReceiptViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-24.
//
//

#import "CasePrintViewController.h"
#import "CaseServiceFiles.h"
#import "CaseServiceReceipt.h"
#import "ServiceFileEditorViewController.h"

@interface CaseServiceReceiptViewController : CasePrintViewController<ServiceFileEditorDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textMark2;//案号 字
@property (nonatomic, weak) IBOutlet UITextField *textMark3;//案号 号

@property (nonatomic, weak) IBOutlet UITextField *textincepter_name;//单行多文本框    受送达人
@property (nonatomic, weak) IBOutlet UITextField *textreason;//案由
@property (nonatomic, weak) IBOutlet UITextField *textservice_company;//单行多文本框    送达单位
@property (nonatomic, weak) IBOutlet UITextField *textservice_address;//送达地点

@property (weak, nonatomic) IBOutlet UITableView *tableDetail;
@property (nonatomic, weak) IBOutlet UITextView *textremark;//多行多文本框    备注

- (IBAction)btnAddNew:(id)sender;
+ (void)generateDefaultInfo:(CaseServiceReceipt *)caseServiceFiles caseId:(NSString*)caseID;
@end
