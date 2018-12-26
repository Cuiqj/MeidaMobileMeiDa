//
//  InitSystype.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "InitSystype.h"

@implementation InitSystype
- (void)downloadSysType{
    WebServiceInit;
    [service downloadDataSet:@"select * from SysType"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"Systype" andInXMLString:webString];
}
/*
+ (void)initSystype{
    void(^SystypeParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"Systype"];
        [[AppDelegate App] saveContext];
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Systype" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"Systype" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *row=[TBXML childElementNamed:@"row" parentElement:root];
        while (row) {
            Systype *systype=[[Systype alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *child=[TBXML childElementNamed:@"sys_code" parentElement:row];
            if (child) {
                systype.sys_code=[TBXML textForElement:child];
            }
            child=[TBXML childElementNamed:@"code_name" parentElement:row];
            systype.code_name=[TBXML textForElement:child];
            child=[TBXML childElementNamed:@"type_code" parentElement:row];
            if (child) {
                systype.type_code=[TBXML textForElement:child];
            }
            child=[TBXML childElementNamed:@"type_value" parentElement:row];
            systype.type_value=[TBXML textForElement:child];
            [[AppDelegate App] saveContext];
            row=row->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    SystypeParser();
}
*/ 
@end
