//
//  XMLPDFRenderer.h
//
//  Created by XU SHIWEN on 13-8-23.
//  Copyright (c) 2013年 XU SHIWEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#ifdef DEBUG
#define DebugLog(...) {}
#else
#define DebugLog(...) {}
#endif

typedef enum _ADTextVAlignment {
    ADTextVAlignmentTop = 0x20,
    ADTextVAlignmentMiddle,
    ADTextVAlignmentBottom
} ADTextVAlignment;

typedef enum _ADTextBasePoint {
    ADTextBasePointTopLeft = 0x30,
    ADTextBasePointMidLeft,
    ADTextBasePointBottomLeft
} ADTextBasePoint;

typedef enum _ADLineStyle {
    ADLineStyleSolid = 0x40,
    ADLineStyleDash,
    ADLineStyleDash2
} ADLineStyle;

#define AD_ENUM_NULL -1

typedef UITextAlignment ADTextHAlignment;

/*---------------------------------------------------------------*/

@class ADPDFPage;

@interface XMLPDFRenderer : NSObject
@property (nonatomic, strong) ADPDFPage *pdfInfo;
@property (nonatomic, strong) ADPDFPage *pdfInfo2;
- (void)renderFromXML:(NSString *)xmlString toPDF:(NSString *)path;
- (void)renderFromXML:(NSString *)xmlString toPDF:(NSString *)path dataOnly:(BOOL)isDataOnly;
- (void)renderFromXML:(NSString *)xmlString XML2:(NSString *)xmlString2 toPDF:(NSString *)path dataOnly:(BOOL)isDataOnly;
@end


/*---------------------------------------------------------------*/

#pragma mark - ADPDFPage

@interface ADPDFPage : NSObject
@property (nonatomic) CGRect mediaBox;
@property (nonatomic) CGFloat defaultFontSize;
@property (nonatomic, strong) NSString * defaultFontName;
@property (nonatomic) CGFloat ratioPtsByMm;
@property (nonatomic) CGSize globalOffset;
@end

/*---------------------------------------------------------------*/

@interface NSString (XMLPDFDrawing)

- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font basePoint:(ADTextBasePoint)basePoint;
- (CGSize)drawAtPoint:(CGPoint)point withFont:(UIFont *)font basePoint:(ADTextBasePoint)basePoint maxWidth:(CGFloat)maxWidth;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode hAlignment:(ADTextHAlignment)hAlignment vAlignment:(ADTextVAlignment)vAlignment;
- (CGSize)drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode hAlignment:(ADTextHAlignment)hAlignment vAlignment:(ADTextVAlignment)vAlignment maxWidth:(CGFloat)maxWidth;
@end