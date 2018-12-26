//
//  InitFileCode.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-8.
//
//

#import "InitFileCode.h"
#import "TBXML.h"

@implementation InitFileCode

-(void)downLoadFileCode{
    WebServiceInit;
    [service downloadDataSet:@"select * from FileCode"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"FileCode" andInXMLString:webString];
}

@end
