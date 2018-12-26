//
//  InspectionCheckPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <UIKit/UIKit.h>
#import "CheckHandle.h"
#import "CheckReason.h"
#import "CheckStatus.h"
#import "CheckType.h"
#import "Systype.h"

typedef enum {
    kCheckType = 0,
    kCheckReason = 1,
    kCheckStatus = 2,
    kCheckHandle = 3,
    kWeatherPicker = 4,
    kCarCode = 5,
    kWorkShifts = 6,
    kUser = 7,
    kStation,
    kDescription,
    kRoadType,
    kStationCheckStatus
}InspectionCheckState;

@protocol InspectionPickerDelegate;

@interface InspectionCheckPickerViewController : UITableViewController
@property (nonatomic,assign) InspectionCheckState pickerState;
@property (nonatomic,weak) id<InspectionPickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@property (nonatomic,copy) NSString *checkTypeID;
@end

@protocol InspectionPickerDelegate <NSObject>
@optional
//设置检查类型
- (void)setCheckType:(NSString *)typeName typeID:(NSString *)typeID;
//设置原因，处理方法，状态等
- (void)setCheckText:(NSString *)checkText;


@end