//
//  CaseServiceReceipt.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "CaseServiceReceipt.h"
#import "CaseServiceFiles.h"


@implementation CaseServiceReceipt

@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic incepter_name;
@dynamic remark;
@dynamic service_position;
@dynamic myid;
@dynamic service_company;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+(CaseServiceReceipt *)newCaseServiceReceiptForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseServiceReceipt *caseServiceReceipt = [[CaseServiceReceipt alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseServiceReceipt.caseinfo_id = caseID;
    caseServiceReceipt.isuploaded = @(NO);
    caseServiceReceipt.myid = [NSString randomID];
    [[AppDelegate App] saveContext];
    return caseServiceReceipt;
}

+ (CaseServiceReceipt *)caseServiceReceiptForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if (result && [result count]>0) {
        return [result objectAtIndex:0];
    }else{
        return nil;
    }
}

- (NSArray *)file_list{
    return [CaseServiceFiles caseServiceFilesForCase:self.caseinfo_id];
}
@end
