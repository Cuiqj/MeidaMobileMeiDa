//
//  DDXMLNode+CDATA.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-27.
//
//

#import "DDXMLNode+CDATA.h"
#import "DDXMLElement.h"
#import "DDXMLDocument.h"

@implementation DDXMLNode (CDATA)

+ (id)cdataElementWithName:(NSString *)name stringValue:(NSString *)string
{
    NSString* nodeString = [NSString stringWithFormat:@"<%@><![CDATA[%@]]></%@>", name, string, name];
    DDXMLElement* cdataNode = [[DDXMLDocument alloc] initWithXMLString:nodeString
                                                               options:DDXMLDocumentXMLKind
                                                                 error:nil].rootElement;
    return [cdataNode copy];
}

@end
