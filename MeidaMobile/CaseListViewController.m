//
//  CaseListViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseInfo.h"
#import "RoadSegment.h"

@interface CaseListViewController ()

@end

@implementation CaseListViewController
@synthesize myPopover=_myPopover;
@synthesize delegate=_delegate;
@synthesize caseList=_caseList;
@synthesize caseListView = _caseListView;


- (void)viewDidLoad
{
    self.caseList=[[NSMutableArray alloc] initWithCapacity:1];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInfo" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSSortDescriptor *sortByCaseMark2=[NSSortDescriptor sortDescriptorWithKey:@"case_mark2.integerValue" ascending:YES];
    NSSortDescriptor *sortByCaseMark3=[NSSortDescriptor sortDescriptorWithKey:@"case_mark3.integerValue" ascending:YES];
    NSArray *sortArray=[NSArray arrayWithObjects:sortByCaseMark2,sortByCaseMark3,nil];
    [fetchRequest setSortDescriptors:sortArray];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"case_mark2 != nil && case_mark3 != nil"]];
    NSError *error;
    self.caseList=[[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMyPopover:nil];
    [self setDelegate:nil];
    [self.caseList removeAllObjects];
    [self setCaseList:nil];
    [self setCaseListView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    return self.caseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CaseListCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CaseInfo *caseInfo=[self.caseList objectAtIndex:indexPath.row];
    NSString *roadName=[RoadSegment roadNameFromSegment:caseInfo.roadsegment_id];
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"K%@+%@m处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"K%@+%@m至K%@+%@m处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    
    cell.textLabel.text=[[NSString alloc] initWithFormat:@"%@%@%@",roadName,caseInfo.side,stationString];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@年%@号",caseInfo.case_mark2,caseInfo.full_case_mark3];
    if (caseInfo.isuploaded.boolValue) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate  setCaseIDdelegate:[[self.caseList objectAtIndex:indexPath.row] valueForKey:@"myid"]];
    [self.myPopover dismissPopoverAnimated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//删除案件信息
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate deleteCaseAllDataForCase:[[self.caseList objectAtIndex:indexPath.row] valueForKey:@"myid"]];
        [self.caseList removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
} 

- (IBAction)btnEdit:(id)sender {
    if ([self.caseListView isEditing]) {
        [(UIBarButtonItem *)sender setTitle:@"编辑"];
        [(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleBordered];
        [self.caseListView setEditing:NO animated:YES];
    } else {
        [(UIBarButtonItem *)sender setTitle:@"完成"];
        [(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleDone];
        [self.caseListView setEditing:YES animated:YES];
    }    
}
@end
