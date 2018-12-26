//
//  LawbreakingAction.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "LawbreakingAction.h"


@implementation LawbreakingAction

@dynamic caption;
@dynamic casetype_id;
@dynamic myid;
@dynamic remark;

+ (NSArray *)LawbreakingActionsForCasetype:(NSString *)caseTypeID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if ([caseTypeID isEmpty]) {
        [fetchRequest setPredicate:nil];
    } else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"casetype_id == %@ ",caseTypeID]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (NSArray *)LawbreakingActionsForCase:(NSString *)myID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@ ",myID]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
