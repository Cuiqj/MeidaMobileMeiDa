//
//  InitRoadAssetPrice.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadAssetPrice.h"

@implementation InitRoadAssetPrice

- (void)downloadRoadAssetPrice{
    WebServiceInit;
    [service downloadDataSet:@"select * from RoadAssetPrice"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"RoadAssetPrice" andInXMLString:webString];
}
/*
+(void)initRoadAssetPrice{
    void(^RoadAssetPriceParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"RoadAssetPrice"];
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"RoadAssetPrice" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *r1=[TBXML childElementNamed:@"irmsxeh_n.dbo.RoadAssetPrice" parentElement:root];
        while (r1) {
            RoadAssetPrice *roadAsset=[[RoadAssetPrice alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            roadAsset.roadasset_id=[TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:r1]];
            TBXMLElement *xmlLabel=[TBXML childElementNamed:@"label" parentElement:r1];
            NSString *label=[TBXML textForElement:xmlLabel];
            roadAsset.label=label;
            TBXMLElement *xmlRoadAssetType=[TBXML childElementNamed:@"roadasset_type" parentElement:r1];
            NSString *roadAssetType=[TBXML textForElement:xmlRoadAssetType];
            roadAsset.roadassettype=roadAssetType;
            TBXMLElement *xmlName=[TBXML childElementNamed:@"name" parentElement:r1];
            NSString *name=[TBXML textForElement:xmlName];
            roadAsset.name=name;
            TBXMLElement *xmlSpec=[TBXML childElementNamed:@"spec" parentElement:r1];
            NSString *spec=[TBXML textForElement:xmlSpec];
            roadAsset.spec=spec;
            TBXMLElement *xmlPrice=[TBXML childElementNamed:@"price" parentElement:r1];
            NSString *price=[TBXML textForElement:xmlPrice];
            roadAsset.price=[NSNumber numberWithDouble:[price doubleValue]];
            TBXMLElement *xmlUnitName=[TBXML childElementNamed:@"unit_name" parentElement:r1];
            NSString *unitName=[TBXML textForElement:xmlUnitName];
            roadAsset.unitname=unitName;
            TBXMLElement *xmlDocName=[TBXML childElementNamed:@"document_name" parentElement:r1];
            NSString *docName=[TBXML textForElement:xmlDocName];
            roadAsset.documentname=docName;
            TBXMLElement *xmlIsUnvarying=[TBXML childElementNamed:@"is_unvarying" parentElement:r1];
            roadAsset.isunvarying=[NSNumber numberWithInteger:[[TBXML textForElement:xmlIsUnvarying] integerValue]];
            TBXMLElement *xmlRemark=[TBXML childElementNamed:@"remark" parentElement:r1];
            roadAsset.remark=[TBXML textForElement:xmlRemark];
            [[AppDelegate App] saveContext];
            r1=r1->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    RoadAssetPriceParser();
}
*/ 
@end
