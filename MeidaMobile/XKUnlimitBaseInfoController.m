//
//  XKUnlimitBaseInfoController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XKUnlimitBaseInfoController.h"
#import "XKSPInfoController.h"
#import "XKAttechmentController.h"


@implementation XKUnlimitBaseInfoController
@synthesize txtAppno;
@synthesize lableAppNo;
@synthesize delegate=_delegate;
@synthesize appno=_appno;
@synthesize tbView=_tbView;
@synthesize data=_data;
@synthesize detaildata=_detaildata;


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
- (void)viewDidLoad
{
    [super viewDidLoad];
    WebServiceHandler *service=[[WebServiceHandler alloc]init];
    service.delegate=self;
    [service getPermitUnlimitInfo:_appno];
    
}

-(void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    void(^XMLParser)(void)=^(void){
        if (!_data){
            _data=[[NSMutableArray alloc]init ];
        }
        if (!_detaildata){
            _detaildata=[[NSMutableArray alloc]init];
        }
        NSError *error=nil;
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1=[TBXML childElementNamed:@"getPermitInfo_unlResponse" parentElement:rf];
        TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
        TBXMLElement *author=[TBXML childElementNamed:@"ns1:UnlimitedAppModel" parentElement:r2];
        NSString *value;
        
        [_data addObject:@"案号"];
        [_detaildata addObject:[TBXML getXmlValue:@"case_no" inElement:author] ];
        [_data addObject:@"申请事由"];
        [_detaildata addObject:[TBXML getXmlValue:@"reason" inElement:author] ];
        [_data addObject:@"主车牌号"];
        [_detaildata addObject:[TBXML getXmlValue:@"car_owners" inElement:author] ];
        [_data addObject:@"挂车牌号"];
        [_detaildata addObject:[TBXML getXmlValue:@"car_no" inElement:author] ];
        value=[TBXML getXmlValue:@"date_start" inElement:author];
        if ([value length] > 10) value=[value substringToIndex:10];
        [_data addObject:@"行驶开始时间"];
        [_detaildata addObject: value];
        value=[TBXML getXmlValue:@"date_end" inElement:author];
        if ([value length] > 10) value=[value substringToIndex:10];
        [_data addObject:@"行驶结束时间"];
        [_detaildata addObject: value];
        [_data addObject:@"申请行驶路线"];
        [_detaildata addObject:[TBXML getXmlValue:@"permission_address" inElement:author] ];
        [_data addObject:@"申请人"];
        [_detaildata addObject:[TBXML getXmlValue:@"applicant_name" inElement:author] ];
        [_data addObject:@"申请人联系方式"];
        [_detaildata addObject:[TBXML getXmlValue:@"applicant_address" inElement:author] ];
        [_data addObject:@"经办人"];
        [_detaildata addObject:[TBXML getXmlValue:@"attorney_name" inElement:author] ];
        [_data addObject:@"经办人联系方式"];
        [_detaildata addObject:[TBXML getXmlValue:@"attorney_mobile" inElement:author] ];
        [_data addObject:@"与本案关系"];
        [_detaildata addObject:[TBXML getXmlValue:@"attorney_degree" inElement:author] ];
        [_data addObject:@"车辆类型"];
        [_detaildata addObject:[TBXML getXmlValue:@"car_type" inElement:author] ];
        [_data addObject:@"厂牌型号"];
        [_detaildata addObject:[TBXML getXmlValue:@"factory_type" inElement:author] ];
        [_data addObject:@"核定载质量（吨）"];
        [_detaildata addObject:[TBXML getXmlValue:@"approved_weight" inElement:author] ];
        [_data addObject:@"整车自重（吨）"];
        [_detaildata addObject:[TBXML getXmlValue:@"car_weight" inElement:author] ];
        value=[NSString stringWithFormat:@"长%@米 X 宽%@米 X 高%@米"
               ,[TBXML getXmlValue:@"car_length" inElement:author]
               ,[TBXML getXmlValue:@"car_width" inElement:author]
               ,[TBXML getXmlValue:@"car_high" inElement:author] ];
        [_data addObject:@"整车长宽高（米）"];
        [_detaildata addObject: value];
        value=[NSString stringWithFormat:@"长%@米 X 宽%@米 X 高%@米"
               ,[TBXML getXmlValue:@"goods_length" inElement:author]
               ,[TBXML getXmlValue:@"goods_width" inElement:author]
               ,[TBXML getXmlValue:@"goods_high" inElement:author] ];
        [_data addObject:@"货物长宽高（米）"];
        [_detaildata addObject: value];
        [_data addObject:@"可否解体"];
        [_detaildata addObject:[TBXML getXmlValue:@"can_disintegration" inElement:author] ];
        [_data addObject:@"车货总重（吨）"];
        [_detaildata addObject:[TBXML getXmlValue:@"all_weight" inElement:author] ];
        value=[NSString stringWithFormat:@"长%@米 X 宽%@米 X 高%@米"
               ,[TBXML getXmlValue:@"all_length" inElement:author]
               ,[TBXML getXmlValue:@"all_width" inElement:author]
               ,[TBXML getXmlValue:@"all_high" inElement:author] ];
        [_data addObject:@"车货长宽高（米）"];
        [_detaildata addObject: value];
        [_data addObject:@"接收材料单位"];
        value=[TBXML getXmlValue:@"accept_org" inElement:author];
        value=[[AppDelegate App]getOrgName:value];
        [_detaildata addObject:  value ];
        
        [_data addObject:@"基层管理机构"];
        value=[TBXML getXmlValue:@"control_org" inElement:author];
        value=[[AppDelegate App]getOrgName:value];
        [_detaildata addObject:  value ];
        
        [_data addObject:@"审批机关"];
        value=[TBXML getXmlValue:@"org_id" inElement:author];
        value=[[AppDelegate App]getOrgName:value];
        [_detaildata addObject:  value ];
        
        value=[TBXML getXmlValue:@"app_date" inElement:author];
        if ([value length] > 10) value=[value substringToIndex:10];
        [_data addObject:@"提交材料日期"];
        [_detaildata addObject: value];
        
        value=[TBXML getXmlValue:@"admissible_date" inElement:author];
        if ([value length] > 10) value=[value substringToIndex:10];
        [_data addObject:@"受理日期"];
        [_detaildata addObject: value];
        
        value=[TBXML getXmlValue:@"limitdate" inElement:author];
        if ([value length] > 10) value=[value substringToIndex:10];
        [_data addObject:@"办结时限"];
        [_detaildata addObject: value];
        MAINDISPATCH(^(void){[self.tbView reloadData];});
    };
    BACKDISPATCH(XMLParser);
}

- (void)viewDidUnload
{
    [self setLableAppNo:nil];
    [self setTxtAppno:nil];
    [self setTbView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
-(void)showInfo:(NSString *)appno{
    _appno=appno;
    
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
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[_data objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[_detaildata objectAtIndex:indexPath.row];
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    // Navigation logic may go here. Create and push another view controller.
    //    /*
    //     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    //     // ...
    //     // Pass the selected object to the new view controller.
    //     [self.navigationController pushViewController:detailViewController animated:YES];
    //     */
    //    /*
    //     101   超限车辆上路许可
    //     102   设置非公路标志许可
    //     103	临时占用公路许可
    //     104	跨越公路工程许可
    //     105	埋设电缆管线许可
    //     106	损路机具上路许可
    //     107	增设平交道口许可
    //     108	封闭公路施工许可
    //     109	砍伐修剪路树许可
    //     110	占路使其改线许可
    //     204	穿越公路工程许可
    //     205	架设线路电杆许可
    //     */
    //    NSString *permit_type=[_typelist objectAtIndex:indexPath.row];
    //    _currentid=[_idlist objectAtIndex:indexPath.row];
    //    
    //    if ([permit_type isEqualToString:@"103"] ||
    //        [permit_type isEqualToString:@"104"] ||
    //        [permit_type isEqualToString:@"105"] ||
    //        [permit_type isEqualToString:@"106"] ||
    //        [permit_type isEqualToString:@"107"] ||
    //        [permit_type isEqualToString:@"108"] ||
    //        [permit_type isEqualToString:@"109"] ||
    //        [permit_type isEqualToString:@"110"] ||
    //        [permit_type isEqualToString:@"204"] ||
    //        [permit_type isEqualToString:@"205"] ){
    //        [self performSegueWithIdentifier:@"ShowApp" sender:self];
    //        
    //    }else if ([permit_type isEqualToString:@"101"]){
    //        [self performSegueWithIdentifier:@"showUnlimit" sender:self];
    //        
    //    }else if ([permit_type isEqualToString:@"102"]){
    //        [self performSegueWithIdentifier:@"ShowAd" sender:self];
    //        
    //    }
    //    [self performSegueWithIdentifier:@"ShowApp" sender:self];
    //    //self prepareForSegue:<#(UIStoryboardSegue *)#> sender:<#(id)#>
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"InfoLink"]){
        XKSPInfoController *detail=segue.destinationViewController;
        [detail showInfo:_appno];
        
    }else if ([[segue identifier] isEqualToString:@"AttechLink"]){
        XKAttechmentController *detail=segue.destinationViewController;
        [detail showInfo:_appno];
        
    }  
    //    if ([[segue identifier] isEqualToString:@"ShowApp"]){
    //        XKBaseInfoController *detail=segue.destinationViewController;
    //        [detail showInfo:_currentid];
    //        
    //    }else if ([[segue identifier] isEqualToString:@"showUnlimit"]){
    //        XKBaseInfoController *detail=segue.destinationViewController;
    //        [detail showInfo:_currentid];
    //        
    //    }else if ([[segue identifier] isEqualToString:@"ShowAd"]){
    //        XKBaseInfoController *detail=segue.destinationViewController;
    //        [detail showInfo:_currentid];
    //        
    //    }     
    
    
}

@end
