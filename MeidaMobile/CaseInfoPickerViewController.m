//
//  CaseInfoPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseInfoPickerViewController.h"

@interface CaseInfoPickerViewController ()
@property (retain,nonatomic) NSArray *data;
@end

@implementation CaseInfoPickerViewController
@synthesize pickerType=_pickerType;
@synthesize pickerPopover=_pickerPopover;
@synthesize data=_data;
@synthesize delegate=_delegate;

- (void)viewDidLoad
{
    switch (_pickerType) {
        case 0:
            self.data=[Systype typeValueForCodeName:@"天气"];
            break;
        case 1:
            self.data=[Systype typeValueForCodeName:@"车型"];
            break;
        case 2:
            self.data=[Systype typeValueForCodeName:@"损坏程度"];
            break;
        default:
            break;
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[_data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    if (_pickerType==0) {
        [_delegate setWeather:myCell.textLabel.text];
    } else if (_pickerType==1) {
        [_delegate setAuotMobilePattern:myCell.textLabel.text];
    } else if (_pickerType==2) {
        [_delegate setBadDesc:myCell.textLabel.text];
    }   
    [_pickerPopover dismissPopoverAnimated:YES];
}

@end
