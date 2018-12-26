//
//  NSAttributedString+DrawMethod.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-6.
//
//

#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

@interface NSAttributedString (DrawMethod)

- (CFRange)renderInRect:(CGRect)rect
          withTextRange:(CFRange)currentRange;

- (CFRange)rangeInRect:(CGRect)rect
         withTextRange:(CFRange)currentRange;
- (CFRange)rangeInRectWithoutContext:(CGRect)rect
withTextRange:(CFRange)currentRange;
@end
