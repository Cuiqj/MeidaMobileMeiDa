//
//  TextInputViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-7-12.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintHeader.h"

@protocol TextInputDelegate;

@interface TextInputViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UITextField *textFontSize;

- (IBAction)btnAddText:(id)sender;
- (IBAction)btnCancel:(id)sender;

@property (nonatomic,weak) id<TextInputDelegate> delegate;
@property (nonatomic,assign) CGRect rectPresentFrom;
@property (nonatomic,weak) UIPopoverController *popover;
@end

@protocol TextInputDelegate <NSObject>

-(void)inputString:(NSString *)text fontSize:(CGFloat)fontSize inRect:(CGRect)rect;

@end