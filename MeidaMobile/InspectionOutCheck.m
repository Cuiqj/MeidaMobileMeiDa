//
//  InspectionOutCheck.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InspectionOutCheck.h"


@implementation InspectionOutCheck

@dynamic checkresult;
@dynamic checktext;
@dynamic inspectionid;
@dynamic isuploaded;
@dynamic myid;
@dynamic remark;

- (NSString *) signStr{
    if (![self.inspectionid isEmpty]) {
        return [NSString stringWithFormat:@"inspectionid == %@", self.inspectionid];
    }else{
        return @"";
    }
}

+ (NSArray *)outChecksForInspection:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"inspectionid == %@",inspectionID]];
    } else {
        [fetchRequest setPredicate:nil];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
