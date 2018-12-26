//
//  NSNumber+NumberConvert.m
//  Test2
//
//  Created by yu hongwu on 12-7-27.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "NSNumber+NumberConvert.h"

@implementation NSNumber (NumberConvert)
-(NSString *)numberConvertToChineseCapitalNumberString{
    NSString *chineseCapitalNumberString;
    static NSString *c1=@"仟佰拾万仟佰拾亿仟佰拾万仟佰拾元";
    static NSString *c2=@"角分";
    static NSString *c3=@"玖捌柒陆伍肆叁贰壹";
    NSString *numString=[NSString stringWithFormat:@"%.2f",self.doubleValue];
    if (numString.floatValue==0) {
        chineseCapitalNumberString=@"零元整";
    } else {
        NSString *integerPart=[numString substringToIndex:(numString.length-3)];
        NSString *decimalPart=[numString substringFromIndex:(integerPart.length+1)];
        chineseCapitalNumberString=@"";
        if (decimalPart.integerValue !=0) {
            for (int i=decimalPart.length-1; i>=0; i--) {
                NSRange range=NSMakeRange(i, 1);
                NSString *charNum=[decimalPart substringWithRange:range];
                if (charNum.integerValue!=0) {
                    chineseCapitalNumberString=[[c2 substringWithRange:range] stringByAppendingString:chineseCapitalNumberString];
                    chineseCapitalNumberString=[[c3 substringWithRange:NSMakeRange(c3.length-charNum.integerValue, 1)] stringByAppendingString:chineseCapitalNumberString];
                } else {
                    if (i==0 && integerPart.integerValue!=0) {
                        chineseCapitalNumberString=[NSString stringWithFormat:@"零%@",chineseCapitalNumberString];
                    }
                }
            }
        }
        if (integerPart.integerValue !=0) {
            chineseCapitalNumberString=[NSString stringWithFormat:@"元%@",chineseCapitalNumberString];
            NSInteger k=0; 
            for (int i=integerPart.length-1; i>=0; i--) {
                if ((integerPart.length-i)==5) {
                    chineseCapitalNumberString=[NSString stringWithFormat:@"万%@",chineseCapitalNumberString];
                } else if ((integerPart.length-i)==9) {
                    chineseCapitalNumberString=[NSString stringWithFormat:@"亿%@",chineseCapitalNumberString];
                } else if ((integerPart.length-i)==13) {
                    chineseCapitalNumberString=[NSString stringWithFormat:@"万%@",chineseCapitalNumberString];
                }
                NSRange range=NSMakeRange(i, 1);
                NSString *charNum=[integerPart substringWithRange:range];                
                if (charNum.integerValue!=0) {                    
                    if (i==integerPart.length-1) {
                        chineseCapitalNumberString=[[c3 substringWithRange:NSMakeRange(c3.length-charNum.integerValue, 1)] stringByAppendingString:chineseCapitalNumberString];
                    } else {
                        if ((integerPart.length-i)!=5 && (integerPart.length-i)!=9 && (integerPart.length-i)!=13) {
                            chineseCapitalNumberString=[[c1 substringWithRange:NSMakeRange(c1.length-k-1, 1)] stringByAppendingString:chineseCapitalNumberString];
                        }
                        chineseCapitalNumberString=[[c3 substringWithRange:NSMakeRange(c3.length-charNum.integerValue, 1)] stringByAppendingString:chineseCapitalNumberString];
                    }
                } else {
                    NSString *bitString=[chineseCapitalNumberString substringWithRange:NSMakeRange(0, 1)];
                    if ((![bitString isEqualToString:@"元"]) && (![bitString isEqualToString:@"万"])
                        && (![bitString isEqualToString:@"亿"])) {
                        if (![bitString isEqualToString:@"零"]) {
                            chineseCapitalNumberString=[NSString stringWithFormat:@"零%@",chineseCapitalNumberString];
                        }                 
                    }
                }
                k=k+1;
            }
        }    
        chineseCapitalNumberString=[chineseCapitalNumberString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *lastChar=[chineseCapitalNumberString substringWithRange:NSMakeRange(chineseCapitalNumberString.length-1, 1)];
        if ((![lastChar isEqualToString:@"分"]) && (![lastChar isEqualToString:@"角"])) {
            chineseCapitalNumberString=[chineseCapitalNumberString stringByAppendingString:@"整"];
        }
    }
    return chineseCapitalNumberString;    
}
@end
