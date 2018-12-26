//
//  CaseServiceFiles.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "CaseServiceFiles.h"
#import "CaseDocuments.h"
#import "CaseServiceReceipt.h"
#import "CaseInfo.h"


@implementation CaseServiceFiles

@dynamic receipt_date;
@dynamic receipter_name;
@dynamic service_file;
@dynamic servicereceipt_id;
@dynamic servicer_name;
@dynamic myid;
@dynamic remark;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.servicereceipt_id isEmpty]) {
        return [NSString stringWithFormat:@"servicereceipt_id == %@", self.servicereceipt_id];
    }else{
        return @"";
    }
}

+ (CaseServiceFiles *)newCaseServiceFilesForCaseServiceReceipt:(NSString *)receiptID
{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseServiceFiles *caseServiceFiles = [[CaseServiceFiles alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseServiceFiles.myid = [NSString randomID];
    caseServiceFiles.servicereceipt_id = receiptID;
    caseServiceFiles.isuploaded = @(NO);
    [[AppDelegate App] saveContext];
    return caseServiceFiles;
}

+ (NSArray *)caseServiceFilesForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseServiceFiles" inManagedObjectContext:context];
    CaseServiceReceipt *serviceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:caseID];
    if (serviceReceipt) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"servicereceipt_id==%@",serviceReceipt.myid];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        return [context executeFetchRequest:fetchRequest error:nil];
    }
    return [NSArray array];
}

+ (NSArray *)caseServiceFilesForCaseServiceReceipt:(NSString *)receiptID
{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseServiceFiles" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"servicereceipt_id==%@", receiptID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    return [context executeFetchRequest:fetchRequest error:nil];
}


+ (NSArray *)addDefaultCaseServiceFilesForCase:(NSString *)caseID forCaseServiceReceipt:(NSString *)receiptID
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
    NSMutableArray *addedFiles = [NSMutableArray array];
    if (caseInfo) {
        if ([caseInfo.case_type_id isEqualToString:CaseTypeIDPei]) {
            CaseServiceFiles *defaultServiceFile1 = [CaseServiceFiles newCaseServiceFilesForCaseServiceReceipt:receiptID];
            defaultServiceFile1.service_file = @"公路赔（补）偿通知书";
            [addedFiles addObject:defaultServiceFile1];
            
            CaseServiceFiles *defaultServiceFile2 = [CaseServiceFiles newCaseServiceFilesForCaseServiceReceipt:receiptID];
            defaultServiceFile2.service_file = @"损坏公路设施索赔清单";
            [addedFiles addObject:defaultServiceFile2];
            
            CaseServiceFiles *defaultServiceFile3 = [CaseServiceFiles newCaseServiceFilesForCaseServiceReceipt:receiptID];
            defaultServiceFile3.service_file = @"责令车辆停驶通知书";
            [addedFiles addObject:defaultServiceFile2];
        }
    }
    return addedFiles;
}

@end
