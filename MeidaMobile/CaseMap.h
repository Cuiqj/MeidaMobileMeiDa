//
//  CaseMap.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface CaseMap : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * draftsman_name;
@property (nonatomic, retain) NSDate * draw_time;
@property (nonatomic, retain) NSString * road_type;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * map_item;

+ (CaseMap *)caseMapForCase:(NSString *)caseID;

- (NSString *)map_remark;

- (NSString *)map_file;
@end
