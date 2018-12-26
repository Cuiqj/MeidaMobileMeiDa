//
//  DeformInfoBriefViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeformInfoBriefViewController.h"
#import "CaseDeformation.h"
#import "Citizen.h"

@interface DeformInfoBriefViewController ()
-(void)reloadInfo;
-(void)showAlertView;
-(void)reloadDeformTableViewWithCitizenName:(NSString *)citizenName;
@property (nonatomic,retain) NSMutableArray *citizenList;
@property (nonatomic,retain) NSMutableArray *deformList;
@end

@implementation DeformInfoBriefViewController
@synthesize deformTableView = _deformTableView;
@synthesize citizenPickerView = _citizenPickerView;
@synthesize caseID=_caseID;
@synthesize citizenList=_citizenList;
@synthesize delegate=_delegate;
@synthesize deformList=_deformList;
//显示位置标记，在案件主页面显示，整数值为0，在清单编辑页面显示，整数值为1；
@synthesize viewLocal=_viewLocal;


-(void)viewWillAppear:(BOOL)animated{
    [self reloadInfo];
    if (self.viewLocal==0) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    } else {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInfo) name:@"ReloadCitizen" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{    
    [self.citizenPickerView.layer setCornerRadius:4];
    [self.deformTableView.layer setCornerRadius:4];
    [self.citizenPickerView.layer setMasksToBounds:YES];
    [self.deformTableView.layer setMasksToBounds:YES];
    [self.citizenPickerView setBounces:NO];    
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"左栏背景" ofType:@"png"];
    UIImage *citizenPickerBackImage=[UIImage imageWithContentsOfFile:imagePath];
    UIGraphicsBeginImageContext(self.citizenPickerView.frame.size);
    [citizenPickerBackImage drawInRect:self.citizenPickerView.bounds];
    citizenPickerBackImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *citizenPickerBackgroundView=[[UIImageView alloc] initWithImage:citizenPickerBackImage];
    self.citizenPickerView.backgroundView=citizenPickerBackgroundView;    
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDeformTableView:nil];
    [self setCaseID:nil];
    [self.citizenList removeAllObjects];
    [self setCitizenList:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCitizenPickerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger numberOfSection=0;
    switch (tableView.tag) {
        case 1000:
            //车号选择列表
            numberOfSection=1;
            break;
        case 1001:
            //路产损坏清单
            numberOfSection=2;
            break;
        default:
            break;
    }
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger numberOfRows=0;
    switch (tableView.tag) {
        case 1000:
            //车号选择列表
            numberOfRows=self.citizenList.count;
            break;
        case 1001:
            //路产损坏清单
        {
            if (section==0) {
                numberOfRows=self.deformList.count;
            }
            if (section==1) {
                numberOfRows=1;
            }    
        }
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (tableView.tag) {
        case 1000:
            //车号选择列表
        {
            static NSString *CellIdentifier=@"CitizenPickerCell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.textLabel.text=[self.citizenList objectAtIndex:indexPath.row];
            NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"左栏按钮" ofType:@"png"];
            UIImage *backImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
            UIImageView *backView=[[UIImageView alloc] initWithImage:backImage];
            cell.selectedBackgroundView=backView;
            return cell;
        }
            break;
        case 1001:
            //路产损坏清单
        {
            //路产损坏列表
            if (indexPath.section==0) {
                static NSString *CellIdentifier = @"DefomationCell";
                DeformationCell *cell = (DeformationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                CaseDeformation *deformation=[self.deformList objectAtIndex:indexPath.row];
                cell.assetNameLabel.text = deformation.roadasset_name;
                cell.assetPriceLabel.text = [[NSString alloc] initWithFormat:@"%.2f元/%@",deformation.price.floatValue,deformation.unit];
                if (self.viewLocal == 0) {
                    cell.assetQuantityLabel.text = @"";
                    [cell.assetQuantityLabel setHidden:YES];
                } else {
                    if ([deformation.unit rangeOfString:@"米"].location != NSNotFound) {
                        cell.assetQuantityLabel.text=[NSString stringWithFormat:@"%.2f%@",deformation.quantity.doubleValue,deformation.unit];
                    } else {
                        cell.assetQuantityLabel.text=[NSString stringWithFormat:@"%d%@",deformation.quantity.integerValue,deformation.unit];
                    }
                }
                cell.assetTotalAmountLabel.text = [[NSString alloc] initWithFormat:@"%.2f元",deformation.total_price.doubleValue];
                cell.assetTotalAmountLabel.textColor=[UIColor scrollViewTexturedBackgroundColor];
                return cell;
            } 
            //总金额计算
            if (indexPath.section==1) {
                static NSString *CellIndetifier = @"SummaryCell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIndetifier];
                double summary=[[self.deformList valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
                cell.detailTextLabel.font=[UIFont systemFontOfSize:20];
                cell.textLabel.font=[UIFont boldSystemFontOfSize:20];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f元",summary];
                cell.textLabel.text=[NSString stringWithFormat:@"总金额："];
                cell.detailTextLabel.textColor=[UIColor scrollViewTexturedBackgroundColor];
                return cell;
            }
        }
            break;
        default:
            return nil;
            break;
    }
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle cellEditingStyle=0;
    switch (tableView.tag) {
        case 1000:
            //车号选择列表
            cellEditingStyle=UITableViewCellEditingStyleNone;
            break;
        case 1001:
            //路产损坏清单
        {
            if (indexPath.section==0 && self.viewLocal==1) {
                cellEditingStyle=UITableViewCellEditingStyleDelete;
            } else {
                cellEditingStyle=UITableViewCellEditingStyleNone;
            }

        }
            break;
        default:
            break;
    }
    return cellEditingStyle;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}  

//删除路产记录
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    [context deleteObject:[self.deformList objectAtIndex:indexPath.row]];
    [[AppDelegate App] saveContext];
    [self.deformList removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    NSIndexPath *indexOfSummaryCell=[NSIndexPath indexPathForRow:0 inSection:1];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexOfSummaryCell] withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView endUpdates]; 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1000) {
        NSString *citizenName=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self reloadDeformTableViewWithCitizenName:citizenName];
    }
}

//添加路产损坏记录
-(void)addDeformationForRoadAsset:(RoadAssetPrice *)aRoadAsset andQuantity:(double)quantity withRemark:(NSString *)aRemark{
    if (![self.caseID isEmpty]) {
        if (self.citizenList.count>0) {
            NSString *rowTitle=[self.citizenPickerView cellForRowAtIndexPath:[self.citizenPickerView indexPathForSelectedRow]].textLabel.text;
            if (self.citizenList.count==1) {
                rowTitle=[self.citizenList objectAtIndex:0];
            }
            CaseDeformation *newDeformation=[CaseDeformation newDataObjectWithEntityName:@"CaseDeformation"];             newDeformation.proveinfo_id=self.caseID;
            if ([rowTitle isEqualToString:@"全部"]) {
                newDeformation.citizen_name=@"共同";
            } else {
                newDeformation.citizen_name=rowTitle;
            }        
            newDeformation.price=aRoadAsset.price;
            newDeformation.quantity=[NSNumber numberWithDouble:quantity];
            newDeformation.rasset_size=aRoadAsset.spec;
            newDeformation.unit=aRoadAsset.unit_name;
            newDeformation.remark=aRemark;
            newDeformation.roadasset_name=aRoadAsset.name;
            newDeformation.total_price=[NSNumber numberWithDouble:aRoadAsset.price.doubleValue*quantity];
            [[AppDelegate App] saveContext];
            //在TableView添加行
            [self.deformList addObject:newDeformation];
            [self.deformTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.deformList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            
            //更新总价
            NSIndexPath *indexOfSummaryCell=[NSIndexPath indexPathForRow:0 inSection:1];
            [self.deformTableView beginUpdates];
            [self.deformTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexOfSummaryCell] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.deformTableView endUpdates]; 
        } else {
            [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:YES];
        }
    }    
}

-(void)showAlertView{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"无车号信息，无法记录损坏路产，请检查车辆信息记录是否存在！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


//根据caseID初始化，重载信息
-(void)reloadInfo{
    self.caseID=[_delegate getCaseIDdelegate];
    if (self.citizenList == nil) {
        self.citizenList=[[NSMutableArray alloc ] initWithCapacity:1];
    } else {
        [self.citizenList removeAllObjects];
    }
    if (self.deformList == nil) {
        self.deformList=[[NSMutableArray alloc] initWithCapacity:1];
    } else {
        [self.deformList removeAllObjects];
    }
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSArray *temp=[Citizen allCitizenNameForCase:self.caseID];
    self.citizenList=[[temp valueForKey:@"automobile_number"] mutableCopy];
    [self.citizenList removeObject:[NSNull null]];
    if (temp.count>1) {
        [self.citizenList addObject:@"共同"];
        [self.citizenList addObject:@"全部"];
    }
    if (self.citizenList.count<=1) {
        [self.citizenPickerView setHidden:YES];
        if (self.viewLocal==0) {
            self.deformTableView.frame=CGRectMake(0, 0, 654, 336);
        } else if (self.viewLocal==1) {
            self.deformTableView.frame=CGRectMake(30,34, 966, 413);
        }
    } else {
        [self.citizenPickerView setHidden:NO];
        if (self.viewLocal==0) {
            self.citizenPickerView.frame=CGRectMake(0, 0, 105, 336);
            self.deformTableView.frame=CGRectMake(105, 0, 549, 336);
        } else if (self.viewLocal==1) {
            self.citizenPickerView.frame=CGRectMake(30, 34, 105, 413);
            self.deformTableView.frame=CGRectMake(135, 34, 861, 413);
        }
    }
    if (!self.citizenPickerView.hidden) {
        [self.citizenPickerView reloadData];
        [self.citizenPickerView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    if (self.citizenList.count>0) {
        NSString *citizenName=[self.citizenList objectAtIndex:0];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id == %@) && (citizen_name == %@)",self.caseID,citizenName];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        self.deformList=[[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    [self.deformTableView reloadData];
    [self.view setNeedsDisplay];
}

//根据左边选择的类别，读取相应的损坏清单
-(void)reloadDeformTableViewWithCitizenName:(NSString *)citizenName{
    if (self.deformList==nil) {
        self.deformList=[[NSMutableArray alloc] initWithCapacity:1];
    } else {
        [self.deformList removeAllObjects];
    }
    if (self.citizenList.count>0) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSPredicate *predicate=nil;
        if ([citizenName isEqualToString:@"全部"]) {
            predicate=[NSPredicate predicateWithFormat:@"proveinfo_id == %@",self.caseID];
        } else {
            predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id == %@) && (citizen_name == %@)",self.caseID,citizenName];
        }
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSError *error;
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        self.deformList=[[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    [self.deformTableView reloadData];
}

@end
