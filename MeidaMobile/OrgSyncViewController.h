//
//  OrgSyncViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceHandler.h"
#import "OrgInfo.h"
#import "TBXML.h"
#import "DataDownLoad.h"
#import "ServiceListViewController.h"

@protocol OrgSetDelegate;

@interface OrgSyncViewController : UIViewController<UIAlertViewDelegate,setServiceDelegate>
@property (retain, nonatomic) DataDownLoad *dataDownLoader;
//@property (weak, nonatomic) IBOutlet UITableView *tableOrgList;
@property (weak, nonatomic) IBOutlet UITextField *textServerAddress;
@property (weak, nonatomic) id<OrgSetDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *versionName;
@property (weak, nonatomic) IBOutlet UILabel *versionTime;

//确定当前服务器地址
- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *serviceTextField;


@property (nonatomic,retain) UIPopoverController *pickerPopOver;

//保存

- (IBAction)saveService:(UIButton *)sender;


// 选择

- (IBAction)ServiceChoose:(UITextField *)sender;


@end

@protocol OrgSetDelegate <NSObject>

- (void)pushLoginView;
@end