//
//  RoadSegmentPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-19.
//
//

#import <UIKit/UIKit.h>
#import "RoadSegment.h"

typedef enum {
    kRoadSegment = 0,
    kRoadSide,
    kRoadPlace
} RoadSegmentPickerState;

@protocol RoadSegmentPickerDelegate;

@interface RoadSegmentPickerViewController : UITableViewController
@property (assign, nonatomic) RoadSegmentPickerState pickerState;
@property (weak, nonatomic) UIPopoverController *pickerPopover;
@property (weak, nonatomic) id<RoadSegmentPickerDelegate> delegate;

@end

@protocol RoadSegmentPickerDelegate <NSObject>
@optional
- (void)setRoadSegment:(NSString *)aRoadSegmentID roadName:(NSString *)roadName;
- (void)setRoadPlace:(NSString *)place;
- (void)setRoadSide:(NSString *)side;

@end