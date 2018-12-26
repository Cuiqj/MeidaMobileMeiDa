//
//  InspectionListViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-11-21.
//
//

#import <UIKit/UIKit.h>

@protocol InspectionListDelegate;

@interface InspectionListViewController : UITableViewController
@property (nonatomic, weak) id<InspectionListDelegate> delegate;
@property (nonatomic, weak) UIPopoverController *popover;
@end

@protocol InspectionListDelegate <NSObject>

- (void)setCurrentInspection:(NSString *)inspectionID;

@end