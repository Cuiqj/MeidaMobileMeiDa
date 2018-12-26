//
//  RoadClosePickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-17.
//
//

#import "RoadClosePickerViewController.h"
#import "Systype.h"

@interface RoadClosePickerViewController ()
@property (nonatomic, retain) NSArray *data;
@end

@implementation RoadClosePickerViewController
@synthesize data;
@synthesize delegate;
@synthesize pickerPopover;
@synthesize pickerState;

- (void)viewWillAppear:(BOOL)animated{
    switch (self.pickerState) {
        case kCloseRoadSelect:
            self.data=[Systype typeValueForCodeName:@"封闭车道"];
            break;
        case kImportanceSelect:{
            NSMutableArray *temp=[[Systype typeValueForCodeName:@"封闭紧急状态"] mutableCopy];
            if (temp.count<=0) {
                [temp addObject:@"紧急"];
                [temp addObject:@"非"];
            }
            self.data=[NSArray arrayWithArray:temp];
        }
            break;
        case kTypeSelect:
            self.data=[Systype typeValueForCodeName:@"事件类型"];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setPickerPopover:nil];
    [self setData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate setText:[self.data objectAtIndex:indexPath.row]];
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
