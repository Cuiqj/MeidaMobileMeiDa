//
//  CaseInfoPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseIDHandler.h"
#import "Systype.h"

@interface CaseInfoPickerViewController : UITableViewController
@property (nonatomic,weak) id<CaseIDHandler> delegate;
@property (weak,nonatomic) UIPopoverController *pickerPopover;
@property (nonatomic,assign) NSInteger pickerType;

@end
