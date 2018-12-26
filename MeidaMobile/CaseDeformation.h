//
//  CaseDeformation.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseDeformation : BaseManageObject

@property (nonatomic, retain) NSString * proveinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * rasset_size;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadasset_name;
@property (nonatomic, retain) NSNumber * total_price;
@property (nonatomic, retain) NSString * unit;

+ (NSArray *)deformationsForCase:(NSString *)caseID;
+ (NSArray *)deformationsForCase:(NSString *)caseID forCitizen:(NSString *)citizen;
@end
