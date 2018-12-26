//
//  CitizenInfoBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CaseIDHandler.h"
#import "AutoNumerPickerViewController.h"
#import "Citizen.h"

@interface CitizenInfoBriefViewController : UIViewController<UITextFieldDelegate,AutoNumberPickerDelegate>
- (IBAction)showPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textAutoNumber;
@property (weak, nonatomic) IBOutlet UITextField *textParty;


@property (weak, nonatomic) IBOutlet UITextField *textNexus;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textSex;
@property (weak, nonatomic) IBOutlet UITextField *textAge;
@property (weak, nonatomic) IBOutlet UITextField *textCardNO;
@property (weak, nonatomic) IBOutlet UITextField *textAddress;
@property (weak, nonatomic) IBOutlet UITextField *textOrgName;
@property (weak, nonatomic) IBOutlet UITextField *textProfession;

//法定代表人
@property (weak, nonatomic) IBOutlet UITextField *textOrgPrincipal;
@property (weak, nonatomic) IBOutlet UITextField *textTelNumber;
@property (weak, nonatomic) IBOutlet UITextField *textPostalCode;
@property (weak, nonatomic) IBOutlet UITextField *textAutoAddress;
@property (weak, nonatomic) IBOutlet UITextField *textCarOwner;
@property (weak, nonatomic) IBOutlet UITextField *textCarOwernAddress;
@property (nonatomic,copy) NSString * caseID;
@property (nonatomic,weak) id<CaseIDHandler> delegate;


-(void)saveCitizenInfoForCase:(NSString *)caseID;
-(void)loadCitizenInfoForCase:(NSString *)caseID autoNumber:(NSString *)aAutoNumber andNexus:(NSString *)nexus;
-(void)newDataForCase:(NSString *)caseID;
@end

