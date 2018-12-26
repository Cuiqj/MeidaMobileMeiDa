//
//  HomePageController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgSyncViewController.h"
#import "LoginViewController.h"
#import "LogoutViewController.h"

@interface HomePageController : UIViewController<UINavigationControllerDelegate,OrgSetDelegate,UserSetDelegate,LogOutDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelOrgShortName;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrentUser;
- (IBAction)btnLogOut:(UIBarButtonItem *)sender;

@end
