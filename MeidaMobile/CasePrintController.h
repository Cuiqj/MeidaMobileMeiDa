//
//  CasePrintController.h
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-8-29.
//
//

#import <Foundation/Foundation.h>
#import "GRMustache.h"
#import "XMLPDFRenderer.h"

NSString * const DocNameKeyPei_PeiBuChangQingDan;
NSString * const DocNameKeyPei_AnJianKanYanJianChaBiLu;
NSString * const DocNameKeyPei_AnJianXunWenBiLu;
NSString * const DocNameKeyPei_AnJianXunWenBiLuExtra;
NSString * const DocNameKeyPei_AnJianGuanLiWenShuSongDaHuiZheng;
NSString * const DocNameKeyPei_PeiBuChangTongZhiShu;
NSString * const DocNameKeyPei_TSPeiBuChangTongZhiShu;
NSString * const DocNameKeyPei_LuZhengAnJianXianChangKanYanTu;
NSString * const DocNameKeyPei_ZeLingCheLiangTingShiTongZhiShu;
NSString * const DocNameKeyFa_ZeLingGaizhengTongZhiShu;
NSString * const DocNameKeyFa_SheXianWeiFaXingWeiGaoZhiShu;
NSString * const DocNameKeyFa_KanYanJianChaBiLu;
NSString * const DocNameKeyPei_JieChu_ZeLingCheLiangTingShiTongZhiShu;

NSString * const NSDateFormatStringCustom1;



@protocol CasePrintProtocol;

@interface CasePrintController : NSObject

@property (nonatomic, strong) GRMustacheTemplateRepository *templateRepo;
@property (nonatomic, strong) NSDictionary *templateNameDictionary;
@property (nonatomic, weak) id<CasePrintProtocol> delegate;
@property (nonatomic, strong) XMLPDFRenderer *pdfRenderer;

- (BOOL)saveAsPDF:(NSString *)path dataOnly:(BOOL)isDataOnly;
- (NSRange)rangeOfString:(NSString *)str drawInRect:(CGRect)rect withFont:(UIFont *)font headIndent:(CGFloat)indent andLineHeight:(CGFloat)lineHeight;

@end


@protocol CasePrintProtocol <NSObject>
@optional
- (id)dataForPDFTemplate;
- (id)dateForExtraPDFTemplate;
- (NSString *)templateNameKey;
- (NSString *)extraTemplateNameKey;
@end



static inline NSString *NSStringFromNSDateAndFormatter(NSDate *date, NSString *formatterString) {
    if (date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatterString];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        return [dateFormatter stringFromDate:date];
    }
    return @"";
}

static inline id DateDataFromDateString(NSString *dateString) {
    if (dateString) {
        NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"年月日时分"];
        NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:delimiterSet];
        if (dateComponents.count >= 5) {
            return @{
                     @"year":dateComponents[0],
                     @"month":dateComponents[1],
                     @"day":dateComponents[2],
                     @"hour":dateComponents[3],
                     @"minute":dateComponents[4],
                     };
        }
    }
    return nil;
}

static inline NSString * NSStringNilIsBad(NSString *str) {
    return (str == nil ? @"" : str);
}