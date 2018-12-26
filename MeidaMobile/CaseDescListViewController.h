//
//  CaseDescListViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSArray+NewCaseDescArray.h"

#import "CaseIDHandler.h"


@interface CaseDescListViewController : UIViewController
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnConfirm:(id)sender;
@property (nonatomic,weak) UIPopoverController *popOver;
@property (nonatomic,weak) id<CaseIDHandler> delegate;
@property (nonatomic,copy) NSString *caseID;

@end
