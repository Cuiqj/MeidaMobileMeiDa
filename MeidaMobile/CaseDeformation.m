//
//  CaseDeformation.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "CaseDeformation.h"


@implementation CaseDeformation

@dynamic proveinfo_id;
@dynamic citizen_name;
@dynamic isuploaded;
@dynamic myid;
@dynamic price;
@dynamic quantity;
@dynamic rasset_size;
@dynamic remark;
@dynamic roadasset_name;
@dynamic total_price;
@dynamic unit;

- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}

+ (NSArray *)deformationsForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (NSArray *)deformationsForCase:(NSString *)caseID forCitizen:(NSString *)citizen{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && citizen_name == %@",caseID,citizen];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
