//
//  XKMainController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateSelectController.h"
#import "OrgSelectHandler.h"
#import "DateSelectController.h"

@interface XKMainController : UIViewController <UITableViewDataSource,UITableViewDelegate,WebServiceReturnString,DatetimePickerHandler,OrgSelectHandler,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *detaildata;
@property (nonatomic,strong) NSMutableArray *idlist;
@property (nonatomic,strong) NSMutableArray *typelist;
@property (nonatomic,strong) NSString *currentid;

@property (weak, nonatomic) IBOutlet UITableView *tbview;

- (IBAction)selectStartDate:(id)sender;
- (IBAction)selectOrg:(id)sender;
- (IBAction)selectEndDate:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFirst;
@property (weak, nonatomic) IBOutlet UITextField *txtSec;
@property (strong,nonatomic) NSString *currentField;
@property (weak, nonatomic) IBOutlet UITextField *txtOrg;

@property (strong,nonatomic) NSString *selectorg;

-(void)searchData:(NSString *)caseno
        startDate:(NSString *)startdate
          endDate:(NSString *)enddate
      permitOrgId:(NSString *)permitOrgId;
- (IBAction)btnSearch:(id)sender;
- (IBAction)prmitEditEnd:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txtCaseno;

@end
