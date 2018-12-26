//
//  RoadSegment.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import "RoadSegment.h"


@implementation RoadSegment

@dynamic code;
@dynamic delflag;
@dynamic driveway_count;
@dynamic group_flag;
@dynamic group_id;
@dynamic name;
@dynamic organization_id;
@dynamic place_end;
@dynamic place_start;
@dynamic place_prefix1;
@dynamic place_prefix2;
@dynamic road_grade;
@dynamic road_id;
@dynamic myid;
@dynamic station_end;
@dynamic station_start;

//根据路段ID返回路段名称
+ (NSString *)roadNameFromSegment:(NSString *)segmentID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",segmentID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        id obj=[temp objectAtIndex:0];
        return [obj name];
    } else {
        return @"";
    }
}

+ (RoadSegment *)roadSegmentFromSegmentID:(NSString *)segmentID {
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",segmentID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp objectAtIndex:0];
    } else {
        return nil;
    }
}

//返回所有的路段名称和路段号
+ (NSArray *)allRoadSegments{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
