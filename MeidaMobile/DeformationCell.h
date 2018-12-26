//
//  DeformationCell.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@interface DeformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetTotalAmountLabel;

@end
