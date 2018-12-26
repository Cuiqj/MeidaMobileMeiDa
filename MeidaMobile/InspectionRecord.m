//
//  InspectionRecord.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InspectionRecord.h"


@implementation InspectionRecord

@dynamic fix;
@dynamic inspection_id;
@dynamic inspection_item;
@dynamic inspection_type;
@dynamic isuploaded;
@dynamic location;
@dynamic measure;
@dynamic myid;
@dynamic relationid;
@dynamic relationType;
@dynamic remark;
@dynamic roadsegment_id;
@dynamic start_time;
@dynamic station;
@dynamic status;

- (NSString *)roadsegment_id{
    [self willAccessValueForKey:@"roadsegment_id"];
    int _id = [[self primitiveValueForKey:@"roadsegment_id"] intValue];
    [self didAccessValueForKey:@"roadsegment_id"];
    if (_id < 0) {
        _id = 0;
    }
    return [NSString stringWithFormat:@"%d", _id];
}

- (NSString *)signStr{
    if (![self.inspection_id isEmpty]) {
        return [NSString stringWithFormat:@"inspection_id == %@", self.inspection_id];
    }else{
        return @"";
    }
}

+ (NSArray *)recordsForInspection:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"inspection_id == %@",inspectionID];
        [fetchRequest setPredicate:predicate];
    } else {
        [fetchRequest setPredicate:nil];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start_time" ascending:YES];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
