//
//  CheckReason.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "CheckReason.h"


@implementation CheckReason

@dynamic checktype_id;
@dynamic remark;
@dynamic reasonname;
+(NSArray *)reasonForCheckType:(NSString *)typeID{
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
