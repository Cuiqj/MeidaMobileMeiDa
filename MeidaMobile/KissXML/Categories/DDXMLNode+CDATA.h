//
//  DDXMLNode+CDATA.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-27.
//
//

#import "DDXMLNode.h"

@interface DDXMLNode (CDATA)

/**
 Creates a new XML element with an inner CDATA block
 <name><![CDATA[string]]></name>
 */
+ (id)cdataElementWithName:(NSString *)name stringValue:(NSString *)string;

@end
