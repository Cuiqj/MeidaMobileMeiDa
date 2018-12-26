//
//  RoadClosePickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-17.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    kCloseRoadSelect = 0,
    kImportanceSelect,
    kTypeSelect
} RoadClosePickerState;

@protocol RoadPickerDelegate;

@interface RoadClosePickerViewController : UITableViewController
@property (nonatomic, weak) id<RoadPickerDelegate> delegate;
@property (nonatomic, weak) UIPopoverController *pickerPopover;
@property (nonatomic, assign) RoadClosePickerState pickerState;
@end

@protocol RoadPickerDelegate <NSObject>

- (void)setText:(NSString *)aText;

@end