//
//  InitData.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-10-9.
//
//

#import "InitData.h"

@implementation InitData

- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    [self xmlParser:webString];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ParserFinished" object:nil userInfo:nil];
}

- (void)autoParserForDataModel:(NSString *)dataModelName andInXMLString:(NSString *)xmlString{
    [[AppDelegate App] clearEntityForName:dataModelName];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    if (!error) {
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
        TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
        TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
        TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
        
        TBXMLElement *table=r4->firstChild;
        while (table) {
            @autoreleasepool {
                NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:dataModelName inManagedObjectContext:context];
                id obj = [[NSClassFromString(dataModelName) alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                TBXMLElement *tableChild = table->firstChild;
                while (tableChild) {
                    @autoreleasepool {
                        NSString *elementName = [[TBXML elementName:tableChild] lowercaseString];
                        if ([elementName isEqualToString:@"id"]) {
                            elementName = @"myid";
                        }
                        if ([obj respondsToSelector:NSSelectorFromString(elementName)]) {
                            NSDictionary *attributes = [entity attributesByName];
                            NSAttributeDescription *attriDesc = [attributes objectForKey:elementName];
                            switch (attriDesc.attributeType) {
                                case NSStringAttributeType:
                                    [obj setValue:[TBXML textForElement:tableChild] forKey:elementName];
                                    break;
                                case NSBooleanAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].boolValue) forKey:elementName];
                                    break;
                                case NSFloatAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].floatValue) forKey:elementName];
                                    break;
                                case NSDoubleAttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].doubleValue) forKey:elementName];
                                    break;
                                case NSDateAttributeType:{
                                    NSString *dateString = [TBXML textForElement:tableChild];
                                    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmss'.'SSSSSSSZ"];
                                    [obj setValue:[dateFormatter dateFromString:dateString] forKey:elementName];
                                }
                                    break;
                                case NSInteger16AttributeType:
                                case NSInteger32AttributeType:
                                case NSInteger64AttributeType:
                                    [obj setValue:@([TBXML textForElement:tableChild].integerValue) forKey:elementName];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                    tableChild = tableChild->nextSibling;
                }
                [[AppDelegate App] saveContext];
                table = table->nextSibling;
            }
        }
    }
}

- (void)xmlParser:(NSString *)webString{};

@end