//
//  CaseCountDetailCell.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-4.
//
//

#import <UIKit/UIKit.h>

@interface CaseCountDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelAssetName;
@property (weak, nonatomic) IBOutlet UILabel *labelAssetSize;
@property (weak, nonatomic) IBOutlet UILabel *labelQunatity;
@property (weak, nonatomic) IBOutlet UILabel *labelAssetUnit;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;

@end
