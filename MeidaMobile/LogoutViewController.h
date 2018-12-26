//
//  LogoutViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-26.
//
//

#import <UIKit/UIKit.h>

@protocol LogOutDelegate;

@interface LogoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *uibuttonLogout;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonDeliver;
- (IBAction)btnDeliver:(UIButton *)sender;
- (IBAction)btnLogout:(UIButton *)sender;
@property (weak, nonatomic) id<LogOutDelegate> delegate;
@end

@protocol LogOutDelegate <NSObject>

- (void)logOut;
- (void)inspectionDeliver;

@end