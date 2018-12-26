//
//  CasePrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CasePrintViewController.h"
#import "NSString+MyStringProcess.h"

typedef enum {
    PDFDrawLineStyleDefault = 0x00,
    PDFDrawLineStyleNormal = 0x00,
    PDFDrawLineStyleDash,
    PDFDrawLineStyleDotted
} PDFDrawLineStyleOptions;

@interface CasePrintViewController ()
//从xml的content元素中生成字符串
- (NSString *)formedStringFromData:(NSManagedObject *)data XMLElement:(TBXMLElement *)xmlElement;
@end

@implementation CasePrintViewController

@synthesize isPortrait = _isPortrait;
@synthesize caseID = _caseID;

-(NSInteger)dataCount{
    return 1;
}

- (BOOL)shouldDocDeleted{
    if ([self.caseID isEmpty]) {
        return NO;
    } else
        return YES;
}

- (BOOL)shouldGenereateDefaultDoc{
    if ([self.caseID isEmpty]) {
        return NO;
    } else
        return YES;
}

- (void)deleteCurrentDoc{}

- (void)generateDefaultAndLoad{}

-(void)pageLoadInfo{}
-(BOOL)pageSaveInfo{
    return TRUE;
}

-(NSString *)xmlStringFromFile:(NSString *)xmlName{
    NSError *error=nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *docXMLSettingFileName=[xmlName stringByAppendingString:@".xml"];
    NSString *docXMLSettingFilePath=[libraryDirectory stringByAppendingPathComponent:docXMLSettingFileName];
    NSString *xmlString = [NSString stringWithContentsOfFile:docXMLSettingFilePath encoding:NSUTF8StringEncoding error:&error];
    if (xmlString==nil) {
        xmlString=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:xmlName ofType:@"xml"] encoding:NSUTF8StringEncoding error:&error];
    }
    return xmlString;
}

//解析配置文件内的页面大小，边距等信息，初始化页面
-(void)LoadPaperSettings:(NSString *)xmlName{
    prTopMargin=prLeftMargin=prRightMargin=prBottomMargin=paperWidth=paperHeight=0.0f;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSError *error;
    NSString *xmlString=[self xmlStringFromFile:xmlName];
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *paper=[TBXML childElementNamed:@"Paper" parentElement:root];
    TBXMLElement *margin=[TBXML childElementNamed:@"Margin" parentElement:paper];
    
    paperWidth=[[TBXML valueOfAttributeNamed:@"width" forElement:paper] floatValue];
    paperHeight=[[TBXML valueOfAttributeNamed:@"height" forElement:paper] floatValue];
    
    prTopMargin=[[TBXML valueOfAttributeNamed:@"top" forElement:margin] floatValue];
    prLeftMargin=[[TBXML valueOfAttributeNamed:@"left" forElement:margin] floatValue];
    prRightMargin=[[TBXML valueOfAttributeNamed:@"right" forElement:margin] floatValue];
    prBottomMargin=[[TBXML valueOfAttributeNamed:@"bottom" forElement:margin] floatValue];
    
    TBXMLElement *orientation = [TBXML childElementNamed:@"Orientation" parentElement:paper];
    if (orientation) {
        _isPortrait = [[TBXML valueOfAttributeNamed:@"isPortrait" forElement:orientation] boolValue];
    } else {
        _isPortrait = YES;
    }
}

//根据配置绘制固定的表格及文字，宋体
/*
 -(void)drawStaticTable:(NSString *)xmlName{
 NSError *error;
 NSString *xmlString=[self xmlStringFromFile:xmlName];
 TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
 TBXMLElement *root=tbxml.rootXMLElement;
 
 TBXMLElement *staticTables=[TBXML childElementNamed:@"StaticTable" parentElement:root];
 if (staticTables != nil) {
 TBXMLElement *lines=[TBXML childElementNamed:@"Lines" parentElement:staticTables];
 if (lines != nil) {
 TBXMLElement *tempElement=[TBXML childElementNamed:@"defaultLineWidth" parentElement:lines];
 CGFloat defaultLineWidth=[[TBXML textForElement:tempElement] floatValue];
 TBXMLElement *line=[TBXML childElementNamed:@"line" parentElement:lines];
 if (line != nil) {
 do {
 CGFloat x1=[[TBXML valueOfAttributeNamed:@"x1" forElement:line] floatValue];
 CGFloat y1=[[TBXML valueOfAttributeNamed:@"y1" forElement:line] floatValue];
 CGFloat x2=[[TBXML valueOfAttributeNamed:@"x2" forElement:line] floatValue];
 CGFloat y2=[[TBXML valueOfAttributeNamed:@"y2" forElement:line] floatValue];
 CGFloat lineWidth=defaultLineWidth;
 TBXMLAttribute *attribute=line->firstAttribute;
 while (attribute) {
 if ([[TBXML attributeName:attribute] isEqualToString:@"lineWidth"]) {
 lineWidth=[[TBXML attributeValue:attribute] floatValue];
 }
 attribute=attribute->next;
 }
 NSString *childName = [TBXML elementName:line];
 if ([childName isEqualToString:@"line"]) {
 [self drawLineFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
 } else if ([childName isEqualToString:@"rect"]){
 [self drawRectFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
 }
 } while ((line=line->nextSibling));
 }
 }
 TBXMLElement *title = [TBXML childElementNamed:@"Title" parentElement:staticTables];
 if (title) {
 TBXMLElement *titleText = [TBXML childElementNamed:@"Text" parentElement:title];
 while (titleText) {
 CGFloat fontSize=12;
 TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:titleText];
 if (textInXML != nil) {
 NSString *textString=[TBXML textForElement:textInXML];
 if (![textString isEmpty]) {
 TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:titleText];
 if (originInXML != nil) {
 CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
 CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
 TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:titleText];
 if (fontSizeInXML != nil) {
 fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
 }
 TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:titleText];
 if (sizeInXML) {
 CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
 CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
 CGRect rect = CGRectMake(x, y, width, height);
 UIFont *font = [UIFont fontWithName:FONT_HeiTi size:fontSize];
 [textString drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
 }
 }
 }
 }
 titleText = titleText->nextSibling;
 }
 }
 
 TBXMLElement *texts=[TBXML childElementNamed:@"Texts111" parentElement:staticTables];
 if (texts != nil) {
 TBXMLElement *text=[TBXML childElementNamed:@"Text" parentElement:texts];
 while (text) {
 CGFloat fontSize=12;
 TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:text];
 if (textInXML != nil) {
 NSString *textString=[TBXML textForElement:textInXML];
 if (![textString isEmpty]) {
 TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:text];
 if (originInXML != nil) {
 CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
 CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
 TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:text];
 if (fontSizeInXML != nil) {
 fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
 }
 UITextAlignment alignment = UITextAlignmentLeft;
 TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:text];
 if (alignmentInXML) {
 NSString *alignmentString = [TBXML textForElement:alignmentInXML];
 alignmentString = [alignmentString lowercaseString];
 if (![alignmentString isEmpty]) {
 if ([alignmentString isEqualToString:@"center"]) {
 alignment = UITextAlignmentCenter;
 } else if ([alignmentString isEqualToString:@"right"]){
 alignment = UITextAlignmentRight;
 }
 }
 }
 TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:text];
 if (sizeInXML) {
 CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
 CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
 CGRect rect = CGRectMake(x, y, width, height);
 UIFont *font = [UIFont fontWithName:FONT_SongTi size:fontSize];
 [textString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
 }
 }
 }
 }
 text=text->nextSibling;
 }
 }
 }
 }
 */
-(void)drawStaticTable:(NSString *)xmlName{
    NSError *error;
    NSString *xmlString=[self xmlStringFromFile:xmlName];
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    
    TBXMLElement *staticTables=[TBXML childElementNamed:@"StaticTable" parentElement:root];
    if (staticTables != nil) {
        
        TBXMLElement *lines=[TBXML childElementNamed:@"Lines" parentElement:staticTables];
        if (lines != nil) {
            TBXMLElement *tempElement=[TBXML childElementNamed:@"defaultLineWidth" parentElement:lines];
            CGFloat defaultLineWidth=[[TBXML textForElement:tempElement] floatValue];
            TBXMLElement *line=[TBXML childElementNamed:@"line" parentElement:lines];
            if (line != nil) {
                do {
                    CGFloat x1=[[TBXML valueOfAttributeNamed:@"x1" forElement:line] floatValue]*MMTOPIX;
                    CGFloat y1=[[TBXML valueOfAttributeNamed:@"y1" forElement:line] floatValue]*MMTOPIX;
                    CGFloat x2=[[TBXML valueOfAttributeNamed:@"x2" forElement:line] floatValue]*MMTOPIX;
                    CGFloat y2=[[TBXML valueOfAttributeNamed:@"y2" forElement:line] floatValue]*MMTOPIX;
                    CGFloat lineWidth=defaultLineWidth;
                    PDFDrawLineStyleOptions *lineStyle = PDFDrawLineStyleDefault;
                    TBXMLAttribute *attribute=line->firstAttribute;
                    while (attribute) {
                        if ([[TBXML attributeName:attribute] isEqualToString:@"lineWidth"]) {
                            lineWidth=[[TBXML attributeValue:attribute] floatValue];
                        }
                        if ([[TBXML attributeName:attribute] isEqualToString:@"lineStyle"]) {
                            if ([[TBXML attributeValue:attribute] isEqualToString:@"dash"]) {
                                lineStyle = PDFDrawLineStyleDash;
                            } else if ([[TBXML attributeValue:attribute] isEqualToString:@"dotted"]) {
                                lineStyle = PDFDrawLineStyleDotted;
                            }
                        }
                        attribute=attribute->next;
                    }
                    NSString *childName = [TBXML elementName:line];
                    if ([childName isEqualToString:@"line"]) {
                        [self drawLineFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
//                        [self drawLineFromPoint1:CGPointMake(x1, y1) toPoint2:CGPointMake(x2, y2) withLineWidth:lineWidth andLineStyle:lineStyle];
                    } else if ([childName isEqualToString:@"rect"]){
                        [self drawRectFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                    }
                } while ((line=line->nextSibling));
            }
        }
        TBXMLElement *title = [TBXML childElementNamed:@"Title" parentElement:staticTables];
        if (title) {
            TBXMLElement *titleText = [TBXML childElementNamed:@"Text" parentElement:title];
            while (titleText) {
                CGFloat fontSize=12;
                TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:titleText];
                if (textInXML != nil) {
                    NSString *textString=[TBXML textForElement:textInXML];
                    if (![textString isEmpty]) {
                        TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:titleText];
                        if (originInXML != nil) {
                            
                            CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                            CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                            TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:titleText];
                            if (fontSizeInXML != nil) {
                                fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                            }
                            TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:titleText];
                            if (sizeInXML) {
                                CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                CGRect rect = CGRectMake(x, y, width, height);
                                UIFont *font = [UIFont fontWithName:FONT_HeiTi size:fontSize];
                                [textString drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                            }
                        }
                    }
                }
                titleText = titleText->nextSibling;
            }
        }
        
        TBXMLElement *texts=[TBXML childElementNamed:@"Texts" parentElement:staticTables];
        if (texts != nil) {
            TBXMLElement *text=[TBXML childElementNamed:@"Text" parentElement:texts];
            while (text) {
                CGFloat fontSize=12;
                TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:text];
                if (textInXML != nil) {
                    NSString *textString=[TBXML textForElement:textInXML];
                    if (![textString isEmpty]) {
                        TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:text];
                        if (originInXML != nil) {
                            /*modify by lxm 2013.05.08
                             CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                             CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                             */
                            CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]*MMTOPIX;
                            CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]*MMTOPIX;
                            
                            TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:text];
                            if (fontSizeInXML != nil) {
                                fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                            }
                            UITextAlignment alignment = UITextAlignmentLeft;
                            TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:text];
                            if (alignmentInXML) {
                                NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                alignmentString = [alignmentString lowercaseString];
                                if (![alignmentString isEmpty]) {
                                    if ([alignmentString isEqualToString:@"center"]) {
                                        alignment = UITextAlignmentCenter;
                                    } else if ([alignmentString isEqualToString:@"right"]){
                                        alignment = UITextAlignmentRight;
                                    }
                                }
                            }
                            TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:text];
                            if (sizeInXML) {
                                CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                CGRect rect = CGRectMake(x, y, width, height);
                                UIFont *font = [UIFont fontWithName:FONT_SongTi size:fontSize];
                                [textString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                            }
                        }
                    }
                }
                text=text->nextSibling;
            }
        }
    }
}


//打印数据，仿宋
- (void)drawDateTable:(NSString *)xmlName withDataModel:(NSManagedObject *)data{
    if (data) {
        NSString *xmlString = [self xmlStringFromFile:xmlName];
        TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
            TBXMLElement *uitextfield=dataTable->firstChild;
            while (uitextfield) {
                TBXMLElement *contentInXML=[TBXML childElementNamed:@"content" parentElement:uitextfield];
                if (contentInXML) {
                    NSString *contentString=@"";
                    TBXMLElement *tempElement=contentInXML->firstChild;
                    while (tempElement) {
                        NSString *elementName=[TBXML elementName:tempElement];
                        if ([elementName isEqualToString:@"text"]) {
                            NSString *elementText = [TBXML textForElement:tempElement];
                            if ([elementText isEqualToString:@"\\n"]) {
                                elementText = @"\n";
                            }
                            contentString=[contentString stringByAppendingString:elementText];
                        } else if ([elementName isEqualToString:@"data"]) {
                            contentString = [contentString stringByAppendingString:[self formedStringFromData:data XMLElement:tempElement]];
                        }
                        tempElement=tempElement->nextSibling;
                    }
                    TBXMLElement *textByLine = [TBXML childElementNamed:@"textByLine" parentElement:uitextfield];
                    if (textByLine) {
                        __block NSNumber *line1CharCount;
                        __block NSNumber *line2CharCount;
                        __block NSNumber *lineCount;
                        __block NSNumber *lineIndex;
                        [TBXML iterateAttributesOfElement:textByLine withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue){
                            if (attributeName && attributeValue) {
                                if ([attributeName isEqualToString:@"line1CharCount"]) {
                                    line1CharCount = @(attributeValue.integerValue);
                                } else if ([attributeName isEqualToString:@"line2CharCount"]) {
                                    line2CharCount = @(attributeValue.integerValue);
                                } else if ([attributeName isEqualToString:@"lineCount"]) {
                                    lineCount = @(attributeValue.integerValue);
                                } else if ([attributeName isEqualToString:@"lineIndex"]) {
                                    lineIndex = @(attributeValue.integerValue);
                                }
                            }
                        }];
                        if (line1CharCount && line2CharCount && lineCount && lineIndex && lineIndex.integerValue < lineCount.integerValue) {
                            contentString = [[contentString getLinesWithCharNumerOfLine1:line1CharCount.integerValue line2:line2CharCount.integerValue andLineCount:lineCount.integerValue] objectAtIndex:lineIndex.integerValue];
                        } else {
                            contentString = @"";
                        }
                    } else {
                        //循环截取，当下个元素不为截取设定元素时即止
                        TBXMLElement *truncInXML = [TBXML childElementNamed:@"truncContent" parentElement:uitextfield];
                        while (truncInXML && [[TBXML elementName:truncInXML] isEqualToString:@"truncContent"]) {
                            TBXMLElement *indexInXML = [TBXML childElementNamed:@"index" parentElement:truncInXML];
                            TBXMLElement *fromHeadInXML = [TBXML childElementNamed:@"fromHead" parentElement:truncInXML];
                            if (indexInXML && fromHeadInXML) {
                                NSInteger index = [TBXML textForElement:indexInXML].integerValue;
                                if (contentString.length > index) {
                                    if ([TBXML textForElement:fromHeadInXML].boolValue) {
                                        contentString = [contentString substringToIndex:index];
                                    } else {
                                        contentString = [contentString substringFromIndex:index];
                                    }
                                } else {
                                    if (![TBXML textForElement:fromHeadInXML].boolValue) {
                                        contentString = @"";
                                    }
                                }
                            }
                            truncInXML = truncInXML->nextSibling;
                        }
                    }
                    TBXMLElement *staticText = [TBXML childElementNamed:@"staticPrefix" parentElement:uitextfield];
                    if (staticText) {
                        contentString=[[TBXML textForElement:staticText] stringByAppendingString:contentString];
                    }
                    TBXMLElement *conditionInXML = [TBXML childElementNamed:@"condition" parentElement:uitextfield];
                    if (conditionInXML) {
                        TBXMLElement *dataSource = [TBXML childElementNamed:@"dataSource" parentElement:conditionInXML];
                        if (dataSource) {
                            TBXMLElement *judgeInXML = [TBXML childElementNamed:@"judgingString" parentElement:conditionInXML];
                            if (judgeInXML) {
                                NSString *dataString = [self formedStringFromData:data XMLElement:dataSource];
                                if (![dataString isEmpty]) {
                                    TBXMLElement *equalInXML = [TBXML childElementNamed:@"equals" parentElement:judgeInXML];
                                    TBXMLElement *notEqualInXML = [TBXML childElementNamed:@"notEquals" parentElement:judgeInXML];
                                    if (equalInXML && notEqualInXML) {
                                        NSString *equalString = [TBXML textForElement:equalInXML];
                                        NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                        if (!([dataString isEqualToString:equalString] && ![dataString isEqualToString:notEqualString])) {
                                            contentString = @"";
                                        }
                                    } else if (equalInXML){
                                        NSString *equalString = [TBXML textForElement:equalInXML];
                                        if (![dataString isEqualToString:equalString]) {
                                            contentString = @"";
                                        }
                                    } else if (notEqualInXML) {
                                        NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                        if ([dataString isEqualToString:notEqualString]) {
                                            contentString = @"";
                                        }
                                    }
                                }
                            }
                        } else {
                            TBXMLElement *lengthLimitInXML = [TBXML childElementNamed:@"lengthLimit" parentElement:conditionInXML];
                            if (lengthLimitInXML) {
                                TBXMLElement *maxInXML = [TBXML childElementNamed:@"max" parentElement:lengthLimitInXML];
                                TBXMLElement *minInXML = [TBXML childElementNamed:@"min" parentElement:lengthLimitInXML];
                                if (maxInXML && minInXML) {
                                    NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                    NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                    if (!(contentString.length <= maxLength && contentString.length > minLength)) {
                                        contentString = @"";
                                    }
                                } else if (maxInXML) {
                                    NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                    if (contentString.length > maxLength) {
                                        contentString = @"";
                                    }
                                } else if (minInXML) {
                                    NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                    if (contentString.length <= minLength) {
                                        contentString = @"";
                                    }
                                }
                            }
                        }
                    }

                    if (![contentString isEmpty]){
                        if ([[TBXML elementName:uitextfield] isEqualToString:@"UITextField"]) {
                            CGFloat fontSize = 12;
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                
                                /* modify by lxm 2013.05.08
                                 CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                                 CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                                 */
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]*MMTOPIX;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]*MMTOPIX;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                                if (fontSizeInXML) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    /* modify by lxm 2013.05.08
                                     CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                     CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                     */
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue*MMTOPIX;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue*MMTOPIX;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    //用于调试元素的位置
                                    //[self drawRectFromPoint1x:x Point1y:y toPoint2x:x+width Point2y:y+height LineWidth:1.0];
                                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                                    
                                    [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                                }
                            }
                        }else if ([[TBXML elementName:uitextfield] isEqualToString:@"UITextView"]){
                            CGFloat fontSize = 12;
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                /*
                                 * modify by lxm 2013.05.08
                                 CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                                 CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                                 */
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]*MMTOPIX;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]*MMTOPIX;
                                
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                                if (fontSizeInXML) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                CGFloat leftOffset = 0;
                                TBXMLElement *leftOffsetInXML = [TBXML childElementNamed:@"leftOffSet" parentElement:uitextfield];
                                if (leftOffsetInXML) {
                                    leftOffset = [TBXML textForElement:leftOffsetInXML].floatValue*MMTOPIX;
                                }
                                //默认无行高,直接画出
                                CGFloat lineHeight = 0;
                                TBXMLElement *lineHeightInXML = [TBXML childElementNamed:@"lineHeight" parentElement:uitextfield];
                                if (lineHeightInXML) {
                                    lineHeight = [TBXML textForElement:lineHeightInXML].floatValue;
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    /*
                                     *modify by lxm 2013.05.08
                                     CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                     CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                     */
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue*MMTOPIX;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue*MMTOPIX;
                                    
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                                    [contentString drawMultiLineTextInRect:rect withFont:font horizontalAlignment:alignment leftOffSet:leftOffset lineHeight:lineHeight];
                                }
                            }
                        }else if ([[TBXML elementName:uitextfield] isEqualToString:@"UITableView"]){
                            [self drawUITableVIew:uitextfield WithData:data];
                        }else if ([[TBXML elementName:uitextfield] isEqualToString:@"UIImgView"]){
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]*MMTOPIX;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]*MMTOPIX;
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue*MMTOPIX;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue*MMTOPIX;
                                    UIImage *img = [UIImage imageWithContentsOfFile:contentString];
                                    CGRect rect;
                                    CGSize imgSize;
                                    //图片缩放
                                    if (width/img.size.width < height/img.size.height) {
                                        imgSize = CGSizeMake(width, (width/img.size.width)*img.size.height);
                                    }else{
                                        imgSize = CGSizeMake((height/img.size.height)*img.size.width, height);
                                    }
                                    //居中处理
                                    rect = CGRectMake(x+(width-imgSize.width)/2, y+(height-imgSize.height)/2, imgSize.width, imgSize.height);
                                    [img drawInRect:rect];
                                }
                            }
                        }
                    }
                }
                uitextfield=uitextfield->nextSibling;
            }
        }
    }
}

// 根据NSDictionary中的数据模型来绘制模板中的内容 | xushiwen | 2013.7.31
- (void)drawDataTable:(NSString *)xmlName withDataInfo:(NSDictionary *)dataInfo {
    if (dataInfo != nil) {
        NSString *xmlString = [self xmlStringFromFile:xmlName];
        NSError *err;
        TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:&err];
        if (err != nil) {
            return;
        }
        
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *datatable = [TBXML childElementNamed:@"DataTable" parentElement:root error:&err];
        if (err != nil) {
            return;
        }
        
        TBXMLElement *defaultFontSizeElement = [TBXML childElementNamed:@"DefaultFontSize" parentElement:datatable error:&err];
        CGFloat defaultFontSize = 0;
        if (defaultFontSizeElement != nil) {
            defaultFontSize = [[TBXML textForElement:defaultFontSizeElement] floatValue];
        }
        
        
        //遍历DataTable下的节点
        [TBXML iterateElementsForQuery:@"DataTable.*" fromElement:root withBlock:^(TBXMLElement *element) {
            TBXMLElement *typeElement = element;
            NSString *typeName = [TBXML elementName:typeElement];
            
            NSError *err = nil;
            TBXMLElement *contentELement = [TBXML childElementNamed:@"content" parentElement:typeElement error:&err];
            TBXMLElement *dataElement = [TBXML childElementNamed:@"data" parentElement:contentELement error:&err];
            
            if (contentELement != nil && dataElement != nil) {
                if ([typeName isEqualToString:@"UITextField"]){
                    
                    //绘制区域
                    TBXMLElement *originElement = [TBXML childElementNamed:@"origin" parentElement:typeElement error:&err];
                    TBXMLElement *sizeElement = [TBXML childElementNamed:@"size" parentElement:typeElement error:&err];
                    CGFloat x = [[TBXML valueOfAttributeNamed:@"x" forElement:originElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGFloat y = [[TBXML valueOfAttributeNamed:@"y" forElement:originElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGFloat width = [[TBXML valueOfAttributeNamed:@"width" forElement:sizeElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGFloat height = [[TBXML valueOfAttributeNamed:@"height" forElement:sizeElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGRect textRect = CGRectMake(x, y, width, height);
                    
                    //用于调试元素的位置
                    //[self drawRectFromPoint1x:x Point1y:y toPoint2x:x+width Point2y:y+height LineWidth:1.0];
                    
                    //字体及大小
                    TBXMLElement *fontSizeElement = [TBXML childElementNamed:@"fontSize" parentElement:typeElement error:&err];
                    CGFloat fontSize = 12;
                    if (fontSizeElement == nil) {
                        if (defaultFontSize > 0) {
                            fontSize = defaultFontSize;
                        }
                    } else {
                        fontSize = [[TBXML textForElement:fontSizeElement] floatValue];
                    }
                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                    
                    //文字对齐方式
                    UITextAlignment alignment = UITextAlignmentLeft;
                    TBXMLElement *alignmentElement = [TBXML childElementNamed:@"alignment" parentElement:typeElement error:&err];
                    if (alignmentElement != nil) {
                        NSString *alignmentString = [[[TBXML textForElement:alignmentElement] lowercaseString]
                                                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if ([alignmentString isEqualToString:@""] || [alignmentString isEqualToString:@"left"]) {
                             alignment = UITextAlignmentLeft;
                        } else if ([alignmentString isEqualToString:@"center"]) {
                            alignment = UITextAlignmentCenter;
                        } else if ([alignmentString isEqualToString:@"right"]){
                            alignment = UITextAlignmentRight;
                        }
                    }
                    
                    NSString *dataContent = [self formedStringFromDataInfo:dataInfo formattedByXML:dataElement];
                    if ([dataContent isEqualToString:@"0"]) {
                        dataContent = @"";
                    }
                    if ([dataContent sizeWithFont:font].width > width) {
                        font = [UIFont fontWithName:FONT_FangSong size:9];
                    }
                    [dataContent alignWithVerticalCenterDrawInRect:textRect withFont:font horizontalAlignment:alignment];
                    
                } else if ([typeName isEqualToString:@"UITextView"]){
                    
                    //绘制区域
                    TBXMLElement *originElement = [TBXML childElementNamed:@"origin" parentElement:typeElement error:&err];
                    TBXMLElement *sizeElement = [TBXML childElementNamed:@"size" parentElement:typeElement error:&err];
                    CGFloat x = [[TBXML valueOfAttributeNamed:@"x" forElement:originElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGFloat y = [[TBXML valueOfAttributeNamed:@"y" forElement:originElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGFloat width = [[TBXML valueOfAttributeNamed:@"width" forElement:sizeElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGFloat height = [[TBXML valueOfAttributeNamed:@"height" forElement:sizeElement error:&err] floatValue] * MMTOPIX * SCALEFACTOR;
                    CGRect textRect = CGRectMake(x, y, width, height);
                    
                    //用于调试元素的位置
                    //[self drawRectFromPoint1x:x Point1y:y toPoint2x:x+width Point2y:y+height LineWidth:1.0];
                    
                    //字体及大小
                    TBXMLElement *fontSizeElement = [TBXML childElementNamed:@"fontSize" parentElement:typeElement error:&err];
                    CGFloat fontSize = 12;
                    if (fontSizeElement == nil) {
                        if (defaultFontSize > 0) {
                            fontSize = defaultFontSize;
                        }
                    } else {
                        fontSize = [[TBXML textForElement:fontSizeElement] floatValue];
                    }
                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                    
                    //文字对齐方式
                    UITextAlignment alignment = UITextAlignmentLeft;
                    TBXMLElement *alignmentElement = [TBXML childElementNamed:@"alignment" parentElement:typeElement error:&err];
                    if (alignmentElement != nil) {
                        NSString *alignmentString = [[[TBXML textForElement:alignmentElement] lowercaseString]
                                                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if (![alignmentString isEqualToString:@""]) {
                            if ([alignmentString isEqualToString:@"center"]) {
                                alignment = UITextAlignmentCenter;
                            } else if ([alignmentString isEqualToString:@"right"]){
                                alignment = UITextAlignmentRight;
                            }
                        }
                    }
                    CGFloat leftOffset = 0;
                    TBXMLElement *leftOffsetElement = [TBXML childElementNamed:@"leftOffSet" parentElement:typeElement];
                    if (leftOffsetElement != nil) {
                        leftOffset = [[TBXML textForElement:leftOffsetElement] floatValue] * MMTOPIX * SCALEFACTOR;
                    }
                    CGFloat lineHeight = 0;
                    TBXMLElement *lineHeightElement = [TBXML childElementNamed:@"lineHeight" parentElement:typeElement];
                    if (lineHeightElement != nil) {
                        lineHeight = [[TBXML textForElement:lineHeightElement] floatValue];
                    }
                    NSString *dataContent = [self formedStringFromDataInfo:dataInfo formattedByXML:dataElement];
                    
                    [dataContent drawMultiLineTextInRect:textRect withFont:font horizontalAlignment:alignment leftOffSet:leftOffset lineHeight:lineHeight];
                    
                } else if ([typeName isEqualToString:@"UITableView"]){
                    //TODO
                } else if ([typeName isEqualToString:@"UIImgView"]){
                    //TODO
                }
            }
        }];
    }
}

//打印多项子表格
- (NSArray *)drawSubTable:(NSString *)subXMLName withDataArray:(NSArray *)dataArray inRect:(CGRect)rect{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dataArray];
    CGPoint origin = rect.origin;
    NSString *xmlString = [self xmlStringFromFile:subXMLName];
    TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
    TBXMLElement *root = tbxml.rootXMLElement;
    TBXMLElement *paper=[TBXML childElementNamed:@"Paper" parentElement:root];
    CGFloat subHeight=[[TBXML valueOfAttributeNamed:@"height" forElement:paper] floatValue];
    NSInteger index = 0;
    while (origin.y < rect.size.height + rect.origin.y && index < dataArray.count) {
        //静态文本，宋体
        TBXMLElement *staticTables=[TBXML childElementNamed:@"StaticTable" parentElement:root];
        if (staticTables != nil) {
            TBXMLElement *lines=[TBXML childElementNamed:@"Lines" parentElement:staticTables];
            if (lines != nil) {
                TBXMLElement *tempElement=[TBXML childElementNamed:@"defaultLineWidth" parentElement:lines];
                CGFloat defaultLineWidth=[[TBXML textForElement:tempElement] floatValue];
                TBXMLElement *line=[TBXML childElementNamed:@"line" parentElement:lines];
                if (line != nil) {
                    do {
                        CGFloat x1=[[TBXML valueOfAttributeNamed:@"x1" forElement:line] floatValue]+origin.x;
                        CGFloat y1=[[TBXML valueOfAttributeNamed:@"y1" forElement:line] floatValue]+origin.y;
                        CGFloat x2=[[TBXML valueOfAttributeNamed:@"x2" forElement:line] floatValue]+origin.x;
                        CGFloat y2=[[TBXML valueOfAttributeNamed:@"y2" forElement:line] floatValue]+origin.y;
                        CGFloat lineWidth=defaultLineWidth;
                        TBXMLAttribute *attribute=line->firstAttribute;
                        while (attribute) {
                            if ([[TBXML attributeName:attribute] isEqualToString:@"lineWidth"]) {
                                lineWidth=[[TBXML attributeValue:attribute] floatValue];
                            }
                            attribute=attribute->next;
                        }
                        NSString *childName = [TBXML elementName:line];
                        if ([childName isEqualToString:@"line"]) {
                            [self drawLineFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                        } else if ([childName isEqualToString:@"rect"]){
                            [self drawRectFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                        }
                    } while ((line=line->nextSibling));
                }
            }
            TBXMLElement *title = [TBXML childElementNamed:@"Title" parentElement:staticTables];
            if (title) {
                TBXMLElement *titleText = [TBXML childElementNamed:@"Text" parentElement:title];
                while (titleText) {
                    CGFloat fontSize=12;
                    TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:titleText];
                    if (textInXML != nil) {
                        NSString *textString=[TBXML textForElement:textInXML];
                        if (![textString isEmpty]) {
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:titleText];
                            if (originInXML != nil) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:titleText];
                                if (fontSizeInXML != nil) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:titleText];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_HeiTi size:fontSize];
                                    [textString drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                                }
                            }
                        }
                    }
                    titleText = titleText->nextSibling;
                }
            }
            
            TBXMLElement *texts=[TBXML childElementNamed:@"Texts" parentElement:staticTables];
            if (texts != nil) {
                TBXMLElement *text=[TBXML childElementNamed:@"Text" parentElement:texts];
                while (text) {
                    CGFloat fontSize=12;
                    TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:text];
                    if (textInXML != nil) {
                        NSString *textString=[TBXML textForElement:textInXML];
                        if (![textString isEmpty]) {
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:text];
                            if (originInXML != nil) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:text];
                                if (fontSizeInXML != nil) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:text];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:text];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_SongTi size:fontSize];
                                    [textString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                                }
                            }
                        }
                    }
                    text=text->nextSibling;
                }
            }
        }
        
        //动态数据，仿宋
        NSManagedObject *data = [dataArray objectAtIndex:index];
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
            TBXMLElement *uitextfield=dataTable->firstChild;
            while (uitextfield) {
                if ([[TBXML elementName:uitextfield] isEqualToString:@"UITextField"]) {
                    
                    TBXMLElement *contentInXML=[TBXML childElementNamed:@"content" parentElement:uitextfield];
                    if (contentInXML) {
                        NSString *contentString=@"";
                        TBXMLElement *tempElement=contentInXML->firstChild;
                        while (tempElement) {
                            NSString *elementName=[TBXML elementName:tempElement];
                            if ([elementName isEqualToString:@"text"]) {
                                NSString *elementText = [TBXML textForElement:tempElement];
                                if ([elementText isEqualToString:@"\\n"]) {
                                    elementText = @"\n";
                                }
                                contentString=[contentString stringByAppendingString:elementText];
                            } else if ([elementName isEqualToString:@"data"]) {
                                contentString = [contentString stringByAppendingString:[self formedStringFromData:data XMLElement:tempElement]];
                            }
                            tempElement=tempElement->nextSibling;
                        }
                        TBXMLElement *textByLine = [TBXML childElementNamed:@"textByLine" parentElement:uitextfield];
                        if (textByLine) {
                            __block NSNumber *line1CharCount;
                            __block NSNumber *line2CharCount;
                            __block NSNumber *lineCount;
                            __block NSNumber *lineIndex;
                            [TBXML iterateAttributesOfElement:textByLine withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue){
                                if (attributeName && attributeValue) {
                                    if ([attributeName isEqualToString:@"line1CharCount"]) {
                                        line1CharCount = @(attributeValue.integerValue);
                                    } else if ([attributeName isEqualToString:@"line2CharCount"]) {
                                        line2CharCount = @(attributeValue.integerValue);
                                    } else if ([attributeName isEqualToString:@"lineCount"]) {
                                        lineCount = @(attributeValue.integerValue);
                                    } else if ([attributeName isEqualToString:@"lineIndex"]) {
                                        lineIndex = @(attributeValue.integerValue);
                                    }
                                }
                            }];
                            if (line1CharCount && line2CharCount && lineCount && lineIndex && lineIndex.integerValue < lineCount.integerValue) {
                                contentString = [[contentString getLinesWithCharNumerOfLine1:line1CharCount.integerValue line2:line2CharCount.integerValue andLineCount:lineCount.integerValue] objectAtIndex:lineIndex.integerValue];
                            } else {
                                contentString = @"";
                            }
                        } else {
                            //循环截取，当下个元素不为截取设定元素时即止
                            TBXMLElement *truncInXML = [TBXML childElementNamed:@"truncContent" parentElement:uitextfield];
                            while (truncInXML && [[TBXML elementName:truncInXML] isEqualToString:@"truncContent"]) {
                                TBXMLElement *indexInXML = [TBXML childElementNamed:@"index" parentElement:truncInXML];
                                TBXMLElement *fromHeadInXML = [TBXML childElementNamed:@"fromHead" parentElement:truncInXML];
                                if (indexInXML && fromHeadInXML) {
                                    NSInteger index = [TBXML textForElement:indexInXML].integerValue;
                                    if (contentString.length > index) {
                                        if ([TBXML textForElement:fromHeadInXML].boolValue) {
                                            contentString = [contentString substringToIndex:index];
                                        } else {
                                            contentString = [contentString substringFromIndex:index];
                                        }
                                    } else {
                                        if (![TBXML textForElement:fromHeadInXML].boolValue) {
                                            contentString = @"";
                                        }
                                    }
                                }
                                truncInXML = truncInXML->nextSibling;
                            }
                        }
                        TBXMLElement *staticText = [TBXML childElementNamed:@"staticPrefix" parentElement:uitextfield];
                        if (staticText) {
                            contentString=[[TBXML textForElement:staticText] stringByAppendingString:contentString];
                        }
                        TBXMLElement *conditionInXML = [TBXML childElementNamed:@"condition" parentElement:uitextfield];
                        if (conditionInXML) {
                            TBXMLElement *dataSource = [TBXML childElementNamed:@"dataSource" parentElement:conditionInXML];
                            if (dataSource) {
                                TBXMLElement *judgeInXML = [TBXML childElementNamed:@"judgingString" parentElement:conditionInXML];
                                if (judgeInXML) {
                                    NSString *dataString = [self formedStringFromData:data XMLElement:dataSource];
                                    if (![dataString isEmpty]) {
                                        TBXMLElement *equalInXML = [TBXML childElementNamed:@"equals" parentElement:judgeInXML];
                                        TBXMLElement *notEqualInXML = [TBXML childElementNamed:@"notEquals" parentElement:judgeInXML];
                                        if (equalInXML && notEqualInXML) {
                                            NSString *equalString = [TBXML textForElement:equalInXML];
                                            NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                            if (!([dataString isEqualToString:equalString] && ![dataString isEqualToString:notEqualString])) {
                                                contentString = @"";
                                            }
                                        } else if (equalInXML){
                                            NSString *equalString = [TBXML textForElement:equalInXML];
                                            if (![dataString isEqualToString:equalString]) {
                                                contentString = @"";
                                            }
                                        } else if (notEqualInXML) {
                                            NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                            if ([dataString isEqualToString:notEqualString]) {
                                                contentString = @"";
                                            }
                                        }
                                    }
                                }
                            } else {
                                TBXMLElement *lengthLimitInXML = [TBXML childElementNamed:@"lengthLimit" parentElement:conditionInXML];
                                if (lengthLimitInXML) {
                                    TBXMLElement *maxInXML = [TBXML childElementNamed:@"max" parentElement:lengthLimitInXML];
                                    TBXMLElement *minInXML = [TBXML childElementNamed:@"min" parentElement:lengthLimitInXML];
                                    if (maxInXML && minInXML) {
                                        NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                        NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                        if (!(contentString.length <= maxLength && contentString.length > minLength)) {
                                            contentString = @"";
                                        }
                                    } else if (maxInXML) {
                                        NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                        if (contentString.length > maxLength) {
                                            contentString = @"";
                                        }
                                    } else if (minInXML) {
                                        NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                        if (contentString.length <= minLength) {
                                            contentString = @"";
                                        }
                                    }
                                }
                            }
                        }
                        if (![contentString isEmpty]){
                            CGFloat fontSize = 12;
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                                if (fontSizeInXML) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                                    [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                                }
                            }
                        }
                    }
                } else if ([[TBXML elementName:uitextfield] isEqualToString:@"SequenceNumber"]) {
                    TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                    if (originInXML) {
                        NSString *contentString = [[NSString alloc] initWithFormat:@"%d", index+1];
                        CGFloat fontSize = 12;
                        CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                        CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                        TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                        if (fontSizeInXML) {
                            fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                        }
                        UITextAlignment alignment = UITextAlignmentLeft;
                        TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                        if (alignmentInXML) {
                            NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                            alignmentString = [alignmentString lowercaseString];
                            if (![alignmentString isEmpty]) {
                                if ([alignmentString isEqualToString:@"center"]) {
                                    alignment = UITextAlignmentCenter;
                                } else if ([alignmentString isEqualToString:@"right"]){
                                    alignment = UITextAlignmentRight;
                                }
                            }
                        }
                        TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                        if (sizeInXML) {
                            CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                            CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                            CGRect rect = CGRectMake(x, y, width, height);
                            UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                            [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                        }
                    }
                }
                uitextfield=uitextfield->nextSibling;
            }
        }
        index += 1;
        origin = CGPointMake(origin.x, origin.y + subHeight);
    }
    
    [tempArray removeObjectsInRange:NSMakeRange(0, index)];
    return [NSArray arrayWithArray:tempArray];
}

//根据配置绘制固定的表格及文字，宋体
-(void)drawStaticTable1:(NSString *)xmlName{
    NSError *error;
    NSString *xmlString=[self xmlStringFromFile:xmlName];
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    
    TBXMLElement *staticTables=[TBXML childElementNamed:@"StaticTable" parentElement:root];
    if (staticTables != nil) {
        TBXMLElement *lines=[TBXML childElementNamed:@"Lines" parentElement:staticTables];
        if (lines != nil) {
            TBXMLElement *tempElement=[TBXML childElementNamed:@"defaultLineWidth" parentElement:lines];
            CGFloat defaultLineWidth=[[TBXML textForElement:tempElement] floatValue];
            TBXMLElement *line=[TBXML childElementNamed:@"line" parentElement:lines];
            if (line != nil) {
                do {
                    CGFloat x1=[[TBXML valueOfAttributeNamed:@"x1" forElement:line] floatValue]*MMTOPIX;
                    CGFloat y1=[[TBXML valueOfAttributeNamed:@"y1" forElement:line] floatValue]*MMTOPIX;
                    CGFloat x2=[[TBXML valueOfAttributeNamed:@"x2" forElement:line] floatValue]*MMTOPIX;
                    CGFloat y2=[[TBXML valueOfAttributeNamed:@"y2" forElement:line] floatValue]*MMTOPIX;
                    CGFloat lineWidth=defaultLineWidth;
                    TBXMLAttribute *attribute=line->firstAttribute;
                    while (attribute) {
                        if ([[TBXML attributeName:attribute] isEqualToString:@"lineWidth"]) {
                            lineWidth=[[TBXML attributeValue:attribute] floatValue];
                        }
                        attribute=attribute->next;
                    }
                    NSString *childName = [TBXML elementName:line];
                    if ([childName isEqualToString:@"line"]) {
                        [self drawLineFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                    } else if ([childName isEqualToString:@"rect"]){
                        [self drawRectFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                    }
                } while ((line=line->nextSibling));
            }
        }
        TBXMLElement *title = [TBXML childElementNamed:@"Title" parentElement:staticTables];
        if (title) {
            TBXMLElement *titleText = [TBXML childElementNamed:@"Text" parentElement:title];
            while (titleText) {
                CGFloat fontSize=12;
                TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:titleText];
                if (textInXML != nil) {
                    NSString *textString=[TBXML textForElement:textInXML];
                    if (![textString isEmpty]) {
                        TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:titleText];
                        if (originInXML != nil) {
                            CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                            CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                            TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:titleText];
                            if (fontSizeInXML != nil) {
                                fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                            }
                            TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:titleText];
                            if (sizeInXML) {
                                CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                CGRect rect = CGRectMake(x, y, width, height);
                                UIFont *font = [UIFont fontWithName:FONT_HeiTi size:fontSize];
                                [textString drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                            }
                        }
                    }
                }
                titleText = titleText->nextSibling;
            }
        }
        
        TBXMLElement *texts=[TBXML childElementNamed:@"Texts" parentElement:staticTables];
        if (texts != nil) {
            TBXMLElement *text=[TBXML childElementNamed:@"Text" parentElement:texts];
            while (text) {
                CGFloat fontSize=12;
                TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:text];
                if (textInXML != nil) {
                    NSString *textString=[TBXML textForElement:textInXML];
                    if (![textString isEmpty]) {
                        TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:text];
                        if (originInXML != nil) {
                            CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]*MMTOPIX * SCALEFACTOR;
                            CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]*MMTOPIX * SCALEFACTOR;
                            TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:text];
                            if (fontSizeInXML != nil) {
                                fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                            }
                            UITextAlignment alignment = UITextAlignmentLeft;
                            TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:text];
                            if (alignmentInXML) {
                                NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                alignmentString = [alignmentString lowercaseString];
                                if (![alignmentString isEmpty]) {
                                    if ([alignmentString isEqualToString:@"center"]) {
                                        alignment = UITextAlignmentCenter;
                                    } else if ([alignmentString isEqualToString:@"right"]){
                                        alignment = UITextAlignmentRight;
                                    }
                                }
                            }
                            TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:text];
                            if (sizeInXML) {
                                CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue*MMTOPIX * SCALEFACTOR;
                                CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue*MMTOPIX * SCALEFACTOR;
                                CGRect rect = CGRectMake(x, y, width, height);
                                UIFont *font = [UIFont fontWithName:FONT_SongTi size:fontSize];
                                [textString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                            }
                        }
                    }
                }
                text=text->nextSibling;
            }
        }
    }
}


//打印数据，仿宋
- (void)drawDateTable1:(NSString *)xmlName withDataModel:(NSManagedObject *)data{
    if (data) {
        NSString *xmlString = [self xmlStringFromFile:xmlName];
        TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
            TBXMLElement *uitextfield=dataTable->firstChild;
            while (uitextfield) {
                TBXMLElement *contentInXML=[TBXML childElementNamed:@"content" parentElement:uitextfield];
                if (contentInXML) {
                    NSString *contentString=@"";
                    TBXMLElement *tempElement=contentInXML->firstChild;
                    while (tempElement) {
                        NSString *elementName=[TBXML elementName:tempElement];
                        if ([elementName isEqualToString:@"text"]) {
                            NSString *elementText = [TBXML textForElement:tempElement];
                            if ([elementText isEqualToString:@"\\n"]) {
                                elementText = @"\n";
                            }
                            contentString=[contentString stringByAppendingString:elementText];
                        } else if ([elementName isEqualToString:@"data"]) {
                            contentString = [contentString stringByAppendingString:[self formedStringFromData:data XMLElement:tempElement]];
                        }
                        tempElement=tempElement->nextSibling;
                    }
                    TBXMLElement *textByLine = [TBXML childElementNamed:@"textByLine" parentElement:uitextfield];
                    if (textByLine) {
                        __block NSNumber *line1CharCount;
                        __block NSNumber *line2CharCount;
                        __block NSNumber *lineCount;
                        __block NSNumber *lineIndex;
                        [TBXML iterateAttributesOfElement:textByLine withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue){
                            if (attributeName && attributeValue) {
                                if ([attributeName isEqualToString:@"line1CharCount"]) {
                                    line1CharCount = @(attributeValue.integerValue);
                                } else if ([attributeName isEqualToString:@"line2CharCount"]) {
                                    line2CharCount = @(attributeValue.integerValue);
                                } else if ([attributeName isEqualToString:@"lineCount"]) {
                                    lineCount = @(attributeValue.integerValue);
                                } else if ([attributeName isEqualToString:@"lineIndex"]) {
                                    lineIndex = @(attributeValue.integerValue);
                                }
                            }
                        }];
                        if (line1CharCount && line2CharCount && lineCount && lineIndex && lineIndex.integerValue < lineCount.integerValue) {
                            contentString = [[contentString getLinesWithCharNumerOfLine1:line1CharCount.integerValue line2:line2CharCount.integerValue andLineCount:lineCount.integerValue] objectAtIndex:lineIndex.integerValue];
                        } else {
                            contentString = @"";
                        }
                    } else {
                        //循环截取，当下个元素不为截取设定元素时即止
                        TBXMLElement *truncInXML = [TBXML childElementNamed:@"truncContent" parentElement:uitextfield];
                        while (truncInXML && [[TBXML elementName:truncInXML] isEqualToString:@"truncContent"]) {
                            TBXMLElement *indexInXML = [TBXML childElementNamed:@"index" parentElement:truncInXML];
                            TBXMLElement *fromHeadInXML = [TBXML childElementNamed:@"fromHead" parentElement:truncInXML];
                            if (indexInXML && fromHeadInXML) {
                                NSInteger index = [TBXML textForElement:indexInXML].integerValue;
                                if (contentString.length > index) {
                                    if ([TBXML textForElement:fromHeadInXML].boolValue) {
                                        contentString = [contentString substringToIndex:index];
                                    } else {
                                        contentString = [contentString substringFromIndex:index];
                                    }
                                } else {
                                    if (![TBXML textForElement:fromHeadInXML].boolValue) {
                                        contentString = @"";
                                    }
                                }
                            }
                            truncInXML = truncInXML->nextSibling;
                        }
                    }
                    TBXMLElement *staticText = [TBXML childElementNamed:@"staticPrefix" parentElement:uitextfield];
                    if (staticText) {
                        contentString=[[TBXML textForElement:staticText] stringByAppendingString:contentString];
                    }
                    TBXMLElement *conditionInXML = [TBXML childElementNamed:@"condition" parentElement:uitextfield];
                    if (conditionInXML) {
                        TBXMLElement *dataSource = [TBXML childElementNamed:@"dataSource" parentElement:conditionInXML];
                        if (dataSource) {
                            TBXMLElement *judgeInXML = [TBXML childElementNamed:@"judgingString" parentElement:conditionInXML];
                            if (judgeInXML) {
                                NSString *dataString = [self formedStringFromData:data XMLElement:dataSource];
                                if (![dataString isEmpty]) {
                                    TBXMLElement *equalInXML = [TBXML childElementNamed:@"equals" parentElement:judgeInXML];
                                    TBXMLElement *notEqualInXML = [TBXML childElementNamed:@"notEquals" parentElement:judgeInXML];
                                    if (equalInXML && notEqualInXML) {
                                        NSString *equalString = [TBXML textForElement:equalInXML];
                                        NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                        if (!([dataString isEqualToString:equalString] && ![dataString isEqualToString:notEqualString])) {
                                            contentString = @"";
                                        }
                                    } else if (equalInXML){
                                        NSString *equalString = [TBXML textForElement:equalInXML];
                                        if (![dataString isEqualToString:equalString]) {
                                            contentString = @"";
                                        }
                                    } else if (notEqualInXML) {
                                        NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                        if ([dataString isEqualToString:notEqualString]) {
                                            contentString = @"";
                                        }
                                    }
                                }
                            }
                        } else {
                            TBXMLElement *lengthLimitInXML = [TBXML childElementNamed:@"lengthLimit" parentElement:conditionInXML];
                            if (lengthLimitInXML) {
                                TBXMLElement *maxInXML = [TBXML childElementNamed:@"max" parentElement:lengthLimitInXML];
                                TBXMLElement *minInXML = [TBXML childElementNamed:@"min" parentElement:lengthLimitInXML];
                                if (maxInXML && minInXML) {
                                    NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                    NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                    if (!(contentString.length <= maxLength && contentString.length > minLength)) {
                                        contentString = @"";
                                    }
                                } else if (maxInXML) {
                                    NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                    if (contentString.length > maxLength) {
                                        contentString = @"";
                                    }
                                } else if (minInXML) {
                                    NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                    if (contentString.length <= minLength) {
                                        contentString = @"";
                                    }
                                }
                            }
                        }
                    }
                    if (![contentString isEmpty]){
                        if ([[TBXML elementName:uitextfield] isEqualToString:@"UITextField"]) {
                            CGFloat fontSize = 12;
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                                if (fontSizeInXML) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                                    [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                                }
                            }
                        }
                        else if ([[TBXML elementName:uitextfield] isEqualToString:@"UITextView"]){
                            CGFloat fontSize = 12;
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                                if (fontSizeInXML) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                CGFloat leftOffset = 0;
                                TBXMLElement *leftOffsetInXML = [TBXML childElementNamed:@"leftOffSet" parentElement:uitextfield];
                                if (leftOffsetInXML) {
                                    leftOffset = [TBXML textForElement:leftOffsetInXML].floatValue;
                                }
                                //默认无行高,直接画出
                                CGFloat lineHeight = 0;
                                TBXMLElement *lineHeightInXML = [TBXML childElementNamed:@"lineHeight" parentElement:uitextfield];
                                if (lineHeightInXML) {
                                    lineHeight = [TBXML textForElement:lineHeightInXML].floatValue;
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                                    [contentString drawMultiLineTextInRect:rect withFont:font horizontalAlignment:alignment leftOffSet:leftOffset lineHeight:lineHeight];
                                }
                            }
                        }
                    }
                }
                uitextfield=uitextfield->nextSibling;
            }
        }
    }
}


//打印多项子表格
- (NSArray *)drawSubTable1:(NSString *)subXMLName withDataArray:(NSArray *)dataArray inRect:(CGRect)rect{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:dataArray];
    CGPoint origin = rect.origin;
    NSString *xmlString = [self xmlStringFromFile:subXMLName];
    TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
    TBXMLElement *root = tbxml.rootXMLElement;
    TBXMLElement *paper=[TBXML childElementNamed:@"Paper" parentElement:root];
    CGFloat subHeight=[[TBXML valueOfAttributeNamed:@"height" forElement:paper] floatValue];
    NSInteger index = 0;
    while (origin.y < rect.size.height + rect.origin.y && index < dataArray.count) {
        //静态文本，宋体
        TBXMLElement *staticTables=[TBXML childElementNamed:@"StaticTable" parentElement:root];
        if (staticTables != nil) {
            TBXMLElement *lines=[TBXML childElementNamed:@"Lines" parentElement:staticTables];
            if (lines != nil) {
                TBXMLElement *tempElement=[TBXML childElementNamed:@"defaultLineWidth" parentElement:lines];
                CGFloat defaultLineWidth=[[TBXML textForElement:tempElement] floatValue];
                TBXMLElement *line=[TBXML childElementNamed:@"line" parentElement:lines];
                if (line != nil) {
                    do {
                        CGFloat x1=[[TBXML valueOfAttributeNamed:@"x1" forElement:line] floatValue]+origin.x;
                        CGFloat y1=[[TBXML valueOfAttributeNamed:@"y1" forElement:line] floatValue]+origin.y;
                        CGFloat x2=[[TBXML valueOfAttributeNamed:@"x2" forElement:line] floatValue]+origin.x;
                        CGFloat y2=[[TBXML valueOfAttributeNamed:@"y2" forElement:line] floatValue]+origin.y;
                        CGFloat lineWidth=defaultLineWidth;
                        TBXMLAttribute *attribute=line->firstAttribute;
                        while (attribute) {
                            if ([[TBXML attributeName:attribute] isEqualToString:@"lineWidth"]) {
                                lineWidth=[[TBXML attributeValue:attribute] floatValue];
                            }
                            attribute=attribute->next;
                        }
                        NSString *childName = [TBXML elementName:line];
                        if ([childName isEqualToString:@"line"]) {
                            [self drawLineFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                        } else if ([childName isEqualToString:@"rect"]){
                            [self drawRectFromPoint1x:x1 Point1y:y1 toPoint2x:x2 Point2y:y2 LineWidth:lineWidth];
                        }
                    } while ((line=line->nextSibling));
                }
            }
            TBXMLElement *title = [TBXML childElementNamed:@"Title" parentElement:staticTables];
            if (title) {
                TBXMLElement *titleText = [TBXML childElementNamed:@"Text" parentElement:title];
                while (titleText) {
                    CGFloat fontSize=12;
                    TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:titleText];
                    if (textInXML != nil) {
                        NSString *textString=[TBXML textForElement:textInXML];
                        if (![textString isEmpty]) {
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:titleText];
                            if (originInXML != nil) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:titleText];
                                if (fontSizeInXML != nil) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:titleText];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_HeiTi size:fontSize];
                                    [textString drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
                                }
                            }
                        }
                    }
                    titleText = titleText->nextSibling;
                }
            }
            
            TBXMLElement *texts=[TBXML childElementNamed:@"Texts" parentElement:staticTables];
            if (texts != nil) {
                TBXMLElement *text=[TBXML childElementNamed:@"Text" parentElement:texts];
                while (text) {
                    CGFloat fontSize=12;
                    TBXMLElement *textInXML=[TBXML childElementNamed:@"text" parentElement:text];
                    if (textInXML != nil) {
                        NSString *textString=[TBXML textForElement:textInXML];
                        if (![textString isEmpty]) {
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:text];
                            if (originInXML != nil) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:text];
                                if (fontSizeInXML != nil) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:text];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:text];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_SongTi size:fontSize];
                                    [textString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                                }
                            }
                        }
                    }
                    text=text->nextSibling;
                }
            }
        }
        
        //动态数据，仿宋
        NSManagedObject *data = [dataArray objectAtIndex:index];
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
            TBXMLElement *uitextfield=dataTable->firstChild;
            while (uitextfield) {
                if ([[TBXML elementName:uitextfield] isEqualToString:@"UITextField"]) {
                    
                    TBXMLElement *contentInXML=[TBXML childElementNamed:@"content" parentElement:uitextfield];
                    if (contentInXML) {
                        NSString *contentString=@"";
                        TBXMLElement *tempElement=contentInXML->firstChild;
                        while (tempElement) {
                            NSString *elementName=[TBXML elementName:tempElement];
                            if ([elementName isEqualToString:@"text"]) {
                                NSString *elementText = [TBXML textForElement:tempElement];
                                if ([elementText isEqualToString:@"\\n"]) {
                                    elementText = @"\n";
                                }
                                contentString=[contentString stringByAppendingString:elementText];
                            } else if ([elementName isEqualToString:@"data"]) {
                                contentString = [contentString stringByAppendingString:[self formedStringFromData:data XMLElement:tempElement]];
                            }
                            tempElement=tempElement->nextSibling;
                        }
                        TBXMLElement *textByLine = [TBXML childElementNamed:@"textByLine" parentElement:uitextfield];
                        if (textByLine) {
                            __block NSNumber *line1CharCount;
                            __block NSNumber *line2CharCount;
                            __block NSNumber *lineCount;
                            __block NSNumber *lineIndex;
                            [TBXML iterateAttributesOfElement:textByLine withBlock:^(TBXMLAttribute *attribute, NSString *attributeName, NSString *attributeValue){
                                if (attributeName && attributeValue) {
                                    if ([attributeName isEqualToString:@"line1CharCount"]) {
                                        line1CharCount = @(attributeValue.integerValue);
                                    } else if ([attributeName isEqualToString:@"line2CharCount"]) {
                                        line2CharCount = @(attributeValue.integerValue);
                                    } else if ([attributeName isEqualToString:@"lineCount"]) {
                                        lineCount = @(attributeValue.integerValue);
                                    } else if ([attributeName isEqualToString:@"lineIndex"]) {
                                        lineIndex = @(attributeValue.integerValue);
                                    }
                                }
                            }];
                            if (line1CharCount && line2CharCount && lineCount && lineIndex && lineIndex.integerValue < lineCount.integerValue) {
                                contentString = [[contentString getLinesWithCharNumerOfLine1:line1CharCount.integerValue line2:line2CharCount.integerValue andLineCount:lineCount.integerValue] objectAtIndex:lineIndex.integerValue];
                            } else {
                                contentString = @"";
                            }
                        } else {
                            //循环截取，当下个元素不为截取设定元素时即止
                            TBXMLElement *truncInXML = [TBXML childElementNamed:@"truncContent" parentElement:uitextfield];
                            while (truncInXML && [[TBXML elementName:truncInXML] isEqualToString:@"truncContent"]) {
                                TBXMLElement *indexInXML = [TBXML childElementNamed:@"index" parentElement:truncInXML];
                                TBXMLElement *fromHeadInXML = [TBXML childElementNamed:@"fromHead" parentElement:truncInXML];
                                if (indexInXML && fromHeadInXML) {
                                    NSInteger index = [TBXML textForElement:indexInXML].integerValue;
                                    if (contentString.length > index) {
                                        if ([TBXML textForElement:fromHeadInXML].boolValue) {
                                            contentString = [contentString substringToIndex:index];
                                        } else {
                                            contentString = [contentString substringFromIndex:index];
                                        }
                                    } else {
                                        if (![TBXML textForElement:fromHeadInXML].boolValue) {
                                            contentString = @"";
                                        }
                                    }
                                }
                                truncInXML = truncInXML->nextSibling;
                            }
                        }
                        TBXMLElement *staticText = [TBXML childElementNamed:@"staticPrefix" parentElement:uitextfield];
                        if (staticText) {
                            contentString=[[TBXML textForElement:staticText] stringByAppendingString:contentString];
                        }
                        TBXMLElement *conditionInXML = [TBXML childElementNamed:@"condition" parentElement:uitextfield];
                        if (conditionInXML) {
                            TBXMLElement *dataSource = [TBXML childElementNamed:@"dataSource" parentElement:conditionInXML];
                            if (dataSource) {
                                TBXMLElement *judgeInXML = [TBXML childElementNamed:@"judgingString" parentElement:conditionInXML];
                                if (judgeInXML) {
                                    NSString *dataString = [self formedStringFromData:data XMLElement:dataSource];
                                    if (![dataString isEmpty]) {
                                        TBXMLElement *equalInXML = [TBXML childElementNamed:@"equals" parentElement:judgeInXML];
                                        TBXMLElement *notEqualInXML = [TBXML childElementNamed:@"notEquals" parentElement:judgeInXML];
                                        if (equalInXML && notEqualInXML) {
                                            NSString *equalString = [TBXML textForElement:equalInXML];
                                            NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                            if (!([dataString isEqualToString:equalString] && ![dataString isEqualToString:notEqualString])) {
                                                contentString = @"";
                                            }
                                        } else if (equalInXML){
                                            NSString *equalString = [TBXML textForElement:equalInXML];
                                            if (![dataString isEqualToString:equalString]) {
                                                contentString = @"";
                                            }
                                        } else if (notEqualInXML) {
                                            NSString *notEqualString = [TBXML textForElement:notEqualInXML];
                                            if ([dataString isEqualToString:notEqualString]) {
                                                contentString = @"";
                                            }
                                        }
                                    }
                                }
                            } else {
                                TBXMLElement *lengthLimitInXML = [TBXML childElementNamed:@"lengthLimit" parentElement:conditionInXML];
                                if (lengthLimitInXML) {
                                    TBXMLElement *maxInXML = [TBXML childElementNamed:@"max" parentElement:lengthLimitInXML];
                                    TBXMLElement *minInXML = [TBXML childElementNamed:@"min" parentElement:lengthLimitInXML];
                                    if (maxInXML && minInXML) {
                                        NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                        NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                        if (!(contentString.length <= maxLength && contentString.length > minLength)) {
                                            contentString = @"";
                                        }
                                    } else if (maxInXML) {
                                        NSInteger maxLength = [TBXML textForElement:maxInXML].integerValue;
                                        if (contentString.length > maxLength) {
                                            contentString = @"";
                                        }
                                    } else if (minInXML) {
                                        NSInteger minLength = [TBXML textForElement:minInXML].integerValue;
                                        if (contentString.length <= minLength) {
                                            contentString = @"";
                                        }
                                    }
                                }
                            }
                        }
                        if (![contentString isEmpty]){
                            CGFloat fontSize = 12;
                            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                            if (originInXML) {
                                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                                TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                                if (fontSizeInXML) {
                                    fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                                }
                                UITextAlignment alignment = UITextAlignmentLeft;
                                TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                                if (alignmentInXML) {
                                    NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                    alignmentString = [alignmentString lowercaseString];
                                    if (![alignmentString isEmpty]) {
                                        if ([alignmentString isEqualToString:@"center"]) {
                                            alignment = UITextAlignmentCenter;
                                        } else if ([alignmentString isEqualToString:@"right"]){
                                            alignment = UITextAlignmentRight;
                                        }
                                    }
                                }
                                TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                                if (sizeInXML) {
                                    CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                                    CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                                    CGRect rect = CGRectMake(x, y, width, height);
                                    UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                                    [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                                }
                            }
                        }
                    }
                } else if ([[TBXML elementName:uitextfield] isEqualToString:@"SequenceNumber"]) {
                    TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:uitextfield];
                    if (originInXML) {
                        NSString *contentString = [[NSString alloc] initWithFormat:@"%d", index+1];
                        CGFloat fontSize = 12;
                        CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+origin.x;
                        CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+origin.y;
                        TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:uitextfield];
                        if (fontSizeInXML) {
                            fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                        }
                        UITextAlignment alignment = UITextAlignmentLeft;
                        TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:uitextfield];
                        if (alignmentInXML) {
                            NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                            alignmentString = [alignmentString lowercaseString];
                            if (![alignmentString isEmpty]) {
                                if ([alignmentString isEqualToString:@"center"]) {
                                    alignment = UITextAlignmentCenter;
                                } else if ([alignmentString isEqualToString:@"right"]){
                                    alignment = UITextAlignmentRight;
                                }
                            }
                        }
                        TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:uitextfield];
                        if (sizeInXML) {
                            CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                            CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                            CGRect rect = CGRectMake(x, y, width, height);
                            UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                            [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                        }
                    }
                }
                uitextfield=uitextfield->nextSibling;
            }
        }
        index += 1;
        origin = CGPointMake(origin.x, origin.y + subHeight);
    }
    
    [tempArray removeObjectsInRange:NSMakeRange(0, index)];
    return [NSArray arrayWithArray:tempArray];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.printController = [[CasePrintController alloc] init];
    self.printController.delegate = self;
}

- (void)viewDidUnload
{
    [self setCaseID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
//全打
-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        if (![filePath isEmpty]) {
            if ([self.printController saveAsPDF:filePath dataOnly:NO] == YES) {
                return [NSURL fileURLWithPath:filePath];
            }
        }
    }
    return nil;
}
// 套打
- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        if ([self.printController saveAsPDF:formatFilePath dataOnly:YES] == YES) {
            return [NSURL fileURLWithPath:formatFilePath];
        }
    }
    return nil;
}


-(void)loadDataAtIndex:(NSInteger)index{
    [self pageLoadInfo];
}

//按位置绘制直线
-(void)drawLineFromPoint1x:(CGFloat)p1x
                   Point1y:(CGFloat)p1y
                 toPoint2x:(CGFloat)p2x
                   Point2y:(CGFloat)p2y
                 LineWidth:(CGFloat)lineWidth{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, p1x+prLeftMargin, p1y+prTopMargin);
    CGContextAddLineToPoint(context, p2x+prLeftMargin, p2y+prTopMargin);
    CGContextStrokePath(context);
    //统一调用drawLineFromPoint1:toPoint2:withLineWidth:andLineStyle:方法 | xushiwen | 2013.7.29
//    [self drawLineFromPoint1:CGPointMake(p1x, p1y) toPoint2:CGPointMake(p2x, p2y) withLineWidth:lineWidth andLineStyle:PDFDrawLineStyleNormal];
}

//根据指定的直线样式绘制直线 | xushiwen | 2013.7.29
-(void)drawLineFromPoint1:(CGPoint)p1 toPoint2:(CGPoint)p2 withLineWidth:(CGFloat)lineWidth andLineStyle:(PDFDrawLineStyleOptions)lineStyle
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    if (lineStyle == PDFDrawLineStyleDash) {
        CGFloat dashLengths[] = {2.5, 2.5};
        CGContextSetLineDash(context, 0, dashLengths, 2);
    } else if (lineStyle == PDFDrawLineStyleDotted) {
        CGFloat dottedLengths[] = {1, 1};
        CGContextSetLineDash(context, 0, dottedLengths, 2);
    }
    CGContextMoveToPoint(context, p1.x + prLeftMargin, p1.y + prTopMargin);
    CGContextAddLineToPoint(context, p2.x + prLeftMargin, p2.y + prTopMargin);
    CGContextStrokePath(context);
    //恢复成普通直线
    CGFloat defaultLengths[] = {};
    CGContextSetLineDash(context, 0, defaultLengths, 0);
}

////按位置绘制直线
//-(void)drawLineFromPoint1x:(CGFloat)p1x
//                   Point1y:(CGFloat)p1y
//                 toPoint2x:(CGFloat)p2x
//                   Point2y:(CGFloat)p2y
//                 LineWidth:(CGFloat)lineWidth{
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
//    CGContextSetLineWidth(context, lineWidth);
//    CGContextMoveToPoint(context, p1x+prLeftMargin, p1y+prTopMargin);
//    CGContextAddLineToPoint(context, p2x+prLeftMargin, p2y+prTopMargin);
//    CGContextStrokePath(context);
//}
//
- (void)drawRectFromPoint1x:(CGFloat)p1x
                    Point1y:(CGFloat)p1y
                  toPoint2x:(CGFloat)p2x
                    Point2y:(CGFloat)p2y
                  LineWidth:(CGFloat)lineWidth{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGRect rect = CGRectMake( p1x+prLeftMargin, p1y+prTopMargin, ABS(p2x-p1x), ABS(p2y-p1y));
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

//从xml的content元素中生成字符串
- (NSString *)formedStringFromData:(NSManagedObject *)data XMLElement:(TBXMLElement *)xmlElement{
    NSString *tempString = @"";
    TBXMLElement *attriNameInXML=[TBXML childElementNamed:@"attributeName" parentElement:xmlElement];
    TBXMLElement *entityNameInXML=[TBXML childElementNamed:@"entityName" parentElement:xmlElement];
    NSString *attributeName=@"";
    NSString *entityName=@"";
    if (attriNameInXML) {
        attributeName=[TBXML textForElement:attriNameInXML];
    }
    if (entityNameInXML) {
        entityName=[TBXML textForElement:entityNameInXML];
    }
    //return attributeName;
    if (![attributeName isEmpty]) {
        NSManagedObject *dataObj;
        if (![entityName isEmpty]) {
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
            NSEntityDescription *entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate;
            if ([entityName isEqualToString:@"CaseDeformation"] || [entityName isEqualToString:@"CaseInquire"] || [entityName isEqualToString:@"Citizen"]){
                predicate = [NSPredicate predicateWithFormat:@"proveinfo_id == %@",self.caseID];
            }else if ([entityName isEqualToString:@"CaseProveInfo"]){
                predicate = [NSPredicate predicateWithFormat:@"caseinfo_id == %@",self.caseID];
            }else {
                /*
                 predicate = [NSPredicate predicateWithFormat:@"caseinfo_id == %@",self.caseID];
                 *modify by lxm
                 */
                predicate = [NSPredicate predicateWithFormat:@"myid == %@",self.caseID];
                
            }
            [fetchRequest setPredicate:predicate];
            NSArray *fetchResults=[context executeFetchRequest:fetchRequest error:nil];
            if (fetchResults.count>0){
                dataObj=[fetchResults objectAtIndex:0];
            }
        } else {
            dataObj = data;
        }
        if (dataObj) {
            if ([dataObj respondsToSelector:NSSelectorFromString(attributeName)]) {
                NSDictionary *attributes = [dataObj.entity attributesByName];
                NSAttributeDescription *attriDesc = [attributes objectForKey:attributeName];
                id valueObj = [dataObj valueForKey:attributeName];
                if (valueObj){
                    switch (attriDesc.attributeType) {
                        case NSStringAttributeType:
                            tempString = [tempString stringByAppendingString:valueObj];
                            break;
                        case NSFloatAttributeType:
                        case NSDoubleAttributeType:{
                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                            [formatter setPositiveFormat:@"#,##0.00"];
                            TBXMLElement *formatterElement=[TBXML childElementNamed:@"mode" parentElement:xmlElement];
                            if (formatterElement) {
                                [formatter setPositiveFormat:[TBXML textForElement:formatterElement]];
                            }
                            tempString=[tempString stringByAppendingString:[formatter stringFromNumber:valueObj]];
                        }
                            break;
                        case NSDateAttributeType:{
                            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                            [formatter setLocale:[NSLocale currentLocale]];
                            [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
                            TBXMLElement *formatterElement=[TBXML childElementNamed:@"mode" parentElement:xmlElement];
                            NSString *dateString = @"";
                            if (formatterElement) {
                                NSString *dateFormat = [TBXML textForElement:formatterElement];
                                [formatter setDateFormat:dateFormat];
                                dateString = [formatter stringFromDate:valueObj];
                            } else {
                                dateString = [formatter stringFromDate:valueObj];
                            }
                            tempString=[tempString stringByAppendingString:dateString];
                        }
                            break;
                        case NSInteger16AttributeType:
                        case NSInteger32AttributeType:
                        case NSInteger64AttributeType:{
                            if ([valueObj integerValue] > 0) {
                                tempString=[tempString stringByAppendingString:[valueObj stringValue]];
                            }
                        }
                            break;
                        default:
                            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@", valueObj]];

                            break;
                    }
                }
            }
        }
    }

    return tempString;
}

// 根据info的键值内容以及XML格式返回字符串，根据formedStringFromData:XMLElement:改写 | xushiwen | 2013.7.31
// dataInfo[实体名][属性名][@"value"] = 属性值
// dataInfo[实体名][属性名][@"valueType"] = 属性描述
// dataInfo[@"Default"] = 默认实体，针对XML中未标实体名的节点
// dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = 总页数
// dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = 当前页码
- (NSString *)formedStringFromDataInfo:(NSDictionary *)dataInfo formattedByXML:(TBXMLElement *)xmlElement{
    NSString *returnString = @"";
    TBXMLElement *attriNameInXML = [TBXML childElementNamed:@"attributeName" parentElement:xmlElement];
    NSString *attributeName = @"";
    if (attriNameInXML != nil) {
        attributeName =[TBXML textForElement:attriNameInXML];
    }
    
    if (![attributeName isEmpty]) {
        NSString *entityName = @"Default";
        TBXMLElement *entityNameInXML = [TBXML childElementNamed:@"entityName" parentElement:xmlElement];
        if (entityNameInXML != nil) {
            NSString *temp = [[TBXML textForElement:entityNameInXML] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![temp isEqualToString:@""]) {
                entityName = temp;
            }
        }
        
        NSDictionary *attributeData = dataInfo[entityName][attributeName];
        id attributeValue = nil;
        NSNumber *attributeTypeNSNumber = nil;
        if (attributeData == nil) {
            // 如没有相关的属性值，查看是否是一个方法
            if ([NSClassFromString(entityName) instancesRespondToSelector:NSSelectorFromString(attributeName)]) {
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
                NSEntityDescription *entity=[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"myid == %@", dataInfo[entityName][@"myid"][@"value"]];
                [fetchRequest setPredicate:predicate];
                NSArray *fetchResults=[context executeFetchRequest:fetchRequest error:nil];
                if ([fetchResults count] > 0){
                    id dataObject = fetchResults[0];
                    SEL aSelector = NSSelectorFromString(attributeName);
                    
                    if (aSelector != nil && [dataObject respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        attributeValue = [dataObject performSelector:aSelector];      //ARC下此方法会产生警告，虽已设置忽略，但需确认方法返回时不会分配内存空间以免内存泄漏
#pragma clang diagnostic pop
                        attributeTypeNSNumber = @(NSUndefinedAttributeType);
                    }
                } 
            }
        } else {
            attributeValue = attributeData[@"value"];
            attributeTypeNSNumber = attributeData[@"valueType"];
        }
        
        if (attributeValue != nil && attributeTypeNSNumber != nil) {
            NSAttributeType attributeType = [attributeTypeNSNumber unsignedIntegerValue];
            if (attributeType == NSStringAttributeType) {
                
                returnString = attributeValue;
            
            } else if (attributeType == NSFloatAttributeType ||
                       attributeType == NSDoubleAttributeType) {
                
                NSNumberFormatter *doubleTypeFormatter = [[NSNumberFormatter alloc] init];
                [doubleTypeFormatter setPositiveFormat:@"#,##0.00"];
                TBXMLElement *formatterElement=[TBXML childElementNamed:@"mode" parentElement:xmlElement];
                if (formatterElement != nil) {
                    [doubleTypeFormatter setPositiveFormat:[TBXML textForElement:formatterElement]];
                }
                returnString = [doubleTypeFormatter stringFromNumber:attributeValue];
            
            } else if (attributeType == NSInteger16AttributeType ||
                       attributeType == NSInteger32AttributeType ||
                       attributeType == NSInteger64AttributeType) {
                
                returnString = [attributeValue stringValue];
            
            } else if (attributeType == NSDateAttributeType) {
               
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setLocale:[NSLocale currentLocale]];
                [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
                TBXMLElement *formatterElement = [TBXML childElementNamed:@"mode" parentElement:xmlElement];
                if (formatterElement) {
                    NSString *dateFormat = [TBXML textForElement:formatterElement];
                    [formatter setDateFormat:dateFormat];
                    returnString = [formatter stringFromDate:attributeValue];
                } else {
                    returnString = [formatter stringFromDate:attributeValue];
                }
            
            } else {
                
                returnString = [NSString stringWithFormat:@"%@",attributeValue];
            }
        }
    }
    return returnString;
}

- (void) drawUITableVIew:(TBXMLElement *)xml WithData:(NSManagedObject *) data{
    if (xml) {
        NSArray *dataArray = nil;
        //获取数据列表
        TBXMLElement *dataInXML=[TBXML childElementNamed:@"data" parentElement:[TBXML childElementNamed:@"content" parentElement:xml]];
        if (dataInXML) {
            NSString *attributeName=@"";
            TBXMLElement *attriNameInXML=[TBXML childElementNamed:@"attributeName" parentElement:dataInXML];
            if (attriNameInXML) {
                attributeName=[TBXML textForElement:attriNameInXML];
            }
            if (![attributeName isEmpty]) {
                if ([data respondsToSelector:NSSelectorFromString(attributeName)]) {
                    id valueObj = [data valueForKey:attributeName];
                    if ([[valueObj class] isSubclassOfClass:[NSArray class]]) {
                        dataArray = [NSArray arrayWithArray:valueObj];
                    }
                }
            }
        }
        if (dataArray && [dataArray count]>0){
            TBXMLElement *tableInXML = [TBXML childElementNamed:@"table" parentElement:xml];
            TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:tableInXML];
            if (originInXML) {
                CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]*MMTOPIX * SCALEFACTOR;
                CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]*MMTOPIX * SCALEFACTOR;
                CGFloat inx;
                CGFloat iny = y;
                TBXMLElement *rowInXML=[TBXML childElementNamed:@"row" parentElement:tableInXML];
                if (rowInXML) {
                    int rowNum = 0;
                    while (rowNum < [dataArray count]) {
                        NSManagedObject *one = [dataArray objectAtIndex:rowNum];
                        CGFloat rowH = 0;
                        rowNum++;
                        inx = x;
                        TBXMLElement *cellInXML=rowInXML->firstChild;
                        while (cellInXML) {
                            CGFloat fontSize=12;
                            TBXMLElement *cellSizeInXML=[TBXML childElementNamed:@"size" parentElement:cellInXML];
                            CGFloat cellW=[[TBXML valueOfAttributeNamed:@"width" forElement:cellSizeInXML] floatValue]*MMTOPIX;
                            CGFloat cellH=[[TBXML valueOfAttributeNamed:@"height" forElement:cellSizeInXML] floatValue]*MMTOPIX;
                            TBXMLElement *cellFontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:cellInXML];
                            if (cellFontSizeInXML) {
                                fontSize=[[TBXML textForElement:cellFontSizeInXML] floatValue];
                            }
                            UITextAlignment cellAlignment = UITextAlignmentLeft;
                            TBXMLElement *cellAlignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:cellInXML];
                            if (cellAlignmentInXML) {
                                NSString *cellAlignmentString = [TBXML textForElement:cellAlignmentInXML];
                                cellAlignmentString = [cellAlignmentString lowercaseString];
                                if (![cellAlignmentString isEmpty]) {
                                    if ([cellAlignmentString isEqualToString:@"center"]) {
                                        cellAlignment = UITextAlignmentCenter;
                                    } else if ([cellAlignmentString isEqualToString:@"right"]){
                                        cellAlignment = UITextAlignmentRight;
                                    }
                                }
                            }
                            CGRect rect = CGRectMake(inx, iny, cellW, cellH);
                            //用于调试元素的位置
                            //[self drawRectFromPoint1x:inx Point1y:iny toPoint2x:inx+cellW Point2y:iny+cellH LineWidth:1.0];
                            UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                            NSString *contentString=@"";
                            TBXMLElement *dataInXML = [TBXML childElementNamed:@"data" parentElement:cellInXML];
                            if (dataInXML) {
                                contentString = [contentString stringByAppendingString:[self formedStringFromData:one XMLElement:dataInXML]];
                            }
                            [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:cellAlignment];
//                            [contentString drawStringFitIntoRect:rect withBasicFont:font];
                            if (rowH < cellH) {
                                rowH = cellH;
                            }
                            inx += cellW;
                            cellInXML = cellInXML->nextSibling;
                        }
                        iny += rowH;
                    }
                }
            }
        }
    }
}



@end
