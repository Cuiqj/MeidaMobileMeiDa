//
//  XMLPDFRenderer.m
//
//  Created by XU SHIWEN on 13-8-23.
//  Copyright (c) 2013年 XU SHIWEN. All rights reserved.
//

#import "XMLPDFRenderer.h"
#import "TBXML.h"

/*---------------------------------------------------------------*/

#pragma mark - ADPDFPage implementation

@implementation ADPDFPage
- (id)init
{
    self = [super init];
    self.mediaBox = CGRectZero;
    self.globalOffset = CGSizeZero;
    return self;
}
@end


/*---------------------------------------------------------------*/

#pragma mark - Constants

/* XMLPDFTag */
NSString * const XMLPDFTagTemplate              = @"pdf:template";
NSString * const XMLPDFTagPaper                 = @"pdf:paper";
NSString * const XMLPDFTagContent               = @"pdf:content";
NSString * const XMLPDFTagTable                 = @"pdf:table";
NSString * const XMLPDFTagTD                    = @"pdf:td";
NSString * const XMLPDFTagTR                    = @"pdf:tr";
NSString * const XMLPDFTagText                  = @"pdf:text";
NSString * const XMLPDFTagParagraph             = @"pdf:paragraph";
NSString * const XMLPDFTagLine                  = @"pdf:line";
NSString * const XMLPDFTagImage                 = @"pdf:image";
NSString * const XMLPDFTagGrid                  = @"pdf:grid";
/* XMLPDFAttribute */
NSString * const XMLPDFAttributeOffset          = @"offset";
NSString * const XMLPDFAttributeRect            = @"rect";
NSString * const XMLPDFAttributeWidth           = @"width";
NSString * const XMLPDFAttributeHeight          = @"height";
NSString * const XMLPDFAttributeFontName        = @"fontName";
NSString * const XMLPDFAttributeFontSize        = @"fontSize";
NSString * const XMLPDFAttributeBorderWidth     = @"borderWidth";
NSString * const XMLPDFAttributeFromPoint       = @"fromPoint";
NSString * const XMLPDFAttributeToPoint         = @"toPoint";
NSString * const XMLPDFAttributePoint           = @"point";
NSString * const XMLPDFAttributeLineWidth       = @"lineWidth";
NSString * const XMLPDFAttributeLineStyle       = @"lineStyle";
NSString * const XMLPDFAttributeTextAlignment   = @"textAlignment";
NSString * const XMLPDFAttributeURL             = @"url";
NSString * const XMLPDFAttributeStatic          = @"static";
NSString * const XMLPDFAttributePadding         = @"padding";
NSString * const XMLPDFAttributeIndent          = @"indent";
NSString * const XMLPDFAttributeLineHeight      = @"lineHeight";
NSString * const XMLPDFAttributeRow             = @"row";
NSString * const XMLPDFAttributeColumn          = @"column";
NSString * const XMLPDFAttributeMaxWidth        = @"maxWidth";
NSString * const XMLPDFAttributeAlpha           = @"alpha";
/* XMLPDFAttributeValue */
NSString * const XMLPDFAttributeValueCenter     = @"center";
NSString * const XMLPDFAttributeValueLeft       = @"left";
NSString * const XMLPDFAttributeValueRight      = @"right";
NSString * const XMLPDFAttributeValueSolid      = @"solid";
NSString * const XMLPDFAttributeValueDash       = @"dash";
NSString * const XMLPDFAttributeValueDash2      = @"dash2";
NSString * const XMLPDFAttributeValueYES        = @"YES";
NSString * const XMLPDFAttributeValueNO         = @"NO";
/* XMLPDFAttributeValueKey */
NSString * const XMLPDFAttributeValueKeyTopLeft     = @"top-left";
NSString * const XMLPDFAttributeValueKeyMidLeft     = @"mid-left";
NSString * const XMLPDFAttributeValueKeyBottomLeft  = @"bottom-left";
NSString * const XMLPDFAttributeValueKeyHead        = @"head";
NSString * const XMLPDFAttributeValueKeyTail        = @"tail";
/* DrawingContextKey */
NSString * const DrawingContextKeyRect              = @"DrawingContextKeyRect";
NSString * const DrawingContextKeyWidth             = @"DrawingContextKeyWidth";
NSString * const DrawingContextKeyHeight            = @"DrawingContextKeyHeight";
NSString * const DrawingContextKeyUIFont            = @"DrawingContextKeyUIFont";
NSString * const DrawingContextKeyBorderWidth       = @"DrawingContextKeyBorderWidth";
NSString * const DrawingContextKeyFromPoint         = @"DrawingContextKeyFromPoint";
NSString * const DrawingContextKeyToPoint           = @"DrawingContextKeyToPoint";
NSString * const DrawingContextKeyPoint             = @"DrawingContextKeyPoint";
NSString * const DrawingContextKeyLineWidth         = @"DrawingContextKeyLineWidth";
NSString * const DrawingContextKeyLineStyle         = @"DrawingContextKeyLineStyle";
NSString * const DrawingContextKeyTextHAlignment    = @"DrawingContextKeyTextHAlignment";
NSString * const DrawingContextKeyTextVAlignment    = @"DrawingContextKeyTextVAlignment";
NSString * const DrawingContextKeyTextBasePoint     = @"DrawingContextKeyTextBasePoint";
NSString * const DrawingContextKeyURL               = @"DrawingContextKeyURL";
NSString * const DrawingContextKeyStatic            = @"DrawingContextKeyStatic";
NSString * const DrawingContextKeyPadding           = @"DrawingContextKeyPadding";
NSString * const DrawingContextKeyHeadIndent        = @"DrawingContextKeyHeadIndent";
NSString * const DrawingContextKeyTailIndent        = @"DrawingContextKeyTailIndent";
NSString * const DrawingContextKeyLineHeight        = @"DrawingContextKeyLineHeight";
NSString * const DrawingContextKeyRow               = @"DrawingContextKeyRow";
NSString * const DrawingContextKeyColumn            = @"DrawingContextKeyColumn";
NSString * const DrawingContextKeyMaxWidth          = @"DrawingContextKeyMaxWidth";
NSString * const DrawingContextKeyAlpha             = @"DrawingContextKeyAlpha";

/*---------------------------------------------------------------*/

#pragma mark - Inline Methods

/* 将毫米单位的CGFloat映射为以点为单位的CGFloat */
static inline CGFloat MapMmToPtsFromCGFloat(CGFloat floatValue, CGFloat ratio) {
    return floatValue * ratio;
}
/* 将毫米单位的CGPoint映射为以点为单位的CGPoint */
static inline CGPoint MapMmToPtsFromCGPoint(CGPoint point, CGFloat ratio) {
    CGFloat x = point.x * ratio;
    CGFloat y = point.y * ratio;
    return CGPointMake(x, y);
}
/* 将毫米单位的CGSize映射为以点为单位的CGSize */
static inline CGSize MapMmToPtsFromCGSize(CGSize size, CGFloat ratio) {
    CGFloat width = size.width * ratio;
    CGFloat height = size.height * ratio;
    return CGSizeMake(width, height);
}
/* 将毫米单位的CGRect映射为以点为单位的CGRect */
static inline CGRect MapMmToPtsFromCGRect(CGRect rect, CGFloat ratio) {
    CGFloat x = rect.origin.x * ratio;
    CGFloat y = rect.origin.y * ratio;
    CGFloat width = rect.size.width * ratio;
    CGFloat height = rect.size.height * ratio;
    return CGRectMake(x, y, width, height);
}
/* 根据CGRect和Padding来计算实际绘制所在的CGRect */
static inline CGRect CGRectFromCGRectAndPadding(CGRect rect, CGFloat padding) {
    return CGRectMake(rect.origin.x + padding, rect.origin.y + padding, rect.size.width - padding * 2, rect.size.height - padding * 2);
}
/* 根据相对位置的CGPoint和Offset来计算绝对位置的CGPoint */
static inline CGPoint CGPointFromCGPointAndOffset(CGPoint point, CGPoint offset) {
    return CGPointMake(point.x + offset.x, point.y + offset.y);
}
/* 根据相对位置的CGRect和Offset来计算绝对位置的CGRect */
static inline CGRect CGRectFromCGRectAndOffset(CGRect rect, CGPoint offset) {
    return CGRectMake(rect.origin.x + offset.x, rect.origin.y + offset.y, rect.size.width, rect.size.height);
}
static inline CGPoint CGPointFromCGSize(CGSize size) {
    return CGPointMake(size.width, size.height);
}
/* 返回已删除前后空白字符的字符串 */
static inline NSString * NSStringFromStringByTrimmingBlank(NSString *str) {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
/* 返回已恢复被转义的换行符的字符串 */
static inline NSString * NSStringFromStringByRecoverNewLine(NSString *str) {
    return [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}

static inline ADTextHAlignment ADTextHAlignmentFromString(NSString *aligment) {
    if ([aligment.lowercaseString isEqualToString:XMLPDFAttributeValueLeft]) {
        return UITextAlignmentLeft;
    } else if ([aligment.lowercaseString isEqualToString:XMLPDFAttributeValueRight]) {
        return UITextAlignmentRight;
    } else if ([aligment.lowercaseString isEqualToString:XMLPDFAttributeValueCenter]) {
        return UITextAlignmentCenter;
    } else {
        return AD_ENUM_NULL;
    }
}

static inline ADTextBasePoint ADTextBasePointFromString(NSString *alignment) {
    if ([alignment.lowercaseString isEqualToString:XMLPDFAttributeValueKeyMidLeft]) {
        return ADTextBasePointMidLeft;
    } else if ([alignment.lowercaseString isEqualToString:XMLPDFAttributeValueKeyBottomLeft]) {
        return ADTextBasePointBottomLeft;
    } else if ([alignment.lowercaseString isEqualToString:XMLPDFAttributeValueKeyTopLeft]) {
        return ADTextBasePointTopLeft;
    } else {
        return AD_ENUM_NULL;
    }
}

static inline ADLineStyle ADLineStyleFromString(NSString *lineStyle) {
    if ([lineStyle.lowercaseString isEqualToString:XMLPDFAttributeValueDash]) {
        return ADLineStyleDash;
    } else if ([lineStyle.lowercaseString isEqualToString:XMLPDFAttributeValueDash2]) {
        return ADLineStyleDash2;
    } else if ([lineStyle.lowercaseString isEqualToString:XMLPDFAttributeValueSolid]) {
        return ADLineStyleSolid;
    } else {
        return AD_ENUM_NULL;
    }
}

static inline CTFontRef CTFontFromUIFont(UIFont *font) {
    return CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
}


/*---------------------------------------------------------------*/

#pragma mark - XMLPDFRenderer private declare

@interface XMLPDFRenderer ()

@property (nonatomic, strong) NSMutableDictionary *drawingContext;
@property (nonatomic, strong) NSMutableArray *contextStack;


- (ADPDFPage *)getPageInfoFromNode:(TBXMLElement *)node;

- (void)updateDrawContextWithNode:(TBXMLElement *)node andTagName:(NSString *)tagName;
- (void)initDrawContextWithPageInfo:(ADPDFPage *)pageInfo;
- (void)pushDrawContext;
- (void)popDrawContext;
- (void)resetCurrentDrawContext;

- (void)drawContentToContextWithNode:(TBXMLElement *)contentNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;

- (void)drawTableToContextWithNode:(TBXMLElement *)tableNode  offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;
- (void)drawTextToContextWithNode:(TBXMLElement *)textNode  offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;
- (void)drawParagraphToContextWithNode:(TBXMLElement *)paragraphNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;
- (void)drawLineToContextWithNode:(TBXMLElement *)lineNode  offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;
- (void)drawImageToContextWithNode:(TBXMLElement *)imageNode  offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;
- (void)drawGridToContextWithNode:(TBXMLElement *)gridNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly;

@end


/*---------------------------------------------------------------*/

#pragma mark - XMLPDFRenderer Implementation

@implementation XMLPDFRenderer


#pragma mark - Drawing context manipulation

- (void)initDrawContextWithPageInfo:(ADPDFPage *)pageInfo
{
    self.drawingContext = [[NSMutableDictionary alloc] init];
    if (pageInfo.defaultFontName != nil &&
        pageInfo.defaultFontSize > 0.0) {
        UIFont *font = [UIFont fontWithName:pageInfo.defaultFontName size:pageInfo.defaultFontSize];
        if (font == nil) {
            DebugLog(@"未找到设置的默认字体");
            return;
        }
        [self.drawingContext setObject:font forKey:DrawingContextKeyUIFont];
    }
}

- (NSMutableArray *)contextStack
{
    if (_contextStack == nil) {
        _contextStack = [[NSMutableArray alloc] init];
    }
    return _contextStack;
}


- (void)pushDrawContext
{
    if (self.drawingContext != nil) {
        [self.contextStack addObject:[self.drawingContext mutableCopy]];
    }
}

- (void)popDrawContext
{
    if (self.contextStack.count > 0) {
        self.drawingContext = [self.contextStack lastObject];
        [self.contextStack removeLastObject];
    }
}

- (void)resetCurrentDrawContext
{
    self.drawingContext = [[self.contextStack lastObject] mutableCopy];
}

- (void)updateDrawContextWithNode:(TBXMLElement *)node andTagName:(NSString *)tagName
{
    if (node != nil) {
        
        __block NSMutableDictionary *drawingContext = self.drawingContext;
        
        [TBXML iterateAttributesOfElement:node withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
            attributeValue = NSStringFromStringByTrimmingBlank(attributeValue);
            if ([attributeName isEqualToString:XMLPDFAttributeBorderWidth]) {
                if ([tagName isEqualToString:XMLPDFTagTable]) {
                    CGFloat borderWidth = attributeValue.floatValue;
                    if (borderWidth > 0.0) {
                        [drawingContext setObject:@(borderWidth) forKey:DrawingContextKeyBorderWidth];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeFontName]) {
                CGFloat fontSize = 10.5;
                if ([self.drawingContext objectForKey:DrawingContextKeyUIFont] != nil) {
                    UIFont *lastFont = [self.drawingContext objectForKey:DrawingContextKeyUIFont];
                    fontSize = lastFont.pointSize;
                }
                UIFont *font = [UIFont fontWithName:attributeValue size:fontSize];
                if (font) {
                    [drawingContext setObject:font forKey:DrawingContextKeyUIFont];
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeFontSize]) {
                CGFloat fontSize = attributeValue.floatValue;
                if (fontSize > 0.0) {
                    UIFont *font = [self.drawingContext objectForKey:DrawingContextKeyUIFont];
                    font = [font fontWithSize:fontSize];
                    [drawingContext setObject:font forKey:DrawingContextKeyUIFont];
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeFromPoint]) {
                if ([tagName isEqualToString:XMLPDFTagLine]) {
                    CGPoint fromPoint = CGPointFromString([NSString stringWithFormat:@"{%@}", attributeValue]);
                    if (!CGPointEqualToPoint(fromPoint, CGPointZero)) {
                        fromPoint = MapMmToPtsFromCGPoint(fromPoint, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        [drawingContext setObject:NSStringFromCGPoint(fromPoint) forKey:DrawingContextKeyFromPoint];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeHeight]) {
                if ([tagName isEqualToString:XMLPDFTagTR]) {
                    CGFloat height = attributeValue.floatValue;
                    if (height > 0.0) {
                        height = MapMmToPtsFromCGFloat(height, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        [drawingContext setObject:@(height) forKey:DrawingContextKeyHeight];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeLineStyle]) {
                if ([tagName isEqualToString:XMLPDFTagLine]) {
                    ADLineStyle lineStyle = ADLineStyleFromString(attributeValue);
                    if (lineStyle != AD_ENUM_NULL) {
                        [drawingContext setObject:@(lineStyle) forKey:DrawingContextKeyLineStyle];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeLineWidth]) {
                if ([tagName isEqualToString:XMLPDFTagTable] ||
                    [tagName isEqualToString:XMLPDFTagTD] ||
                    [tagName isEqualToString:XMLPDFTagTR] ||
                    [tagName isEqualToString:XMLPDFTagLine]) {
                    CGFloat lineWidth = attributeValue.floatValue;
                    if (lineWidth > 0.0) {
                        [drawingContext setObject:@(lineWidth) forKey:DrawingContextKeyLineWidth];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributePadding]) {
                if ([tagName isEqualToString:XMLPDFTagTable] ||
                    [tagName isEqualToString:XMLPDFTagTD] ||
                    [tagName isEqualToString:XMLPDFTagTR]) {
                    CGFloat padding = attributeValue.floatValue;
                    if (padding > 0.0) {
                        padding =  MapMmToPtsFromCGFloat(padding, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        [drawingContext setObject:@(padding) forKey:DrawingContextKeyPadding];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributePoint]) {
                if ([tagName isEqualToString:XMLPDFTagText]) {
                    NSArray *components = [attributeValue componentsSeparatedByString:@":"];
                    CGPoint point;
                    if (components.count > 1) {
                        NSString *keyStr = NSStringFromStringByTrimmingBlank([components[0] lowercaseString]);
                        NSString *valueStr = NSStringFromStringByTrimmingBlank(components[1]);
                        point = CGPointFromString([NSString stringWithFormat:@"{%@}", valueStr]);
                        if (!CGPointEqualToPoint(point, CGPointZero)) {
                            point = MapMmToPtsFromCGPoint(point, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                            [drawingContext setObject:NSStringFromCGPoint(point) forKey:DrawingContextKeyPoint];
                            if ([keyStr isEqualToString:XMLPDFAttributeValueKeyTopLeft] ||
                                [keyStr isEqualToString:XMLPDFAttributeValueKeyMidLeft] ||
                                [keyStr isEqualToString:XMLPDFAttributeValueKeyBottomLeft]) {
                                ADTextBasePoint pointAlignment = ADTextBasePointFromString(keyStr);
                                [drawingContext setObject:@(pointAlignment) forKey:DrawingContextKeyTextBasePoint];
                            }
                        }
                    } else {
                        point = CGPointFromString([NSString stringWithFormat:@"{%@}", attributeValue]);
                        if (!CGPointEqualToPoint(point, CGPointZero)) {
                            point = MapMmToPtsFromCGPoint(point, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                            [drawingContext setObject:NSStringFromCGPoint(point) forKey:DrawingContextKeyPoint];
                        }
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeRect]) {
                if ([tagName isEqualToString:XMLPDFTagTable] ||
                    [tagName isEqualToString:XMLPDFTagParagraph] ||
                    [tagName isEqualToString:XMLPDFTagImage] ||
                    [tagName isEqualToString:XMLPDFTagGrid]) {
                    CGRect rect = CGRectFromString([NSString stringWithFormat:@"{%@}", attributeValue]);
                    if (!CGRectEqualToRect(rect, CGRectZero)) {
                        rect = MapMmToPtsFromCGRect(rect, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        [drawingContext setObject:NSStringFromCGRect(rect) forKey:DrawingContextKeyRect];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeWidth]) {
                if ([tagName isEqualToString:XMLPDFTagTD]) {
                    CGFloat tdWidth = MapMmToPtsFromCGFloat(attributeValue.floatValue, self.pdfInfo.ratioPtsByMm);
                    [drawingContext setObject:@(tdWidth) forKey:DrawingContextKeyWidth];
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeStatic]) {
                attributeValue = attributeValue.uppercaseString;
                if ([attributeValue isEqualToString:XMLPDFAttributeValueYES] ||
                    [attributeValue isEqualToString:XMLPDFAttributeValueNO]) {
                    BOOL isStatic = attributeValue.boolValue;
                    [drawingContext setObject:@(isStatic) forKey:DrawingContextKeyStatic];
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeTextAlignment]) {
                if ([tagName isEqualToString:XMLPDFTagTR] ||
                    [tagName isEqualToString:XMLPDFTagTD] ||
                    [tagName isEqualToString:XMLPDFTagParagraph]) {
                    ADTextHAlignment textHAlignment = ADTextHAlignmentFromString(attributeValue);
                    if (textHAlignment != AD_ENUM_NULL) {
                        [drawingContext setObject:@(textHAlignment) forKey:DrawingContextKeyTextHAlignment];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeToPoint]) {
                if ([tagName isEqualToString:XMLPDFTagLine]) {
                    CGPoint toPoint = CGPointFromString([NSString stringWithFormat:@"{%@}", attributeValue]);
                    if (!CGPointEqualToPoint(toPoint, CGPointZero)) {
                        toPoint = MapMmToPtsFromCGPoint(toPoint, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        [drawingContext setObject:NSStringFromCGPoint(toPoint) forKey:DrawingContextKeyToPoint];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeURL]) {
                if ([tagName isEqualToString:XMLPDFTagImage]) {
                    NSURL *imgUrl = [NSURL fileURLWithPath:attributeValue];
                    if (imgUrl != nil) {
                        [drawingContext setObject:imgUrl forKey:DrawingContextKeyURL];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeIndent]) {
                if ([tagName isEqualToString:XMLPDFTagParagraph]) {
                    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@":;"];
                    NSArray *components = [attributeValue componentsSeparatedByCharactersInSet:delimiters];
                    if (components.count == 4) {
                        NSString *keyStr = @"";
                        NSString *valueStr =  @"";
                        for ( int i = 0; i < components.count; i++ ) {
                            if (i % 2 == 0) {
                                keyStr = NSStringFromStringByTrimmingBlank([components[i] lowercaseString]);
                            } else {
                                valueStr = NSStringFromStringByTrimmingBlank(components[i]);
                                CGFloat value = MapMmToPtsFromCGFloat(valueStr.floatValue, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                                if ([keyStr isEqualToString:XMLPDFAttributeValueKeyHead]) {                                    [drawingContext setObject:@(value) forKey:DrawingContextKeyHeadIndent];
                                } else if ([keyStr isEqualToString:XMLPDFAttributeValueKeyTail]) {
                                    [drawingContext setObject:@(value) forKey:DrawingContextKeyTailIndent];
                                }
                            }
                        }
                    } else if (components.count == 2) {
                        NSString *keyStr = NSStringFromStringByTrimmingBlank([components[0] lowercaseString]);
                        NSString *valueStr =  NSStringFromStringByTrimmingBlank(components[1]);
                        CGFloat value = MapMmToPtsFromCGFloat(valueStr.floatValue, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        if ([keyStr isEqualToString:XMLPDFAttributeValueKeyHead]) {
                            [drawingContext setObject:@(value) forKey:DrawingContextKeyHeadIndent];
                        } else if ([keyStr isEqualToString:XMLPDFAttributeValueKeyTail]) {
                            [drawingContext setObject:@(value) forKey:DrawingContextKeyTailIndent];
                        }
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeLineHeight]) {
                if ([tagName isEqualToString:XMLPDFTagParagraph]) {
                    if (attributeValue.floatValue > 0.0) {
                        CGFloat lineHeight = MapMmToPtsFromCGFloat(attributeValue.floatValue, self.pdfInfo.ratioPtsByMm);  /* 将毫米单位换算成点值 */
                        [drawingContext setObject:@(lineHeight) forKey:DrawingContextKeyLineHeight];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeRow]) {
                if ([tagName isEqualToString:XMLPDFTagGrid]) {
                    if (attributeValue.integerValue > 0) {
                        [drawingContext setObject:@(attributeValue.integerValue) forKey:DrawingContextKeyRow];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeColumn]) {
                if ([tagName isEqualToString:XMLPDFTagGrid]) {
                    if (attributeValue.integerValue > 0) {
                        [drawingContext setObject:@(attributeValue.integerValue) forKey:DrawingContextKeyColumn];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeMaxWidth]) {
                if ([tagName isEqualToString:XMLPDFTagText] || [tagName isEqualToString:XMLPDFTagTD]) {
                    if (attributeValue.floatValue > 0) {
                        CGFloat maxWidth = MapMmToPtsFromCGFloat(attributeValue.floatValue, self.pdfInfo.ratioPtsByMm);
                        [drawingContext setObject:@(maxWidth) forKey:DrawingContextKeyMaxWidth];
                    }
                }
            }
            else if ([attributeName isEqualToString:XMLPDFAttributeAlpha]) {
                if ([tagName isEqualToString:XMLPDFTagLine] ||
                    [tagName isEqualToString:XMLPDFTagGrid] ||
                    [tagName isEqualToString:XMLPDFTagTable]) {
                    if (attributeValue.floatValue > 0) {
                        [drawingContext setObject:@(attributeValue.floatValue) forKey:DrawingContextKeyAlpha];
                    }
                }
            }
        }];
    }
}

#pragma mark - Render methods

- (void)renderFromXML:(NSString *)xmlString toPDF:(NSString *)path
{
    [self renderFromXML:xmlString toPDF:path dataOnly:NO];
    
}

- (void)renderFromXML:(NSString *)xmlString toPDF:(NSString *)path dataOnly:(BOOL)isDataOnly
{
    NSError *err = nil;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlString error:&err];
    if (err) {
        DebugLog(@"%@ %@", err.localizedDescription, err.userInfo);
        return;
    }
    
    TBXMLElement *rootNode = xmlTree.rootXMLElement;
    if ([[TBXML elementName:rootNode] isEqualToString:XMLPDFTagTemplate]) {
        TBXMLElement *pageNode = [TBXML childElementNamed:XMLPDFTagPaper parentElement:rootNode error:&err];
        if (pageNode) {
            self.pdfInfo = [self getPageInfoFromNode:pageNode];
            if (!self.pdfInfo) {
                DebugLog(@"请检查XML模板：在页面节点中找不到指定的页面信息");
                return;
            } else {
                [self initDrawContextWithPageInfo:self.pdfInfo];
            }
        } else {
            DebugLog(@"请检查XML模板：找不到指定的页面节点");
            return;
        }
        TBXMLElement *contentNode = [TBXML childElementNamed:XMLPDFTagContent parentElement:rootNode error:&err];
        if (contentNode) {
            UIGraphicsBeginPDFContextToFile(path, self.pdfInfo.mediaBox, nil);
            CGRect mediaBox = self.pdfInfo.mediaBox;
            CGRect trimBox = mediaBox;
            CGRect cropBox = mediaBox;
            CGRect bleedBox = mediaBox;
            CGRect artBox = CGRectMake(mediaBox.origin.x+10, mediaBox.origin.y+10, mediaBox.size.width-20, mediaBox.size.height-20);
            NSDictionary *pageInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSData dataWithBytes:&trimBox length:sizeof(trimBox)],
                                      kCGPDFContextTrimBox,
                                      [NSData dataWithBytes:&cropBox length:sizeof(cropBox)],
                                      kCGPDFContextCropBox,
                                      [NSData dataWithBytes:&bleedBox length:sizeof(bleedBox)],
                                      kCGPDFContextBleedBox,
                                      [NSData dataWithBytes:&artBox length:sizeof(artBox)],
                                      kCGPDFContextArtBox,
                                      nil];
            UIGraphicsBeginPDFPageWithInfo(self.pdfInfo.mediaBox, pageInfo);
            CGPoint globalOffset = CGPointFromCGSize(self.pdfInfo.globalOffset);
            [self drawContentToContextWithNode:contentNode offset:globalOffset dataOnly:isDataOnly];
            UIGraphicsEndPDFContext();
        } else {
            DebugLog(@"请检查XML模板：找不到指定的内容节点");
            return;
        }
    } else {
        DebugLog(@"请检查XML模板：找不到指定的根节点");
        return;
    }
}


- (void)renderFromXML:(NSString *)xmlString XML2:(NSString *)xmlString2 toPDF:(NSString *)path dataOnly:(BOOL)isDataOnly
{
    NSError *err = nil;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlString error:&err];
    TBXML *xmlTree2 = [TBXML newTBXMLWithXMLString:xmlString2 error:&err];
    if (err) {
        DebugLog(@"%@ %@", err.localizedDescription, err.userInfo);
        return;
    }
    
    TBXMLElement *rootNode = xmlTree.rootXMLElement;
    TBXMLElement *rootNode2 = xmlTree2.rootXMLElement;
    if ([[TBXML elementName:rootNode] isEqualToString:XMLPDFTagTemplate] && [[TBXML elementName:rootNode2] isEqualToString:XMLPDFTagTemplate]) {
        TBXMLElement *pageNode = [TBXML childElementNamed:XMLPDFTagPaper parentElement:rootNode error:&err];
        TBXMLElement *pageNode2 = [TBXML childElementNamed:XMLPDFTagPaper parentElement:rootNode2 error:&err];
        if (pageNode && pageNode2) {
            self.pdfInfo = [self getPageInfoFromNode:pageNode];
            self.pdfInfo2 = [self getPageInfoFromNode:pageNode2];
            if (!self.pdfInfo || !self.pdfInfo2) {
                DebugLog(@"请检查XML模板：在页面节点中找不到指定的页面信息");
                return;
            } else {
                [self initDrawContextWithPageInfo:self.pdfInfo];
                [self initDrawContextWithPageInfo:self.pdfInfo2];
            }
        } else {
            DebugLog(@"请检查XML模板：找不到指定的页面节点");
            return;
        }
        TBXMLElement *contentNode = [TBXML childElementNamed:XMLPDFTagContent parentElement:rootNode error:&err];
        TBXMLElement *contentNode2 = [TBXML childElementNamed:XMLPDFTagContent parentElement:rootNode2 error:&err];
        if (contentNode && contentNode2) {
            UIGraphicsBeginPDFContextToFile(path, self.pdfInfo.mediaBox, nil);

            
            CGRect mediaBox = self.pdfInfo.mediaBox;
            CGRect trimBox = mediaBox;
            CGRect cropBox = mediaBox;
            CGRect bleedBox = mediaBox;
            CGRect artBox = CGRectMake(mediaBox.origin.x+10, mediaBox.origin.y+10, mediaBox.size.width-20, mediaBox.size.height-20);
            NSDictionary *pageInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSData dataWithBytes:&trimBox length:sizeof(trimBox)],
                                      kCGPDFContextTrimBox,
                                      [NSData dataWithBytes:&cropBox length:sizeof(cropBox)],
                                      kCGPDFContextCropBox,
                                      [NSData dataWithBytes:&bleedBox length:sizeof(bleedBox)],
                                      kCGPDFContextBleedBox,
                                      [NSData dataWithBytes:&artBox length:sizeof(artBox)],
                                      kCGPDFContextArtBox,
                                      nil];
            UIGraphicsBeginPDFPageWithInfo(self.pdfInfo.mediaBox, pageInfo);
            CGPoint globalOffset = CGPointFromCGSize(self.pdfInfo.globalOffset);
            [self drawContentToContextWithNode:contentNode offset:globalOffset dataOnly:isDataOnly];
            
            CGRect mediaBox2 = self.pdfInfo2.mediaBox;
            CGRect trimBox2 = mediaBox;
            CGRect cropBox2 = mediaBox;
            CGRect bleedBox2 = mediaBox;
            CGRect artBox2 = CGRectMake(mediaBox2.origin.x+10, mediaBox2.origin.y+10, mediaBox2.size.width-20, mediaBox2.size.height-20);
            NSDictionary *pageInfo2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSData dataWithBytes:&trimBox2 length:sizeof(trimBox2)],
                                      kCGPDFContextTrimBox,
                                      [NSData dataWithBytes:&cropBox2 length:sizeof(cropBox2)],
                                      kCGPDFContextCropBox,
                                      [NSData dataWithBytes:&bleedBox2 length:sizeof(bleedBox2)],
                                      kCGPDFContextBleedBox,
                                      [NSData dataWithBytes:&artBox2 length:sizeof(artBox2)],
                                      kCGPDFContextArtBox,
                                      nil];
            UIGraphicsBeginPDFPageWithInfo(self.pdfInfo2.mediaBox, pageInfo2);
            CGPoint globalOffset2 = CGPointFromCGSize(self.pdfInfo2.globalOffset);
            [self drawContentToContextWithNode:contentNode2 offset:globalOffset2 dataOnly:isDataOnly];
            UIGraphicsEndPDFContext();
        } else {
            DebugLog(@"请检查XML模板：找不到指定的内容节点");
            return;
        }
    } else {
        DebugLog(@"请检查XML模板：找不到指定的根节点");
        return;
    }
}



#pragma mark - Attribute Methods

- (ADPDFPage *)getPageInfoFromNode:(TBXMLElement *)node
{
    __block ADPDFPage *pageInfo = nil;
    __block CGFloat width = -1;
    __block CGFloat height = -1;
    __block CGFloat fontSize = -1;
    __block NSString *fontName = nil;
    __block CGSize offset = CGSizeZero;
    [TBXML iterateAttributesOfElement:node withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue) {
        
        attributeValue = NSStringFromStringByTrimmingBlank(attributeValue);
        NSLog(@"%@",attributeName);
        if ([attributeName isEqualToString:XMLPDFAttributeWidth]) {
            CGFloat _width = attributeValue.floatValue;
            if (_width > 0) {
                width = _width;
            }
        } else if ([attributeName isEqualToString:XMLPDFAttributeHeight]) {
            CGFloat _height = attributeValue.floatValue;
            if (_height > 0) {
                height = _height;
            }
        } else if ([attributeName isEqualToString:XMLPDFAttributeFontSize]) {
            fontSize = attributeValue.floatValue;
        } else if ([attributeName isEqualToString:XMLPDFAttributeFontName]) {
            fontName = attributeValue;
        } else if ([attributeName isEqualToString:XMLPDFAttributeOffset]) {
            offset = CGSizeFromString([NSString stringWithFormat:@"{%@}",attributeValue]);
        }
    }];
    
    if (width > 0 && height > 0 && fontSize > 0 && fontName != nil) {
        pageInfo = [[ADPDFPage alloc] init];
        pageInfo.mediaBox = CGRectMake(0, 0, width, height);
        pageInfo.defaultFontSize = fontSize;
        pageInfo.defaultFontName = fontName;
        if (height > width) {
            pageInfo.ratioPtsByMm = height / 297;
        } else {
            pageInfo.ratioPtsByMm = width / 297;
        }
        pageInfo.globalOffset = MapMmToPtsFromCGSize(offset, pageInfo.ratioPtsByMm);
    }
    return pageInfo;
}



#pragma mark - Draw method

- (void)drawContentToContextWithNode:(TBXMLElement *)contentNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{

    [self pushDrawContext];
    [TBXML iterateElementsForQuery:@"*" fromElement:contentNode withBlock:^(TBXMLElement *element) {
        NSString *nodeName = [TBXML elementName:element];
        [self resetCurrentDrawContext];  /* 避免遍历同一层子节点时互相影响 */
        [self updateDrawContextWithNode:element andTagName:nodeName];
        if ([nodeName isEqualToString:XMLPDFTagTable])
        {
            [self drawTableToContextWithNode:element offset:offset dataOnly:isDataOnly];
        }
        else if ([nodeName isEqualToString:XMLPDFTagText])
        {
            [self drawTextToContextWithNode:element offset:offset dataOnly:isDataOnly];
        }
        else if ([nodeName isEqualToString:XMLPDFTagParagraph])
        {
            [self drawParagraphToContextWithNode:element offset:offset dataOnly:isDataOnly];
        }
        else if ([nodeName isEqualToString:XMLPDFTagLine])
        {
            [self drawLineToContextWithNode:element offset:offset dataOnly:isDataOnly];
        }
        else if ([nodeName isEqualToString:XMLPDFTagImage])
        {
            [self drawImageToContextWithNode:element offset:offset dataOnly:isDataOnly];
        }
        else if ([nodeName isEqualToString:XMLPDFTagGrid])
        {
            [self drawGridToContextWithNode:element offset:offset dataOnly:isDataOnly];
        }
    }];
    [self popDrawContext];
}

- (void)drawTableToContextWithNode:(TBXMLElement *)tableNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{
    DebugLog(@"开始绘制pdf:table");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if ([self.drawingContext objectForKey:DrawingContextKeyRect] == nil) {
        return;
    }
    
    /* 绘制表格外边框 */
    CGRect outerRect = CGRectFromString([self.drawingContext objectForKey:DrawingContextKeyRect]);
    outerRect = CGRectFromCGRectAndOffset(outerRect, offset);
    CGFloat borderWidth = 1.0;
    if ([self.drawingContext objectForKey:DrawingContextKeyBorderWidth] != nil) {
        borderWidth = [[self.drawingContext objectForKey:DrawingContextKeyBorderWidth] floatValue];
    }
    CGFloat lineWidth = 1.0;
    if ([self.drawingContext objectForKey:DrawingContextKeyLineWidth] != nil) {
        lineWidth = [[self.drawingContext objectForKey:DrawingContextKeyLineWidth] floatValue];
    }
    BOOL isTableStatic = YES;
    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
        isTableStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
    }
    if (!isDataOnly || !isTableStatic) {
        CGContextSetLineWidth(context, borderWidth);
        CGContextStrokeRect(context, outerRect);
    }
    
    __block CGMutablePathRef cellsPath = CGPathCreateMutable();
//    __block CGPoint newOrigin = CGPointMake(offset.x + outerRect.origin.x, offset.y + outerRect.origin.y);
    __block CGPoint newOrigin = CGPointMake(outerRect.origin.x, outerRect.origin.y);
    
    [self pushDrawContext];
    
    [TBXML iterateElementsForQuery:@"*" fromElement:tableNode withBlock:^(TBXMLElement *element) {
        NSString *trName = [TBXML elementName:element];
        if ([trName isEqualToString:XMLPDFTagTR]) {
            /*************开始解析TR***************/
            TBXMLElement *trElement = element;
            [self resetCurrentDrawContext];
            [self updateDrawContextWithNode:trElement andTagName:XMLPDFTagTR];
            
            CGFloat rowHeight = -1;
            if ([self.drawingContext objectForKey:DrawingContextKeyHeight] != nil) {
                rowHeight = [[self.drawingContext objectForKey:DrawingContextKeyHeight] floatValue];
            }
            
            if (rowHeight > 0) {
                [self pushDrawContext];
                
                __block CGPoint tdOrigin = newOrigin;
                [TBXML iterateElementsForQuery:@"*" fromElement:trElement withBlock:^(TBXMLElement *element) {
                    NSString *tdName = [TBXML elementName:element];
                    if ([tdName isEqualToString:XMLPDFTagTD]) {
                        /*************开始解析TD***************/
                        TBXMLElement *tdElement = element;

                        [self resetCurrentDrawContext];
                        [self updateDrawContextWithNode:tdElement andTagName:XMLPDFTagTD];
                        
                        CGFloat tdWidth = -1;
                        if ([self.drawingContext objectForKey:DrawingContextKeyWidth] != nil) {
                            tdWidth = [[self.drawingContext objectForKey:DrawingContextKeyWidth] floatValue];
                        }
                        ADTextHAlignment cellTextHAlignment = UITextAlignmentCenter;
                        if ([self.drawingContext objectForKey:DrawingContextKeyTextHAlignment] != nil) {
                            cellTextHAlignment = [[self.drawingContext objectForKey:DrawingContextKeyTextHAlignment] integerValue];
                        }
                        ADTextVAlignment cellTextVAlignment = ADTextVAlignmentMiddle;
                        
                        if (tdWidth > 0) {
                            CGRect tdRect = CGRectMake(tdOrigin.x, tdOrigin.y, tdWidth, rowHeight);
                            /*************添加要绘制的单元格到路径中***************/
                            if (!isDataOnly || !isTableStatic) {
                                CGPathAddRect(cellsPath, NULL, tdRect);
                            }
                            if (tdElement != NULL && tdElement->firstChild == NULL) {
                                /*************开始绘制内部文本***************/
                                NSString *tdText = [TBXML textForElement:tdElement];
                                tdText = NSStringFromStringByRecoverNewLine(tdText);
                                CGRect actualTextRect = tdRect;
                                if ([self.drawingContext objectForKey:DrawingContextKeyPadding] != nil) {
                                    CGFloat cellPadding = [[self.drawingContext objectForKey:DrawingContextKeyPadding] floatValue];
                                    actualTextRect = CGRectFromCGRectAndPadding(tdRect, cellPadding);
                                }
                                UIFont *textFont = nil;
                                if ([self.drawingContext objectForKey:DrawingContextKeyUIFont] != nil) {
                                    textFont = [self.drawingContext objectForKey:DrawingContextKeyUIFont];
                                }
                                if (textFont != nil) {
                                    BOOL isStatic = YES;
                                    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
                                        isStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
                                    }
                                    if (!isDataOnly || !isStatic) {
                                        
                                        CGFloat maxWidth = [[self.drawingContext objectForKey:DrawingContextKeyMaxWidth] floatValue];
                                        if (maxWidth > 0) {
                                            [tdText drawInRect:actualTextRect withFont:textFont lineBreakMode:UILineBreakModeWordWrap hAlignment:cellTextHAlignment vAlignment:cellTextVAlignment maxWidth:maxWidth];
                                        } else {
                                            [tdText drawInRect:actualTextRect withFont:textFont lineBreakMode:UILineBreakModeWordWrap hAlignment:cellTextHAlignment vAlignment:cellTextVAlignment];
                                        }

                                        
                                    }
                                } else {
                                    DebugLog(@"字体信息缺失");
                                }
                                
                            } else {
                                DebugLog(@"TD节点包括非文本子节点");
                                DebugLog(@"开始绘制嵌套内容");
                                [self drawContentToContextWithNode:tdElement offset:tdOrigin dataOnly:isDataOnly];
                                DebugLog(@"完成绘制嵌套内容");
                            }
                            tdOrigin = CGPointMake(tdOrigin.x + tdWidth, tdOrigin.y);
                        }
                    }
                }];
                newOrigin = CGPointMake(newOrigin.x, newOrigin.y + rowHeight);
                [self popDrawContext];
            }
        }
    }];
    
    [self popDrawContext];
    
    /*************集中绘制所有的单元格***************/
    CGFloat alpha = 1.0;
    if ([self.drawingContext objectForKey:DrawingContextKeyAlpha] != nil) {
        alpha = [[self.drawingContext objectForKey:DrawingContextKeyAlpha] floatValue];
        if (alpha < 0) {
            alpha = 1.0;
        }
    }
    CGContextSetStrokeColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:alpha] CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextAddPath(context, cellsPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawTextToContextWithNode:(TBXMLElement *)textNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{
    BOOL isStatic = YES;
    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
        isStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
    }
    if (!isDataOnly || !isStatic) {
        DebugLog(@"开始绘制pdf:text");
        NSString *text = [TBXML textForElement:textNode];
        text = NSStringFromStringByRecoverNewLine(text);
        CGPoint point = CGPointFromString([self.drawingContext objectForKey:DrawingContextKeyPoint]);
        ADTextBasePoint basePoint = ADTextBasePointTopLeft;
        if ([self.drawingContext objectForKey:DrawingContextKeyTextBasePoint] != nil) {
            basePoint = [[self.drawingContext objectForKey:DrawingContextKeyTextBasePoint] integerValue];
        }
        UIFont *textFont = [self.drawingContext objectForKey:DrawingContextKeyUIFont];
        if (!CGPointEqualToPoint(point, CGPointZero)) {
            point = CGPointFromCGPointAndOffset(point, offset);
            if ([self.drawingContext objectForKey:DrawingContextKeyMaxWidth] != nil) {
                CGFloat maxWidth = [[self.drawingContext objectForKey:DrawingContextKeyMaxWidth] floatValue];
                [text drawAtPoint:point withFont:textFont basePoint:basePoint maxWidth:maxWidth];
            } else {
                [text drawAtPoint:point withFont:textFont basePoint:basePoint];
            }
        }
    }
    
}

- (void)drawParagraphToContextWithNode:(TBXMLElement *)paragraphNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{
    
    BOOL isStatic = YES;
    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
        isStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
    }
    if (!isDataOnly || !isStatic) {
        DebugLog(@"开始绘制pdf:paragraph");
        
        /* 字体 */
        UIFont *uiFont = [self.drawingContext objectForKey:DrawingContextKeyUIFont];
        if (uiFont == nil) {
            DebugLog(@"字体信息缺失");
            return;
        }
        CTFontRef ctFont = CTFontFromUIFont(uiFont);
        
        int paragraphSettingCnt = 0;
        /* 段落对齐方式 */
        CTTextAlignment alignment = kCTNaturalTextAlignment;
        CTParagraphStyleSetting alignmentStyle;
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        alignmentStyle.valueSize = sizeof(alignment);
        alignmentStyle.value = &alignment;
        paragraphSettingCnt++;
        /* 段落换行方式 */
        CTParagraphStyleSetting lineBreakModeStyle;
        CTLineBreakMode lineBreakMode = kCTLineBreakByCharWrapping;
        lineBreakModeStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
        lineBreakModeStyle.valueSize = sizeof(lineBreakMode);
        lineBreakModeStyle.value = &lineBreakMode;
        paragraphSettingCnt++;
        /* 行高 */
        CGFloat lineHeight = 0;
        if ([self.drawingContext objectForKey:DrawingContextKeyLineHeight]) {
            lineHeight = [[self.drawingContext objectForKey:DrawingContextKeyLineHeight] floatValue];
        }
        CTParagraphStyleSetting lineHeightStyle;
        lineHeightStyle.spec = kCTParagraphStyleSpecifierMinimumLineHeight;
        lineHeightStyle.valueSize = sizeof(CGFloat);
        lineHeightStyle.value = &lineHeight;
        paragraphSettingCnt++;
        /* 段前缩进 */
        CGFloat headIndent = 0;
        if ([self.drawingContext objectForKey:DrawingContextKeyHeadIndent] != nil) {
            headIndent = [[self.drawingContext objectForKey:DrawingContextKeyHeadIndent] floatValue];
        }
        CTParagraphStyleSetting headIndentStyle;
        headIndentStyle.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
        headIndentStyle.valueSize = sizeof(CGFloat);
        headIndentStyle.value = &headIndent;
        paragraphSettingCnt++;
        /* 组成段落样式 */
        CTParagraphStyleSetting settings[] = {
            alignmentStyle,
            lineBreakModeStyle,
            headIndentStyle,
            lineHeightStyle
        };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, paragraphSettingCnt);
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)paragraphStyle forKey:(__bridge id)kCTParagraphStyleAttributeName];

        NSString *textContent = [TBXML textForElement:paragraphNode];
        textContent = NSStringFromStringByRecoverNewLine(textContent);
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:textContent];
        [attributedText addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:NSMakeRange(0, attributedText.length)];
        [attributedText addAttributes:attributes range:NSMakeRange(0, attributedText.length)];
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedText);
        CGRect rect = CGRectFromString([self.drawingContext objectForKey:DrawingContextKeyRect]);
        if (CGRectEqualToRect(rect, CGRectZero)) {
            return;
        } else {
            rect = CGRectFromCGRectAndOffset(rect, offset);
        }
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, rect.origin.y * 2 + rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CTFrameDraw(frame, context);
        CGContextRestoreGState(context);
        CFRelease(frame);
        CFRelease(path);
        CFRelease(framesetter);
    }
}

- (void)drawLineToContextWithNode:(TBXMLElement *)lineNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{
    BOOL isStatic = YES;
    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
        isStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
    }
    if (!isDataOnly || !isStatic) {
        DebugLog(@"开始绘制pdf:line");
        if ([self.drawingContext objectForKey:DrawingContextKeyFromPoint] != nil &&
            [self.drawingContext objectForKey:DrawingContextKeyToPoint] != nil) {
            CGPoint fromPoint = CGPointFromString([self.drawingContext objectForKey:DrawingContextKeyFromPoint]);
            CGPoint toPoint = CGPointFromString([self.drawingContext objectForKey:DrawingContextKeyToPoint]);
            if (!CGPointEqualToPoint(fromPoint, CGPointZero) &&
                !CGPointEqualToPoint(toPoint, CGPointZero)) {
                
                fromPoint = CGPointFromCGPointAndOffset(fromPoint, offset);
                toPoint =  CGPointFromCGPointAndOffset(toPoint, offset);
                
                CGFloat lineWidth = 0.5;
                if ([self.drawingContext objectForKey:DrawingContextKeyLineWidth] != nil) {
                    lineWidth = [[self.drawingContext objectForKey:DrawingContextKeyLineWidth] floatValue];
                }
                if ([self.drawingContext objectForKey:DrawingContextKeyLineStyle] != nil) {
                    //TODO 设置直线样式
                }
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSaveGState(context);
                CGFloat alpha = 1.0;
                if ([self.drawingContext objectForKey:DrawingContextKeyAlpha] != nil) {
                    alpha = [[self.drawingContext objectForKey:DrawingContextKeyAlpha] floatValue];
                    if (alpha < 0) {
                        alpha = 1.0;
                    }
                }
                CGContextSetStrokeColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:alpha] CGColor]);
                CGContextSetLineWidth(context, lineWidth);
                CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
                CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
                CGContextStrokePath(context);
                CGContextRestoreGState(context);
            }
        }
    }
}


- (void)drawImageToContextWithNode:(TBXMLElement *)imageNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{
    BOOL isStatic = YES;
    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
        isStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
    }
    if (!isDataOnly || !isStatic) {
        DebugLog(@"开始绘制pdf:image");
        if ([self.drawingContext objectForKey:DrawingContextKeyRect] != nil) {
            if ([self.drawingContext objectForKey:DrawingContextKeyURL] != nil) {
                NSURL *imageURL = [self.drawingContext objectForKey:DrawingContextKeyURL];
                CGRect rect = CGRectFromString([self.drawingContext objectForKey:DrawingContextKeyRect]);
                if (!CGRectEqualToRect(rect, CGRectZero)) {
                    rect = CGRectFromCGRectAndOffset(rect, offset);
                    UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
                    if (image) {
                        if ((rect.size.width/rect.size.height) > (image.size.width/image.size.height)) {
                            CGFloat newWidth = rect.size.height * image.size.width / image.size.height;
                            rect = CGRectMake(rect.origin.x+(rect.size.width-newWidth)/2, rect.origin.y, newWidth, rect.size.height);
                        } else {
                            CGFloat newHeight = rect.size.width * image.size.height / image.size.width;
                            rect = CGRectMake(rect.origin.x, rect.origin.y+(rect.size.height-newHeight)/2, rect.size.width, newHeight);
                        }
                        [image drawInRect:rect];
                    }
                } 
            }
        }
    }
}

- (void)drawGridToContextWithNode:(TBXMLElement *)gridNode offset:(CGPoint)offset dataOnly:(BOOL)isDataOnly
{
    BOOL isStatic = YES;
    if ([self.drawingContext objectForKey:DrawingContextKeyStatic] != nil) {
        isStatic = [[self.drawingContext objectForKey:DrawingContextKeyStatic] boolValue];
    }
    if (!isDataOnly || !isStatic) {
        DebugLog(@"开始绘制pdf:grid");
        if ([self.drawingContext objectForKey:DrawingContextKeyRow] != nil &&
            [self.drawingContext objectForKey:DrawingContextKeyColumn] != nil &&
            [self.drawingContext objectForKey:DrawingContextKeyRect] != nil ) {
            CGRect rect = CGRectFromString([self.drawingContext objectForKey:DrawingContextKeyRect]);
            if (!CGRectEqualToRect(rect, CGRectZero)) {
                rect = CGRectFromCGRectAndOffset(rect, offset);
                NSInteger rowCount = [[self.drawingContext objectForKey:DrawingContextKeyRow] integerValue];
                NSInteger colCount = [[self.drawingContext objectForKey:DrawingContextKeyColumn] integerValue];
                if (rowCount > 0 && colCount > 0) {
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    CGFloat alpha = 1.0;
                    if ([self.drawingContext objectForKey:DrawingContextKeyAlpha] != nil) {
                        alpha = [[self.drawingContext objectForKey:DrawingContextKeyAlpha] floatValue];
                        if (alpha < 0) {
                            alpha = 1.0;
                        }
                    }
                    CGColorRef lineColor = [[[UIColor blackColor] colorWithAlphaComponent:alpha] CGColor];
                    CGContextSaveGState(context);
                    CGContextSetStrokeColorWithColor(context, lineColor);
                    CGContextSetLineWidth(context, 0.5);
                    CGFloat xOffset = rect.size.width / colCount;
                    CGFloat yOffset = rect.size.height / rowCount;
                    for (int i = 0; i < rowCount+1; i++) {
                        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + i * yOffset);
                        CGContextAddLineToPoint(context, rect.origin.x+rect.size.width, rect.origin.y + i * yOffset);
                        CGContextStrokePath(context);
                    }
                    for (int i = 0; i < colCount+1; i++) {
                        CGContextMoveToPoint(context, rect.origin.x + i * xOffset, rect.origin.y);
                        CGContextAddLineToPoint(context, rect.origin.x + i * xOffset, rect.origin.y + rect.size.height);
                        CGContextStrokePath(context);
                    }
                    CGContextRestoreGState(context);
                }
            }
        }
    }
}

@end



/*---------------------------------------------------------------*/

#pragma mark - NSString Category

@implementation NSString (XMLPDFDrawing)

- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font basePoint:(ADTextBasePoint)basePoint
{
    CGSize size = [self sizeWithFont:font];
    if (basePoint == ADTextBasePointMidLeft) {
        point = CGPointMake(point.x, point.y - size.height / 2);
    } else if (basePoint == ADTextBasePointBottomLeft) {
        point = CGPointMake(point.x, point.y - size.height);
    }
    return [self drawAtPoint:point withFont:font];
}


- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font basePoint:(ADTextBasePoint)basePoint maxWidth:(CGFloat)maxWidth
{
    CGSize size = [self sizeWithFont:font];
    if (basePoint == ADTextBasePointMidLeft) {
        point = CGPointMake(point.x, point.y - size.height / 2);
    } else if (basePoint == ADTextBasePointBottomLeft) {
        point = CGPointMake(point.x, point.y - size.height);
    }
    return [self drawAtPoint:point forWidth:maxWidth withFont:font minFontSize:1.0 actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignCenters];
}


- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode hAlignment:(ADTextHAlignment)hAlignment vAlignment:(ADTextVAlignment)vAlignment
{
    CGSize actualSize = [self sizeWithFont:font constrainedToSize:rect.size lineBreakMode:lineBreakMode];
    CGRect actualRect = rect;
    if (actualSize.height < rect.size.height) {
        CGFloat offsetY;
        if (vAlignment == ADTextVAlignmentTop) {
            offsetY = 0;
        } else if (vAlignment == ADTextVAlignmentBottom) {
            offsetY = rect.size.height - actualSize.height;
        } else {
            offsetY = (rect.size.height - actualSize.height) / 2;
        }
        actualRect = CGRectMake(rect.origin.x, rect.origin.y + offsetY, rect.size.width, actualSize.height);
    }
    return [self drawInRect:actualRect withFont:font lineBreakMode:lineBreakMode alignment:hAlignment];
}
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode hAlignment:(ADTextHAlignment)hAlignment vAlignment:(ADTextVAlignment)vAlignment maxWidth:(CGFloat)maxWidth
{
    CGSize actualSize = [self sizeWithFont:font constrainedToSize:rect.size lineBreakMode:lineBreakMode];
    CGRect actualRect = rect;
    CGPoint point = rect.origin;
    if (actualSize.height < rect.size.height) {
        CGFloat offsetY;
        if (vAlignment == ADTextVAlignmentTop) {
            offsetY = 0;
        } else if (vAlignment == ADTextVAlignmentBottom) {
            offsetY = rect.size.height - actualSize.height;
        } else {
            offsetY = (rect.size.height - actualSize.height) / 2;
        }
        actualRect = CGRectMake(rect.origin.x, rect.origin.y + offsetY, rect.size.width, actualSize.height);
        point = CGPointMake(rect.origin.x, rect.origin.y );
    }
    return [self drawAtPoint:point forWidth:maxWidth withFont:font minFontSize:1.0 actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignCenters];
}
@end

