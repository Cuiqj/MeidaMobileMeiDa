//
//  CheckItems.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckItems : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * checktext;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * checktype;

+ (NSArray *)allCheckItemsForType:(NSInteger)checkType;
@end
