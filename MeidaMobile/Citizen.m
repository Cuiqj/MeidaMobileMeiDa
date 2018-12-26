//
//  Citizen.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import "Citizen.h"


@implementation Citizen

@dynamic address;
@dynamic age;
@dynamic automobile_address;
@dynamic automobile_number;
@dynamic automobile_owner;
@dynamic automobile_pattern;
@dynamic bad_desc;
@dynamic card_name;
@dynamic card_no;
@dynamic carowner;
@dynamic carowner_address;
@dynamic proveinfo_id;
@dynamic compensate_money;
@dynamic driver;
@dynamic isuploaded;
@dynamic myid;
@dynamic nation;
@dynamic nationality;
@dynamic nexus;
@dynamic org_name;
@dynamic org_principal;
@dynamic org_principal_duty;
@dynamic org_principal_tel_number;
@dynamic org_tel_number;
@dynamic original_home;
@dynamic party;
@dynamic patry_type;
@dynamic postalcode;
@dynamic profession;
@dynamic proportion;
@dynamic remark;
@dynamic sex;
@dynamic tel_number;
@dynamic org_full_name;

- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}

+ (NSArray *)allCitizenNameForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,@"当事人"];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (Citizen *)citizenForName:(NSString *)autoNumber nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && automobile_number==%@",caseID,nexus,autoNumber];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}

+ (Citizen *)citizenForParty:(NSString *)party case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && party==%@",caseID,@"当事人",party];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
+ (Citizen *)citizenForParty:(NSString *)party case:(NSString *)caseID nexus:(NSString*)nexus{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@ && party==%@",caseID,nexus,party];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}

//add by lxm 2013.05.10
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
@end
