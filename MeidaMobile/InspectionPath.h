//
//  InspectionPath.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface InspectionPath : BaseManageObject

@property (nonatomic, retain) NSDate * checktime;
@property (nonatomic, retain) NSString * inspectionid;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * stationname;
@property (nonatomic, retain) NSNumber * isuploaded;

+ (NSArray *)pathsForInspection:(NSString *)inspectionID;
@end
