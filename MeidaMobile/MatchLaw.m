//
//  MatchLaw.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "MatchLaw.h"


@implementation MatchLaw

@dynamic casetype_id;
@dynamic filetype_id;
@dynamic lawbreakingaction_id;
@dynamic myid;

+ (NSArray *)matchLawsForLawbreakingActionID:(NSString *)lawbreakActionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //[fetchRequest setPredicate:nil];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"lawbreakingaction_id == %@ ",lawbreakActionID]];
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
