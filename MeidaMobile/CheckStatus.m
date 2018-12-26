//
//  CheckStatus.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "CheckStatus.h"


@implementation CheckStatus

@dynamic checktype_id;
@dynamic remark;
@dynamic statusname;
+ (NSArray *)statusForCheckType:(NSString *)typeID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    if ([typeID isEmpty]) {
        fetchRequest.predicate=nil;
    } else {
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"checktype_id == %@",typeID];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
