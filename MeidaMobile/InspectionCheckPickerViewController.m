//
//  InspectionCheckPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "InspectionCheckPickerViewController.h"
#import "UserInfo.h"

@interface InspectionCheckPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation InspectionCheckPickerViewController



- (void)viewDidLoad
{
    switch (self.pickerState) {
        case kCheckHandle:
            self.data=[[CheckHandle handleForCheckType:self.checkTypeID] valueForKey:@"handle_name"];
            break;
        case kCheckReason:
            self.data=[[CheckReason reasonForCheckType:self.checkTypeID] valueForKey:@"reasonname"];
            break;
        case kCheckStatus:
            self.data=[[CheckStatus statusForCheckType:self.checkTypeID] valueForKey:@"statusname"];
            break;
        case kCheckType:
            self.data=[CheckType allCheckType];
            break;
        case kWeatherPicker:
            self.data=[Systype typeValueForCodeName:@"天气"];
            break;
        case kWorkShifts:{
            NSMutableArray *temp=[[Systype typeValueForCodeName:@"巡查班次"] mutableCopy];
            if (temp.count < 1) {
                [temp addObject:@"早班"];
                [temp addObject:@"中班"];
                [temp addObject:@"晚班"];
            }
            self.data=[temp valueForKeyPath:@"@distinctUnionOfObjects.self"];            
        }
            break;
        case kCarCode:
            self.data=[Systype typeValueForCodeName:@"巡查车号"];
            break;
        case kUser:
            self.data = [[UserInfo allUserInfo] valueForKey:@"username"];
            break;
        case kStation:
            self.data = [Systype typeValueForCodeName:@"收费站"];
            break;
        case kDescription:
            self.data = [Systype typeValueForCodeName:@"巡查无异常描述"];
            break;
        case kRoadType:
            self.data = [Systype typeValueForCodeName:@"路面概况类型"];
            break;
        case kStationCheckStatus:
            self.data = [Systype typeValueForCodeName:@"过站状况"];
        default:
            break;
    }
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    static NSString *CellIdentifier = @"InspectionCheckPickerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (self.pickerState==kCheckType) {
        cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"name"];
    } else {
        cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pickerState==kCheckType) {
        [self.delegate setCheckType:[[self.data objectAtIndex:indexPath.row] valueForKey:@"name"] typeID:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"]];
    } else {
        [self.delegate setCheckText:[self.data objectAtIndex:indexPath.row]];
    }
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
