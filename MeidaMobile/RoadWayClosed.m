//
//  RoadWayClosed.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "RoadWayClosed.h"


@implementation RoadWayClosed

@dynamic closed_reason;
@dynamic closed_result;
@dynamic closed_roadway;
@dynamic creater;
@dynamic fix;
@dynamic is_importance;
@dynamic isuploaded;
@dynamic it_company;
@dynamic it_duty;
@dynamic it_telephone;
@dynamic maintainplan_id;
@dynamic myid;
@dynamic promulgate;
@dynamic remark;
@dynamic roadsegment_id;
@dynamic station_end;
@dynamic station_start;
@dynamic time_end;
@dynamic time_start;
@dynamic title;
@dynamic type;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}

+ (NSArray *)roadWayCloseInfoForID:(NSString *)roadWayCloseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if ([roadWayCloseID isEmpty]) {
        [fetchRequest setPredicate:nil];
    } else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@ ",roadWayCloseID]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
