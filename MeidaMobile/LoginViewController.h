//
//  LoginViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-21.
//
//

#import <UIKit/UIKit.h>
#import "UserPickerViewController.h"

@protocol UserSetDelegate;

@interface LoginViewController : UIViewController<UserPickerDelegate,UITextFieldDelegate>
- (IBAction)btnOK:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textInspector1;
@property (weak, nonatomic) IBOutlet UITextField *textInspector2;
@property (weak, nonatomic) IBOutlet UITextField *textInspector3;
@property (weak, nonatomic) IBOutlet UITextField *textInspector4;
@property (weak, nonatomic) id<UserSetDelegate> delegate;
- (IBAction)userSelect:(UITextField *)sender;

@end

@protocol UserSetDelegate <NSObject>

- (void)reloadUserLabel;

@end
