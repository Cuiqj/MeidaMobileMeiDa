//
//  RoadAssetCell.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoadAssetCell.h"

@implementation RoadAssetCell
@synthesize specLabel=_specLabel;
@synthesize textLabel=__textLabel;
@synthesize detailTextLabel=__detailTextLabel;

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
