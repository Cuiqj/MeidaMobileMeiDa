//
//  CaseListViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseIDHandler.h"

@interface CaseListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic)  UIPopoverController *myPopover;
@property (nonatomic,weak) id<CaseIDHandler> delegate;
@property (weak, nonatomic) IBOutlet UITableView *caseListView;
@property (retain,nonatomic) NSMutableArray *caseList;

- (IBAction)btnEdit:(id)sender;

@end
