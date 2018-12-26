//
//  ServerSettingController.h
//  GDYZMobile
//
//  Created by maijunjin on 14-11-3.
//
//

#import <UIKit/UIKit.h>

@interface ServerSettingController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtServer;
@property (weak, nonatomic) IBOutlet UITextField *txtFile;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnDismiss:(UIBarButtonItem *)sender;
@end
