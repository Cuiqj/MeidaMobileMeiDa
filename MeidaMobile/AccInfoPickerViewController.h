//
//  AccInfoPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Citizen.h"
#import "Systype.h"

@protocol setCaseTextDelegate;

@interface AccInfoPickerViewController : UITableViewController

//弹出窗口类型标记，0-3分别标识事故性质，事故原因，事故类型和停驶车辆
@property (nonatomic,assign) NSInteger pickerType;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,weak) id<setCaseTextDelegate> delegate;
@property (nonatomic,weak) NSString *caseID;
-(IBAction)btnConfirm:(id)sender;
-(IBAction)btnCancel:(id)sender;
@end

@protocol setCaseTextDelegate <NSObject>

-(void)setCaseText:(NSString *)aText;

@optional
-(NSString *)getParkingCitizens;

@end