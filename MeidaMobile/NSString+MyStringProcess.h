//
//  NSString+MyStringProcess.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandleStrings.h"
@interface NSString (MyStringProcess)

//在方框内居中绘制文字，lineBreakMode：WordWarp
- (CGSize)alignWithVerticalCenterDrawInRect:(CGRect)rect withFont:(UIFont *)font horizontalAlignment:(UITextAlignment)alignment;

- (void)drawStringFitIntoRect:(CGRect)rect withBasicFont:(UIFont *)font;

//绘制多行文本，lineHeight为整行高度。返回值为剩余的字符
- (NSString *)drawMultiLineTextInRect:(CGRect)rect
                             withFont:(UIFont *)font
                  horizontalAlignment:(UITextAlignment)alignment
                           leftOffSet:(CGFloat)leftOffSet
                           lineHeight:(CGFloat)lineHeight;

// 为字符串分行
// 将字符串本身分行，3个参数分别为第一行字数、第二行字数（后面所有行字数等于第二行）、总行数
- (NSArray *)getLinesWithCharNumerOfLine1:(NSInteger)line1
                                    line2:(NSInteger)line2
                             andLineCount:(NSInteger)line_num;


//将文本分页，可定义第一页和后续页大小，字体，对齐方式及整体行高
- (NSArray *)pagesWithFont:(UIFont *)font
                lineHeight:(CGFloat)lineHeight
       horizontalAlignment:(UITextAlignment)alignment
                 page1Rect:(CGRect)page1Rect
            followPageRect:(CGRect)followPageRect;

//将数字日期转换成为中文汉字日期，仅转换单独数字。如果是2013-01-01等类型的日期，需分隔开之后再单独转换处理，参数决定是否按年份转换
- (NSString *)numberDateToChineseAndIsYearDate:(BOOL)isYearDate;

//检查字符串是否为空
- (BOOL)isEmpty;
// 前后去掉空格和换行符
- (NSString *)simpleString;// zhenlintie 2014-03-26
// 如果为空默认返回'无'
- (NSString *)defaultEmpty;// zhenlintie 2014-03-26

//生成随机ID
+ (NSString *)randomID;

//对字符串加密
- (NSString *)encryptedString;

//将字符串序列化为xml元素
- (NSString *)serializedXMLElementStringWithElementName:(NSString *)elementName;

+ (NSString *)matchLawsFromCaseDesc:(NSString *)caseDesc;

- (NSString *)autoAddressFromAutoNumber;
@end

@interface NSString (TrimmingAdditions)
//移除字符串变量中的给定前导字符
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
//移除字符串变量中的给定尾随字符
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;

- (HandleStrings *)getSpecifiedWidthString:(UIFont *)font lineWith:(CGFloat)lineWith horizontalAlignment:(UITextAlignment)alignment;
- (HandleStrings *)getSpecifiedWidthString2:(UIFont *)font lineWith:(CGFloat)lineWith horizontalAlignment:(UITextAlignment)alignment;
//获取字符串的宽度
- (CGFloat)getStringWith:(UIFont *)font;
- (NSString * )getSpecifiedWidthSpace:(CGFloat)width font:(UIFont*) font;

@end