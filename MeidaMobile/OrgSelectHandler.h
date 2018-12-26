//
//  OrgSelectHandler.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrgSelectHandler <NSObject>
-(void)setOrg:(NSString *)org;
-(void)setOrgName:(NSString *)orgname;

@end
