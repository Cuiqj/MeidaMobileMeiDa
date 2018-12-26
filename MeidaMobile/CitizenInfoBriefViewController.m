//
//  CitizenInfoBriefViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CitizenInfoBriefViewController.h"
#import "CaseInquire.h"

@interface CitizenInfoBriefViewController ()
@property (nonatomic,retain) UIPopoverController *autoNumberPicker;
@property (nonatomic,assign) AutoNumberPickerType pickerType;
-(void)pickerPresentForIndex:(AutoNumberPickerType)iIndex fromRect:(CGRect)rect;
@end

@implementation CitizenInfoBriefViewController
@synthesize textAutoNumber = _textAutoNumber;
@synthesize textParty = _textParty;
@synthesize textNexus = _textNexus;
@synthesize textSex = _textSex;
@synthesize textAge = _textAge;
@synthesize textCardNO = _textCardNO;
@synthesize textAddress = _textAddress;
@synthesize textOrgName = _textOrgName;
@synthesize textProfession = _textProfession;
@synthesize textOrgPrincipal = _textOrgPrincipal;
@synthesize textTelNumber = _textTelNumber;
@synthesize textPostalCode = _textPostalCode;
@synthesize textAutoAddress = _textAutoAddress;
@synthesize textCarOwner = _textCarOwner;
@synthesize textCarOwernAddress = _textCarOwernAddress;
@synthesize caseID =_caseID;
@synthesize delegate=_delegate;
@synthesize autoNumberPicker=_autoNumberPicker;
@synthesize pickerType=_pickerType;

- (void)viewDidLoad
{
    self.textNexus.text=@"当事人";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextAutoNumber:nil];
    [self setTextParty:nil];
    [self setTextSex:nil];
    [self setTextNexus:nil];
    [self setTextAge:nil];
    [self setTextCardNO:nil];
    [self setTextAddress:nil];
    [self setTextOrgName:nil];
    [self setTextProfession:nil];
    [self setTextOrgPrincipal:nil];
    [self setTextTelNumber:nil];
    [self setTextPostalCode:nil];
    [self setTextAutoAddress:nil];
    [self setTextCarOwernAddress:nil];
    [self setTextCarOwner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//点击textField出现软键盘，为防止软键盘遮挡，上移scrollview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate scrollViewNeedsMove];
}

//车号仅可选择，不可编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==1000 || textField.tag==1001) {
        return NO;
    } else {
        return YES;
    }
}


//询问人类型1001
- (IBAction)showPicker:(id)sender{
    switch ([(UITextField *)sender tag]) {
        //弹出车号选择    
        case 1000:
            [self pickerPresentForIndex:kAutoNumber fromRect:[(UITextField*)sender frame]];
            break;
        //弹出人员类型选择    
        case 1001:
            [self pickerPresentForIndex:kNexus fromRect:[(UITextField*)sender frame]];
            break;
        //弹出车主选择    
        case 1002:
            [self pickerPresentForIndex:kCarOwner fromRect:[(UITextField*)sender frame]];
            break;
        default:
            break;
    }
    
}


//弹窗
-(void)pickerPresentForIndex:(AutoNumberPickerType)iIndex fromRect:(CGRect)rect{
    if (([_autoNumberPicker isPopoverVisible]) && (self.pickerType==iIndex)) {
        [_autoNumberPicker dismissPopoverAnimated:YES];
    } else {
        self.pickerType=iIndex;
        AutoNumerPickerViewController *pickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate=self;
        pickerVC.caseID=_caseID;
        pickerVC.pickerType=iIndex;
        _autoNumberPicker=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        if (iIndex==kNexus) {
            _autoNumberPicker.popoverContentSize=CGSizeMake(130, 176);
        }
        [_autoNumberPicker presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.popOver=_autoNumberPicker;
    }
}

//显示所选车号
-(void)setAutoNumberText:(NSString *)aAuotNumber{
    switch (self.pickerType) {
        case kAutoNumber:
        {
            [self saveCitizenInfoForCase:self.caseID];
            if (![self.textAutoNumber.text isEqualToString:aAuotNumber]) {
                self.textAutoNumber.text=aAuotNumber;
                [self loadCitizenInfoForCase:self.caseID autoNumber:aAuotNumber andNexus:@"当事人"];
                [self.delegate  setAutoNumber:aAuotNumber];
            }
        }
            break;
        case kNexus:
        {
            [self saveCitizenInfoForCase:self.caseID];
            if ([self.textAutoNumber.text isEmpty]) {
                self.textNexus.text=aAuotNumber;
            } else {
                [self loadCitizenInfoForCase:self.caseID autoNumber:self.textAutoNumber.text andNexus:aAuotNumber];
            }            
        }
            break;
        case kCarOwner:
            self.textCarOwner.text=aAuotNumber;
            break;
        default:
            break;
    }
}


-(void)saveCitizenInfoForCase:(NSString *)caseID{
    self.caseID=caseID;
    //NSString *aAutoNumber=_textAutoNumber.text;
    //和CaseViewController页面保持一致，必须保存大写，不然会导致重复保存，因为是按车号判断数据库是否已存在相应的当事人信息
    NSString *aAutoNumber=[_textAutoNumber.text uppercaseString];
    if ([aAutoNumber isEmpty]) {
        aAutoNumber=[self.delegate getAutoNumberDelegate];
    }
    aAutoNumber=[aAutoNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![aAutoNumber isEmpty] && ![self.textParty.text isEmpty]) {
        Citizen *citizen=[Citizen citizenForName:aAutoNumber nexus:self.textNexus.text case:caseID];
        if (citizen==nil){
            citizen=[Citizen newDataObjectWithEntityName:@"Citizen"];//[[Citizen alloc] initWithEntity:entity 
        }
        citizen.automobile_number=aAutoNumber;
        citizen.proveinfo_id=caseID;
        citizen.party=_textParty.text == nil? @"": _textParty.text;
        switch (_textSex.selectedSegmentIndex) {
            case 0:
                citizen.sex=@"男";
                break;
            case 1:
                citizen.sex=@"女";
                break;
            default:
                break;
        }
        citizen.nationality=@"中国";
        citizen.nation=@"汉";
        citizen.nexus=self.textNexus.text;
        citizen.age=[NSNumber numberWithInteger:_textAge.text.integerValue];
        citizen.card_no=_textCardNO.text;
        citizen.address=_textAddress.text;
        citizen.org_name=_textOrgName.text == nil?@"":_textOrgName.text;
        citizen.org_principal_duty = _textProfession.text  == nil?@"":_textProfession.text;
        citizen.profession = @"";// 改为空,默认不为司机 zhenlintie 2014-04-01
        
        //法人代表
        citizen.org_principal=_textOrgPrincipal.text;
        citizen.tel_number=_textTelNumber.text;
        citizen.postalcode=_textPostalCode.text;
        citizen.automobile_address=_textAutoAddress.text;
        citizen.carowner=_textCarOwner.text;
        if ([citizen.carowner isEqualToString:@"当事人"]) {
            citizen.patry_type=@"车主";
        }
        citizen.carowner_address=_textCarOwernAddress.text;
        
        CaseInquire* caseInquire = [CaseInquire inquireForCase:self.caseID];
        if (caseInquire) {
            caseInquire.answerer_name = citizen.party;
            caseInquire.relation=citizen.nexus;
            caseInquire.sex=citizen.sex;
            caseInquire.age=citizen.age;
            caseInquire.company_duty=[NSString stringWithFormat:@"%@ %@",citizen.org_name?citizen.org_name:@"",citizen.org_principal_duty?citizen.org_principal_duty:@""];
            caseInquire.phone=citizen.tel_number;
            caseInquire.postalcode=citizen.postalcode;
            caseInquire.address=citizen.address;
        }
        
        [[AppDelegate App] saveContext];
    }
}

-(void)loadCitizenInfoForCase:(NSString *)caseID autoNumber:(NSString *)aAutoNumber andNexus:(NSString *)nexus{
   
    //add by 李晓明 加载数据前需要清除旧数据
    {
        self.textNexus.text=@"";
        _textParty.text=@"";
        _textSex.selectedSegmentIndex=0;
        _textAge.text=@"";
        _textCardNO.text=@"";
        _textAddress.text=@"";
        _textOrgName.text=@"";
        _textProfession.text=@"";
        _textOrgPrincipal.text=@"";
        _textTelNumber.text=@"";
        _textPostalCode.text=@"";
        _textAutoAddress.text=@"";
        _textCarOwner.text=@"";
        _textCarOwernAddress.text=@"";
    }
    
    aAutoNumber=[aAutoNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    _caseID=caseID;
    _textAutoNumber.text=aAutoNumber;
    _textSex.selectedSegmentIndex=0;
    self.textNexus.text=nexus;
    if (![aAutoNumber isEmpty]) {
        Citizen *citizen=[Citizen citizenForName:aAutoNumber nexus:nexus case:caseID];
        if (citizen){
            _textParty.text=citizen.party;
            if([citizen.sex isEqualToString:@"男"]){
                _textSex.selectedSegmentIndex=0;
            } else if ([citizen.sex isEqualToString:@"女"]) {
                _textSex.selectedSegmentIndex=1;
            }
            _textAge.text=(citizen.age.integerValue==0)?@"":[NSString stringWithFormat:@"%d",citizen.age.integerValue];
            _textCardNO.text=citizen.card_no;
            _textAddress.text=citizen.address;
            _textOrgName.text=citizen.org_name;
            _textProfession.text=citizen.org_principal_duty;
            
            //法定代表人
            _textOrgPrincipal.text=citizen.org_principal;
            _textTelNumber.text=citizen.tel_number;
            _textPostalCode.text=citizen.postalcode;
            _textAutoAddress.text=citizen.automobile_address;
            _textCarOwner.text=citizen.carowner;
            _textCarOwernAddress.text=citizen.carowner_address;
        } else {
            for (UITextField *text in [self.view subviews]) {
                if ([text isKindOfClass:[UITextField class]]) {
                    text.text=@"";
                }
            }
            self.textAutoNumber.text=aAutoNumber;
            self.textNexus.text=nexus;
        }
    }
}

-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    self.textNexus.text=@"当事人";
}

@end
