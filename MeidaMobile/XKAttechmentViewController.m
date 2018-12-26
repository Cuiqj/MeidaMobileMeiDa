//
//  XKAttechmentViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XKAttechmentViewController.h"


@implementation XKAttechmentViewController
@synthesize attechmentView;
@synthesize filename=_filename;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSString *fileAddress=[[AppDelegate App]fileAddress];
    NSString *fullfilename=[NSString stringWithFormat:@"%@%@",fileAddress,_filename] ;
    NSURL * url=[NSURL URLWithString:fullfilename];
    NSURLRequest * request=[NSURLRequest requestWithURL:url];
    [attechmentView loadRequest:request]; 
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setAttechmentView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
-(void)showInfo:(NSString *)filename{
    _filename=filename;
}


@end
