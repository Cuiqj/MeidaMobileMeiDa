//
//  ServiceListViewController.h
//  GDRMMobile
//
//  Created by luna on 14-1-17.
//
//

#import <UIKit/UIKit.h>

@protocol setServiceDelegate <NSObject>

-(void)setServiceTextDelegate:(NSString *)aText;

@end

@interface ServiceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * _dataSource;
    
}
@property (retain, nonatomic) UITableView * tableView;

@property (nonatomic,weak) id<setServiceDelegate> delegate;

@property (nonatomic,weak) UIPopoverController *pickerPopover;
@end


