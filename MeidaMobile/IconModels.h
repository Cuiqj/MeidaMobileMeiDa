//
//  IconModels.h
//  GDRMMobile
//
//  Created by Danny Liu on 12-4-4.
//  Copyright (c) 2012年 SNDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IconItems, IconTexts;

@interface IconModels : NSManagedObject

@property (nonatomic, retain) NSString * iconangle;
@property (nonatomic, retain) NSString * iconheight;
@property (nonatomic, retain) NSString * iconid;
@property (nonatomic, retain) NSString * iconleft;
@property (nonatomic, retain) NSString * iconname;
@property (nonatomic, retain) NSString * icontop;
@property (nonatomic, retain) NSString * icontype;
@property (nonatomic, retain) NSString * iconwidth;
@property (nonatomic, retain) NSString * itemsxml;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSSet *texts;

+ (IconModels *)iconModelforID:(NSString *)iconid;
@end

@interface IconModels (CoreDataGeneratedAccessors)

- (void)addItemsObject:(IconItems *)value;
- (void)removeItemsObject:(IconItems *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

- (void)addTextsObject:(IconTexts *)value;
- (void)removeTextsObject:(IconTexts *)value;
- (void)addTexts:(NSSet *)values;
- (void)removeTexts:(NSSet *)values;

@end
