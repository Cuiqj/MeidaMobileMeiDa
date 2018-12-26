//
//  SystemTypeListViewController.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-10.
//
//

#import <UIKit/UIKit.h>

@protocol SystemTypePopoverDelegate <NSObject>
@optional
//设置检查类型
- (void)setSelectData:(NSString *)data;

@end

@interface SystemTypeListViewController : UITableViewController
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@property (nonatomic,weak) id<SystemTypePopoverDelegate> delegate;
@property (nonatomic,strong) NSString *code_name;

@end
