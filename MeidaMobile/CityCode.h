//
//  CityCode.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CityCode : NSManagedObject

@property (nonatomic, retain) NSString * city_code;
@property (nonatomic, retain) NSString * city_name;
@property (nonatomic, retain) NSString * province_id;

@end
