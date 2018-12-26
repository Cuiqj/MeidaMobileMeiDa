//
//  PaintBriefViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintBriefViewController.h"
#import "RoadModelBoard.h"

@interface PaintBriefViewController ()
@end

@implementation PaintBriefViewController
@synthesize Image = _Image;
@synthesize caseID = _caseID;

- (void)viewDidLoad
{
    [self.view setBackgroundColor:BGCOLOR];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadCasePaint];
}

- (void)loadCasePaint{
    if (![self.caseID isEmpty]) {
        
        //add by 李晓明 2013.05.09
        //load 之前需要清除旧信息
        self.Image.image=nil;
        
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath=[pathArray objectAtIndex:0];
        NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
        mapPath=[documentPath stringByAppendingPathComponent:mapPath];
        NSString *mapName = @"casemap.jpg";
        NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
            self.Image.image = imageFile;
        }
    }
}

- (void)viewDidUnload
{
	[self setCaseID:nil];
    [self setImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
