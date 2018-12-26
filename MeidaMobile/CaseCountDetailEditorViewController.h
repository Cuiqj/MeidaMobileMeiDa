//
//  CaseCountDetailEditorViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-23.
//
//

#import <UIKit/UIKit.h>
#import "CaseDeformation.h"

@protocol CaseCountDetailEditorDelegate;

@interface CaseCountDetailEditorViewController : UIViewController

- (IBAction)btnDismiss:(UIBarButtonItem *)sender;
- (IBAction)btnComfirm:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;
@property (weak, nonatomic) IBOutlet UITextField *textQuantity;
@property (weak, nonatomic) IBOutlet UITextField *textRmark;
@property (weak, nonatomic) id<CaseCountDetailEditorDelegate> delegate;
@property (nonatomic, retain) CaseDeformation *countDetail;
@property (nonatomic, retain) NSString *caseID;
@end


@protocol CaseCountDetailEditorDelegate <NSObject>

- (void)reloadDataArray;
@end