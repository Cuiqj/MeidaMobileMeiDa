//
//  AtonementNotice.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface AtonementNotice : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSString * check_organization;
@property (nonatomic, retain) NSString * case_desc;
@property (nonatomic, retain) NSString * witness;
@property (nonatomic, retain) NSString * pay_reason;
@property (nonatomic, retain) NSString * pay_mode;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;

+ (NSArray *)AtonementNoticesForCase:(NSString *)caseID;

- (NSString *)organization_info;

- (NSString *)bank_name;
- (NSString *)pay_reason1;
- (NSString *)pay_reason2;
@end
