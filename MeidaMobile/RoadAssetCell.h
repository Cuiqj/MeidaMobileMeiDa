//
//  RoadAssetCell.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义的路产显示用表格单元，便于路产规格的对齐显示
@interface RoadAssetCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *specLabel;
@property (nonatomic,weak) IBOutlet UILabel *textLabel;
@property (nonatomic,weak) IBOutlet UILabel *detailTextLabel;
@end
