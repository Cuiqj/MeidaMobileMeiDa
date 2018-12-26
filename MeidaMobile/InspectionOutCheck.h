//
//  InspectionOutCheck.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface InspectionOutCheck : BaseManageObject

@property (nonatomic, retain) NSString * checkresult;
@property (nonatomic, retain) NSString * checktext;
@property (nonatomic, retain) NSString * inspectionid;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)outChecksForInspection:(NSString *)inspectionID;
@end
