//
//  CaseInquirePrinterViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-9.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CasePrintViewController.h"
#import "CaseInquire.h"

@interface CaseInquirePrinterViewController : CasePrintViewController

//add by lxm 2013.05.10
@property(nonatomic,weak)IBOutlet UITextField *textdate_inquired;
@property(nonatomic,weak)IBOutlet UITextField *textlocality;
@property(nonatomic,weak)IBOutlet UITextField *textinquirer_name;

@property(nonatomic,weak)IBOutlet UITextField *textrecorder_name;
@property(nonatomic,weak)IBOutlet UITextField *textanswerer_name;
@property(nonatomic,weak)IBOutlet UITextField *textsex;
@property(nonatomic,weak)IBOutlet UITextField *textage;

@property(nonatomic,weak)IBOutlet UITextField *textrelation;
@property(nonatomic,weak)IBOutlet UITextField *textcompany_duty;
@property(nonatomic,weak)IBOutlet UITextField *textphone;
@property(nonatomic,weak)IBOutlet UITextField *textaddress;
@property(nonatomic,weak)IBOutlet UITextField *textpostalcode;

@property(nonatomic,weak)IBOutlet UITextView *textinquiry_note;
@end
