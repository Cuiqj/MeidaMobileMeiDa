//
//  IconTexts.h
//  GDRMMobile
//
//  Created by Danny Liu on 12-4-4.
//  Copyright (c) 2012年 SNDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IconModels;

@interface IconTexts : NSManagedObject

@property (nonatomic, retain) NSString * textname;
@property (nonatomic, retain) NSString * textfontsize;
@property (nonatomic, retain) NSString * textleft;
@property (nonatomic, retain) NSString * texttop;
@property (nonatomic, retain) NSString * textwidth;
@property (nonatomic, retain) NSString * textHeight;
@property (nonatomic, retain) IconModels *model;

@end
