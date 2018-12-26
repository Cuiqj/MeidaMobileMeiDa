//
//  ServiceFileSelectViewController.h
//  GDRMMobile
//
//  Created by XU SHIWEN on 13-7-17.
//
//

#import <UIKit/UIKit.h>
#import "CaseServiceFiles.h"

@protocol ServiceFileSelectViewControllerDelegate;

@interface ServiceFileSelectViewController : UITableViewController

@property (nonatomic, weak) id<ServiceFileSelectViewControllerDelegate> delegate;
@property (nonatomic, weak) UIPopoverController *outerPopover;

@end

@protocol ServiceFileSelectViewControllerDelegate<NSObject>

- (void)serviceFileNameSelected:(NSString *)serviceFileName;

@end