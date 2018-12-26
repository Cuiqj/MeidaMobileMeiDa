//
//  InspectionPath.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "InspectionPath.h"


@implementation InspectionPath

@dynamic checktime;
@dynamic inspectionid;
@dynamic myid;
@dynamic stationname;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.inspectionid isEmpty]) {
        return [NSString stringWithFormat:@"inspectionid == %@", self.inspectionid];
    }else{
        return @"";
    }
}

+ (NSArray *)pathsForInspection:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"inspectionid == %@",inspectionID]];
    } else {
        [fetchRequest setPredicate:nil];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checktime" ascending:YES];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
