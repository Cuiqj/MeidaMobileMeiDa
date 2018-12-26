//
//  NSString+MyStringProcess.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "NSString+MyStringProcess.h"
#import "NSAttributedString+DrawMethod.h"

@implementation NSString (MyStringProcess)

//在方框内居中绘制文字，lineBreakMode：WordWarp
- (CGSize)alignWithVerticalCenterDrawInRect:(CGRect)rect withFont:(UIFont *)font horizontalAlignment:(UITextAlignment)alignment{
    CGSize size = [self sizeWithFont:font constrainedToSize:rect.size lineBreakMode:UILineBreakModeWordWrap];
    CGFloat yOffset = (rect.size.height - size.height)/2.0f;
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, rect.size.width, size.height);
    CGSize actualSize = [self drawInRect:newRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    return actualSize;
}

- (void)drawStringFitIntoRect:(CGRect)rect withBasicFont:(UIFont *)font{

    if ([self sizeWithFont:font].width > rect.size.width) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)(font.fontName), font.pointSize, nil);
        [attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, self.length)];
        CFRange textRange = CFRangeMake(0, 0);
        textRange = [attributedString rangeInRect:rect withTextRange:textRange];
        
        CGFloat lastFontSize = font.pointSize;
        UIFont *newFont = nil;
        while (textRange.length < self.length) {
            lastFontSize = lastFontSize - 1.0;
            newFont = [UIFont fontWithName:font.fontName size:lastFontSize];
            CTFontRef newFontRef = CTFontCreateWithName((__bridge CFStringRef)(newFont.fontName), newFont.pointSize, nil);
            [attributedString removeAttribute:(__bridge NSString *)kCTFontAttributeName range:NSMakeRange(0, self.length)];
            [attributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)newFontRef range:NSMakeRange(0, self.length)];
            textRange.length = 0;
            textRange = [attributedString rangeInRect:rect withTextRange:textRange];
        }
        
        newFont = [UIFont fontWithName:font.fontName size:lastFontSize - 2.0f];
        [self drawMultiLineTextInRect:rect withFont:newFont horizontalAlignment:UITextAlignmentLeft leftOffSet:0.0f lineHeight:newFont.lineHeight];
        
    } else {
        [self drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    }
}

//绘制多行文本，lineHeight为整行高度。返回值为剩余的字符。lineBreakMode：WordWarp
- (NSString *)drawMultiLineTextInRect:(CGRect)rect
                             withFont:(UIFont *)font
                  horizontalAlignment:(UITextAlignment)alignment
                           leftOffSet:(CGFloat)leftOffSet
                           lineHeight:(CGFloat)lineHeight{
    NSString *testString = @"测";
    CGFloat fontHeight = [testString sizeWithFont:font].height;
    CGFloat fontWeight = [testString sizeWithFont:font].width;
    NSString *allStr = self;
    NSString *printStr = nil;
    
    if (lineHeight < fontHeight) {
        lineHeight = fontHeight;
    }
    int i = 0;
    do {
        CGFloat w = rect.size.width;
        CGFloat h = lineHeight;
        CGFloat x = rect.origin.x;
        if (i == 0) {
            x += leftOffSet;
            w -= leftOffSet;
        }
        CGFloat y = rect.origin.y + i*lineHeight;
        i++;
        
        if (y+fontHeight > rect.origin.y+rect.size.height) {
            break;
        }
        int maxChars = floor(w/fontWeight);
        
        NSRange nRange = [allStr rangeOfString:@"\n"];
        NSString *canPrintStr = allStr;
        if (nRange.location != NSNotFound) {
            canPrintStr = [allStr substringToIndex:nRange.location+nRange.length];
        }
        
        if ([canPrintStr length] > maxChars) {
            //while ([[canPrintStr substringToIndex:maxChars] sizeWithFont:font].width<w-fontWeight) {
            while (maxChars < [canPrintStr length] &&
                   [[canPrintStr substringToIndex:maxChars] sizeWithFont:font].width<w-fontWeight) {
                maxChars++;
            }
            //若一行的末尾超出显示范围的那个恰好是换行符，则将其算入当前行
            if ( [allStr length] < maxChars && [allStr characterAtIndex:maxChars] == '\n') {
                printStr = [canPrintStr substringToIndex:maxChars+1];
            } else {
                printStr = [canPrintStr substringToIndex:maxChars];
            }  
            allStr = [allStr substringFromIndex:[printStr length]];
        } else {
            printStr = canPrintStr;
            if ([allStr length] > [canPrintStr length]) {
                allStr = [allStr substringFromIndex:[canPrintStr length]];
            }else{
                allStr = @"";
            }
        }
        
        CGRect newRect = CGRectMake(x, y, w, h);
        //NSLog(@"%@", printStr);
        [printStr drawInRect:newRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    } while ([allStr length]>0 && i*lineHeight<rect.size.height);
//    if (lineHeight < fontHeight) {
//        [self drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
//    } else {
//        
//        //字体
//        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize/8,NULL);
//        
//        //设置行高
//        CGFloat lineSpace = lineHeight;
//        CTParagraphStyleSetting lineSpaceStyle;
//        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
//        lineSpaceStyle.value = &lineSpace;
//        lineSpaceStyle.valueSize = sizeof(CGFloat);
//        
//        //设置对齐方式
//        CTTextAlignment coreTextAlignment = kCTTextAlignmentLeft;
//        if (alignment == UITextAlignmentCenter) {
//            coreTextAlignment = kCTTextAlignmentCenter;
//        } else if (alignment == UITextAlignmentRight) {
//            coreTextAlignment = kCTTextAlignmentRight;
//        }
//        CTParagraphStyleSetting alignmentStyle;
//        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
//        alignmentStyle.value = &coreTextAlignment;
//        alignmentStyle.valueSize = sizeof(CTTextAlignment);
//        
//        CTParagraphStyleSetting settings[2] = {lineSpaceStyle, alignmentStyle};
//        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
//		
//		//确定文本属性
//		NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style, (__bridge id)kCTFontAttributeName : (__bridge id)fontRef};
//        //NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style};
//		
//		NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attriDic];
//		
//        //currentRange = [attributeString renderInRect:rect withTextRange:currentRange];
//        
////		if (currentRange.location < attributeString.length) {
////			return [self substringFromIndex:currentRange.location];
////		}
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, rect);
//        
//        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributeString);
//        
//        
//        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributeString length]), path, NULL);
//        CTFrameDraw(frame, ctx);
//        
//        CFRelease(frame);
//        CFRelease(path);
//        CFRelease(framesetter);
//	}
    return @"";
}


// 为字符串分行
// 将字符串本身分行，3个参数分别为第一行字数、第二行字数（后面所有行字数等于第二行）、总行数
- (NSArray *)getLinesWithCharNumerOfLine1:(NSInteger)line1
                                    line2:(NSInteger)line2
                             andLineCount:(NSInteger)line_num;{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:line_num];
    for (int i = 0; i < line_num; i++) {
        [result addObject:@""];
    }
    int index1 = 0;
    int index2 = 0;
    for (int i = 0; i < line_num; i++) {
        // 下标赋值
        if (i == 0) {
            index1 = 0;
            index2 = line1;
        } else {
            index1 = index2;
            index2 = index1 + line2;
        }
        // 下标不能越界
        if (self.length < index2) {
            index2 = self.length;
        }
        // 如果以回车开头，则去掉
        NSString *temp = [self substringWithRange:NSMakeRange(index1, index2 - index1)];
        while ([temp hasPrefix:@"\r"] || [temp hasPrefix:@"\n"]) {
            index1 += 1;
            index2 += 1;
            if (self.length < index2) {
                index2 = self.length;
            }
            temp = [self substringWithRange:NSMakeRange(index1, index2 - index1)];
        }
        // 如果已经是最后一行，则去掉回车全部输出
        if (i == line_num - 1) {
            NSString *subString = [self substringFromIndex:index1];
            subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            [result replaceObjectAtIndex:i withObject:subString];
            return [NSArray arrayWithArray:result];
        }
        //
        NSInteger enter = [temp rangeOfString:@"\n"].location;
        if (enter != NSNotFound) {
            index2 = index1 + enter + 1;
        }
        NSString *subString = [self substringWithRange:NSMakeRange(index1, index2 - index1)];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [result replaceObjectAtIndex:i withObject:subString];
        if (index2 == self.length) {
            break;
        }
    }
    return [NSArray arrayWithArray:result];
}

//将文本分页，可定义第一页和后续页大小，及整体行高
- (NSArray *)pagesWithFont:(UIFont *)font
                lineHeight:(CGFloat)lineHeight
       horizontalAlignment:(UITextAlignment)alignment
                 page1Rect:(CGRect)page1Rect
            followPageRect:(CGRect)followPageRect{
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *test1 = @"测试";
	CGFloat fontHeight = [test1 sizeWithFont:font].height;
    if (lineHeight < fontHeight) {
        [pages addObject:self];
    } else {
        CGFloat lineSpace = lineHeight - fontHeight;
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL);
        
        //设置行高
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.value = &lineSpace;
        lineSpaceStyle.valueSize = sizeof(CGFloat);
        
        //设置对齐方式
        CTTextAlignment coreTextAlignment = kCTTextAlignmentLeft;
        if (alignment == NSTextAlignmentCenter) {
            coreTextAlignment = kCTTextAlignmentCenter;
        } else if (alignment == NSTextAlignmentRight) {
            coreTextAlignment = kCTTextAlignmentRight;
        }
        CTParagraphStyleSetting alignmentStyle;
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        alignmentStyle.value = &coreTextAlignment;
        alignmentStyle.valueSize = sizeof(CTTextAlignment);
        
        CTParagraphStyleSetting settings[2] = {lineSpaceStyle, alignmentStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
        
        NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style, (__bridge id)kCTFontAttributeName : (__bridge id)fontRef };
        
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attriDic];
        CFRange currentRange = CFRangeMake(0, 0);
        BOOL done = NO;
        do {
            //如果是第一页
            if (currentRange.location == 0) {
                currentRange = [attributeString rangeInRect:page1Rect withTextRange:currentRange];
            } else {
                currentRange = [attributeString rangeInRect:followPageRect withTextRange:currentRange];
            }
            [pages addObject:[self substringWithRange:NSMakeRange(currentRange.location, currentRange.length)]];
            
            currentRange.location += currentRange.length;
            currentRange.length = 0;
            if (currentRange.location == attributeString.length)
                done = YES;
        } while (!done);
    }
    return pages;
}


//将数字日期转换成为中文汉字日期，仅转换单独数字。如果是2013-01-01等类型的日期，需分隔开之后再单独转换处理，参数决定是否按年份转换
- (NSString *)numberDateToChineseAndIsYearDate:(BOOL)isYearDate{
	NSString *result = @"";
	NSArray *strChinese = @[@"〇", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
	if (isYearDate) {
		NSString *numberStringFromSelf = [[NSString alloc] initWithFormat:@"%d",self.integerValue];
		for (int i = 0; i < numberStringFromSelf.length; i++) {
			NSString *sub = [numberStringFromSelf substringWithRange:NSMakeRange(i, 1)];
			result = [result stringByAppendingString:[strChinese objectAtIndex:sub.integerValue]];
		}
	} else {
		NSInteger dateNumber = self.integerValue%100;
		NSInteger date1 = dateNumber/10;
		NSInteger date2 = dateNumber%10;
		if (date1 > 1) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:date1]];
		}
		if (date1 > 0) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:10]];
		}
		if (date2 != 0) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:date2]];
		}
	}
	return result;
}

//根据车号获取车辆车辆所在地信息
/*
- (NSString *)autoAddressFromAutoNumber{
    NSString * provinceShortName=[self substringToIndex:1];
    NSString * cityCode=[self substringWithRange:NSMakeRange(1, 1)];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *provinceEntity=[NSEntityDescription entityForName:@"Provinces" inManagedObjectContext:context];
    NSEntityDescription *cityEntity=[NSEntityDescription entityForName:@"CityCode" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"short_name == %@",provinceShortName];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:provinceEntity];
    [fetchRequest setPredicate:predicate];
    NSArray *provinceFetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (provinceFetchResult.count>0) {
        id province=[provinceFetchResult objectAtIndex:0];
        NSString *provinceLongName=[province valueForKey:@"long_name"];
        predicate=[NSPredicate predicateWithFormat:@"(myid == %@) && (city_code == %@)",[province valueForKey:@"myid"],cityCode];
        [fetchRequest setEntity:cityEntity];
        [fetchRequest setPredicate:predicate];
        NSArray *cityFetchResult=[context executeFetchRequest:fetchRequest error:nil];
        if (cityFetchResult.count>0) {
            id city=[cityFetchResult objectAtIndex:0];
            NSString *cityName=[city valueForKey:@"city_name"];
            provinceLongName=[provinceLongName stringByAppendingString:cityName];
        }
        return provinceLongName;       
    } else {
        return @"";
    }
}
 */
//根据车号获取车辆车辆所在地信息
- (NSString *)autoAddressFromAutoNumber{
    NSString * provinceShortName=[self substringToIndex:1];
    NSString * cityCode=[self substringWithRange:NSMakeRange(1, 1)];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *provinceEntity=[NSEntityDescription entityForName:@"Provinces" inManagedObjectContext:context];
    NSEntityDescription *cityEntity=[NSEntityDescription entityForName:@"CityCode" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"short_name == %@",provinceShortName];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:provinceEntity];
    [fetchRequest setPredicate:predicate];
    NSArray *provinceFetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (provinceFetchResult.count>0) {
        id province=[provinceFetchResult objectAtIndex:0];
        NSString *provinceLongName=[province valueForKey:@"long_name"];
        //FIXME lxm 2013.04.27 city_code没有myid，只有province_id
        predicate=[NSPredicate predicateWithFormat:@"(province_id == %@) && (city_code == %@)",[province valueForKey:@"myid"],cityCode];
        [fetchRequest setEntity:provinceEntity];
        [fetchRequest setEntity:cityEntity];
        [fetchRequest setPredicate:predicate];
        NSArray *cityFetchResult=[context executeFetchRequest:fetchRequest error:nil];
        if (cityFetchResult.count>0) {
            id city=[cityFetchResult objectAtIndex:0];
            NSString *cityName=[city valueForKey:@"city_name"];
            provinceLongName=[provinceLongName stringByAppendingString:cityName];
        }
        return provinceLongName;
    } else {
        return @"";
    }
}

// 前后去掉空格和换行符
- (NSString *)simpleString{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 如果为空默认返回'无'
- (NSString *)defaultEmpty{
    return [self isEmpty]?@"无":self;
}

//检查字符串是否为空
- (BOOL)isEmpty{
    if([self length] == 0) { 
        //string is empty or nil
        return YES;
    } else if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}


//生成随机ID
+ (NSString *)randomID{
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:@"yyMMddHHmmssSSS"];
    NSString *IDString=[dateFormatter stringFromDate:[NSDate date]];
    return IDString;
}

- (NSString *)encryptedString{
    static char cvt[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "0123456789@#$";
    
	static char fillchar = '*';
    
    NSString *temp = [self lowercaseString];
    NSData *tempData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 *data = (UInt8 *)[tempData bytes];
    int c;
    int len = [tempData length];
    NSMutableString *ret = [NSMutableString stringWithCapacity:((len / 3) + 1) * 4];
    for (int i = 0; i < len; i++) {
        c = (data[i] >> 2) & 0x3f;
        [ret appendFormat:@"%c",cvt[c]];
        c = (data[i]  < 4) & 0x3f;
        i ++;
        if (i < len) {
            c |= (data[i] >> 4) & 0x0f;
        }
        [ret appendFormat:@"%c",cvt[c]];
        if (i < len) {
            c = (data[i] << 2) & 0x3f;
            i ++;
            if (i < len) {
                c |= (data[i] >> 6) & 0x03;
            }
            [ret appendFormat:@"%c",cvt[c]];
        } else {
            i ++;
            [ret appendFormat:@"%c",fillchar];
            
        }
        if (i < len) {
            c = data[i] & 0x3f;
            [ret appendFormat:@"%c",cvt[c]];
        } else {
            [ret appendFormat:@"%c",fillchar];
        }
    }
    return ret;
}


- (NSString *)serializedXMLElementStringWithElementName:(NSString *)elementName{
    NSString *serializedXML;
    if ([self isEmpty]) {
        serializedXML = [[NSString alloc] initWithFormat:@"<%@ xsi:nil=\"true\" />",elementName];
    } else {
        serializedXML = [[NSString alloc] initWithFormat:@"<%@>%@</%@>",elementName,self,elementName];
    }
    return serializedXML;
}

+ (NSString *)matchLawsFromCaseDesc:(NSString *)caseDesc{
    return @"";
}
@end


@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];    
    [self getCharacters:charBuffer];    
    for (location=0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length=[self length];
    unichar charBuffer[length];    
    [self getCharacters:charBuffer];    
    for (length=[self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}
//返回
//返回处理之后的字符串
//返回指定长度的字符串
- (HandleStrings *)getSpecifiedWidthString:(UIFont *)font lineWith:(CGFloat)lineWith horizontalAlignment:(UITextAlignment)alignment{
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL);

    float lineSpace = 100;
    //设置行高
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.value = &lineSpace;
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    
    //设置对齐方式
    CTTextAlignment coreTextAlignment = kCTTextAlignmentLeft;
    if (alignment == NSTextAlignmentCenter) {
        coreTextAlignment = kCTTextAlignmentCenter;
    } else if (alignment == NSTextAlignmentRight) {
        coreTextAlignment = kCTTextAlignmentRight;
    }
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.value = &coreTextAlignment;
    alignmentStyle.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting settings[2] = {lineSpaceStyle, alignmentStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
    
    NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style, (__bridge id)kCTFontAttributeName : (__bridge id)fontRef };
    
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attriDic];
    CFRange currentRange = CFRangeMake(0, 0);
    CGRect pageRect = CGRectMake(0.0, 0.0, lineWith, 1000);
    currentRange = [attributeString rangeInRectWithoutContext:pageRect withTextRange:currentRange];
    HandleStrings *handleStrings = [[HandleStrings alloc]init];
    handleStrings.returnString = [self substringWithRange:NSMakeRange(currentRange.location, currentRange.length)];
    handleStrings.handleString = [self substringFromIndex:(currentRange.location + currentRange.length)];
    return handleStrings;
    
}
- (HandleStrings *)getSpecifiedWidthString2:(UIFont *)font lineWith:(CGFloat)lineWith horizontalAlignment:(UITextAlignment)alignment{
    float hanziLength = [@"汉" getStringWith:font];
    int i = 0;
    float length = 0;
    NSRange range;
    NSString *temp = @"";
    while (length < lineWith && i < self.length) {
        range = NSMakeRange(i, 1);
        temp = [self substringWithRange:range];
        int a = [temp characterAtIndex:0];;
        if( (a >= 0x4e00 && a < 0x9fff) || [temp isEqual:@"。"] || [temp isEqual:@"、"] || [temp isEqual:@"，"] || [temp isEqual:@"："] || [temp isEqual:@"×"] || [temp isEqual:@"）"] || [temp isEqual:@"（"]){
            length += hanziLength;
        } else {
            length += hanziLength * 1/2;
        }
        i++;
    }
    if (length > lineWith) {
        i--;
    }

    HandleStrings *handleStrings = [[HandleStrings alloc]init];
    handleStrings.returnString = [self substringToIndex:i];
    if (self.length >= i+1) {
        handleStrings.handleString = [self substringFromIndex:i];
    } else {
        handleStrings.handleString = @"";
    }
    return handleStrings;
    
}

- (CGFloat)getStringWith:(UIFont *)font{
    return [self sizeWithFont:font].width;
}
- (NSString * )getSpecifiedWidthSpace:(CGFloat)width font:(UIFont*) font{
    NSString * temp = @" ";
    while ([temp getStringWith:font] < width) {
        temp = [temp stringByAppendingString:@" "];
    }
    return temp;
}
@end

