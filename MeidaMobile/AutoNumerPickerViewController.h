//
//  AutoNumerPickerViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kAutoNumber = 0,
    kNexus,
    kCarOwner
}AutoNumberPickerType;

@protocol AutoNumberPickerDelegate;

@interface AutoNumerPickerViewController : UITableViewController
@property (nonatomic,assign) AutoNumberPickerType pickerType;
@property (nonatomic,copy) NSString *caseID;
@property (nonatomic,weak) UIPopoverController *popOver;
@property (nonatomic,weak) id<AutoNumberPickerDelegate> delegate;
@end

@protocol AutoNumberPickerDelegate <NSObject>

-(void)setAutoNumberText:(NSString *)aAuotNumber;

@end