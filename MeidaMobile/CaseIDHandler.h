//
//  CaseIDHandler.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CaseIDHandler <NSObject>

@optional
-(void)setCaseIDdelegate:(NSString *)caseID;
-(void)setCaseIDdelegate2:(NSString *)caseID;
-(void)setWeather:(NSString *)textWeather;
-(void)setAuotMobilePattern:(NSString *)textPattern;
-(void)setCaseDescArrayDelegate:(NSArray *)aCaseDescArray;
-(void)setBadDesc:(NSString *)textBadDesc;
-(void)setAutoNumber:(NSString *)textAutoNumber;
-(void)reloadDocuments;
-(void)loadInquireForAnswerer:(NSString *)answererName;
-(void)clearAutoInfo;
-(void)scrollViewNeedsMove;
-(void)deleteCaseAllDataForCase:(NSString *)caseID;
-(NSString *)getCaseIDdelegate;
-(NSString *)getAutoNumberDelegate;
-(NSArray *)getCaseDescArrayDelegate;
@end
