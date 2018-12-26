//
//  CaseServiceReceipt.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseServiceReceipt : BaseManageObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * incepter_name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * service_position;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * service_company;
@property (nonatomic, retain) NSNumber * isuploaded;

+ (CaseServiceReceipt *)newCaseServiceReceiptForCase:(NSString *)caseID;

+ (CaseServiceReceipt *)caseServiceReceiptForCase:(NSString *)caseID;

- (NSArray *)file_list;
@end
