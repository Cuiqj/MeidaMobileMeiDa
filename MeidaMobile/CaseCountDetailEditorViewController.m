//
//  CaseCountDetailEditorViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-23.
//
//

#import "CaseCountDetailEditorViewController.h"

@interface CaseCountDetailEditorViewController ()

@end

@implementation CaseCountDetailEditorViewController
-(void)awakeFromNib{
    [super awakeFromNib];
    self.preferredContentSize = CGSizeMake(520, 640);
}

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
    if (self.countDetail) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"#,##0.00"];
        self.textPrice.text = [numberFormatter stringFromNumber:self.countDetail.price];
        self.textQuantity.text = [numberFormatter stringFromNumber:self.countDetail.quantity];
		self.textRmark.text=self.countDetail.remark;
    }
}


- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnComfirm:(UIBarButtonItem *)sender {
    BOOL needReload = NO;
    if (![self.textPrice.text isEmpty]) {
        self.countDetail.price = @(self.textPrice.text.floatValue);
        [[AppDelegate App] saveContext];
        needReload = YES;
    }
    if (![self.textQuantity.text isEmpty]) {
        self.countDetail.quantity = @(self.textQuantity.text.floatValue);
        [[AppDelegate App] saveContext];
        needReload = YES;
    }
	if(![self.textRmark.text isEmpty]){
		self.countDetail.remark=self
		.textRmark.text;
	}
    if (needReload) {
        self.countDetail.total_price = @(self.countDetail.price.floatValue * self.countDetail.quantity.floatValue);
        [[AppDelegate App] saveContext];
        [self.delegate reloadDataArray];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setCaseID:nil];
    [self setCountDetail:nil];

    [self setTextPrice:nil];
    [self setTextQuantity:nil];
    [super viewDidUnload];
}

@end
