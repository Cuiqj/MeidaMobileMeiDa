//
//  Provinces.h
//  GDRMMobile
//
//  Created by Sniper One on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Provinces : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * short_name;
@property (nonatomic, retain) NSString * long_name;

@end
