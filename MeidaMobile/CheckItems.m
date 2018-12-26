//
//  CheckItems.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-7.
//
//

#import "CheckItems.h"


@implementation CheckItems

@dynamic myid;
@dynamic checktext;
@dynamic remark;
@dynamic checktype;

+ (NSArray *)allCheckItemsForType:(NSInteger)checkType{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"checktype.integerValue==%d",checkType]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
