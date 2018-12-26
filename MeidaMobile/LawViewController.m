//
//  LawViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LawViewController.h"

@implementation LawViewController

@synthesize tvAttechment;
@synthesize docview;
@synthesize tvMainList;
int current_sel;

-(void)viewDidLoad{
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"shenqing-bg1" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    
    [self.tvAttechment selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tvMainList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    current_sel = 0;
    NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"中华人民共和国公路法.pdf" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:mainBundleDirectory];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.docview.scalesPageToFit = YES;
    
    [self.docview loadRequest:request];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTvAttechment:nil];
    [self setDocview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 1001:
            return 3;
            break;
        case 1002:
            switch (current_sel) {
                case 0:
                    return 2;
                    break;
                case 1:
                    return 2;
                    break;
                case 2:
                    return 4  ;
                    break;
                default:
                    break;
            }
        default:
            return -1;
            break;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *result;
    switch (tableView.tag) {
        case 1001:
            switch (indexPath.row) {
                case 0:
                    result=@"国家法律法规";
                    break;
                case 1:
                    result=@"交通部法规";
                    break;
                case 2:
                    result=@"广东省规定";
                    break;
                default:
                    break;
            }
            break;
        case 1002: 
            switch (current_sel) {
                case 0:
                    //国家法律
                    switch (indexPath.row) {
                        case 0:
                            result=@"中华人民共和国公路法";
                            break;
                        case 1:
                            result=@"中华人民共和国道路交通安全法";
                            break;
                            
                        default:
                            break;
                    }
                    break;
                case 1:
                    //部委法规
                    switch (indexPath.row) {
                        case 0:
                            result=@"公路安全保护条例";
                            break;
                        case 1:
                            result=@"路政管理规定";
                            break;
                            
                        default:
                            
                            break;
                    }
                    break;
                case 2:
                    //广东法规
                    switch (indexPath.row) {
                        case 0:
                            result=@"广东省公路条例";
                            break;
                        case 1:
                            result=@"广东省路政档案管理办法";
                            break;
                        case 2:
                            result=@"广东省路政许可实施办法";
                            break;
                        case 3:
                            result=@"损坏公路路产赔补偿标准";
                        default:
                            break;
                    }
                    break;
                    
                default:
                    break;
            }
            
        default:
            break;
    }
    cell.textLabel.text=result;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择列表项
    switch (tableView.tag) {
        case 1001:
            current_sel=indexPath.row;
            [tvAttechment reloadData];
            break;
        case 1002:{
            if (indexPath) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                NSString *result = [NSString stringWithFormat:@"%@.pdf",cell.textLabel.text];
                NSString
                *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:result ofType:nil];
                NSURL *url = [NSURL fileURLWithPath:mainBundleDirectory];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                self.docview.scalesPageToFit = YES;
                
                [self.docview loadRequest:request];
            }
        }
            break;
        default:
            break;
    }
    
}


@end
