//
//  CaseDocuments.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CaseDocuments.h"


@implementation CaseDocuments

@dynamic caseinfo_id;
@dynamic document_name;
@dynamic document_path;

+ (void)deleteDocumentsForCase:(NSString *)caseID docName:(NSString *)docName{
    if (docName && ![docName isEmpty]) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && document_name == %@",caseID,docName];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
        for (CaseDocuments *doc in temp) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:doc.document_path]){
                [[NSFileManager defaultManager] removeItemAtPath:doc.document_path error:nil];
            }
            [context deleteObject:doc];
            [[AppDelegate App] saveContext];
        }
    }
}

+ (NSArray *)caseDocumentsForCase:(NSString *)caseID docName:(NSString *)docName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && document_name == %@",caseID,docName];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (BOOL)isExistingDocumentForCase:(NSString *)caseID docPath:(NSString *)docPath{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && document_path == %@",caseID,docPath];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSInteger count = [context countForFetchRequest:fetchRequest error:nil];
    if (count > 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)allDocumentShortNamesForCaseTypeID:(NSString *)caseTypeID
{
    if ([caseTypeID isEqualToString:CaseTypeIDDefault] ||
        [caseTypeID isEqualToString:CaseTypeIDPei]) {
#ifdef DEBUG
        return @[@"勘验检查笔录",@"询问笔录",@"赔（补）偿通知书",@"现场勘验图",@"送达回证",@"赔（补）偿清单",@"责令车辆停驶通知书",@"解除责令车辆停驶通知书",@"施工整改通知书"];
#else
        return @[@"勘验检查笔录",@"询问笔录",@"赔（补）偿通知书",@"现场勘验图",@"送达回证",@"赔（补）偿清单",@"责令车辆停驶通知书",@"解除责令车辆停驶通知书"];
#endif
    }
    else if ([caseTypeID isEqualToString:CaseTypeIDFa]) {
        return @[@"勘验检查笔录(罚)",@"涉嫌违法行为告知书",@"责令改正通知书",@"公路违法行为告知表",@"询问笔录(罚)",@"责令车辆停驶通知书"];
    }
    else {
        return nil;
    }
}

+ (NSArray *)allDocumentFullNamesForCaseTypeID:(NSString *)caseTypeID
{
    if ([caseTypeID isEqualToString:CaseTypeIDDefault] ||
        [caseTypeID isEqualToString:CaseTypeIDPei]) {
#ifdef DEBUG
        return @[@"公路赔（补）偿案件勘验检查笔录",@"公路赔（补）偿案件询问笔录",@"公路赔（补）偿通知书",@"路产索赔现场勘查图",@"公路赔（补）偿案件管理文书送达回证",@"公路赔（补）偿清单",@"责令车辆停驶通知书",@"施工整改通知书（回执）"];
#else
        return @[@"公路赔（补）偿案件勘验检查笔录",@"公路赔（补）偿案件询问笔录",@"公路赔（补）偿通知书",@"路产索赔现场勘查图",@"公路赔（补）偿案件管理文书送达回证",@"公路赔（补）偿清单",@"责令车辆停驶通知书"];
#endif
    }
    else if ([caseTypeID isEqualToString:CaseTypeIDFa]) {
        return @[@"勘验检查笔录",@"涉嫌违法行为告知书",@"责令改正通知书（存根）",@"公路违法行为告知表",@"询问笔录",@"责令车辆停驶通知书"];
    }
    else {
        return nil;
    }
}

@end
