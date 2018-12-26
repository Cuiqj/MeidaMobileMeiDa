//
//  PaintBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CasePaintViewController.h"
#import "PaintHeader.h"
@interface PaintBriefViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (nonatomic,retain) NSString *caseID;

- (void)loadCasePaint;
@end
