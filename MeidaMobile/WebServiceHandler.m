//
//  WebServiceHandler.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebServiceHandler.h"

static NSString *PASSWORD=@"Xinlu:Admin";

@implementation WebServiceHandler
@synthesize delegate=_delegate;

//测试网络连通性
+ (BOOL)isServerReachable{
    NSURL *url1 = [NSURL URLWithString:[[AppDelegate App] serverAddress]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
    if (response == nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"连接错误" message:@"无法连接到服务器，请检查网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
        return NO;
    }
    return YES;
}

-(void)getPermitData:(NSString *)permitNo 
                       startDate:(NSString *)startdate 
                         endDate:(NSString *)enddate
                     permitOrgId:(NSString *)orgId{
    //得到许可列表
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getPermitList> \n"
                           "  <q0:in0>%@</q0:in0> \n"
                           "  <q0:in1>%@</q0:in1> \n"
                           "  <q0:in2>%@</q0:in2> \n"
                           "  <q0:in3>%@</q0:in3>  \n"
                           " </q0:getPermitList> \n",orgId,startdate,enddate,permitNo];
    [self executeWebService:@"getPermitList" serviceParm:soapMessage];
}

-(void)getOrgInfo{
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getOrgList> \n"
                           " </q0:getOrgList> \n"];
    [self executeWebService:@"getOrgList" serviceParm:soapMessage];
   
}
-(void)getUserInfo{
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getUserInfo> \n"
                           " </q0:getUserInfo> \n"];
    [self executeWebService:@"getUserInfo" serviceParm:soapMessage];
    
}
-(void)getPermitAppInfo:(NSString *)permit_no{
    //得到许可信息
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getPermitInfo_app> \n"
                           "  <q0:in0>%@</q0:in0> \n"
                           " </q0:getPermitInfo_app> \n",permit_no];
    [self executeWebService:@"getPermitInfo_app" serviceParm:soapMessage];

}
-(void)getPermitUnlimitInfo:(NSString *)permit_no{
    //得到超限许可信息
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getPermitInfo_unl> \n"
                           "  <q0:in0>%@</q0:in0> \n"
                           " </q0:getPermitInfo_unl> \n",permit_no];
    [self executeWebService:@"getPermitInfo_unl" serviceParm:soapMessage];
}
-(void)getPermitAdvInfo:(NSString *)permit_no{
    //得到广告许可信息
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getPermitInfo_adv> \n"
                           "  <q0:in0>%@</q0:in0> \n"
                           " </q0:getPermitInfo_adv> \n",permit_no];
    [self executeWebService:@"getPermitInfo_adv" serviceParm:soapMessage];
}
-(void)getPermitAuditListInfo:(NSString *)permit_no{
    //得到许可审批信息
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getPermitAuditList> \n"
                           "  <q0:in0>%@</q0:in0> \n"
                           " </q0:getPermitAuditList> \n",permit_no];
    [self executeWebService:@"getPermitAuditList" serviceParm:soapMessage];
}
-(void)getPermitattechmentListInfo:(NSString *)permit_no{
    //得到许可附件信息
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getPermitAttach> \n"
                           "  <q0:in0>%@</q0:in0> \n"
                           " </q0:getPermitAttach> \n",permit_no];
    [self executeWebService:@"getPermitAttach" serviceParm:soapMessage];
}

-(void)getIconModels;{
    //得到所有图标模型信息
    NSString *soapMessage=[NSString stringWithFormat:@" <q0:getIconModels> \n"
                           " </q0:getIconModels> \n"];
    [self executeWebService:@"getIconModels" serviceParm:soapMessage];
}


- (void)downloadDataSet:(NSString *)strSQL{
    NSString *soapMessage = [[NSString alloc] initWithFormat:@" <DownloadDataSet xmlns=\"http://tempuri.org/IrmsData/MobileData\"> \n"
    "  <key>%@</key> \n"
    "  <strSQL>%@</strSQL> \n"
    " </DownloadDataSet> \n",PASSWORD,strSQL];
    [self executeWebService:@"DownloadDataSet" serviceParm:soapMessage];
}

- (void)uploadDataSet:(NSString *)xmlDataFile{
    NSString *soapMessage = [[NSString alloc] initWithFormat:@" <UploadDataSet xmlns=\"http://tempuri.org/IrmsData/MobileData\"> \n"
                             "  <key>%@</key> \n"
                             "  <ds>%@</ds> \n"
                             " </UploadDataSet> \n",PASSWORD,xmlDataFile];
    [self executeWebService:@"UploadDataSet" serviceParm:soapMessage];
}

-(void)executeWebService:(NSString *)serviceName
             serviceParm:(NSString *)parms{
    //web service request
    NSString *soapMessage=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" \n"
                           "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"  \n"
                           "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"> \n"
                           "<soapenv:Header/>"
                           "<soapenv:Body>  \n"
                           "%@"
                           "</soapenv:Body> \n"
                           "</soapenv:Envelope>",parms];
    NSString *urlString=[[[AppDelegate App] serverAddress] stringByAppendingString:@"/MobileData.asmx"];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/IrmsData/MobileData/%@",serviceName] forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (data.length > 0 && error == nil) {
            NSString *theXML = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            [self.delegate getWebServiceReturnString:theXML forWebService:serviceName];
        } else if (error != nil && error.code == NSURLErrorTimedOut) {
            [self.delegate requestTimeOut];
        } else if (error != nil) {
            [self.delegate requestUnkownError];
        }
    }];
}

- (void)dealloc{
    [self setDelegate:nil];
}

@end
