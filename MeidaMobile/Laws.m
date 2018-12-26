//
//  Laws.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "Laws.h"


@implementation Laws

@dynamic caption;
@dynamic myid;
@dynamic remark;

+ (Laws *) lawsForLawID:(NSString *)lawID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",lawID]];
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if (result && [result count]>0) {
        return [result objectAtIndex:0];
    }else{
        return nil;
    }
}
@end
