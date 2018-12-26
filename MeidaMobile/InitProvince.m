//
//  InitUser.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitProvince.h"
#import "TBXML.h"

#import "Provinces.h"

@implementation InitProvince

- (void)downloadProvince{
    WebServiceInit;
    [service downloadDataSet:@"select * from Provinces"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"Provinces" andInXMLString:webString];
}
/*
+(void)initProvince{
    void(^ProvinceParser)(void)=^(void){
        NSError *error;
        [[AppDelegate App] clearEntityForName:@"Provinces"];
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"Provinces" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *r1=[TBXML childElementNamed:@"dbo.Provinces" parentElement:root];
        while (r1) {
            NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *modelsEntity=[NSEntityDescription entityForName:@"Provinces" inManagedObjectContext:entitySaveContext];
            Provinces *province=[[Provinces alloc]initWithEntity:modelsEntity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *xmlId=[TBXML childElementNamed:@"id" parentElement:r1];
            NSString *provinceid=[TBXML textForElement:xmlId];
            province.provinceid=provinceid;
            TBXMLElement *xmlShortName=[TBXML childElementNamed:@"short_name" parentElement:r1];
            NSString *shortName=[TBXML textForElement:xmlShortName];
            province.shortname=shortName;
            TBXMLElement *xmlLongName=[TBXML childElementNamed:@"long_name" parentElement:r1];
            NSString *longName=[TBXML textForElement:xmlLongName];
            province.longname=longName;
            [[AppDelegate App] saveContext];
            r1=r1->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    ProvinceParser();
}
*/

@end
