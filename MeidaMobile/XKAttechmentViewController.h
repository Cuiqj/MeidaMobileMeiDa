//
//  XKAttechmentViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKAttechmentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *attechmentView;
-(void)showInfo:(NSString *)filename;
@property (nonatomic,strong)NSString *filename;

@end
