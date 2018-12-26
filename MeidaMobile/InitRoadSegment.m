//
//  InitRoadSegment.m
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadSegment.h"
#import "RoadSegment.h"

@implementation InitRoadSegment

- (void)downloadRoadSegment{
    WebServiceInit;
    [service downloadDataSet:@"select * from RoadSegment"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"RoadSegment" andInXMLString:webString];
    /*
    [[AppDelegate App] clearEntityForName:@"RoadSegment"];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadSegment" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    
    TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
    TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
    TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
    TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
    
    TBXMLElement *row=[TBXML childElementNamed:@"Table" parentElement:r4];

    while (row) {
        RoadSegment *road=[[RoadSegment alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        road.myid=[TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:row ]];
        road.station_start=[NSNumber numberWithInteger:[[TBXML textForElement:[TBXML childElementNamed:@"station_start" parentElement:row]] integerValue]];
        road.station_end=[NSNumber numberWithInteger:[[TBXML textForElement:[TBXML childElementNamed:@"station_end" parentElement:row]] integerValue]];
        road.place_start=[TBXML textForElement:[TBXML childElementNamed:@"place_start" parentElement:row]];
        road.place_end=[TBXML textForElement:[TBXML childElementNamed:@"place_end" parentElement:row]];
        road.driveway_count=[TBXML textForElement:[TBXML childElementNamed:@"driveway_count" parentElement:row]];
        road.road_grade=[TBXML textForElement:[TBXML childElementNamed:@"road_grade" parentElement:row]];
        road.group_id=[TBXML textForElement:[TBXML childElementNamed:@"group_id" parentElement:row]];
        road.group_flag=[NSNumber numberWithInteger:[[TBXML textForElement:[TBXML childElementNamed:@"group_flag" parentElement:row]] integerValue]];
        
        TBXMLElement *xmlCode=[TBXML childElementNamed:@"code" parentElement:row];
        NSString *code=[TBXML textForElement:xmlCode];
        road.code=code;
        TBXMLElement *xmlName=[TBXML childElementNamed:@"name" parentElement:row];
        NSString *name=[TBXML textForElement:xmlName];
        road.name=name;
        TBXMLElement *xmlroadId=[TBXML childElementNamed:@"road_id" parentElement:row];
        NSString *roadId=[TBXML textForElement:xmlroadId];
        road.road_id=roadId;
        TBXMLElement *xmlOrgID=[TBXML childElementNamed:@"organization_id" parentElement:row];
        NSString *orgID=[TBXML textForElement:xmlOrgID];
        road.organization_id=orgID;
        TBXMLElement *xmlPlacePrefix1=[TBXML childElementNamed:@"place_prefix1" parentElement:row];
        road.place_prefix1=[TBXML textForElement:xmlPlacePrefix1];
        TBXMLElement *xmlPlacePrefix2 = [TBXML childElementNamed:@"place_prefix2" parentElement:row];
        road.place_prefix2 = [TBXML textForElement:xmlPlacePrefix2];
        TBXMLElement *xmlDelflag = [TBXML childElementNamed:@"delflag" parentElement:row];
        road.delflag = [TBXML textForElement:xmlDelflag];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
     */
}
/*
+(void)initRoadSegment{
    void(^RoadSegmentParser)(void)=^(void){
    };
//    BACKDISPATCH(XMLParser);
    RoadSegmentParser();
}
*/

@end
