//
//  Systype.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "Systype.h"


@implementation Systype

@dynamic sys_code;
@dynamic code_name;
@dynamic type_value;
@dynamic type_code;
@dynamic remark;

+ (NSArray *)typeValueForCodeName:(NSString *)codeName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
    NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"type_code" ascending:YES comparator:^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    [tempArray sortUsingDescriptors:@[sort]];
    tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray removeObject:@""];
    return [NSArray arrayWithArray:tempArray];
}
@end
