//
//  CaseCountPrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-4.
//
//

#import "CaseCountPrintViewController.h"
#import "CaseInfo.h"
#import "Citizen.h"
#import "CaseDeformation.h"
#import "CaseProveInfo.h"
#import "NSNumber+NumberConvert.h"
#import "CaseCount.h"
#import "UserInfo.h"
#import "OrgInfo.h"

static NSString * const xmlName = @"CaseCountTable";

@interface CaseCountPrintViewController ()
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CaseCount *caseCount;
@end

@implementation CaseCountPrintViewController
@synthesize caseID = _caseID;
@synthesize data = _data;
@synthesize caseCount = _caseCount;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    //CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    self.textRemark.text=caseInfo.casedeformation_remark;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    //self.labelCaseAddress.text = caseInfo.full_happen_place2;
    if(caseInfo.remark !=nil){
        self.textfieldCaseAddress.text = caseInfo.remark;
    }else{
        self.textfieldCaseAddress.text = caseInfo.full_happen_place;
    }

    self.labelHappenTime.text = [dateFormatter stringFromDate:caseInfo.happen_date];
    if (citizen) {
        self.labelParty.text = [NSString stringWithFormat:@"%@ %@", (citizen.org_name ? citizen.org_name : @""), citizen.party];
        self.labelAutoNumber.text = citizen.automobile_number;
        self.labelAutoPattern.text = citizen.automobile_pattern;
        self.labelTele.text = citizen.tel_number;
    }
    self.data = [[CaseDeformation deformationsForCase:self.caseID forCitizen:citizen.automobile_number] mutableCopy];
    [self.tableCaseCountDetail reloadData];
    double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
    self.textBigNumber.text = [[NSNumber numberWithDouble:summary] numberConvertToChineseCapitalNumberString];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseCount" inManagedObjectContext:context];
    self.caseCount = [[CaseCount alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    self.caseCount.caseinfo_id = self.caseID;
}

- (BOOL)pageSaveInfo{
    Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    citizen.org_full_name = self.labelParty.text;
    
    self.caseCount.citizen_name = self.labelParty.text;
    self.caseCount.sum = [NSNumber numberWithDouble:[[NSString stringWithString:self.labelPayReal.text] doubleValue]];
    self.caseCount.chinese_sum = [[NSNumber numberWithDouble:[self.caseCount.sum doubleValue]] numberConvertToChineseCapitalNumberString];
    self.caseCount.case_count_list = [NSArray arrayWithArray:self.data];
    //self.caseCount.
    
    CaseInfo *caseinfo = [CaseInfo caseInfoForID:self.caseID];
    caseinfo.remark =  self.textfieldCaseAddress.text ;
    caseinfo.casedeformation_remark = self.textRemark.text;
    
    
    [[AppDelegate App] saveContext];
    return TRUE;
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseDeformation  *)caseCount{
    /*
    if (caseCount.caseCountSendDate==nil) {
        caseCount.caseCountSendDate=[NSDate date];
    }
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    caseCount.caseCountReason = [caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
    [CaseCountDetail deleteAllCaseCountDetailsForCase:self.caseID];
    [CaseCountDetail copyAllCaseDeformationsToCaseCountDetailsForCase:self.caseID];
    
    NSArray *deformArray=[CaseCountDetail allCaseCountDetailsForCase:self.caseID];
    double summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    caseCount.case_citizen_info = numString;
    [[AppDelegate App] saveContext];
    */
}

//- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
//    [self pageSaveInfo];
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:xmlName];
//        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
//        [self drawDateTable:xmlName withDataModel:caseInfo];
//        [self drawDateTable:xmlName withDataModel:citizen];
//        [self drawDateTable:xmlName withDataModel:self.caseCount];
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
//}
//
//- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
//    [self pageSaveInfo];
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
//        [self drawDateTable:xmlName withDataModel:caseInfo];
//        [self drawDateTable:xmlName withDataModel:citizen];
//        [self drawDateTable:xmlName withDataModel:self.caseCount];
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
//}


- (void)viewDidUnload {
    [self setLabelHappenTime:nil];
    [self setLabelCaseAddress:nil];
    [self setLabelParty:nil];
    [self setLabelTele:nil];
    [self setLabelAutoPattern:nil];
    [self setLabelAutoNumber:nil];
    [self setTableCaseCountDetail:nil];
    [self setTextBigNumber:nil];
    [self setLabelPayReal:nil];
    [self setTextRemark:nil];
    [super viewDidUnload];
}

-(void)reloadDataArray{
    [self.tableCaseCountDetail reloadData];
    double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    self.textBigNumber.text = numString;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCountDetailCell";
    CaseCountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CaseDeformation *caseDeformation = [self.data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labelAssetName.text = caseDeformation.roadasset_name;
    //cell.labelAssetSize.text = caseDeformation.rasset_size;
    
    if ([caseDeformation.unit rangeOfString:@"米"].location != NSNotFound) {
        cell.labelQunatity.text=[NSString stringWithFormat:@"%.2f",caseDeformation.quantity.doubleValue];
    } else {
        cell.labelQunatity.text=[NSString stringWithFormat:@"%d",caseDeformation.quantity.integerValue];
    }
    cell.labelAssetUnit.text = caseDeformation.unit;
    cell.labelPrice.text = [NSString stringWithFormat:@"%.2f元",caseDeformation.price.floatValue];
    cell.labelTotalPrice.text = [NSString stringWithFormat:@"%.2f元",caseDeformation.total_price.floatValue];
    cell.labelRemark.text = caseDeformation.remark;
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
 
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CaseCountDetail *caseCountDetail = [self.data objectAtIndex:indexPath.row];
        [[[AppDelegate App] managedObjectContext] deleteObject:caseCountDetail];
        [self.data removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
        self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
        NSNumber *sumNum = @(summary);
        NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
        self.textBigNumber.text = numString;
    }
     */
}
     

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toCaseCountDetailEditor" sender:[self.data objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toCaseCountDetailEditor"]) {
        CaseCountDetailEditorViewController *ccdeVC = [segue destinationViewController];
        ccdeVC.caseID = self.caseID;
        ccdeVC.countDetail = sender;
        ccdeVC.delegate = self;
    }
}

- (void)generateDefaultAndLoad{
    //[self generateDefaultInfo:self.caseCount];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
//    if (![self.caseID isEmpty] && self.caseCount){
//        [[[AppDelegate App] managedObjectContext] deleteObject:self.caseCount];
//        for (CaseDeformation *ccd in self.data) {
//            [[[AppDelegate App] managedObjectContext] deleteObject:ccd];
//        }
//        [[AppDelegate App] saveContext];
//        self.caseCount = nil;
//        [self.data removeAllObjects];
//    }
}

#pragma mark - CasePrintProtocol
- (NSString *)templateNameKey
{
    return DocNameKeyPei_PeiBuChangQingDan;
}

- (id)dataForPDFTemplate {
    
    id caseData = @{};
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        
        NSString * dataTemp = NSStringFromNSDateAndFormatter(caseInfo.happen_date, NSDateFormatStringCustom1);
        
        NSArray * arrayYear = [dataTemp componentsSeparatedByString:@"年"];
        
        NSArray * arrayMonth = [[arrayYear objectAtIndex:1] componentsSeparatedByString:@"月"];
        
        NSArray * arrayDay = [[arrayMonth objectAtIndex:1] componentsSeparatedByString:@"日"];
        
        NSArray * arrayHour = [[arrayDay objectAtIndex:1] componentsSeparatedByString:@"时"];
        
        NSArray * arrayMin = [[arrayHour objectAtIndex:1] componentsSeparatedByString:@"分"];
        
        NSString *year = NSStringNilIsBad([arrayYear objectAtIndex:0]);
        
        NSString *month = NSStringNilIsBad([arrayMonth objectAtIndex:0]);
        
        NSString *day = NSStringNilIsBad([arrayDay objectAtIndex:0]);
        
        NSString *hour = NSStringNilIsBad([arrayHour objectAtIndex:0]);
        
        NSString *min = NSStringNilIsBad([arrayMin objectAtIndex:0]);
        
        caseData = @{
                     //@"place": caseInfo.full_happen_place,
                     @"place": self.textfieldCaseAddress.text,
                     //                     @"date": NSStringFromNSDateAndFormatter(caseInfo.happen_date, NSDateFormatStringCustom1),
                     @"year": year,
                     @"month": month,
                     @"day":day,
                     @"hour":hour,
                     @"min":min
                     };
    }
    
    id citizenData = @{};
    Citizen  *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
    if (citizen) {
        citizenData = @{
                        @"name":NSStringNilIsBad(citizen.party),
                        @"car_model":NSStringNilIsBad(citizen.automobile_pattern),
                        @"car_number":NSStringNilIsBad(citizen.automobile_number),
                        @"org":NSStringNilIsBad(citizen.org_name),
                        @"tel":NSStringNilIsBad(citizen.tel_number),
                        };
    }
    
    NSInteger emptyItemCnt = 17;
    id itemsData = [@[] mutableCopy];
    if (self.data != nil) {
        int i = 0;
        for (CaseDeformation *caseDeform in self.data) {
            if (i >= 17) {
                break;
            }
            id singleItem = @{
                              @"id": @(i+1),
                              @"name": caseDeform.roadasset_name,
                              @"size": caseDeform.rasset_size,
                              @"unit": caseDeform.unit,
                              @"quantity": caseDeform.quantity,
                              @"unit_price": caseDeform.price,
                              @"total_price": caseDeform.total_price,
                              @"remark":caseDeform.remark
                              };
            [itemsData addObject:singleItem];
            i++;
            emptyItemCnt--;
        }
    }
    /* 若不足10个，用空数据补足 */
    for (int i = 17-emptyItemCnt; i < 17; i++) {
        [itemsData addObject:@{@"id":@(i+1)}];
    }
    
    id moneyData = @{};
    if (self.data != nil && self.caseCount != nil) {
        moneyData = @{
                      @"type":@"人民币",
                      @"shiwan":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_sw],
                      @"wan":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_w],
                      @"qian":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_q],
                      @"bai":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_b],
                      @"shi":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_s],
                      @"yuan":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_y],
                      @"jiao":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_j],
                      @"fen":[NSString stringWithFormat:@"%@",self.caseCount.chinese_sum_f],
                      @"xiaoxie": [NSString stringWithFormat:@"%@",self.labelPayReal.text]
                      };
    }
    
    id commentData = @"";
    if (![self.textRemark.text isEmpty]) {
        commentData = self.textRemark.text;
    }
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString * currentOrgname = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
    id orgnamedata = @"";
    if ([currentOrgname containsString:@"梅大"]) {
        orgnamedata = @{@"name":@"梅大"};
    }else{
        orgnamedata = @{@"name":@"天汕"};
    }
    id data = @{
                @"citizen":citizenData,
                @"case": caseData,
                @"items":itemsData,
                @"money":moneyData,
                @"comment":commentData,
                @"orgname":orgnamedata
                };
    return data;
}

@end
