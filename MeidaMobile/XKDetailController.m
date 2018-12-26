
//
//  XKDetailController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XKDetailController.h"
#import "XKBaseInfoController.h"

@implementation XKDetailController
@synthesize appno=_appno;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);

}

-(void)setaAppno:(NSString *)appno{
    _appno=appno;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"baseinfo"]){
        XKBaseInfoController *baseinfo=segue.destinationViewController;
        [baseinfo showInfo:_appno];
    }
}
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    if (viewControllerToPresent.class){
//        XKBaseInfoController *baseinfo=segue.destinationViewController;
//        [baseinfo showInfo:_appno];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if ([item.title isEqualToString: @"申请基本信息"]){
        
        XKBaseInfoController *baseinfo=[[XKBaseInfoController alloc]initWithNibName:@"XKBaseInfoController" bundle:nil];
        [baseinfo showInfo:_appno];
        [self.view addSubview:baseinfo.view] ;
        
        //[self.presentingViewController baseinfo];
    }
}
@end
