//
//  RoadSegment.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoadSegment : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * delflag;
@property (nonatomic, retain) NSString * driveway_count;
@property (nonatomic, retain) NSNumber * group_flag;
@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * place_end;
@property (nonatomic, retain) NSString * place_start;
@property (nonatomic, retain) NSString * place_prefix1;
@property (nonatomic, retain) NSString * place_prefix2;
@property (nonatomic, retain) NSString * road_grade;
@property (nonatomic, retain) NSString * road_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;

//根据路段ID返回路段名称
+ (NSString *)roadNameFromSegment:(NSString *)segmentID;

+ (RoadSegment *)roadSegmentFromSegmentID:(NSString *)segmentID;
//返回所有的路段名称和路段号
+ (NSArray *)allRoadSegments;
@end
