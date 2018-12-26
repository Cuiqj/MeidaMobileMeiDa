//
//  NSAttributedString+DrawMethod.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-6.
//
//


#import "NSAttributedString+DrawMethod.h"

@implementation NSAttributedString (DrawMethod)
- (CFRange)renderInRect:(CGRect)rect
          withTextRange:(CFRange)currentRange{
    // Get the graphics context.
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(currentContext);
	
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    
    // Put the text matrix into a known state. This ensures
    
    // that no old scaling factors are left in place.
    
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text. Use 72 point
    
    // margins all around the text.
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    
    CGPathAddRect(framePath, NULL, rect);
    
    // Get the frame that will do the rendering.
    
    // The currentRange variable specifies only the starting point. The framesetter
    
    // lays out as much text as will fit into the frame.
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    
    CGPathRelease(framePath);
    
    
    
    // Core Text draws from the bottom-left corner up, so flip
    
    // the current transform prior to drawing.
    
    CGContextTranslateCTM(currentContext, 0, rect.size.height);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    
    
    // Draw the frame.
    
    CTFrameDraw(frameRef, currentContext);
    
    
    
    // Update the current range based on what was drawn.
    
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    
    currentRange.location += currentRange.length;
    
    currentRange.length = 0;
    
    CFRelease(frameRef);
	CFRelease(framesetter);
	
	CGContextRestoreGState(currentContext);
    
    return currentRange;
}

- (CFRange)rangeInRect:(CGRect)rect
         withTextRange:(CFRange)currentRange{
    // Get the graphics context.
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(currentContext);
	
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    
    CGPathAddRect(framePath, NULL, rect);
    
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    
    CGPathRelease(framePath);
    
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    
    CFRelease(frameRef);
	CFRelease(framesetter);
	
	CGContextRestoreGState(currentContext);
    
    return currentRange;
}
- (CFRange)rangeInRectWithoutContext:(CGRect)rect
         withTextRange:(CFRange)currentRange{
    // Get the graphics context.
    UIGraphicsBeginImageContext(CGSizeMake(20000, 20000));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextSaveGState(currentContext);
	
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    
    CGPathAddRect(framePath, NULL, rect);
    
    
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    
    CGPathRelease(framePath);
    
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    
    CFRelease(frameRef);
	CFRelease(framesetter);
	
	CGContextRestoreGState(currentContext);
    UIGraphicsEndImageContext();
    return currentRange;
}
@end
