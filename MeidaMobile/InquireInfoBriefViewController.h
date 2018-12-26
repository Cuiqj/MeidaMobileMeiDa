//
//  InquireInfoBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoViewController.h"
#import "AnswererPickerViewController.h"

@interface InquireInfoBriefViewController : UIViewController<UITextFieldDelegate,setAnswererDelegate>

//被询问人类型
@property (weak, nonatomic) IBOutlet UITextField *textNexus;

//询问人
@property (weak, nonatomic) IBOutlet UITextField *textParty;

@property (weak, nonatomic) IBOutlet UITextView *inquireTextView;
@property (nonatomic,copy) NSString *caseID;

-(void)newDataForCase:(NSString *)caseID;

//被询问人类型方法
-(IBAction)textTouched:(id)sender;
-(void)loadInquireInfoForCase:(NSString *)caseID andAnswererName:(NSString *)aAnswererName;
@end
