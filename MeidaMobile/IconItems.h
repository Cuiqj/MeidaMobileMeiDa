//
//  IconItems.h
//  GDRMMobile
//
//  Created by Danny Liu on 12-4-4.
//  Copyright (c) 2012年 SNDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IconModels.h"

@class IconModels;

@interface IconItems : NSManagedObject

@property (nonatomic, retain) NSString * itemtype;
@property (nonatomic, retain) NSNumber * itemx1;
@property (nonatomic, retain) NSNumber * itemy1;
@property (nonatomic, retain) NSNumber * itemx2;
@property (nonatomic, retain) NSNumber * itemy2;
@property (nonatomic, retain) IconModels *model;

@end
