//
//  OrgSelectController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OrgSelectController.h"

#import "OrgInfo.h"
@interface OrgSelectController()
@end

@implementation OrgSelectController

@synthesize btnLastOrg = _btnLastOrg;
@synthesize data = _data;
@synthesize currentorg=_currentorg;
@synthesize tvView = _tvView;
@synthesize delegatett=_delegatett;
@synthesize selectedorgs=_selectedorgs;
@synthesize defaultorg=_defaultorg;
@synthesize orgselectPopover=_orgselectPopover;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loaddata];
    //NSLog([[self.data objectAtIndex:0] orgname] );
    [super viewWillAppear:animated];
}

-(void)loaddata{
    self.data=[[AppDelegate App] getAllOrgInfo:_currentorg];
    /*
    for (int i=0; i<[self.data count]; i++) {
        OrgInfo *orgi=[self.data objectAtIndex:i];
        for (int j=0; j<[self.data count]; j++) {
            OrgInfo *orgj=[self.data objectAtIndex:j];
            if (([orgi.orgname isEqualToString:orgj.orgname]) && ([orgi.orgshortname isEqualToString:orgj.orgshortname]) && (i!=j)) {
                [self.data removeObjectAtIndex:j];
            } 
        }
    }
    */ 
    for (int i=0; i<[self.data count]; i++) { 
        OrgInfo *orgi=[self.data objectAtIndex:i];            
       if ([[orgi myid] isEqualToString:@"13860865"]){
          [self.data exchangeObjectAtIndex:0 withObjectAtIndex:i];
       }
   }
    for (int i=0; i<[self.data count]; i++) { 
        OrgInfo *orgi=[self.data objectAtIndex:i]; 
        if ([[orgi myid] isEqualToString:@"-31457279"]){
            [self.data exchangeObjectAtIndex:1 withObjectAtIndex:i];
        }      
    }
    /*
    for (int i=0; i<[self.data count]; i++) { 
        OrgInfo *orgi=[self.data objectAtIndex:i]; 
        if ([[orgi myid] isEqualToString:@"-230195199"]){
            [self.data exchangeObjectAtIndex:2 withObjectAtIndex:i];
        }     
    }
    for (int i=0; i<[self.data count]; i++) { 
        OrgInfo *orgi=[self.data objectAtIndex:i];   
        if ([[orgi myid] isEqualToString:@"-248184831"]){
            [self.data exchangeObjectAtIndex:3 withObjectAtIndex:i];
        }
    }
    for (int i=0; i<[self.data count]; i++) { 
        OrgInfo *orgi=[self.data objectAtIndex:i];   
        if ([[orgi myid] isEqualToString:@"-230195156"]){
            [self.data exchangeObjectAtIndex:4 withObjectAtIndex:i];
        }           
    }
    */
}


-(void)viewDidUnload
{
    [self setTvView:nil];
    [self setBtnLastOrg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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
    static NSString *CellIdentifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    //[cell setIndentationWidth:10.0];
    OrgInfo *org=[self.data objectAtIndex:indexPath.row];
    if (org){
        if ([org.myid isEqualToString:@"13860865"]) {
            [cell setIndentationLevel:0];
        } else if ([org.belongtoorg_id isEqualToString:@"13860865"]) {
            [cell setIndentationLevel:1];
        }
        cell.textLabel.text=org.orgshortname;
        cell.detailTextLabel.text=org.orgname;
    }
    // Configure the cell...
    
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    OrgInfo *org=[self.data objectAtIndex:indexPath.row];
    NSString *selectid=org.myid;
    if (![selectid isEqualToString:@"13860865"]) {
        [_selectedorgs addObject:selectid];
        _currentorg=selectid;
        [self.btnLastOrg setEnabled:YES];
        [self loaddata];
        if (self.data.count>0) {
            [self.tvView beginUpdates];
            [self.tvView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.tvView endUpdates];
        } else {
            BACKDISPATCH(^(void){
                [self.selectedorgs removeObject:selectid];
                self.currentorg=[self.selectedorgs lastObject];
                [self loaddata];
                if (_selectedorgs.count<=1){
                    MAINDISPATCH(^(void){ [self.btnLastOrg setEnabled:NO];});
                } 
            });
        }
    }
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrgInfo *org=[self.data objectAtIndex:indexPath.row];
    NSString *selectid=org.myid;
    NSString *selectname=org.orgshortname;
    
    _currentorg=selectid;
    
    [self.delegatett setOrg:selectid];
    [self.delegatett setOrgName:selectname];
}


-(void)showinfo:(NSString *)org{
    _currentorg=org;
    _defaultorg=org;
    _selectedorgs=[[NSMutableArray alloc]init];
    [_selectedorgs addObject:_currentorg];
    [self.btnLastOrg setEnabled:NO];
    [self loaddata];
    [self.tvView reloadData];
}

- (IBAction)toLastOrg:(id)sender {
    if (_selectedorgs.count>1){
        _currentorg=[_selectedorgs objectAtIndex:_selectedorgs.count-2];
        
        [_selectedorgs removeLastObject];
        if (_selectedorgs.count<=1){
            [self.btnLastOrg setEnabled:NO];
        }
        [self loaddata];
        [self.tvView beginUpdates];
        [self.tvView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.tvView endUpdates];
    }    
}

- (IBAction)btnSave:(id)sender {
    [_delegatett setOrg:_currentorg];
    [self.orgselectPopover dismissPopoverAnimated:YES];
}

-(void)setDelegatett:(id<OrgSelectHandler>)delegatett{
    _delegatett=delegatett;
}
@end
