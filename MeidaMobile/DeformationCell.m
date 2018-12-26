//
//  DeformationCell.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-20.
//
//

#import "DeformationCell.h"

@implementation DeformationCell
@synthesize assetNameLabel;
@synthesize assetPriceLabel;
@synthesize assetQuantityLabel;
@synthesize assetTotalAmountLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
