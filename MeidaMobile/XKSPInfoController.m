//
//  XKSPInfoController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XKSPInfoController.h"
#import "TBXML.h"
#import "XKSPInfoController.h"
#import "XKAttechmentController.h"


@implementation XKSPInfoController
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
    [service getPermitAuditListInfo:_appno];
    
}

-(void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    void(^XMLParser)(void)=^(void){
        _data=[[NSMutableArray alloc]init ];
        _detaildata=[[NSMutableArray alloc]init];
        NSError *error=nil;
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1=[TBXML childElementNamed:@"getPermitAuditListResponse" parentElement:rf];
        TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
        TBXMLElement *author=[TBXML childElementNamed:@"ns1:WorkflowDescForm" parentElement:r2];
        do {
            TBXMLElement *app_no=[TBXML childElementNamed:@"taskdesc" parentElement:author];
            NSString *app_nodesc=[TBXML textForElement:app_no];
            //TBXMLElement *status=[TBXML childElementNamed:@"opinion" parentElement:author];
            //app_nodesc=[app_nodesc stringByAppendingString:[NSString stringWithFormat:@"(%@)",[TBXML textForElement:status]]];
            [_data addObject:app_nodesc];
            TBXMLElement *applicant_name=[TBXML childElementNamed:@"account" parentElement:author];
            NSString *username=[[AppDelegate App] getUserName:[TBXML textForElement:applicant_name]];
            NSString *applicant_namedesc=[NSString stringWithFormat:@"处理人：%@ ",username];
            TBXMLElement *app_date=[TBXML childElementNamed:@"datedesc" parentElement:author];
            applicant_namedesc=[applicant_namedesc stringByAppendingString:[NSString stringWithFormat:@" 时间：%@",[TBXML textForElement:app_date]]];
            TBXMLElement *current_status=[TBXML childElementNamed:@"current_status" parentElement:author];
            NSString *status=[TBXML textForElement:current_status];
            if ([status isEqualToString:@"1"]){
                status=@"未处理";
            }
            if ([status isEqualToString:@"0"]){
                status=@"未查看";
            }
            if ([status isEqualToString:@"2"]){
                status=@"已完成";
            }
            if ([status isEqualToString:@"5"]){
                status=@"返回";
            }
            applicant_namedesc=[applicant_namedesc stringByAppendingString:[NSString stringWithFormat:@" %@",status]];
            [_detaildata addObject:applicant_namedesc];
        } while ((author=author->nextSibling));
        MAINDISPATCH(^(void){ [self.tbView reloadData];});
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
}
-(void)loadData{
    
}

@end
