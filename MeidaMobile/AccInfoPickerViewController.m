//
//  AccInfoPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccInfoPickerViewController.h"
#import <CoreData/CoreData.h>
#import "OrgInfo.h"
@interface AccInfoPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,weak) UITableView *citizenList;
@end

@implementation AccInfoPickerViewController
@synthesize pickerType=_pickerType;
@synthesize data=_data;
@synthesize pickerPopover=_pickerPopover;
@synthesize delegate=_delegate;
@synthesize caseID=_caseID;
@synthesize citizenList=_citizenList;

-(void)viewWillAppear:(BOOL)animated{
    switch (self.pickerType) {
        case 0:
            //事故性质
            self.data=[Systype typeValueForCodeName:@"事故性质"];
            break;
        case 1:
            //事故原因
            self.data=[Systype typeValueForCodeName:@"事故原因"];
            break;
        case 2:
            //事故类型
            self.data=[Systype typeValueForCodeName:@"事故类型"];
            break;
        case 3:
            //停驶车辆
        {            
            self.tableView.allowsMultipleSelection=YES;
            self.citizenList=self.tableView;
            UIView *view=[[UIView alloc] initWithFrame:self.view.frame];
            self.view=view;
            [self.citizenList setFrame:CGRectMake(0.0,44.0,self.view.frame.size.width,self.view.frame.size.height-44)];
            self.data=[Citizen allCitizenNameForCase:self.caseID];
            NSString *parkingCitizens=[self.delegate getParkingCitizens];
            if (![parkingCitizens isEmpty]) {
                NSArray *numberArray=[parkingCitizens componentsSeparatedByString:@"、"];
                for (NSString *number in numberArray) {
                    for (Citizen *citizen in self.data) {
                        if ([citizen.automobile_number isEqualToString:number]) {
                            NSInteger row=[self.data indexOfObject:citizen];
                            [self.citizenList selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                            [[self.citizenList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
                        }
                    }
                }
            }

            UIBarButtonItem *itemConfirm = [[UIBarButtonItem alloc] initWithTitle:@"确定" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:self 
                                                                    action:@selector(btnConfirm:)];
            UIBarButtonItem *itemCancel=[[UIBarButtonItem alloc] initWithTitle:@"取消" 
                                                                         style:UIBarButtonItemStyleBordered 
                                                                        target:self 
                                                                        action:@selector(btnCancel:)];
            UINavigationItem *navItem = [[UINavigationItem alloc] init];
            navItem.rightBarButtonItem = itemConfirm;
            navItem.leftBarButtonItem = itemCancel;
            navItem.title = @"车号";   
            UINavigationBar *naviBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
            naviBar.items=[NSArray arrayWithObject:navItem];
            [self.view addSubview:naviBar];            
            [self.view addSubview:self.citizenList];
        }
            break;
        case 4:
            //停驶地点
            self.data=[Systype typeValueForCodeName:@"停车地点"];
            break;
        case 5:
            //交款地点
            self.data=[Systype typeValueForCodeName:@"交款地点"];
            break;
        case 6:{
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([OrgInfo class]) inManagedObjectContext:context];
            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
            self.data=temp;
            break;
        }
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
    [self setDelegate:nil];
    [self setCaseID:nil];
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (self.pickerType==3) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    if (self.pickerType==3) {
        cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"automobile_number"];
    } else if (self.pickerType == 6) {
         cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgshortname"];
    } else {
         cell.textLabel.text=[_data objectAtIndex:indexPath.row];
    }        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pickerType==3) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [_delegate setCaseText:cell.textLabel.text];
        [_pickerPopover dismissPopoverAnimated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pickerType==3) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
}


-(IBAction)btnConfirm:(id)sender{
    NSArray *indexArray=[self.citizenList indexPathsForSelectedRows];
    NSString *parkingString=@"";
    for (NSIndexPath *indexPath in indexArray) {
        UITableViewCell *cell=[self.citizenList cellForRowAtIndexPath:indexPath];
        if ([parkingString isEmpty]) {
            parkingString=[parkingString stringByAppendingString:cell.textLabel.text];
        } else {
            parkingString=[parkingString stringByAppendingFormat:@"、%@",cell.textLabel.text];
        }
    }
    [self.delegate setCaseText:parkingString];
    [self.pickerPopover dismissPopoverAnimated:YES];
}

-(IBAction)btnCancel:(id)sender{
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
