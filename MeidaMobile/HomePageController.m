//
//  HomePageController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomePageController.h"
#import "OrgInfo.h"
#import "UserInfo.h"

@interface HomePageController ()
- (void) loadUserLabel;
@property (nonatomic,retain) UIPopoverController *popover;
@end

@implementation HomePageController
@synthesize labelOrgShortName;
@synthesize labelCurrentUser;
@synthesize popover;

- (void) loadUserLabel {
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    if (currentUserName==nil) {
        currentUserName = @"";
    }
    self.labelCurrentUser.text=[[NSString alloc] initWithFormat:@"操作员：%@",currentUserName];
    self.labelOrgShortName.text = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgshortname"];
}

//监测是否设置当前机构，否则弹出机构选择菜单
- (void)viewDidAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"TOLOGIN" object:nil];
    [self loadUserLabel];
    if ([UserInfo allUserInfo].count <= 0) {
        OrgSyncViewController *osVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrgSyncVC"];
        osVC.modalPresentationStyle = UIModalPresentationFormSheet;
        osVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        osVC.delegate=self;
        [self presentModalViewController:osVC animated:YES];
    } else {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        if (currentUserID == nil || [currentUserID isEmpty]) {
            [self performSegueWithIdentifier:@"toLogin" sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toLogin"]) {
        LoginViewController *lvc=[segue destinationViewController];
        lvc.delegate=self;
    } else if ([[segue identifier] isEqualToString:@"toLogoutView"]){
        LogoutViewController *lvc=[segue destinationViewController];
        lvc.delegate=self;
        self.popover = [(UIStoryboardPopoverSegue *) segue popoverController];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidUnload {
    [self setLabelOrgShortName:nil];
    [self setLabelCurrentUser:nil];
    [self setPopover:nil];
    [super viewDidUnload];
}

- (void)reloadUserLabel{
    [self loadUserLabel];
}

- (void)pushLoginView{
    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}

- (IBAction)btnLogOut:(UIBarButtonItem *)sender {
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"toLogoutView" sender:nil];
    }
}


- (void)logOut{
    [self.popover dismissPopoverAnimated:YES];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if (![inspectionID isEmpty] && inspectionID!=nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"当前还有未完成的巡查，请先交班再切换用户。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USERKEY];
        [self loadUserLabel];
        [self performSegueWithIdentifier:@"toLogin" sender:nil];
    }
}

- (void)inspectionDeliver{
    [self.popover dismissPopoverAnimated:YES];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if ([inspectionID isEmpty] || inspectionID == nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"没有正在进行的巡查，无法交班。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        [self performSegueWithIdentifier:@"toInspectionOutFromMain" sender:nil];
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
}


@end
