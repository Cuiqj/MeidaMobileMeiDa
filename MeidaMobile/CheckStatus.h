//
//  CheckStatus.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckStatus : NSManagedObject

@property (nonatomic, retain) NSString * checktype_id;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * statusname;

+ (NSArray *)statusForCheckType:(NSString *)typeID;
@end
