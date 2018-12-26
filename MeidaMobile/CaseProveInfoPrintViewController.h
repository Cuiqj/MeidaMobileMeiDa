//
//  CaseProveInfoPrintViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CasePrintViewController.h"
#import "CaseProveInfo.h"
#import "DateSelectController.h"
#import "UserPickerViewController.h"

@interface CaseProveInfoPrintViewController : CasePrintViewController <DatetimePickerHandler, UserPickerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textcase_short_desc;//单行多文本框    案由

@property (nonatomic, weak) IBOutlet UITextField *textstart_date_time;//单行多文本框    勘验开始时间
@property (nonatomic, weak) IBOutlet UITextField *textend_date_time;//单行多文本框    勘验结束时间

@property (nonatomic, weak) IBOutlet UITextField *textprover_place;//单行多文本框    勘验场所
@property (nonatomic, weak) IBOutlet UITextField *textorganizer;//单行多文本框    组织者

@property (nonatomic, weak) IBOutlet UITextField *textprover1;//单行多文本框    勘查人1
@property (nonatomic, weak) IBOutlet UITextField *textprover1_duty;//单行多文本框    单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textprover2;//单行多文本框    勘查人2
@property (nonatomic, weak) IBOutlet UITextField *textprover2_duty;//单行多文本框    单位及职务

@property (nonatomic, weak) IBOutlet UITextField *textcitizen_name;//单行多文本框    当事人
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_duty;//单行多文本框    单位及职务

@property (nonatomic, weak) IBOutlet UITextField *textparty;//单行多文本框    当事人（代理人）
@property (nonatomic, weak) IBOutlet UITextField *textparty_org_duty;//单行多文本框    单位及职务

@property (nonatomic, weak) IBOutlet UITextField *textinvitee;//单行多文本框    被邀请人
@property (nonatomic, weak) IBOutlet UITextField *textInvitee_org_duty;//单行多文本框    被邀请人单位及职务

/*
 * add by lxm 2013.05.02
 */
@property (nonatomic, weak) IBOutlet UITextField *textrecorder;//单行多文本框    记录人
@property (nonatomic, weak) IBOutlet UITextField *textrecorder_duty;//单行多文本框    单位及职务

@property (nonatomic, weak) IBOutlet UITextView *textevent_desc;//多行多文本框    事件简况及现场描述

@property (nonatomic, weak) IBOutlet UITextField *textMark2;
@property (nonatomic, weak) IBOutlet UITextField *textMark3;

@property (nonatomic, assign) int textFieldTag;

- (IBAction)reFormEvetDesc:(UIButton *)sender;

- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo;

- (IBAction)selectDateAndTime:(id)sender;

- (IBAction)userSelect:(UITextField *)sender;
@end
