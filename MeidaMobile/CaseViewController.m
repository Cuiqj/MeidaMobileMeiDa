//
//  CaseViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseServiceFiles.h"
#import "Project.h"
#import "FileCode.h"
#import "AtonementNoticePrintViewController.h"
#import "CaseServiceReceiptViewController.h"
#import "AtonementNotice.h"


#define PHOTO(index) [self cachePhotoForIndex:index]

//载入对应照片，若有多张照片，则显示一个小序列文字标签，并在数秒后消失
#define LOADPHOTOS  if (self.photoArray.count>0) {\
self.labelPhotoIndex.hidden=NO;\
self.labelPhotoIndex.text=[[NSString alloc] initWithFormat:@"%d/%d",self.imageIndex+1,self.photoArray.count];\
self.labelPhotoIndex.alpha=1.0;\
}\



#define WIDTH_OFF_SET 654.0
#define HEIGHT_OFF_SET 0
#define SCROLLVIEW_WIDTH 654.0
#define SCROLLVIEW_HEIGHT 336.0

typedef enum {
    kUITextFieldTagWeather,
    kUITextFieldTagCarType,
    kUITextFieldTagDamageExtent,
    kUITextFieldTagDateTime,
    kUITextFieldTagCaseType
} kUITextFieldTag;

typedef enum {
    kUITableViewTagDocGenerated = 1000,
    kUITableViewTagDocTemplate
} kUITableViewTag;

@interface CaseViewController(){
    NSString *currentFileName;
    //弹窗标识，为0弹出天气选择，为1弹出车型选择，为2弹出损坏程度选择
    NSInteger touchedTag;
    NSDate *proveDate;
	BOOL changeStationEndKMFlag;
    BOOL changeStationEndMFlag;
}
- (void)loadCaseDocList:(NSString *)caseID;
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect;
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;

- (void)registerAsObserver;
- (void)unregiserAsObserver;
@property (nonatomic) kGDRMCaseType thisCaseType;
//案件照片路径
@property (nonatomic,retain) NSString *photoPath;

//案由数组
@property (nonatomic,retain) NSArray *caseDescArray;
//已有文书数组
@property (nonatomic,retain) NSArray *docListArray;
@property (nonatomic,retain) NSArray *docTmplArray;
//案件照片数组
@property (nonatomic,retain) NSMutableArray *photoArray;

@property (nonatomic,retain) UIPopoverController *caseInfoPickerpopover;
@property (nonatomic,retain) UIPopoverController *caseListpopover;
//设定文书查看状态，编辑模式或者PDF查看模式
@property (nonatomic,assign) DocPrinterState docPrinterState;

//路段ID
@property (nonatomic,copy) NSString *roadSegmentID;

@property (nonatomic,assign) RoadSegmentPickerState roadSegmentPickerState;

@property (nonatomic,assign) NSInteger imageIndex;
@property (nonatomic,retain) UIImageView *leftImageView;
@property (nonatomic,retain) UIImageView *midImageView;
@property (nonatomic,retain) UIImageView *rightImageView;

@end



@implementation CaseViewController

@synthesize infoView=_infoView;
@synthesize caseID=_caseID;
@synthesize textCasemark2=_textCasemark2;
@synthesize textCasemark3=_textCasemark3;
@synthesize textWeatheer=_textWeatheer;
@synthesize textSide = _textSide;
@synthesize textPlace = _textPlace;
@synthesize textRoadSegment = _textRoadSegment;
@synthesize textStationStartKM = _textStationStartKM;
@synthesize textStationStartM = _textStationStartM;
@synthesize textStationEndKM = _textStationEndKM;
@synthesize textStationEndM = _textStationEndM;
@synthesize textHappenDate = _textHappenDate;
@synthesize textAutoPattern = _textAutoPattern;
@synthesize textBadDesc = _textBadDesc;
@synthesize textAutoNumber = _textAutoNumber;
@synthesize labelPhotoIndex = _labelPhotoIndex;
@synthesize textCaseDesc = _textCaseDesc;
@synthesize segInfoPage = _segInfoPage;
@synthesize uiButtonEdit = _uiButtonEdit;
@synthesize uiButtonNewCase = _uiButtonNewCase;
@synthesize uiButtonSave = _uiButtonSave;
@synthesize uiButtonCamera = _uiButtonCamera;
@synthesize uiButtonPickFromLibrary = _uiButtonPickFromLibrary;
@synthesize docListView = _docListView;
@synthesize docTemplatesView = _docTemplatesView;
@synthesize caseInfo=_caseInfo;
@synthesize citizenInfo =_citizenInfo;
@synthesize accInfoBriefVC=_accInfoBriefVC;
@synthesize citizenInfoBriefVC=_citizenInfoBriefVC;
@synthesize inquireInfoBriefVC=_inquireInfoBriefVC;
@synthesize deformInfoVC=_deformInfoVC;
@synthesize paintBriefVC=_paintBriefVC;
@synthesize needsMove=_needsMove;
@synthesize caseListpopover=_caseListpopover;
@synthesize caseInfoPickerpopover=_caseInfoPickerpopover;
@synthesize caseDescArray=_caseDescArray;
@synthesize docListArray=_docListArray;
@synthesize docTmplArray=_docTmplArray;
@synthesize docPrinterState=_docPrinterState;
@synthesize roadSegmentID = _roadSegmentID;
@synthesize roadSegmentPickerState = _roadSegmentPickerState;

@synthesize inspectionID = _inspectionID;
@synthesize roadInspectVC = _roadInspectVC;

#pragma mark - init
- (NSString *)caseID{
    if (_caseID==nil) {
        _caseID=@"";
    }
    return _caseID;
}

-(NSArray *)caseDescArray{
    if (_caseDescArray==nil) {
        _caseDescArray=[NSArray newCaseDescArray];
    }
    return _caseDescArray;
}


-(NSArray*)docTmplArray{
    if (_thisCaseType == kGDRMCaseTypeCompensation)
        _docTmplArray = [CaseDocuments allDocumentShortNamesForCaseTypeID:CaseTypeIDPei];
    else
        _docTmplArray = [CaseDocuments allDocumentShortNamesForCaseTypeID:CaseTypeIDFa];
    return _docTmplArray;
}

- (NSMutableArray *)photoArray{
    if (_photoArray==nil) {
        _photoArray=[[NSMutableArray alloc] initWithCapacity:1];
    }
    return _photoArray;
}

- (UIImageView *)leftImageView{
    if (_leftImageView==nil) {
        _leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)midImageView{
    if (_midImageView==nil) {
        _midImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _midImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _midImageView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView==nil) {
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH*2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	changeStationEndKMFlag = FALSE;
    changeStationEndMFlag = FALSE;

	// Do any additional setup after loading the view.
    currentFileName=@"";
    self.caseInfo=nil;
    self.citizenInfo=nil;
    proveDate=nil;
    touchedTag=-1;
    self.thisCaseType = kGDRMCaseTypeCompensation;
    
    FileCode *peiFileCode = [FileCode fileCodeWithPredicateFormat:@"赔补偿案件编号"];
    NSString *orgNamePrefix = peiFileCode.organization_code;
    NSString *payTypePrefix = @"赔";
    [self.payLabel setText:[NSString stringWithFormat:@"%@%@",orgNamePrefix,payTypePrefix]];
    UILabel *casemarkPaddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    [casemarkPaddingView setText:peiFileCode.lochus_code];
    
    NSString *lochus_code = peiFileCode.lochus_code;
    if (lochus_code == nil || [lochus_code isEmpty]) {
        lochus_code = @"";
    }
    self.textCasemark3.text = lochus_code;
    
    
    //删除无用的案件数据
    [CaseInfo deleteEmptyCaseInfo];
    
    //分配必要的tag
    self.textWeatheer.tag = kUITextFieldTagWeather;
    self.docListView.tag = kUITableViewTagDocGenerated;
    self.docTemplatesView.tag = kUITableViewTagDocTemplate;
    
    //界面初始化
    self.labelPhotoIndex.alpha=0.0;
    self.labelPhotoIndex.hidden=YES;
    
    UIFont *segFont = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.segInfoPage setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    self.infoView.layer.cornerRadius=4;
    self.infoView.layer.masksToBounds=YES;
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"案件信息-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *btnBlueImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonNewCase setBackgroundImage:btnBlueImage forState:UIControlStateNormal];
    
    //小按钮进入图片缓存，否则在旋转之后，显示将不正常
    UIImage *btnWhiteImage=[[UIImage imageNamed:@"小按钮.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonEdit setBackgroundImage:btnWhiteImage forState:UIControlStateNormal];
    [self.uiButtonEdit setAlpha:0.0];
    [self.uiButtonEdit setHidden:YES];
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    UIImage *btnYelloImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonSave setBackgroundImage:btnYelloImage forState:UIControlStateNormal];
    
    //事故信息页面初始化
    self.accInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AccidentBriefInfo"];
    self.accInfoBriefVC.delegate=self;
    self.accInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    [self.infoView addSubview:self.accInfoBriefVC.view];
    self.infoView.contentMode=UIViewContentModeLeft;
    self.infoView.bounces=NO;
    self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    self.infoView.contentInset=UIEdgeInsetsZero;
    
    //当事人信息页面初始化
    self.citizenInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CitizenBriefInfo"];
    self.citizenInfoBriefVC.delegate=self;
    self.citizenInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, 500.0);
    
    //勘验草图显示页面初始化
    self.paintBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PaintBriefInfo"];
    self.paintBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    //询问笔录页面初始化
    self.inquireInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"InquireBriefInfo"];
    self.inquireInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    
    //赔补偿清单页面初始化
    self.deformInfoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeformBriefInfo"];
    self.deformInfoVC.delegate=self;
    self.deformInfoVC.viewLocal=0;
    self.deformInfoVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    
    //默认选中事故信息页面
    self.segInfoPage.selectedSegmentIndex=0;
    
    [self.uiButtonCamera setHidden:YES];
    [self.uiButtonPickFromLibrary setHidden:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.needsMove=NO;
    
    self.textAutoNumber.text = [self.textAutoNumber.text uppercaseString];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerAsObserver];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self unregiserAsObserver];
    //生成巡查记录
    if (self.roadInspectVC && [[self.navigationController visibleViewController] isEqual:self.roadInspectVC]) {
        if (![self.inspectionID isEmpty]) {
            [self.roadInspectVC createRecodeByCaseID:self.caseID];
            [self setInspectionID:nil];
            [self setRoadInspectVC:nil];
        }
    }
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:NO];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [[self.infoView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setInfoView:nil];
    [self setCaseID:nil];
    [self setTextCasemark2:nil];
    [self setTextCasemark3:nil];
    [self setTextWeatheer:nil];
    [self setTextSide:nil];
    [self setTextPlace:nil];
    [self setTextRoadSegment:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    [self setTextStationEndKM:nil];
    [self setTextStationEndM:nil];
    [self setTextHappenDate:nil];
    [self setTextAutoPattern:nil];
    [self setTextBadDesc:nil];
    [self setTextAutoNumber:nil];
    [self setTextCaseDesc:nil];
    [self setSegInfoPage:nil];
    
    [self setUiButtonEdit:nil];
    [self setUiButtonNewCase:nil];
    [self setUiButtonSave:nil];
    
    [self setCaseInfo:nil];
    [self setCitizenInfo:nil];
    
    [self setAccInfoBriefVC:nil];
    [self setCitizenInfoBriefVC:nil];
    [self setInquireInfoBriefVC:nil];
    [self setDeformInfoVC:nil];
    [self setPaintBriefVC:nil];
    
    [self setRoadSegmentID:nil];
    [self setCaseListpopover:nil];
    [self setCaseInfoPickerpopover:nil];
    [self setCaseDescArray:nil];
    [self setDocListArray:nil];
    [self setDocListView:nil];
    [self setDocTemplatesView:nil];
    [self setUiButtonCamera:nil];
    [self setUiButtonPickFromLibrary:nil];
    [self setLabelPhotoIndex:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toCaseDocument"]){
        CaseDocumentsViewController *documentsVC=segue.destinationViewController;
        documentsVC.fileName=currentFileName;
        documentsVC.caseID=self.caseID;
        documentsVC.docPrinterState=self.docPrinterState;
        documentsVC.docReloadDelegate=self;
    } else if ([segueIdentifier isEqualToString:@"toCitizenListView"]) {
        CitizenListViewController *clVC=segue.destinationViewController;
        clVC.delegate=self;
        clVC.caseID=self.caseID;
        clVC.citizenListPopover=[(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segueIdentifier isEqualToString:@"toCaseDescList"]) {
        CaseDescListViewController *cdlVC=segue.destinationViewController;
        cdlVC.delegate=self;
        cdlVC.caseID=self.caseID;
        cdlVC.popOver=[(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showdate:self.textHappenDate.text];
    } else if ([segueIdentifier isEqualToString:@"toDeformInfoEditor"]) {
        DeformationInfoViewController *diVC=segue.destinationViewController;
        diVC.caseID=self.caseID;
    } else if ([segueIdentifier isEqualToString:@"toInquireInfoEditor"]) {
        InquireInfoViewController *iiVC=segue.destinationViewController;
        iiVC.caseID=self.caseID;
        iiVC.delegate=self;
        iiVC.answererName=self.inquireInfoBriefVC.textParty.text;
    } else if ([segueIdentifier isEqualToString:@"toPaintEditor"]) {
        CasePaintViewController *cpVC=segue.destinationViewController;
        cpVC.delegate = self;
        cpVC.caseID=self.caseID;
    }
}


#pragma mark - textField Delegate
//使日期选择框不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == kUITextFieldTagDateTime |
        textField.tag == kUITextFieldTagCaseType) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number=0;
    if (tableView.tag==kUITableViewTagDocGenerated) {
        number=self.docListArray.count;
    } else if (tableView.tag==kUITableViewTagDocTemplate) {
        number=self.docTmplArray.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag==kUITableViewTagDocTemplate) {
        static NSString *CellIdentifier = @"DocTemplatesCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text=self.docTmplArray[indexPath.row];
    } else if (tableView.tag==kUITableViewTagDocGenerated) {
        static NSString *CellIdentifier = @"DocListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text=[self.docListArray objectAtIndex:indexPath.row];
    }
    return cell;
}

//点击进入文书编辑和打印页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==kUITableViewTagDocTemplate) {
        self.docPrinterState=1;
    } else if (tableView.tag==kUITableViewTagDocGenerated) {
        self.docPrinterState=kPDFView;
    }
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    currentFileName=myCell.textLabel.text;
    if (![self.caseID isEmpty]) {
        [self saveCaseInfoForCase:self.caseID];
    }
    [self performSegueWithIdentifier:@"toCaseDocument" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - IBActions

//各信息页面切换
- (IBAction)changeInfoPage:(UISegmentedControl *)sender {
    for(UIView *subview in [self.infoView subviews]) {
        [subview removeFromSuperview];
    }
    
    //删除infoView上的所有手势，防止在非照片页面误操作
    for (UIGestureRecognizer *gesture in [self.infoView gestureRecognizers]) {
        [gesture removeTarget:self action:@selector(showDeleteMenu:)];
    }
    
    [self.labelPhotoIndex setAlpha:0.0];
    [self.labelPhotoIndex setHidden:YES];
    if (sender.selectedSegmentIndex!=5) {
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        if (sender.selectedSegmentIndex==1) {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 500.0);
        } else {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        [self.infoView setContentOffset:CGPointZero animated:NO];
    } else {
        [self.infoView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        self.infoView.delegate=self;
        self.infoView.pagingEnabled=YES;
        self.infoView.contentSize=CGSizeMake(self.infoView.bounds.size.width*3, self.infoView.bounds.size.height);
        [self.infoView setContentOffset:CGPointMake(self.infoView.bounds.size.width, 0) animated:NO];
    }
    switch (sender.selectedSegmentIndex) {
            //事故信息
        case 0:{
            if (![self.accInfoBriefVC.caseID isEqualToString:self.caseID]) {
                [self.accInfoBriefVC loadDataForCase:self.caseID];
            }
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.accInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //当事人信息
        case 1:{
            if (![self.citizenInfoBriefVC.caseID isEqualToString:self.caseID]  && [self.textAutoNumber.text isEmpty]) {
                [self.citizenInfoBriefVC newDataForCase:self.caseID];
            } else {

                [self.citizenInfoBriefVC loadCitizenInfoForCase:self.caseID autoNumber:self.textAutoNumber.text  andNexus:@"当事人"];
            }
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.citizenInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //赔补偿清单
        case 2:{
            self.deformInfoVC.caseID=self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.deformInfoVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //询问笔录
        case 3:{
            self.inquireInfoBriefVC.caseID=self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.inquireInfoBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //现场勘验图
        case 4:{
            self.paintBriefVC.caseID = self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.uiButtonEdit setHidden:NO];
                                [self.uiButtonEdit setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.paintBriefVC.view];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
            //现场照片
        case 5:{
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.infoView addSubview:self.leftImageView];
                                [self.infoView addSubview:self.midImageView];
                                [self.infoView addSubview:self.rightImageView];
                                LOADPHOTOS;
                                self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
                                self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
                                self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonCamera setHidden:NO];
                                [self.uiButtonCamera setAlpha:1.0];
                                [self.uiButtonPickFromLibrary setHidden:NO];
                                [self.uiButtonPickFromLibrary setAlpha:1.0];
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
                                [self.infoView addGestureRecognizer:longPressGesture];
                            }];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        }
            break;
        default:
            break;
    }
}


//显示各信息详细编辑页面按钮
- (IBAction)btnClickToEditor:(id)sender {
    [[AppDelegate App]saveContext];
    switch ([self.segInfoPage selectedSegmentIndex]) {
        case 2:
            [self performSegueWithIdentifier:@"toDeformInfoEditor" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"toInquireInfoEditor" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"toPaintEditor" sender:self];
        default:
            break;
    }
}

//新增案件按钮
- (IBAction)btnNewCase:(id)sender;{
    self.caseInfo=nil;
    self.citizenInfo=nil;
    self.caseDescArray=nil;
    [self.photoArray removeAllObjects];
    self.roadSegmentID=@"";
    self.caseInfo=[CaseInfo newDataObjectWithEntityName:@"CaseInfo"];
    
    NSString *caseIDString = self.caseInfo.myid;
    self.caseID = caseIDString;
    
    //在这里所有UITextField的内容被清空了，任何UITextField的内容填写都要放在此段代码之后
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    
    proveDate=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString=[dateFormatter stringFromDate:proveDate];
    NSString *yearString=[dateString substringToIndex:4];
    self.textCasemark2.text=yearString;

    self.textHappenDate.text=dateString;
    
    NSInteger caseMark3InCoreData = [CaseInfo maxCaseMark3];
    NSInteger caseMark3InDefaults=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark3"].integerValue;
    NSString *caseMark3 = [[NSString alloc] initWithFormat:@"%d",MAX(caseMark3InDefaults, caseMark3InCoreData)+1];
    NSString *oldCaseMark2=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark2"];
    if (yearString.integerValue>oldCaseMark2.integerValue) {
        caseMark3=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2"];
    [[NSUserDefaults standardUserDefaults] setObject:caseMark3 forKey:@"CaseMark3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     FileCode *peiFileCode = [FileCode fileCodeWithPredicateFormat:@"赔补偿案件编号"];
    NSString *lochus_code = peiFileCode.lochus_code;
    if (lochus_code == nil || [lochus_code isEmpty]) {
        lochus_code = @"";
    }
    self.textCasemark3.text = [NSString stringWithFormat:@"%@%@",lochus_code,caseMark3];
    
    [self.accInfoBriefVC newDataForCase:caseIDString];
    [self.citizenInfoBriefVC newDataForCase:caseIDString];
    [self.inquireInfoBriefVC newDataForCase:caseIDString];
    [self.paintBriefVC.Image setImage:nil];
    
    [self.segInfoPage setSelectedSegmentIndex:0];
    [self changeInfoPage:self.segInfoPage];
    
    _docListArray = [NSArray array];
    [_docListView beginUpdates];
    [_docListView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [_docListView insertSections:[NSIndexSet indexSetWithIndex:0]  withRowAnimation:UITableViewRowAnimationFade];
    [_docListView endUpdates];
    
    [self setThisCaseType:kGDRMCaseTypeCompensation]; //会触发KVO
}

//弹出以往案件选择框
- (IBAction)btnPreviousCase:(id)sender {
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:YES];
    } else {
        CaseListViewController *caseListVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseListView"];
        self.caseListpopover=[[UIPopoverController alloc] initWithContentViewController:caseListVC];
        caseListVC.delegate=self;
        caseListVC.myPopover=self.caseListpopover;
        [self.caseListpopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

//弹窗
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect{
    if ((iIndex==touchedTag) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        touchedTag=iIndex;
        CaseInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
        acPicker.pickerType=iIndex;
        acPicker.delegate=self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        switch (iIndex) {
                //case 0:{
            case kUITextFieldTagWeather:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(140, 264)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 140, 264)];
            }
                break;
                //case 1:{
            case kUITextFieldTagCarType:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(170,308)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 170, 308)];
            }
                break;
                //case 2:{
            case kUITextFieldTagDamageExtent:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(100, 176)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 100, 176)];
            }
                break;
            default:
                break;
        }
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.caseInfoPickerpopover;
    }
}

//弹出天气选择框
- (IBAction)selectWeather:(id)sender {
    [self pickerPresentForIndex:kUITextFieldTagWeather fromRect:[(UITextField*)sender frame]];
}



//弹出车辆类型选择框
- (IBAction)selectAutoMobilePattern:(id)sender {
    [self pickerPresentForIndex:kUITextFieldTagCarType fromRect:[(UITextField*)sender frame]];
}

//弹出损坏程度选择框
- (IBAction)selectBadDesc:(id)sender {
    [self pickerPresentForIndex:kUITextFieldTagDamageExtent fromRect:[(UITextField*)sender frame]];
}

//弹出车号选择框
- (IBAction)selectCitizen:(id)sender {
    if (![self.caseID isEmpty]) {
        [self performSegueWithIdentifier:@"toCitizenListView" sender:self];
    }
    
    UITextField * textNumaber = (UITextField *)sender;
    
    if (textNumaber.editing) {
    
        textNumaber.text = [textNumaber.text uppercaseString];
    }else
    {
        textNumaber.text = [textNumaber.text uppercaseString];
    }
}
//弹出案由选择
- (IBAction)selectCaseDesc:(id)sender {
    [self performSegueWithIdentifier:@"toCaseDescList" sender:self];
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender {
    [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
}

//保存案件信息按钮
- (IBAction)btnSaveCaseInfo:(id)sender {
    if (![self.textCasemark2.text isEmpty] && ![self.textCasemark3.text isEmpty]) {
        if ([self.caseID isEmpty]) {
            //            NSString *caseIDString=[NSString randomID];
            //            self.caseID=caseIDString;
            //            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            //            NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInfo" inManagedObjectContext:context];
            self.caseInfo=[CaseInfo newDataObjectWithEntityName:@"CaseInfo"];
            self.caseID = self.caseInfo.myid;
        }
        [self saveCaseInfoForCase:self.caseID];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCaseID" object:self userInfo:[NSDictionary dictionaryWithObject:self.caseID forKey:@"caseID"]];
    }
}

//选择路段级路段号
- (IBAction)selectRoadSegmet:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
}

//选择方向
- (IBAction)selectRoadSide:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
}

//选择位置
- (IBAction)selectRoadPlace:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState=state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(150, 243)];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.caseInfoPickerpopover;
    }
}

#pragma mark - CaseID Handler Delegate
//新打印文档后，重新载入文书列表
- (void)reloadDocuments{
    [self loadCaseDocList:self.caseID];
}

- (void)loadInquireForAnswerer:(NSString *)answererName{
    [self.inquireInfoBriefVC loadInquireInfoForCase:self.caseID andAnswererName:answererName];
}

//显示所选天气
- (void)setWeather:(NSString *)textWeather{
    self.textWeatheer.text=textWeather;
}

//显示所选车型
- (void)setAuotMobilePattern:(NSString *)textPattern{
    self.textAutoPattern.text=textPattern;
}

//显示所选损坏程度
- (void)setBadDesc:(NSString *)textBadDesc{
    self.textBadDesc.text=textBadDesc;
}

//显示所选车号，并载入相关车辆信息
- (void)setAutoNumber:(NSString *)textAutoNumber{
    
    textAutoNumber = [textAutoNumber uppercaseString];
    
    [self loadCitizenInfoForCase:self.caseID andAutoNumber:textAutoNumber];
}

//删除车辆信息时清空
- (void)clearAutoInfo{
    self.textAutoNumber.text=@"";
    self.textAutoPattern.text=@"";
    self.textBadDesc.text=@"";
    self.citizenInfo=nil;
    [self.citizenInfoBriefVC newDataForCase:self.caseID];
}

//已立案件delegate，以设定所选案件的caseID，并载入相关数据，并切换到事故信息页面
- (void)setCaseIDdelegate:(NSString *)caseID{
    
    //FIXME lxm 2013.05.09 不需要再保存一次
    //    if (![self.caseID isEmpty]) {
    //        [self btnSaveCaseInfo:nil];
    //    }
    
    if (![self.caseID isEmpty]) {
        [self btnSaveCaseInfo:nil];
    }
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        [self.labelPhotoIndex setAlpha:0.0];
        [self.labelPhotoIndex setHidden:YES];
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.accInfoBriefVC.view];
                            if (!self.uiButtonCamera.hidden) {
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                            }
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                            [self.uiButtonPickFromLibrary setHidden:YES];
                            [self.uiButtonCamera setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
    }
}

//显示所选时间
- (void)setDate:(NSString *)date{
    self.textHappenDate.text=date;
}

//为其他ViewController返回当前caseID
- (NSString *)getCaseIDdelegate{
    return self.caseID;
}

//返回当前选定的案由
- (NSArray *)getCaseDescArrayDelegate{
    return self.caseDescArray;
}

//返回当前选定车号
- (NSString *)getAutoNumberDelegate{
    if (self.textAutoNumber.text != nil) {
        return [self.textAutoNumber.text uppercaseString];
    } else {
        return @"";
    }
}

//设定案由
- (void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray{
    self.caseDescArray=aCaseDescArray;
    NSString *caseFullDesc=@"";
    for (CaseDescString *temp in aCaseDescArray) {
        if (temp.isSelected) {
            if ([caseFullDesc isEmpty]) {
                caseFullDesc=[caseFullDesc stringByAppendingString:temp.caseDesc];
            } else {
                caseFullDesc=[caseFullDesc stringByAppendingFormat:@"，%@",temp.caseDesc];
            }
        }
    }
    self.textCaseDesc.text=caseFullDesc;
}

//根据caseID删除以往案件
- (void)deleteCaseAllDataForCase:(NSString *)caseID{
    if ([self.caseID isEqualToString:caseID]) {
        self.caseID=@"";
        self.roadSegmentID=@"";
        for (UITextField *text in [self.view subviews]) {
            if ([text isKindOfClass:[UITextField class]]) {
                text.text=@"";
            }
        }
        [self.accInfoBriefVC newDataForCase:@""];
        [self.citizenInfoBriefVC newDataForCase:@""];
        self.caseInfo=nil;
        self.caseDescArray=nil;
        self.citizenInfo=nil;
    }
    [self deleteDataForEntityName:@"CaseProveInfo" andCaseID:caseID];
    [self deleteDataForEntityName:@"Citizen" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseDeformation" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseInquire" andCaseID:caseID];
    [CaseInfo deleteCaseInfoForID:caseID];
    [self deleteDataForEntityName:@"ParkingNode" andCaseID:caseID];
    [self deleteDataForEntityName:@"CaseDocuments" andCaseID:caseID];
    [self deleteDataForEntityName:@"CasePhoto" andCaseID:caseID];
}

//根据案号删除对应表数据
- (void)deleteDataForEntityName:(NSString *)aEntiyName andCaseID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:aEntiyName inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    if ([aEntiyName isEqualToString:@"Citizen"] || [aEntiyName isEqualToString:@"CaseDeformation"] || [aEntiyName isEqualToString:@"CaseInquire"]) {
        predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",caseID];
    } else {
        predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    }
    [fetchRequest setPredicate:predicate];
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        for (NSManagedObject *tableInfo in fetchResult) {
            [context deleteObject:tableInfo];
        }
    }
    [[AppDelegate App] saveContext];
}

#pragma mark - ListSelectPopoverDelegate
- (void)setSelectData:(NSString *)data{
    [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
}

#pragma mark - RoadPickerDelegate
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName{
    self.roadSegmentID=aRoadSegmentID;
    self.textRoadSegment.text=roadName;
}

- (void)setRoadPlace:(NSString *)place{
    self.textPlace.text=place;
}

- (void)setRoadSide:(NSString *)side{
    self.textSide.text=side;
}

#pragma mark - ReloadPaintDelegate
- (void)reloadPaint{
    if (self.segInfoPage.selectedSegmentIndex == 4) {
        [self.paintBriefVC loadCasePaint];
    }
}

#pragma mark - keyboard show&hide events
//左下输入框delegate，设定scrollview需要上移
- (void)scrollViewNeedsMove{
    self.needsMove=YES;
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.needsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,302,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        if (self.segInfoPage.selectedSegmentIndex==1) {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, 500);
        } else {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.needsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,18,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        CGSize tempSize;
        if (self.segInfoPage.selectedSegmentIndex==1) {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, 500);
        } else {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        tempSize=CGSizeMake(tempSize.width, keyboardEndFrame.size.width - (704 - 18 - self.infoView.frame.size.height) + tempSize.height);
        self.infoView.contentSize=tempSize;
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//左上普通文本框点击时，scrollview不移动
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.needsMove=NO;
}


#pragma mark - methods save&load
//根据caseID载入相应案件数据
- (void)loadCaseInfoForCase:(NSString *)caseID{
    self.caseInfo=nil;
    self.caseID=caseID;
    self.caseInfo = [CaseInfo caseInfoForID:caseID];
    if (self.caseInfo) {
        self.thisCaseType = [self.caseInfo.case_type_id integerValue];
        self.textCasemark2.text=self.caseInfo.case_mark2;
        FileCode *peiFileCode = [FileCode fileCodeWithPredicateFormat:@"赔补偿案件编号"];
        NSString *lochus_code = peiFileCode.lochus_code;
        if (lochus_code == nil || [lochus_code isEmpty]) {
            lochus_code = @"";
        }
        self.textCasemark3.text = [NSString stringWithFormat:@"%@%@",lochus_code,self.caseInfo.case_mark3];
        self.textWeatheer.text=self.caseInfo.weater;
        self.textRoadSegment.text=[RoadSegment roadNameFromSegment:self.caseInfo.roadsegment_id];
        self.roadSegmentID=self.caseInfo.roadsegment_id;
        self.textPlace.text=self.caseInfo.place;
        self.textSide.text=self.caseInfo.side;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textHappenDate.text=[formatter stringFromDate:self.caseInfo.happen_date];
        self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
        self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
        self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
        self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
    }
    [self loadCitizenInfoForCase:caseID andAutoNumber:@""];
    [self loadCaseProveInfoForCase:caseID];
    [self loadCaseDocList:caseID];
    [self loadCasePhotoForCase:caseID];
    [self.accInfoBriefVC loadDataForCase:caseID];
}

//将当前页面显示数据保存至该caseID下
- (void)saveCaseInfoForCase:(NSString *)caseID{
    self.caseInfo.myid=caseID;
    self.caseInfo.casedeformation_remark=@"无";
    self.caseInfo.case_type_id = [NSString stringWithFormat:@"%d", self.thisCaseType];
    self.caseInfo.case_mark2=self.textCasemark2.text;
    NSArray *array = [self.textCasemark3.text componentsSeparatedByString:@"-"];
    if ([array count] >= 2 ) {
        self.caseInfo.case_mark3=[array objectAtIndex:1];
    }else {
        self.caseInfo.case_mark3 = self.textCasemark3.text;
    }
    self.caseInfo.weater=self.textWeatheer.text;
    self.caseInfo.side=self.textSide.text;
    self.caseInfo.place=self.textPlace.text;
    self.caseInfo.roadsegment_id=[NSString stringWithFormat:@"%d", [self.roadSegmentID intValue]];
    self.caseInfo.station_start=[NSNumber numberWithInteger:(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue)];
    self.caseInfo.station_end=[NSNumber numberWithInteger:(self.textStationEndKM.text.integerValue*1000+self.textStationEndM.text.integerValue)];
    if (self.caseInfo.station_end.integerValue == 0) {
        self.caseInfo.station_end = [self.caseInfo.station_start copy];
    }
    self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
    self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
    self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
    self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.caseInfo.happen_date=[formatter dateFromString:self.textHappenDate.text];
    [[AppDelegate App] saveContext];
    [self saveCaseProveInfoForCase:caseID];
    [self saveCitizenInfoForCase:caseID andAutoNumber:[self.textAutoNumber.text uppercaseString]];
    switch (self.segInfoPage.selectedSegmentIndex) {
        case 0:
            [self.accInfoBriefVC saveDataForCase:caseID];
            break;
        case 1:
            [self.citizenInfoBriefVC saveCitizenInfoForCase:caseID];
            break;
        default:
            break;
    }

    
}


//根据caseID保存勘验信息
/*
 - (void)saveCaseProveInfoForCase:(NSString *)caseID{
 CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
 if (!caseProveInfo) {
 caseProveInfo=[CaseProveInfo newDataObjectWithEntityName:@"CaseProveInfo"];
 caseProveInfo.caseinfo_id=caseID;
 if (proveDate == nil) {
 proveDate = [NSDate date];
 }
 caseProveInfo.start_date_time = proveDate;
 }
 
 NSString *caseDescID=@"";
 for (CaseDescString *temp in self.caseDescArray) {
 if (temp.isSelected) {
 if ([caseDescID isEmpty]) {
 caseDescID=[caseDescID stringByAppendingString:temp.caseDescID];
 } else {
 caseDescID=[caseDescID stringByAppendingFormat:@"#%@",temp.caseDescID];
 }
 }
 }
 caseProveInfo.case_desc_id=caseDescID;
 
 caseProveInfo.case_short_desc=self.textCaseDesc.text;
 [[AppDelegate App] saveContext];
 }
 */
//
- (void)saveCaseProveInfoForCase:(NSString *)caseID{
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:caseID];
    if (!caseProveInfo) {
        caseProveInfo=[CaseProveInfo newDataObjectWithEntityName:@"CaseProveInfo"];
        caseProveInfo.caseinfo_id=caseID;
        if (proveDate == nil) {
            proveDate = [NSDate date];
        }
        caseProveInfo.start_date_time = proveDate;
    }
    
    NSString *caseDescID=@"";
    for (CaseDescString *temp in self.caseDescArray) {
        if (temp.isSelected) {
            if ([caseDescID isEmpty]) {
                caseDescID=[caseDescID stringByAppendingString:temp.caseDescID];
            } else {
                caseDescID=[caseDescID stringByAppendingFormat:@"#%@",temp.caseDescID];
            }
        }
    }
    caseProveInfo.case_desc_id=caseDescID;
    
    //add by lxm 2013.05.09
    //生成案号
    //caseProveInfo.case_mark2 = self.textCasemark2.text;
    //caseProveInfo.case_mark3 = self.textCasemark3.text;
    
    caseProveInfo.case_short_desc=self.textCaseDesc.text;
   
//    caseProveInfo.case_short_desc = [NSString stringWithFormat:@"%@%@因交通事故%@", self.textAutoNumber.text, self.textAutoPattern.text, self.textCaseDesc.text];
    
    //self.text
    
    //add by lxm 2013.05.03
    //在案件编辑页面传入参数
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (caseProveInfo.start_date_time == nil) {
        caseProveInfo.start_date_time=[formatter dateFromString:self.textHappenDate.text];
    }
    if (caseProveInfo.end_date_time == nil) {
        caseProveInfo.end_date_time=[formatter dateFromString:self.textHappenDate.text];
    }
    
    
    // 勘验场所 添加桩号 zhenlintie 2014-04-01
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=self.textStationStartM.text.integerValue;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d",self.textStationStartKM.text.integerValue];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    if (self.textStationEndM.text.integerValue == 0 || self.textStationEndM.text.integerValue == self.textStationStartM.text.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@m",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=self.textStationEndM.text.integerValue;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",self.textStationEndKM.text.integerValue];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@m至K%@+%@m",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    if ([caseProveInfo.remark isEmpty] || caseProveInfo.remark == nil){
        caseProveInfo.remark = [NSString stringWithFormat:@"%@%@%@",self.textRoadSegment.text,self.textSide.text,stationString];
    }
    // 对案件文书打印初始化数据未完
    //FIXME 勘验人员的名字、单位职务获取？
    //caseProveInfo.prover1 = self;
    //caseProveInfo.prover1_org_duty = self;
    //caseProveInfo.prover2 = self ;
    //caseProveInfo.prover2_org_duty = self;
    
    //根据不同的nexus来获取名字、单位和职务
    Citizen *citizen1=[Citizen citizenForName:[self.textAutoNumber.text uppercaseString] nexus:@"当事人" case:caseID];
    caseProveInfo.citizen_name = citizen1.party;
    //caseProveInfo.citizen_org_duty = [NSString stringWithFormat:@"%@%@",[citizen1.org_name length]==0?@"":citizen1.org_name, [citizen1.org_principal_duty length]==0?@"":citizen1.org_principal_duty];
    
    Citizen *citizen2=[Citizen citizenForName:[self.textAutoNumber.text uppercaseString] nexus:@"当事人代表" case:caseID];
    if (citizen2) {
        caseProveInfo.organizer = citizen2.party;
        caseProveInfo.organizer_org_duty = [NSString stringWithFormat:@"%@%@",[citizen2.org_name length]==0?@"":citizen2.org_name, [citizen2.org_principal_duty length]==0?@"":citizen2.org_principal_duty];
    }
    
    Citizen *citizen3=[Citizen citizenForName:[self.textAutoNumber.text uppercaseString] nexus:@"被邀请人" case:caseID];
    if(citizen3){
        caseProveInfo.invitee = citizen3.party;
        caseProveInfo.invitee_org_duty = [NSString stringWithFormat:@"%@%@",[citizen3.org_name length]==0?@"":citizen3.org_name, [citizen3.org_principal_duty length]==0?@"":citizen3.org_principal_duty];
    }
    
    //FIXME 记录者的名字、单位职务获取？
    //caseProveInfo.recorder = self.;
    //caseProveInfo.recorder_org_duty = self;
    
    [[AppDelegate App] saveContext];
}

-(void)saveAtonementNoticeForCase:(NSString *)caseID{
    AtonementNotice *notice = nil;
    NSArray *noticeArray = [AtonementNotice AtonementNoticesForCase:caseID];
    if (noticeArray.count>0) {
        notice = [noticeArray objectAtIndex:0];
    } else {
        notice = [AtonementNotice newDataObjectWithEntityName:@"AtonementNotice"];
        notice.caseinfo_id = caseID;
        [AtonementNoticePrintViewController generateDefaultsForNotice:notice caseId:self.caseID];
        [[AppDelegate App] saveContext];
    }
}
-(void)saveCaseServiceReceiptForCase:(NSString *)caseID{
    if (![caseID isEmpty]) {
        CaseServiceReceipt *caseServiceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:caseID];
        if (caseServiceReceipt == nil) {
            caseServiceReceipt = [CaseServiceReceipt newCaseServiceReceiptForCase:caseID];
            [CaseServiceReceiptViewController generateDefaultInfo:caseServiceReceipt caseId:self.caseID];
        }
    }
}
//根据caseID载入勘验信息
- (void)loadCaseProveInfoForCase:(NSString *)caseID{
    CaseProveInfo *info = [CaseProveInfo proveInfoForCase:caseID];
    if (info) {
        self.textCaseDesc.text=info.case_short_desc;
        for (CaseDescString *caseDescString in self.caseDescArray) {
            caseDescString.isSelected=NO;
        }
        NSString *temp=info.case_desc_id;
        if (![temp isEmpty]) {
            NSArray *descIDArray=[temp componentsSeparatedByString:@"#"];
            for (NSString *descID in descIDArray) {
                for (CaseDescString *caseDesc in self.caseDescArray) {
                    if ([descID isEqualToString:caseDesc.caseDescID]) {
                        caseDesc.isSelected=YES;
                    }
                }
            }
        }
    }
}

//根据案件号和车牌号载入车辆及车主信息
- (void)loadCitizenInfoForCase:(NSString *)caseID andAutoNumber:(NSString *)aAutoNumber{
    self.citizenInfo=nil;
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    if ([aAutoNumber isEmpty]) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",caseID];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id == %@) AND (automobile_number == %@)",caseID,aAutoNumber];
        [fetchRequest setPredicate:predicate];
    }
    NSError *error=nil;
    NSMutableArray *fetchResult=[[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    if (fetchResult.count>0) {
        self.citizenInfo=[fetchResult objectAtIndex:0];
        self.textBadDesc.text=self.citizenInfo.bad_desc;
        self.textAutoNumber.text=self.citizenInfo.automobile_number;
        self.textAutoPattern.text=self.citizenInfo.automobile_pattern;
        if (self.segInfoPage.selectedSegmentIndex==1) {
            //modify by 李晓明 不需要再保存一次 2013.05.09
            //[self.citizenInfoBriefVC saveCitizenInfoForCase:caseID];
            
            [self.citizenInfoBriefVC loadCitizenInfoForCase:caseID autoNumber:aAutoNumber andNexus:@"当事人"];
        }
    } else {
        self.textBadDesc.text=@"";
        self.textAutoNumber.text=@"";
        self.textAutoPattern.text=@"";
    }
}

//保存车辆及车主信息；
- (void)saveCitizenInfoForCase:(NSString *)caseID andAutoNumber:(NSString *)aAutoNumber{
    aAutoNumber=[aAutoNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    aAutoNumber = [aAutoNumber uppercaseString];
    
    self.textAutoNumber.text=aAutoNumber;
    if (![aAutoNumber isEmpty] && aAutoNumber != nil) {
        if (!self.citizenInfo) {
            self.citizenInfo=[Citizen newDataObjectWithEntityName:@"Citizen"];
            self.citizenInfo.nexus=@"当事人";
        }
        self.citizenInfo.proveinfo_id=caseID;
        self.citizenInfo.automobile_pattern=self.textAutoPattern.text;
        NSString *autoNumberNew=self.textAutoNumber.text.uppercaseString;
        self.citizenInfo.automobile_number=autoNumberNew;
        if ([autoNumberNew length]>1) {
            NSString *provinceNew=[autoNumberNew substringToIndex:1];
            NSString *cityCodeNew=[autoNumberNew substringWithRange:NSMakeRange(1, 1)];
            NSString *autoNumberOriginal=self.citizenInfo.automobile_number;
            NSString *provinceOriginal=[autoNumberOriginal substringToIndex:1];
            NSString *cityCodeOriginal=[autoNumberOriginal substringWithRange:NSMakeRange(1, 1)];
            
            if ((![provinceNew isEqualToString:provinceOriginal]) || (![cityCodeNew isEqualToString:cityCodeOriginal])) {
                self.citizenInfo.automobile_address=[self.citizenInfo.automobile_number autoAddressFromAutoNumber];
            }
        }
        self.citizenInfo.bad_desc=self.textBadDesc.text;
        [[AppDelegate App] saveContext];
        if (self.citizenInfo != nil  && self.citizenInfo.party != nil && ![self.citizenInfo.party isEmpty]){
            [self saveAtonementNoticeForCase:caseID];
            [self saveCaseServiceReceiptForCase:caseID];
        }
    }
}

//载入案件已生成文书信息
- (void)loadCaseDocList:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",self.caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    self.docListArray=[temp valueForKeyPath:@"@distinctUnionOfObjects.document_name"];
    [self.docListView reloadData];
}

//载入案件对应的照片
- (void)loadCasePhotoForCase:(NSString *)caseID{
    [self.photoArray removeAllObjects];
    NSArray *tempArray=[CasePhoto casePhotosForCase:caseID];
    self.photoArray=[(NSArray *)[tempArray valueForKeyPath:@"photo_name"] mutableCopy];
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",caseID];
    self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
    self.imageIndex=0;
}


#pragma mark - Photo

- (IBAction)btnImageFromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
    }
}

- (IBAction)btnImageFromLibrary:(id)sender {
    [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.sourceType=sourceType;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self presentModalViewController:picker animated:YES];
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.caseInfoPickerpopover = popover;
        CGRect infoCenter=CGRectMake(self.infoView.center.x-5, self.infoView.center.y-5, 10, 10);
        [self.caseInfoPickerpopover presentPopoverFromRect:infoCenter  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (![self.caseID isEmpty]) {
        dispatch_queue_t myqueue=dispatch_queue_create("PhotoSave", nil);
        dispatch_async(myqueue, ^(void){
            UIImage *photo=[info objectForKey:UIImagePickerControllerOriginalImage];
            if ([self.photoPath isEmpty] || self.photoPath == nil) {
                NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath=[pathArray objectAtIndex:0];
                NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",self.caseID];
                self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.photoPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:self.photoPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoName;
            if (self.photoArray.count==0) {
                photoName=@"1.jpg";
            } else {
                NSInteger photoNumber=[[self.photoArray valueForKeyPath:@"@max.integerValue"] integerValue]+1;
                photoName=[[NSString alloc] initWithFormat:@"%d.jpg",photoNumber];
            }
            NSString *filePath=[self.photoPath stringByAppendingPathComponent:photoName];
            NSData *photoData=UIImageJPEGRepresentation(photo, 0.8);
            if ([photoData writeToFile:filePath atomically:YES]) {
                CasePhoto *newPhoto=[CasePhoto newDataObjectWithEntityName:@"CasePhoto"];
                newPhoto.caseinfo_id=self.caseID;
                newPhoto.photo_name=photoName;
                [[AppDelegate App] saveContext];
                [self.photoArray insertObject:photoName atIndex:self.imageIndex];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    LOADPHOTOS;
                    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
                    self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
                    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
                });
            }
        });
//        dispatch_release(myqueue);
    }
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

//显示删除标签
- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.photoArray.count > 0) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePiece:)];
            [self becomeFirstResponder];
            [menuController setMenuItems:@[deleteMenuItem]];
            [menuController setTargetRect:CGRectMake(self.infoView.frame.origin.x + SCROLLVIEW_WIDTH/2, self.infoView.frame.origin.y + SCROLLVIEW_HEIGHT/2, 0, 0) inView:self.view];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

//删除对应照片
- (void)deletePiece:(UIMenuController *)controller
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (!caseInfo.isuploaded.boolValue) {
        NSString *photoName = [self.photoArray objectAtIndex:self.imageIndex];
        [CasePhoto deletePhotoForCase:self.caseID photoName:photoName];
        NSString *photoPath = [self.photoPath stringByAppendingPathComponent:photoName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
        }
        [self.photoArray removeObjectAtIndex:self.imageIndex];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            LOADPHOTOS;
            self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
            self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
            self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        });
    }
}

- (UIImage *)cachePhotoForIndex:(NSInteger)index{
    if (self.photoArray.count>0) {
        NSString *photoPath;
        if (index<0) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray lastObject]];
        } else if (index>(self.photoArray.count-1)) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:0]];
        } else {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:index]];
        }
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:photoPath];
        CGImageRef imageRef = [image CGImage];
        CGRect rect = CGRectMake(0.f, 0.f, SCROLLVIEW_HEIGHT/3*4, SCROLLVIEW_HEIGHT);
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                           rect.size.width,
                                                           rect.size.height,
                                                           CGImageGetBitsPerComponent(imageRef),
                                                           CGImageGetBytesPerRow(imageRef),
                                                           CGImageGetColorSpace(imageRef),
                                                           kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
                                                           );
        
        CGContextDrawImage(bitmapContext, rect, imageRef);
        CGImageRef compressedImageRef = CGBitmapContextCreateImage(bitmapContext);
        UIImage* compressedImage = [[UIImage alloc] initWithCGImage: compressedImageRef];
        CGImageRelease(compressedImageRef);
        CGContextRelease(bitmapContext);
        return compressedImage;
    } else {
        return nil;
    }
}


#pragma mark -UIScrollViewDelegate

#define SET_FRAME(IMAGE) x = IMAGE.frame.origin.x + increase;\
if(x < 0) x = pageWidth * 2;\
if(x > pageWidth * 2) x = 0.0f;\
[IMAGE setFrame:CGRectMake(x, \
IMAGE.frame.origin.y,\
IMAGE.frame.size.width,\
IMAGE.frame.size.height)]
//将三个view都向右移动，并更新三个指针的指向
- (void)allImagesMoveRight:(CGFloat)pageWidth {
    //上一篇
    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
	
    float increase = pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    SET_FRAME(self.midImageView);
    
    UIImageView *tempView = self.rightImageView;
    self.rightImageView = self.midImageView;
    self.midImageView = self.leftImageView;
    self.leftImageView = tempView;
}

- (void)allImagesMoveLeft:(CGFloat)pageWidth {
    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
	
    float increase = -pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(self.midImageView);
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    
    UIImageView *tempView = self.leftImageView;
    self.leftImageView = self.midImageView;
    self.midImageView = self.rightImageView;
    self.rightImageView = tempView;
}


//实现照片的循环和载入
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.infoView]) {
        CGFloat pageWidth= WIDTH_OFF_SET;
        // 0 1 2
        int page = floor((self.infoView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page == 1) {
            //用户拖动了，但是滚动事件没有生效
        } else if (page == 0) {
            [self allImagesMoveRight:pageWidth];
            self.imageIndex--;
        } else {
            [self allImagesMoveLeft:pageWidth];
            self.imageIndex++;
        }
        if (self.imageIndex<0) {
            self.imageIndex=self.photoArray.count-1;
        } else if (self.imageIndex>(self.photoArray.count-1)) {
            self.imageIndex=0;
        }
        [UIView transitionWithView:self.infoView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            LOADPHOTOS;
                        }
                        completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        [scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
        self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
    }
}

//照片序号标签的消失动画
- (void)hideLabelWithAnimation {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         [self.labelPhotoIndex setAlpha:0.0];
                     }
                     completion:^(BOOL finished){ self.labelPhotoIndex.hidden=YES;}];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - Key-Value Observing

- (void)registerAsObserver {
    [self addObserver:self forKeyPath:@"thisCaseType" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"thisCaseType"]) {
        if (self.caseInfo != nil) {
            kGDRMCaseType newCaseType = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            self.caseInfo.case_type_id = [NSString stringWithFormat:@"%d", newCaseType];
            NSString *newProcessID = nil, *newProcessName = nil;
            if (newCaseType == kGDRMCaseTypeCompensation) {
                newProcessID = ProcessIDRMCompensationSummaryProcedure;
                newProcessName = ProcessNameRMCompensationSummaryProcedure;
            } else {
                newProcessID = ProcessIDAdminPenaltySummaryProcedure;
                newProcessName = ProcessNameAdminPenaltySummaryProcedure;
            }
            Project *relativeProject = [Project projectForProjectID:self.caseInfo.project_id];
            if (relativeProject != nil) {
                //NSLog(@"Project changed (before): %@: ", relativeProject);
                relativeProject.process_id = newProcessID;
                relativeProject.process_name = newProcessName;
                //NSLog(@"Project changed  (after): %@: ", relativeProject);
            }
        }
        [self.docTemplatesView reloadData];
    }
}

- (void)unregiserAsObserver {
    [self removeObserver:self forKeyPath:@"thisCaseType" context:nil];
}

- (void)setCaseIDdelegate2:(NSString *)caseID{
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        [self.labelPhotoIndex setAlpha:0.0];
        [self.labelPhotoIndex setHidden:YES];
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.accInfoBriefVC.view];
                            if (!self.uiButtonCamera.hidden) {
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                            }
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                            [self.uiButtonPickFromLibrary setHidden:YES];
                            [self.uiButtonCamera setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
    }
}
- (IBAction)changeStationStartKM:(UITextField *)sender {
    if (changeStationEndKMFlag != TRUE) {
        _textStationEndKM.text = sender.text;
    }
}

- (IBAction)changeStationStartM:(UITextField *)sender {
    if (changeStationEndMFlag != TRUE) {
        _textStationEndM.text = sender.text;
    }
}

- (IBAction)changeStationEndKM:(UITextField *)sender {
    changeStationEndKMFlag = TRUE;
}

- (IBAction)changeStationEndM:(UITextField *)sender {
    changeStationEndMFlag = TRUE;
}






@end
