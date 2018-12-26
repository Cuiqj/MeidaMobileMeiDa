//
//  CheckReason.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckReason : NSManagedObject

@property (nonatomic, retain) NSString * checktype_id;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * reasonname;

+(NSArray *)reasonForCheckType:(NSString *)typeID;
@end
