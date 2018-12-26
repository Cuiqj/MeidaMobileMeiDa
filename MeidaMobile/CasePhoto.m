//
//  CasePhoto.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-27.
//
//

#import "CasePhoto.h"


@implementation CasePhoto

@dynamic caseinfo_id;
@dynamic photo_name;

+(NSArray *)casePhotosForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (void)deletePhotoForCase:(NSString *)caseID photoName:(NSString *)photoName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@ && photo_name == %@",caseID,photoName];
    fetchRequest.predicate=predicate;
    NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in temp) {
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
}
@end
