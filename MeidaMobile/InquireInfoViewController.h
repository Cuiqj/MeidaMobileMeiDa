//
//  InquireInfoViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseIDHandler.h"
#import "InquireAskSentence.h"
#import "InquireAnswerSentence.h"
#import "DataModelsHeader.h"
#import "AnswererPickerViewController.h"
#import "DateSelectController.h"

@interface InquireInfoViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,setAnswererDelegate,DatetimePickerHandler>
@property (nonatomic,weak) id<CaseIDHandler> delegate;
@property (nonatomic,copy) NSString *caseID;
@property (nonatomic,copy) NSString *answererName;

-(IBAction)btnAddRecord:(id)sender;
-(IBAction)btnDismiss:(id)sender;
-(IBAction)btnSave:(id)sender;
-(IBAction)textTouched:(UITextField *)sender;


@property (weak, nonatomic) IBOutlet UIButton *uiButtonAdd;
@property (weak, nonatomic) IBOutlet UITextView *inquireTextView;
@property (weak, nonatomic) IBOutlet UITextField *textAsk;
@property (weak, nonatomic) IBOutlet UITextField *textAnswer;
@property (weak, nonatomic) IBOutlet UITextField *textNexus;
@property (weak, nonatomic) IBOutlet UITextField *textParty;
@property (weak, nonatomic) IBOutlet UITextField *textLocality;
@property (weak, nonatomic) IBOutlet UITextField *textInquireDate;

//询问人
@property (weak, nonatomic) IBOutlet UITextField *textFieldInquirer;

//记录人
@property (weak, nonatomic) IBOutlet UITextField *textFieldRecorder;

@property (weak, nonatomic) IBOutlet UITableView *caseInfoListView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName;
-(void)loadInquireInfoForCase:(NSString *)caseID andNexus:(NSString *)aNexus;
-(void)saveInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName;

@end
