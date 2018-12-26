//
//  CaseMapPrinterViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "CaseMapPrinterViewController.h"
#import "CaseMap.h"
#import "CaseInfo.h"
#import "CaseProveInfo.h"
#import "Citizen.h"

@interface CaseMapPrinterViewController ()

@end

@implementation CaseMapPrinterViewController
@synthesize labelTime = _labelTime;
@synthesize labelLocality = _labelLocality;
@synthesize labelCitizen = _labelCitizen;
@synthesize labelWeather = _labelWeather;
@synthesize labelRoadType = _labelRoadType;
@synthesize textViewRemark = _textViewRemark;
@synthesize labelDraftMan = _labelDraftMan;
@synthesize labelDraftTime = _labelDraftTime;
@synthesize mapImage = _mapImage;
@synthesize caseID = _caseID;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:@"CaseMapTable"];
    [self loadPageInfo];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabelTime:nil];
    [self setLabelLocality:nil];
    [self setLabelCitizen:nil];
    [self setLabelWeather:nil];
    [self setLabelRoadType:nil];
    [self setTextViewRemark:nil];
    [self setLabelDraftMan:nil];
    [self setLabelDraftTime:nil];
    [self setMapImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadPageInfo{
    CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
    if (caseMap) {
        self.labelRoadType.text = caseMap.road_type;
        self.textViewRemark.text = caseMap.remark;
        self.labelDraftMan.text = caseMap.draftsman_name;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        self.labelDraftTime.text = [dateFormatter stringFromDate:caseMap.draw_time];
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath=[pathArray objectAtIndex:0];
        NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
        mapPath=[documentPath stringByAppendingPathComponent:mapPath];
        NSString *mapName = @"casemap.jpg";
        NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
            self.mapImage.image = imageFile;
        }
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        self.labelTime.text = [dateFormatter stringFromDate:caseInfo.happen_date];
        NSString *locality = [[NSString alloc] initWithFormat:@"%@高速%@%dKm+%03dm",[[AppDelegate App].projectDictionary objectForKey:@"cityname"] ,caseInfo.side,caseInfo.station_start.integerValue/1000,caseInfo.station_start.integerValue%1000];
        self.labelLocality.text = locality;
        self.labelWeather.text = caseInfo.weater;
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (caseProveInfo) {
            self.labelProver.text = caseProveInfo.prover;
        }
        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
        self.labelCitizen.text = citizen.automobile_number;
    }
}

//- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:@"CaseMapTable"];
//        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:caseMap];
//        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:caseInfo];
//        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:caseProveInfo];
//        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:citizen];
//        
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
//}
//
//-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
//    if (![filePath isEmpty]) {
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:caseMap];
//        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:caseInfo];
//        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:caseProveInfo];
//        Citizen *citizen = [Citizen citizenForCitizenName:caseProveInfo.citizen_name nexus:@"当事人" case:self.caseID];
//        [self drawDateTable:@"CaseMapTable" withDataModel:citizen];
//        
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

- (NSString *)templateNameKey
{
    return DocNameKeyPei_LuZhengAnJianXianChangKanYanTu;
}

- (id)dataForPDFTemplate
{
    NSString *caseNo = @"";
    id dateData = @{};
    NSString *place = @"";
    NSString *eventReason = @"";
    NSString *comment = @"";
    NSString *draftsman = @"";
    NSString *inquestman = @"";
    NSString *imagePath = @"";
    NSString *weater = @"";
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSString *road_type = @"";
    NSString *automobile_number = @"";

    
    if (caseInfo) {
        caseNo = [NSString stringWithFormat:@"%@年%@号",caseInfo.case_mark2,caseInfo.full_case_mark3];
        
        //        NSString *dateString = NSStringFromNSDateAndFormatter(caseInfo.happen_date, NSDateFormatStringCustom1);
        
        NSString *dateString = self.labelTime.text;
        dateData = DateDataFromDateString(dateString);
        dateData = (dateData == nil ? @{} : dateData);
        place = NSStringNilIsBad(caseInfo.full_happen_place);
        
//        place = self.labelLocality.text;
        
        
        
        weater = NSStringNilIsBad(caseInfo.weater);
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (proveInfo) {
            //            eventReason = NSStringNilIsBad(proveInfo.case_short_desc);
            inquestman = NSStringNilIsBad(proveInfo.prover);
            Citizen *citizen = [Citizen citizenForCitizenName:proveInfo.citizen_name nexus:@"当事人" case:self.caseID];
            automobile_number = citizen.automobile_number;

        }
        
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        if (caseMap) {
            eventReason = NSStringNilIsBad(caseMap.road_type);
            comment = NSStringNilIsBad(caseMap.remark);
            draftsman = NSStringNilIsBad(caseMap.draftsman_name);
            imagePath = caseMap.map_file;
            road_type = caseMap.road_type;
        }
        
    }
    BOOL flag = NO;
    NSArray * highSpeedArr = @[];
    if (place && ![place isEmpty]) {
        highSpeedArr = [place componentsSeparatedByString:@"高速"];
    }
    if (!highSpeedArr || [highSpeedArr count] < 2  ) {
        highSpeedArr = [place componentsSeparatedByString:@"段"];
        flag = YES;

    }
    
    NSArray * directionArr= @[];
    if (highSpeedArr && [highSpeedArr count] >= 2) {
        directionArr = [[highSpeedArr objectAtIndex:1] componentsSeparatedByString:@"方向K"];
    }
    
    NSArray * stake1Arr= @[];
    if (directionArr && [directionArr count] >= 2) {
        stake1Arr = [[directionArr objectAtIndex:1] componentsSeparatedByString:@"+"];
    }
    
    NSArray * stake2Arr= @[];
    if (stake1Arr && [stake1Arr count] >= 2) {
        stake2Arr = [[stake1Arr objectAtIndex:1] componentsSeparatedByString:@"m"];
    }
    
    NSString * highSpeed= @"";
    if (highSpeedArr && [highSpeedArr count] >= 1) {
        highSpeed = NSStringNilIsBad([highSpeedArr objectAtIndex:0]);
        if (flag == YES) {
            highSpeed = [NSString stringWithFormat:@"%@%@",highSpeed,@"段" ];
        }
    }
    
    NSString * direction= @"";
    if (directionArr && [directionArr count] >= 1) {
        direction = NSStringNilIsBad([directionArr objectAtIndex:0]);
    }
    
    NSString * stake1 = @"";
    if (stake1Arr && [stake1Arr count] >= 1) {
        stake1 = NSStringNilIsBad([stake1Arr objectAtIndex:0]);
    }
    
    NSString * stake2 = @"";
    if (stake2Arr && [stake2Arr count] >= 1) {
        stake2 = NSStringNilIsBad([stake2Arr objectAtIndex:0]);
    }
    
    return @{
             @"caseNo": caseNo,
             @"date": dateData,
             @"highSpeed": highSpeed,
             @"direction":direction,
             @"stake1":stake1,
             @"stake2":stake2,
             @"eventReason": eventReason,
             @"comment": comment,
             @"draftsman": draftsman,
             @"inquestman": inquestman,
             @"imagePath": imagePath,
             @"weater":weater,
             @"road_type":road_type,
             @"automobile_number":automobile_number,
             };
}


@end
