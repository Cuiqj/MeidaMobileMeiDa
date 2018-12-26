//
//  XKMainController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XKMainController.h"
#import "TBXML.h"
#import "XKBaseInfoController.h"
#import "OrgSelectController.h"

@implementation XKMainController 
@synthesize txtCaseno;

@synthesize selectorg=_selectorg;

@synthesize data=_data;
@synthesize detaildata=_detaildata;
@synthesize tbview = _tbview;
@synthesize idlist = _idlist;
@synthesize typelist = _typelist;
@synthesize currentid = _currentid;

@synthesize txtFirst=_txtFirst;
@synthesize txtSec=_txtSec;
@synthesize currentField=_currentField;
@synthesize txtOrg=_txtOrg;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadData];
    _selectorg=@"13860865";
    [self searchData:@"" startDate:@"" endDate:@"" permitOrgId:_selectorg ];
}
-(void)searchData:(NSString *)caseno
        startDate:(NSString *)startdate
          endDate:(NSString *)enddate
      permitOrgId:(NSString *)permitOrgId
{
    WebServiceHandler *service=[[WebServiceHandler alloc]init];
    service.delegate=self;
    [service getPermitData:caseno startDate:startdate endDate:enddate permitOrgId:permitOrgId];
}

- (IBAction)btnSearch:(id)sender {
    [self searchData:txtCaseno.text startDate:_txtFirst.text endDate:_txtSec.text permitOrgId:_selectorg ];
}

- (IBAction)prmitEditEnd:(id)sender {
    [sender resignFirstResponder];
}


-(void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if (!_data){
            _data=[[NSMutableArray alloc]init ];
            
        }else{
            [_data removeAllObjects];
        }
        if (!_detaildata){
            _detaildata=[[NSMutableArray alloc]init];
            
        }else{
            [_detaildata removeAllObjects];
        }
        if (!_idlist){
            _idlist=[[NSMutableArray alloc]init ];
        }else{
            [_idlist removeAllObjects];
        }
        if (!_typelist){
            _typelist=[[NSMutableArray alloc]init ];
        }else{
            [_typelist removeAllObjects];
        }
        NSError *error=nil;
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1=[TBXML childElementNamed:@"getPermitListResponse" parentElement:rf];
        TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
        
        TBXMLElement *author=[TBXML childElementNamed:@"ns1:OrgApplistFormbean" parentElement:r2];
        if (author!=nil){
            do {
                
                TBXMLElement *permit_id=[TBXML childElementNamed:@"id" parentElement:author];
                if (permit_id!=nil){
                    NSString *permit_id_string=[TBXML textForElement:permit_id];
                    [_idlist addObject:permit_id_string];
                    TBXMLElement *process_id=[TBXML childElementNamed:@"process_id" parentElement:author];
                    NSString *process_id_string=[TBXML textForElement:process_id];
                    [_typelist addObject:process_id_string];
                    TBXMLElement *app_no=[TBXML childElementNamed:@"app_no" parentElement:author];
                    NSString *app_nodesc=[TBXML textForElement:app_no];
                    TBXMLElement *status=[TBXML childElementNamed:@"status" parentElement:author];
                    app_nodesc=[app_nodesc stringByAppendingString:[NSString stringWithFormat:@"(%@)",[TBXML textForElement:status]]];
                    [_data addObject:app_nodesc];
                    TBXMLElement *applicant_name=[TBXML childElementNamed:@"applicant_name" parentElement:author];
                    NSString *applicant_namedesc=[NSString stringWithFormat:@"申请人：%@ ",[TBXML textForElement:applicant_name]];
                    TBXMLElement *app_date=[TBXML childElementNamed:@"app_date" parentElement:author];
                    applicant_namedesc=[applicant_namedesc stringByAppendingString:[NSString stringWithFormat:@"申请时间：%@",[TBXML textForElement:app_date]]];
                    TBXMLElement *permission_address=[TBXML childElementNamed:@"permission_address" parentElement:author];
                    applicant_namedesc=[applicant_namedesc stringByAppendingString:[NSString stringWithFormat:@"地点：%@",[TBXML textForElement:permission_address]]];
                    [_detaildata addObject:applicant_namedesc];
                }
                
            } while ((author=author->nextSibling));
            
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){[self.tbview reloadData];});
    });
    
}


- (void)viewDidUnload
{
    [self setTxtFirst:nil];
    [self setTxtSec:nil];
    [self setTxtOrg:nil];
    [self setTbview:nil];
    [self setTxtCaseno:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || 
    (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
    if (_data){
        return _data.count;

    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (_data){
        cell.textLabel.text=[_data objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[_detaildata objectAtIndex:indexPath.row];
    }       
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     101   超限车辆上路许可
     102   设置非公路标志许可
     103	临时占用公路许可
     104	跨越公路工程许可
     105	埋设电缆管线许可
     106	损路机具上路许可
     107	增设平交道口许可
     108	封闭公路施工许可
     109	砍伐修剪路树许可
     110	占路使其改线许可
     204	穿越公路工程许可
     205	架设线路电杆许可
     */
    NSString *permit_type=[_typelist objectAtIndex:indexPath.row];
    _currentid=[_idlist objectAtIndex:indexPath.row];
    
    if ([permit_type isEqualToString:@"103"] ||
        [permit_type isEqualToString:@"104"] ||
        [permit_type isEqualToString:@"105"] ||
        [permit_type isEqualToString:@"106"] ||
        [permit_type isEqualToString:@"107"] ||
        [permit_type isEqualToString:@"108"] ||
        [permit_type isEqualToString:@"109"] ||
        [permit_type isEqualToString:@"110"] ||
        [permit_type isEqualToString:@"204"] ||
        [permit_type isEqualToString:@"205"] ){
        [self performSegueWithIdentifier:@"toShowApp" sender:self];
        
    }else if ([permit_type isEqualToString:@"101"]){
        [self performSegueWithIdentifier:@"toShowUnlimit" sender:self];
        
    }else if ([permit_type isEqualToString:@"102"]){
        [self performSegueWithIdentifier:@"toShowAdv" sender:self];
        
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    _currentField= [segue identifier];
    if ([_currentField isEqualToString:@"toStartDate"]){
        DateSelectController *pview=segue.destinationViewController;
        pview.dateselectPopover=[(UIStoryboardPopoverSegue *)segue popoverController];
        pview.delegate=self;
        pview.pickerType=0;
        [pview showdate:_txtFirst.text];
    }else if ([_currentField isEqualToString:@"toEndDate"]){
        DateSelectController *pview=segue.destinationViewController;
        pview.dateselectPopover=[(UIStoryboardPopoverSegue *)segue popoverController];
        [pview setDelegate:self];
        pview.pickerType=0;
        [pview showdate:_txtSec.text];
    }else if ([_currentField isEqualToString:@"toOrg"]){
        OrgSelectController *oview=segue.destinationViewController;
        oview.orgselectPopover=[(UIStoryboardPopoverSegue *)segue popoverController];
        [oview setDelegatett:self];
        [oview showinfo:@"13860865"];
    }else if ([_currentField isEqualToString:@"toShowApp"]){
        XKBaseInfoController *detail=segue.destinationViewController;
        [detail showInfo:_currentid];
        
    }else if ([_currentField isEqualToString:@"toShowUnlimit"]){
        XKBaseInfoController *detail=segue.destinationViewController;
        [detail showInfo:_currentid];
        
    }else if ([[segue identifier] isEqualToString:@"toShowAdv"]){
        XKBaseInfoController *detail=segue.destinationViewController;
        [detail showInfo:_currentid];        
    }         
}

-(void)setDate:(NSString *)date{
    if ([_currentField isEqualToString:@"toStartDate"]){
        _txtFirst.text=date;
    }else if ([_currentField isEqualToString:@"toEndDate"]){
        _txtSec.text=date;
    }    
}

-(void)setOrg:(NSString *)org{
    _selectorg=org;
}

-(void)setOrgName:(NSString *)orgname{
    _txtOrg.text=orgname;
}

- (IBAction)selectStartDate:(id)sender {
    [self performSegueWithIdentifier:@"toStartDate" sender:self];
}

- (IBAction)selectOrg:(id)sender {
    [self performSegueWithIdentifier:@"toOrg" sender:self];
}

- (IBAction)selectEndDate:(id)sender {
    [self performSegueWithIdentifier:@"toEndDate" sender:self];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
};

@end
