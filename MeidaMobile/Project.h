//
//  Project.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

FOUNDATION_EXPORT NSString * const ProcessIDAdminPenaltySummaryProcedure;
FOUNDATION_EXPORT NSString * const ProcessIDAdminPenaltyGeneralProcedure;
FOUNDATION_EXPORT NSString * const ProcessIDRMCompensationSummaryProcedure;
FOUNDATION_EXPORT NSString * const ProcessIDRMCompensationGeneralProcedure;
FOUNDATION_EXPORT NSString * const ProcessIDDefault;

FOUNDATION_EXPORT NSString * const ProcessNameAdminPenaltySummaryProcedure;
FOUNDATION_EXPORT NSString * const ProcessNameAdminPenaltyGeneralProcedure;
FOUNDATION_EXPORT NSString * const ProcessNameRMCompensationSummaryProcedure;
FOUNDATION_EXPORT NSString * const ProcessNameRMCompensationGeneralProcedure;
FOUNDATION_EXPORT NSString * const ProcessNameDefault;


@interface Project : BaseManageObject

@property (nonatomic, retain) NSString * inite_node_id;
@property (nonatomic, retain) NSString * inituser_account;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * process_id;
@property (nonatomic, retain) NSString * process_name;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSNumber * isuploaded;

+ (Project *)projectForProjectID:(NSString *)myID;

@end
