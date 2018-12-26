//
//  OrgSelectController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgSelectHandler.h"

@interface OrgSelectController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,strong)NSString *currentorg;

-(void)showinfo:(NSString *)org;
-(void)loaddata;

@property (weak, nonatomic) IBOutlet UITableView *tvView;
@property (nonatomic,weak)id<OrgSelectHandler> delegatett;
@property (nonatomic,strong)NSString *defaultorg;
@property (nonatomic,strong)NSMutableArray *selectedorgs;
@property (weak,nonatomic)UIPopoverController *orgselectPopover;
- (IBAction)toLastOrg:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLastOrg;
- (IBAction)btnSave:(id)sender;

@end
