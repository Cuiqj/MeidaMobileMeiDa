//
//  TBXML+TraverseAddition.m
//  GDRMMobile
//
//  Created by XU SHIWEN on 13-7-31.
//
//

#import "TBXML+TraverseAddition.h"

@implementation TBXML (TraverseAddition)

//找到满足节点路径为path的元素，查找条件predicate可以为nil，不为nil时形式必须为"aaa.bbb = ccc"，即拥有子路径aaa.bbb且bbb包含的文本内容为ccc
//返回的数组的元素是经过NSValue装箱的TBXMLElement指针，拆箱时使用pointerValue消息
+ (NSArray *)findElementsFrom:(TBXMLElement *)root byDotSeparatedPath:(NSString *)path withPredicate:(NSString *)predicate{
    if (root != nil) {
        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *paths = [path componentsSeparatedByString:@"."];
        if ([paths count] > 0) {
            __block NSMutableArray *elementsWithoutPredict = [[NSMutableArray alloc] init];
            [TBXML iterateElementsForQuery:path fromElement:root withBlock:^(TBXMLElement *el){
                [elementsWithoutPredict addObject:[NSValue valueWithPointer:el]];
            }];
            predicate = [predicate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (predicate != nil && ![predicate isEqualToString:@""]) {
                NSArray *predictParams = [predicate componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([predictParams count] == 3) {
                    NSString *subpathString = predictParams[0];
                    NSString *predictValue = predictParams[2];
                    if ([[subpathString componentsSeparatedByString:@"."] count] >0) {
                        __block NSMutableArray *elementsWithPredict = [[NSMutableArray alloc] init];
                        for (NSValue *wrappedElement in elementsWithoutPredict) {
                            TBXMLElement *element = (TBXMLElement *)wrappedElement.pointerValue;
                            [TBXML iterateElementsForQuery:subpathString fromElement:element withBlock:^(TBXMLElement *el){
                                if ([[TBXML textForElement:el] isEqualToString:predictValue]) {
                                    [elementsWithPredict addObject:wrappedElement];
                                    //NSLog(@"Elements found : root: %@, predict: %@", path, predicate);
                                }
                            }];
                        }
                        return [elementsWithPredict copy];
                    }
                }
            } else {
                return [elementsWithoutPredict copy];
            }
        }
    }
    return nil;
}

@end
