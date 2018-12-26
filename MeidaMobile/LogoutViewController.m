//
//  LogoutViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-26.
//
//

#import "LogoutViewController.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController
@synthesize uibuttonLogout;
@synthesize uiButtonDeliver;

- (void)viewDidLoad
{
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"小按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uibuttonLogout setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uiButtonDeliver setBackgroundImage:btnImage forState:UIControlStateNormal];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUibuttonLogout:nil];
    [self setUiButtonDeliver:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnDeliver:(UIButton *)sender {
    [self.delegate inspectionDeliver];
}

- (IBAction)btnLogout:(UIButton *)sender {
    [self.delegate logOut];
}
@end
