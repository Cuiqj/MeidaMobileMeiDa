//
//  AutoNumerPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AutoNumerPickerViewController.h"
#import "Systype.h"
#import "Citizen.h"

@interface AutoNumerPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation AutoNumerPickerViewController
@synthesize data=_data;
@synthesize delegate=_delegate;
@synthesize caseID=_caseID;
@synthesize popOver=_popOver;
@synthesize pickerType=_pickerType;

-(void)viewWillAppear:(BOOL)animated{
    switch (self.pickerType) {
        case kAutoNumber:
        {
            self.data=[Citizen allCitizenNameForCase:self.caseID];
        }
            break;
        case kNexus:
            self.data=[NSArray arrayWithObjects:@"当事人", @"当事人代表",@"被邀请人",@"旁证人",nil];
            break;
        case kCarOwner:
            self.data=[NSArray arrayWithObjects:@"",@"当事人", nil];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setPopOver:nil];
    [self setCaseID:nil];
    [self setData:nil];
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
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.pickerType==kAutoNumber) {
        cell.textLabel.text=[[_data objectAtIndex:indexPath.row] valueForKey:@"automobile_number"];
    } else {
        cell.textLabel.text=[_data objectAtIndex:indexPath.row];
    }        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [_delegate setAutoNumberText:cell.textLabel.text];
    [_popOver dismissPopoverAnimated:YES];
}

@end
