//
//  ListSelectViewController.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-13.
//
//

#import <UIKit/UIKit.h>
#import "ListSelectViewController.h"

@protocol ListSelectPopoverDelegate;

@interface ListSelectViewController : UITableViewController

@property (nonatomic,weak) UIPopoverController *pickerPopover;
@property (nonatomic,weak) id<ListSelectPopoverDelegate> delegate;
@property (nonatomic,strong) NSArray *data;

@end

@protocol ListSelectPopoverDelegate <NSObject>
@optional
//设置检查类型
- (void)setSelectData:(NSString *)data;

// added by xushiwen
- (void)listSelectPopover:(ListSelectViewController *)popoverContent selectedIndexPath:(NSIndexPath *)indexPath;


@end