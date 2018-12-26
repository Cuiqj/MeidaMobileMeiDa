//
//  CaseProveInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseProveInfo : BaseManageObject

@property (nonatomic, retain) NSString * case_desc_id;
@property (nonatomic, retain) NSString * case_short_desc;
@property (nonatomic, retain) NSString * case_long_desc;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSDate * end_date_time;
@property (nonatomic, retain) NSString * event_desc;
@property (nonatomic, retain) NSString * invitee;
@property (nonatomic, retain) NSString * invitee_org_duty;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizer_org_duty;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * party_org_duty;
@property (nonatomic, retain) NSString * prover;
@property (nonatomic, retain) NSString * secondProver;
@property (nonatomic, retain) NSString * recorder;
@property (nonatomic, retain) NSDate * start_date_time;
@property (nonatomic, retain) NSString * remark;

//读取案号对应的勘验记录
+(CaseProveInfo *)proveInfoForCase:(NSString *)caseID;

+ (NSString *)generateEventDescForCase:(NSString *)caseID;
+ (NSString *)generateEventDescForInquire:(NSString *)caseID;
- (NSString *) case_mark2;
- (NSString *) full_case_mark3;
- (NSString *) weater;
- (NSString *) prover1;
- (NSString *) prover1_org_duty;
- (NSString *) prover2;
- (NSString *) prover2_org_duty;
- (NSString *) citizen_org_duty;
- (NSString *) recorder_org_duty;
+ (NSString *)generateWoundDesc:(NSString *)caseID;
+ (NSString*)generateDefaultPayReason:(NSString *)caseID;
+ (NSString *)generateEventDescForCase2:(NSString *)caseID;
@end
