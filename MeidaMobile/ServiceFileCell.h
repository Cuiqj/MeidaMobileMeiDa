//
//  ServiceFileCell.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-21.
//
//

#import <UIKit/UIKit.h>

@interface ServiceFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelFileName;
@property (weak, nonatomic) IBOutlet UILabel *labelFileRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelSendWay;
@property (weak, nonatomic) IBOutlet UILabel *labelSendAddress;

@end
