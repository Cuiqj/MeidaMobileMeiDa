//
//  InitInspectionCheck.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "InitInspectionCheck.h"

@implementation InitCheckType

- (void)downLoadCheckType{
    WebServiceInit;
    [service downloadDataSet:@"select * from CheckType"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"CheckType" andInXMLString:webString];
    /*
    [[AppDelegate App] clearEntityForName:@"CheckType"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CheckType" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getCheckTypeModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:CheckTypeModel" parentElement:r2];
    while (row) {
        CheckType *check =[[CheckType alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child1=[TBXML childElementNamed:@"id" parentElement:row];
        check.checktype_id=[TBXML textForElement:child1];
        TBXMLElement *child2=[TBXML childElementNamed:@"name" parentElement:row];
        check.name=[TBXML textForElement:child2];
        TBXMLElement *child3=[TBXML childElementNamed:@"remark" parentElement:row];
        check.remark=[TBXML textForElement:child3];
        TBXMLElement *child4=[TBXML childElementNamed:@"item" parentElement:row];
        check.item=[TBXML textForElement:child4];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
    */ 
}
@end


#pragma mark -

@implementation InitCheckReason

- (void)downLoadCheckReason{
    WebServiceInit;
    [service downloadDataSet:@"select * from Reason"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"CheckReason" andInXMLString:webString];
    /*
    [[AppDelegate App] clearEntityForName:@"CheckReason"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CheckReason" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getReasonModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:ReasonModel" parentElement:r2];
    while (row) {
        CheckReason *check =[[CheckReason alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child1=[TBXML childElementNamed:@"checkType_id" parentElement:row];
        check.checktype_id=[TBXML textForElement:child1];
        TBXMLElement *child2=[TBXML childElementNamed:@"reasonName" parentElement:row];
        check.reasonname=[TBXML textForElement:child2];
        TBXMLElement *child3=[TBXML childElementNamed:@"remark" parentElement:row];
        check.remark=[TBXML textForElement:child3];
        TBXMLElement *child4 = [TBXML childElementNamed:@"reason_unit" parentElement:row];
        check.reason_unit = [TBXML textForElement:child4];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
    */ 
}
@end


#pragma mark -

@implementation InitCheckHandle

- (void)downLoadCheckHandle{
    WebServiceInit;
    [service downloadDataSet:@"select * from Handle"];
}

- (void)xmlParser:(NSString *)webString{
    /*
    [[AppDelegate App] clearEntityForName:@"CheckHandle"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CheckHandle" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getHandelModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:HandleModel" parentElement:r2];
    while (row) {
        CheckHandle *check =[[CheckHandle alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child1=[TBXML childElementNamed:@"checktype_id" parentElement:row];
        check.checktype_id=[TBXML textForElement:child1];
        TBXMLElement *child2=[TBXML childElementNamed:@"handle_name" parentElement:row];
        check.handle_name=[TBXML textForElement:child2];
        TBXMLElement *child3=[TBXML childElementNamed:@"remark" parentElement:row];
        check.remark=[TBXML textForElement:child3];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
    */
    [self autoParserForDataModel:@"CheckHandle" andInXMLString:webString];
}

@end


#pragma mark -

@implementation InitCheckStatus

- (void)downLoadCheckStatus{
    WebServiceInit;
    [service downloadDataSet:@"select * from Status"];
}

- (void)xmlParser:(NSString *)webString{
    /*
    [[AppDelegate App] clearEntityForName:@"CheckStatus"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CheckStatus" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getStatusModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:StatusModel" parentElement:r2];
    while (row) {
        CheckStatus *check =[[CheckStatus alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child1=[TBXML childElementNamed:@"checkType_id" parentElement:row];
        check.checktype_id=[TBXML textForElement:child1];
        TBXMLElement *child2=[TBXML childElementNamed:@"statusName" parentElement:row];
        check.statusname=[TBXML textForElement:child2];
        TBXMLElement *child3=[TBXML childElementNamed:@"remark" parentElement:row];
        check.remark=[TBXML textForElement:child3];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
    */
    [self autoParserForDataModel:@"CheckStatus" andInXMLString:webString];
}
@end

@implementation InitCheckItems

- (void)downloadCheckItems{
    WebServiceInit;
    [service downloadDataSet:@"select * from CheckItems"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"CheckItems" andInXMLString:webString];
}
@end

@implementation InitCheckItemDetails

- (void)downloadCheckItemDetails{
    WebServiceInit;
    [service downloadDataSet:@"select * from CheckItemDetails"];
}

- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"CheckItemDetails" andInXMLString:webString];
}

@end
/*
+(void)initCheckItems{
    void(^CheckItemsParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"CheckItems"];
        [[AppDelegate App] saveContext];
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CheckItems" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"CheckItems" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *row=[TBXML childElementNamed:@"dbo.CheckItems" parentElement:root];
        while (row) {
            CheckItems *items=[[CheckItems alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *child=[TBXML childElementNamed:@"id" parentElement:row];
            items.myid=[TBXML textForElement:child];
            child=[TBXML childElementNamed:@"checktext" parentElement:row];
            items.checktext=[TBXML textForElement:child];
            child=[TBXML childElementNamed:@"remark" parentElement:row];
            items.remark=[TBXML textForElement:child];
            child=[TBXML childElementNamed:@"checktype" parentElement:row];
            items.checktype=@([TBXML textForElement:child].integerValue);
            row=row->nextSibling;
        }
    };
    CheckItemsParser();
}

+(void)initCheckItemDetails{
    void(^CheckItemDetailsParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"CheckItemDetails"];
        [[AppDelegate App] saveContext];
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CheckItemDetails" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"CheckItemDetails" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *row=[TBXML childElementNamed:@"dbo.CheckItemDetails" parentElement:root];
        while (row) {
            CheckItemDetails *detail=[[CheckItemDetails alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *child=[TBXML childElementNamed:@"CheckItems_id" parentElement:row];
            detail.checkitems_id=[TBXML textForElement:child];
            child=[TBXML childElementNamed:@"caption" parentElement:row];
            detail.caption=[TBXML textForElement:child];
            child=[TBXML childElementNamed:@"theindex" parentElement:row];
            detail.theindex=@([TBXML textForElement:child].integerValue);
            child=[TBXML childElementNamed:@"remark" parentElement:row];
            detail.remark=[TBXML textForElement:child];
            row=row->nextSibling;
        }
    };
    CheckItemDetailsParser();
}

@end
*/ 
