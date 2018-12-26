//
//  InspectionRecord.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface InspectionRecord : BaseManageObject

@property (nonatomic, retain) NSString * fix;
@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * inspection_item;
@property (nonatomic, retain) NSString * inspection_type;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * measure;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * relationid;
@property (nonatomic, retain) NSString * relationType;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSNumber * station;
@property (nonatomic, retain) NSString * status;

+ (NSArray *)recordsForInspection:(NSString *)inspectionID;
@end
