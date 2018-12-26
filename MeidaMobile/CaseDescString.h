//
//  CaseDescString.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//案由类，保存案由，案由编号，是否选中三个信息
@interface CaseDescString : NSObject
@property (nonatomic,copy) NSString * caseDesc;
@property (nonatomic,copy) NSString * caseDescID;
@property (nonatomic,assign) BOOL isSelected;
@end

