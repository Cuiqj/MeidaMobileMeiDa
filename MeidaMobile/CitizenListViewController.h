//
//  CitizenListViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+MyStringProcess.h"
#import "CaseIDHandler.h"

@interface CitizenListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)btnEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *citizenListView;
@property (nonatomic,copy) NSString * caseID;
@property (nonatomic,weak) UIPopoverController *citizenListPopover;
@property (nonatomic,weak) id<CaseIDHandler> delegate;
@end
