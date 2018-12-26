//
//  InitInquireAnswerSentence.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitInquireAnswerSentence.h"
#import "TBXML.h"

#import "InquireAnswerSentence.h"

@implementation InitInquireAnswerSentence
- (void)downloadInquireAnswerSentence{
    WebServiceInit;
    [service downloadDataSet:@"select * from InquireAnswerSentence"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"InquireAnswerSentence" andInXMLString:webString];
}
@end
