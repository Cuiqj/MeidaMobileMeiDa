//
//  InspectionRecordCell.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-3.
//
//

#import "InspectionRecordCell.h"

@implementation InspectionRecordCell
@synthesize labelTime;
@synthesize labelRemark;
@synthesize labelStation;

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
