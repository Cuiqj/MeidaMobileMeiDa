//
//  ServiceFileEditorViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-21.
//
//

#import "ServiceFileEditorViewController.h"
#import "CaseServiceReceipt.h"
#define MAX_SELECTED_FILE_NUM 3

@interface ServiceFileEditorViewController ()
@property (nonatomic, strong) UIPopoverController *selectServiceFilePopover;
@end

@implementation ServiceFileEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.file) {
        self.textFileName.text = [self.file service_file];
        self.textRemark.text = [self.file remark];
//        self.textSendAddress.text = [self.file send_address];
//        self.textSendWay.text = [self.file send_way];
    }
}


- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnComfirm:(UIBarButtonItem *)sender {
    if (self.textFileName.text != nil && ![self.textFileName.text isEmpty]) {
        NSArray *filesOwned = [CaseServiceFiles caseServiceFilesForCase:self.caseID];
        // 判断是否已有同名文书
        for (CaseServiceFiles *file in filesOwned){
            if ([file.service_file isEqualToString:self.textFileName.text]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该文书已添加过" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                [self dismissModalViewControllerAnimated:YES];
                return;
            } else {
                continue;
            }
        }
//        if (self.file == nil) {
//            // 在新增文书情况下判断是否已超出文书数量限制
//            if ([filesOwned count] >= MAX_SELECTED_FILE_NUM) {
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能添加三份文书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//                [self dismissModalViewControllerAnimated:YES];
//                return;
//            }
//            self.file = [CaseServiceFiles newCaseServiceFilesForID:self.caseID];
//        }
        if (self.file == nil) {
            // 在新增文书情况下判断是否已超出文书数量限制
            if ([filesOwned count] >= MAX_SELECTED_FILE_NUM) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能添加三份文书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                [self dismissModalViewControllerAnimated:YES];
                return;
            }
            CaseServiceReceipt *serviceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
            if (serviceReceipt) {
                self.file = [CaseServiceFiles newCaseServiceFilesForCaseServiceReceipt:serviceReceipt.myid];
            }
        }
        self.file.service_file = self.textFileName.text;
        [[AppDelegate App] saveContext];
        [self.delegate reloadDataArray];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)textFieldEditBegin:(UITextField *)sender {
    
    if (self.selectServiceFilePopover == nil) {
        ServiceFileSelectViewController *serviceFileSelector = [[ServiceFileSelectViewController alloc] initWithStyle:UITableViewStylePlain];
        [serviceFileSelector setDelegate:self];
        self.selectServiceFilePopover = [[UIPopoverController alloc] initWithContentViewController:serviceFileSelector];
        [self.selectServiceFilePopover setPopoverContentSize:CGSizeMake(serviceFileSelector.view.frame.size.width, 300) animated:YES];
        serviceFileSelector.outerPopover = self.selectServiceFilePopover;
    }

    if ([self.selectServiceFilePopover isPopoverVisible]) {
        [self.selectServiceFilePopover dismissPopoverAnimated:YES];
    } else {
        [self.selectServiceFilePopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }

}

- (void)viewDidUnload {
    [self setTextFileName:nil];
    [self setTextRemark:nil];
    [self setTextSendAddress:nil];
    [self setTextSendWay:nil];
    [self setCaseID:nil];
    [self setFile:nil];
    [super viewDidUnload];
}

#pragma mark - delegate method implementation

- (void)serviceFileNameSelected:(NSString *)serviceFileName
{
    if ([self.textFileName.text isEmpty]) {
        self.textFileName.text = @"";
    }
    self.textFileName.text = serviceFileName;
}

@end
