//
//  RoadSegmentPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-19.
//
//

#import "RoadSegmentPickerViewController.h"
#import "Systype.h"

@interface RoadSegmentPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation RoadSegmentPickerViewController
@synthesize data = _data;
@synthesize pickerPopover = _pickerPopover;
@synthesize pickerState = _pickerState;

- (void)viewWillAppear:(BOOL)animated{
    switch (self.pickerState) {
        case kRoadSegment:
            self.data=[RoadSegment allRoadSegments];
            break;
        case kRoadSide:
            self.data=[Systype typeValueForCodeName:@"方向"];
            break;
        case kRoadPlace:
            self.data=[Systype typeValueForCodeName:@"位置"];
            break;
        default:
            break;
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
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
    if (self.pickerState==kRoadSegment) {
        cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"name"];
    } else {
        cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.pickerState) {
        case kRoadSegment:
            [self.delegate setRoadSegment:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"] roadName:[RoadSegment roadNameFromSegment:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"]]];
            break;
        case kRoadPlace:
            [self.delegate setRoadPlace:[self.data objectAtIndex:indexPath.row]];
            break;
        case kRoadSide:
            [self.delegate setRoadSide:[self.data objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
