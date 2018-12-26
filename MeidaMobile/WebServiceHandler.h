//
//  WebServiceHandler.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WebServiceReturnString;

@interface WebServiceHandler : NSObject;
@property (nonatomic,retain) id<WebServiceReturnString> delegate;

-(void)getPermitData:(NSString *)permitNo 
           startDate:(NSString *)startdate 
             endDate:(NSString *)enddate
         permitOrgId:(NSString *)orgId;
-(void)executeWebService:(NSString *)serviceName
             serviceParm:(NSString *)parms;
-(void)getPermitAppInfo:(NSString *)permit_no;
-(void)getPermitUnlimitInfo:(NSString *)permit_no;
-(void)getPermitAdvInfo:(NSString *)permit_no;
-(void)getPermitAuditListInfo:(NSString *)permit_no;
-(void)getPermitattechmentListInfo:(NSString *)permit_no;
-(void)getOrgInfo;
-(void)getUserInfo;
-(void)getIconModels;

- (void)downloadDataSet:(NSString *)strSQL;
- (void)uploadDataSet:(NSString *)xmlDataFile;

//测试网络连通性
+ (BOOL)isServerReachable;
@end

@protocol WebServiceReturnString <NSObject>
@optional
- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName;
- (void)requestTimeOut;
- (void)requestUnkownError;

@end
