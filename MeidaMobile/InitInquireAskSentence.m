//
//  InitInquireAskSentence.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitInquireAskSentence.h"


@implementation InitInquireAskSentence
- (void)downloadInquireAskSentence{
    WebServiceInit;
    [service downloadDataSet:@"select * from InquireAskSentence where case_type = '赔补偿'"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"InquireAskSentence" andInXMLString:webString];
}
/*
+(void)initInquireAskSentence{
    void(^InquireAskSentenceParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"InquireAskSentence"];
        [[AppDelegate App] saveContext];
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"InquireAskSentence" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"InquireAskSentence" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *r1=[TBXML childElementNamed:@"dbo.InquireAskSentence" parentElement:root];
        while (r1)
        {
            InquireAskSentence *ias=[[InquireAskSentence alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *child1=[TBXML childElementNamed:@"sentence" parentElement:r1];
            ias.sentence=[TBXML textForElement:child1];
            TBXMLElement *child2=[TBXML childElementNamed:@"the_index" parentElement:r1];
            ias.index=[TBXML textForElement:child2];
            TBXMLElement *child3=[TBXML childElementNamed:@"id" parentElement:r1];
            ias.ask_id=[TBXML textForElement:child3];
            [[AppDelegate App] saveContext];
            r1=r1->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    InquireAskSentenceParser();
}
*/ 
@end
