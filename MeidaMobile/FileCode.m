//
//  FileCode.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-8.
//
//

#import "FileCode.h"


@implementation FileCode

@dynamic myid;
@dynamic file_name;
@dynamic province_code;
@dynamic organization_code;
@dynamic lochus_code;
@dynamic file_code;
@dynamic year_digit;
@dynamic serial_digit;
@dynamic is_year_first;
@dynamic rowguid;


+ (FileCode *)fileCodeWithPredicateFormat:(NSString *)predicateStr
{
    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"file_name == %@", predicateStr];
    request.predicate = predicate;
    NSError *err = nil;
    NSArray *rets = [context executeFetchRequest:request error:&err];
    return [rets lastObject];
}

@end
