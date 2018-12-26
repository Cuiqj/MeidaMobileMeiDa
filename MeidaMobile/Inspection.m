//
//  Inspection.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-26.
//
//

#import "Inspection.h"


@implementation Inspection

@dynamic carcode;
@dynamic classe;
@dynamic date_inspection;
@dynamic delivertext;
@dynamic duty_leader;
@dynamic inspection_description;
@dynamic inspection_milimetres;
@dynamic inspection_place;
@dynamic inspectionor_name;
@dynamic isdeliver;
@dynamic isuploaded;
@dynamic myid;
@dynamic organization_id;
@dynamic recorder_name;
@dynamic remark;
@dynamic time_end;
@dynamic time_start;
@dynamic weather;
@dynamic fuzeren;
@dynamic yjsx;
@dynamic yjzb;
@dynamic yjr;
@dynamic jsr;
@dynamic yjsj;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (NSArray *)inspectionForID:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"myid == %@",inspectionID]];
    } else {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"isdeliver.boolValue == YES"]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}

/*add by lxm
 *  新增删除历史巡查
 *
 *
 + (void)deleteInspectionForID:(NSString *)inspectionID withHistoryID:(NSString *)historyID{
 if (inspectionID && ![inspectionID isEmpty]) {
 NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
 NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
 NSPredicate *predicate=[NSPredicate predicateWithFormat:@"myid ==%@ && document_name == %@",inspectionID,historyID];
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
 */
@end
