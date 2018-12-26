//
//  CheckHandle.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckHandle : NSManagedObject

@property (nonatomic, retain) NSString * checktype_id;
@property (nonatomic, retain) NSString * handle_name;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)handleForCheckType:(NSString *)typeID;
@end
