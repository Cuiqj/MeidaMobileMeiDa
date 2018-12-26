//
//  TBXML+TraverseAddition.h
//  GDRMMobile
//
//  Created by XU SHIWEN on 13-7-31.
//
//

#import "TBXML.h"

@interface TBXML (TraverseAddition)
+ (NSArray *)findElementsFrom:(TBXMLElement *)root byDotSeparatedPath:(NSString *)path withPredicate:(NSString *)predicate;
@end
