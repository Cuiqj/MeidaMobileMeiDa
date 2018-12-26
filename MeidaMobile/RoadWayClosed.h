//
//  RoadWayClosed.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface RoadWayClosed : BaseManageObject

@property (nonatomic, retain) NSString * closed_reason;
@property (nonatomic, retain) NSString * closed_result;
@property (nonatomic, retain) NSString * closed_roadway;
@property (nonatomic, retain) NSString * creater;
@property (nonatomic, retain) NSString * fix;
@property (nonatomic, retain) NSString * is_importance;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * it_company;
@property (nonatomic, retain) NSString * it_duty;
@property (nonatomic, retain) NSString * it_telephone;
@property (nonatomic, retain) NSString * maintainplan_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * promulgate;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSDate * time_end;
@property (nonatomic, retain) NSDate * time_start;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;

+ (NSArray *)roadWayCloseInfoForID:(NSString *)roadWayCloseID;
@end
