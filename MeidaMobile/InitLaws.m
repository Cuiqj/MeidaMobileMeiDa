//
//  InitLaws.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InitLaws.h"

@implementation InitLaws
- (void)downLoadLaws{
    WebServiceInit;
    [service downloadDataSet:@"select * from Laws"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"Laws" andInXMLString:webString];
}
@end

@implementation InitLawBreakingAction

- (void)downloadLawBreakingAction{
    WebServiceInit;
    [service downloadDataSet:@"select * from LawbreakingAction"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"LawbreakingAction" andInXMLString:webString];
}
@end

@implementation InitLawItems

- (void)downloadLawItems{
    WebServiceInit;
    [service downloadDataSet:@"select * from LawItems"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"LawItems" andInXMLString:webString];
}
@end

@implementation InitMatchLaw

- (void)downloadMatchLaw{
    WebServiceInit;
    [service downloadDataSet:@"select * from MatchLaw"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"MatchLaw" andInXMLString:webString];
}
@end

@implementation InitMatchLawDetails

- (void)downloadMatchLawDetails{
    WebServiceInit;
    [service downloadDataSet:@"select * from MatchLawDetails"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"MatchLawDetails" andInXMLString:webString];
}
@end