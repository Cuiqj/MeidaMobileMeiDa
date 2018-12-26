//
//  CheckType.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "CheckType.h"


@implementation CheckType

@dynamic myid;
@dynamic remark;
@dynamic name;
@dynamic item;

+(NSArray *)allCheckType{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    fetchRequest.predicate=nil;
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
