//
//  DeformationInfoViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeformationInfoViewController.h"

#define CUSTOM_ROAD_ASSET_LABEL @"自定义路产"

@interface DeformationInfoViewController ()
@property (retain,nonatomic) NSArray *roadAssetLabels;
@property (retain,nonatomic) NSArray *roadAssetWithLabel;
@property (nonatomic) BOOL isUsingCustomRoadAsset;
-(void)textFieldTextDidChange:(NSNotification *)aNotifocation;
@end

@implementation DeformationInfoViewController
@synthesize caseID=_caseID;
@synthesize roadAssetListView = _roadAssetListView;
@synthesize labelPicker = _labelPicker;
@synthesize roadAssetLabels=_roadAssetLabels;
@synthesize roadAssetWithLabel=_roadAssetWithLabel;
@synthesize deformInfoVC=_deformInfoVC;
@synthesize labelQuantity = _labelQuantity;
@synthesize textQuantity = _textQuantity;
@synthesize labelLength = _labelLength;
@synthesize textLength = _textLength;
@synthesize labelWidth = _labelWidth;
@synthesize textWidth = _textWidth;
@synthesize btnAddDeform = _btnAddDeform;
@synthesize labelPrice = _labelPrice;
@synthesize textPrice = _textPrice;
@synthesize navigationBar = _navigationBar;


-(NSString *)getCaseIDdelegate{
    return self.caseID;
}

- (void)viewDidLoad
{
	
	[_navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    _navigationBar.shadowImage = [[UIImage alloc] init];
	
    _labelPicker.transform = CGAffineTransformMakeScale(0.99, 0.91);
	_labelPicker.layer.cornerRadius = 4.5;

	
	
    [self.roadAssetListView.layer setCornerRadius:4];
    [self.roadAssetListView.layer setMasksToBounds:YES];
    [self.customRoadAssetSubView.layer setCornerRadius:4];
    [self.customRoadAssetSubView.layer setMasksToBounds:YES];
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.btnAddDeform setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    //初始化读取路产清单
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSError *error=nil;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
    [fecthRequest setEntity:entity];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"is_unvarying > 0"];
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"is_unvarying" ascending:YES];
    [fecthRequest setPredicate:predicate];
    [fecthRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.roadAssetWithLabel=[[NSMutableArray alloc] initWithCapacity:1];
    self.roadAssetWithLabel=[[context executeFetchRequest:fecthRequest error:&error] mutableCopy];
    NSMutableArray *tempArray=[[self.roadAssetWithLabel valueForKeyPath:@"@distinctUnionOfObjects.label"] mutableCopy];
    [tempArray sortUsingSelector:@selector(localizedCompare:)];
    NSString *tempString=@"常用";
    [tempArray insertObject:tempString atIndex:0];
    self.roadAssetLabels=[NSArray arrayWithArray:tempArray];
    
    
    self.deformInfoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeformBriefInfo"];
    self.deformInfoVC.delegate=self;
    self.deformInfoVC.viewLocal=1;
    self.deformInfoVC.view.frame=CGRectMake(0, 280, 1024, 488);
    [self.view addSubview:self.deformInfoVC.view];
    
    
    
    //在未选中路产的情况下，数量，长宽等输入框隐藏
//    [self.labelQuantity setAlpha:0.0];
    [self.labelLength setAlpha:0.0];
    [self.labelWidth setAlpha:0.0];
//    [self.textQuantity setAlpha:0.0];
    [self.textLength setAlpha:0.0];
    [self.textWidth setAlpha:0.0];
//    [self.btnAddDeform setAlpha:0.0];
//    [self.textPrice setAlpha:0.0];
//    [self.labelPrice setAlpha:0.0];
    self.textLength.text=@"";
    self.textWidth.text=@"";
    self.textQuantity.text=@"";
    self.textPrice.text=@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.textQuantity];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.customRoadAssetUnitPriceTextField];
    
    //默认情况下隐藏自定义路产视图
    [self.customRoadAssetSubView setHidden:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCaseID:nil];
    [self setRoadAssetLabels:nil];
    [self setRoadAssetWithLabel:nil];
    [self setRoadAssetListView:nil];
    [self setLabelQuantity:nil];
    [self setTextQuantity:nil];
    [self setLabelLength:nil];
    [self setTextLength:nil];
    [self setLabelWidth:nil];
    [self setTextWidth:nil];
    [self setBtnAddDeform:nil];
    [self setLabelPrice:nil];
    [self setTextPrice:nil];
    [self setLabelPicker:nil];
    [self setCustomRoadAssetSubView:nil];
    [self setCustomRoadAssetNameTextField:nil];
    [self setCustomRoadAssetSpecTextField:nil];
    [self setCustomRoadAssetUnitTextField:nil];
    [self setCustomRoadAssetUnitPriceTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.roadAssetWithLabel.count;
}

//定义路产列表
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoadAssetCell";
    RoadAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    RoadAssetPrice *roadAssetPrice=[self.roadAssetWithLabel objectAtIndex:indexPath.row];
    cell.textLabel.text=roadAssetPrice.name;
    cell.specLabel.text=roadAssetPrice.spec;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f元/%@",[roadAssetPrice.price doubleValue],roadAssetPrice.unit_name];
    return cell;
}

//根据路产的选择与点击，显示与隐藏数量、长、宽、添加等增加操作组件
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIView animateWithDuration:0.3 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{ 
//                             [self.labelQuantity setAlpha:0.0];
                             [self.labelLength setAlpha:0.0];
                             [self.labelWidth setAlpha:0.0];
//                             [self.textQuantity setAlpha:0.0];
                             [self.textLength setAlpha:0.0];
                             [self.textWidth setAlpha:0.0];
//                             [self.btnAddDeform setAlpha:0.0];
//                             [self.textPrice setAlpha:0.0];
//                             [self.labelPrice setAlpha:0.0];
                         }
                         completion:nil];
        self.textLength.text=@"";
        self.textWidth.text=@"";
        self.textQuantity.text=@"";
        self.textPrice.text=@"";
        return nil;
    } else {
        [UIView animateWithDuration:0.3 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{ 
//                             [self.labelQuantity setAlpha:1.0];
//                             [self.textQuantity setAlpha:1.0];
//                             [self.btnAddDeform setAlpha:1.0];
//                             [self.textPrice setAlpha:1.0];
//                             [self.labelPrice setAlpha:1.0];
                             if ([[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"unit_name"] isEqualToString:@"平方米"]) {
                                 [self.labelLength setAlpha:1.0];
                                 [self.labelWidth setAlpha:1.0];
                                 [self.textLength setAlpha:1.0];
                                 [self.textWidth setAlpha:1.0];
                             } else {
                                 [self.labelLength setAlpha:0.0];
                                 [self.labelWidth setAlpha:0.0];
                                 [self.textWidth setAlpha:0.0];
                                 [self.textLength setAlpha:0.0];
                                 self.textWidth.text=@"";
                                 self.textLength.text=@"";
                             }                          
                         } 
                         completion:nil];
        return indexPath;
    }
}

//根据选择路产与输入数量计算金额
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (![self.textQuantity.text isEmpty]) {
//        double assetPrice=[[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue];
//        double payPrice=assetPrice*self.textQuantity.text.doubleValue;
//        self.textPrice.text=[NSString stringWithFormat:@"%.2f元",payPrice];
//    }
    //选择新路产时清空数量
    [self.textQuantity setText:@""];
    [self textFieldTextDidChange:nil];
    [self.textQuantity becomeFirstResponder];
}

//长宽输入变化时自动计算数量
- (IBAction)textNumberChanged:(id)sender {    
    if (![self.textLength.text isEmpty] && ![self.textWidth.text isEmpty]) {
        double length=self.textLength.text.doubleValue;
        double width=self.textWidth.text.doubleValue;
        self.textQuantity.text=[NSString stringWithFormat:@"%.3f",length*width];
        NSIndexPath* indexPath=[self.roadAssetListView indexPathForSelectedRow];
        if (indexPath!=nil){
            double assetPrice=[[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue];
            double payPrice=assetPrice*length*width;
            self.textPrice.text=[NSString stringWithFormat:@"%.2f元",payPrice];
        }
    }
}

//数量输入变化时自动计算金额
-(void)textFieldTextDidChange:(NSNotification *)aNotifocation{
    self.textLength.text=@"";
    self.textWidth.text=@"";
    double payPrice = 0.0f;
    if (![self isUsingCustomRoadAsset]) {
        NSIndexPath* indexPath=[self.roadAssetListView indexPathForSelectedRow];
        if (indexPath!=nil){
            double assetPrice=[[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue];
            payPrice=assetPrice*self.textQuantity.text.doubleValue;
        }
    } else {
        double assetPrice = [self.customRoadAssetUnitPriceTextField.text doubleValue];
        double quantity = [self.textQuantity.text doubleValue];
        payPrice = assetPrice * quantity;
    }
    self.textPrice.text=[NSString stringWithFormat:@"%.2f元",payPrice];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}   

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.roadAssetLabels.count + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //添加自定义选项
    NSString *title = CUSTOM_ROAD_ASSET_LABEL;
    if (row < [self.roadAssetLabels count]) {
        title = [self.roadAssetLabels objectAtIndex:row];
    }
    return title;
}

//由picker实现选择路产类别，选择不同类别，右方tableview显示不同路产信息
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row < [self.roadAssetLabels count]) {
        NSString *rowTitle=[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSError *error=nil;
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
        NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
        [fecthRequest setEntity:entity];
        NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"is_unvarying" ascending:YES];
        [fecthRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        if ([rowTitle isEqualToString:@"常用"]) {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"is_unvarying > 0"];
            [fecthRequest setPredicate:predicate];
        } else {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"label == %@",rowTitle];
            [fecthRequest setPredicate:predicate];
        }
        self.roadAssetWithLabel=[context executeFetchRequest:fecthRequest error:&error];
        [self.roadAssetListView reloadData];
        [self setIsUsingCustomRoadAsset:NO];
        [self.customRoadAssetSubView setHidden:YES];
    } else {
        [self setIsUsingCustomRoadAsset:YES];
        [self.customRoadAssetSubView setHidden:NO];
        [self.labelLength setAlpha:1.0f];
        [self.textLength setAlpha:1.0f];
        [self.labelWidth setAlpha:1.0f];
        [self.textWidth setAlpha:1.0f];
        [self.textQuantity setText:@""];
        [self textFieldTextDidChange:nil];
    }
}



//添加记录按钮
- (IBAction)btnAddDeformation:(id)sender {
//    [self.textQuantity resignFirstResponder];
    [self.view endEditing:NO]; //避免逐一调用resignFirstResponder
    if (self.textQuantity.text.doubleValue>0) {
        RoadAssetPrice *newRoadAssetPrice = nil;
        NSString *remark = @"";
        double quantity = self.textQuantity.text.doubleValue;
        if (![self isUsingCustomRoadAsset]) {
            NSIndexPath* indexPath=[self.roadAssetListView indexPathForSelectedRow];
            if (indexPath!=nil) {
                newRoadAssetPrice = [self.roadAssetWithLabel objectAtIndex:indexPath.row];
            }
        } else {
            if ([self.customRoadAssetNameTextField.text isEmpty] ||
                [self.customRoadAssetUnitPriceTextField.text isEmpty] ||
                [self.customRoadAssetUnitTextField.text isEmpty]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"路产名称、单位、单价为必填项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                return;
            }
            newRoadAssetPrice = [RoadAssetPrice newDataObjectWithEntityName:@"RoadAssetPrice"];
            newRoadAssetPrice.name = self.customRoadAssetNameTextField.text;
            newRoadAssetPrice.spec = self.customRoadAssetSpecTextField.text;
            newRoadAssetPrice.unit_name = self.customRoadAssetUnitTextField.text;
            newRoadAssetPrice.price = @(self.customRoadAssetUnitPriceTextField.text.doubleValue);
        }
        if ((![self.textLength.text isEmpty]) && (![self.textWidth.text isEmpty])) {
            remark=[NSString stringWithFormat:@"长%@米、宽%@米",self.textLength.text,self.textWidth.text];
        }
        [self.deformInfoVC addDeformationForRoadAsset:newRoadAssetPrice andQuantity:quantity withRemark:remark];
    }
}

-(IBAction)btnDismiss:(id)sender{    
    [self dismissModalViewControllerAnimated:YES];
}

@end
