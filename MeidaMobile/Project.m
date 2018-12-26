//
//  Project.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "Project.h"


NSString * const ProcessIDAdminPenaltySummaryProcedure = @"101";
NSString * const ProcessIDAdminPenaltyGeneralProcedure = @"102";
NSString * const ProcessIDRMCompensationSummaryProcedure = @"104";
NSString * const ProcessIDRMCompensationGeneralProcedure = @"105";
NSString * const ProcessIDDefault = @"104";

NSString * const ProcessNameAdminPenaltySummaryProcedure = @"行政处罚案件简易程序";
NSString * const ProcessNameAdminPenaltyGeneralProcedure = @"行政处罚案件一般程序";
NSString * const ProcessNameRMCompensationSummaryProcedure = @"路政赔偿补偿案件简易程序";
NSString * const ProcessNameRMCompensationGeneralProcedure = @"路政赔偿补偿案件一般程序";
NSString * const ProcessNameDefault = @"路政赔偿补偿案件简易程序";

@implementation Project

@dynamic inite_node_id;
@dynamic inituser_account;
@dynamic myid;
@dynamic process_id;
@dynamic process_name;
@dynamic start_time;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (Project *)projectForProjectID:(NSString *)myID {
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid == %@",myID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

@end
