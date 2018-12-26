//
//  InitUser.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitUser.h"
#import "UserInfo.h"

@implementation InitUser

- (void)downLoadUserInfo{
    WebServiceInit;
    [service downloadDataSet:@"select * from UserInfo"];
}

- (void)xmlParser:(NSString *)webString{
    /*
    [[AppDelegate App] clearEntityForName:@"UserInfo"];
    NSError *error=nil;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    
    TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
    TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
    TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
    TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
    
    TBXMLElement *author=[TBXML childElementNamed:@"Table" parentElement:r4];
    if (author!=nil){
        do {
            TBXMLElement *myid=[TBXML childElementNamed:@"id" parentElement:author];
            if (myid!=nil){
                NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
                UserInfo *userInfo = [[UserInfo alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                NSString *myid_string=[TBXML textForElement:myid];
                userInfo.myid = myid_string;
                TBXMLElement *account=[TBXML childElementNamed:@"account" parentElement:author];
                userInfo.account = [TBXML textForElement:account];
                
                TBXMLElement *orgID=[TBXML childElementNamed:@"orgID" parentElement:author];
                userInfo.orgid = [TBXML textForElement:orgID];
                
                TBXMLElement *username=[TBXML childElementNamed:@"username" parentElement:author];
                userInfo.username = [TBXML textForElement:username];
                
            }
        } while ((author=author->nextSibling));
    }
    */
    [self autoParserForDataModel:@"UserInfo" andInXMLString:webString];
}

@end

@implementation InitOrgInfo

- (void)downLoadOrgInfo{
    WebServiceInit;
    [service downloadDataSet:@"select * from OrgInfo"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"OrgInfo" andInXMLString:webString];
}
@end
