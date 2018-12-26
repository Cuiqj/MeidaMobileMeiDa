//
//  CitizenListViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CitizenListViewController.h"

#import "Citizen.h"

@interface CitizenListViewController ()
@property (nonatomic,retain) NSMutableArray *citizenList;
-(void)deleteCitizenInfo:(Citizen *)citizen;
@end

@implementation CitizenListViewController
@synthesize citizenListView = _citizenListView;
@synthesize caseID = _caseID;
@synthesize citizenList = _citizenList;
@synthesize citizenListPopover = _citizenListPopover;
@synthesize delegate=_delegate;

-(void)viewWillAppear:(BOOL)animated{
    if (self.citizenList==nil) {
        self.citizenList=[[NSMutableArray alloc] initWithCapacity:1];
    } else {
        [self.citizenList removeAllObjects];
    }
    self.citizenList=[[Citizen allCitizenNameForCase:self.caseID] mutableCopy];
}    

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self.citizenList removeAllObjects];
    [self setCaseID:nil];
    [self setCitizenList:nil];
    [self setCitizenListView:nil];
    [self setCitizenListPopover:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.citizenList.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section==0) {
        static NSString *CellIdentifier=@"CitizenListCell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if ([tableView isEditing]) {
            UITextField *textField=(UITextField *)[cell.contentView viewWithTag:1007];
            textField.text=[[self.citizenList objectAtIndex:indexPath.row] valueForKey:@"automobile_number"];
            cell.textLabel.text=@"";
        } else {
            cell.textLabel.text=[[self.citizenList objectAtIndex:indexPath.row] valueForKey:@"automobile_number"];
        }
    } else {
        static NSString *CellIdentifier=@"NewCitizenCell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=@"";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    [_delegate  setAutoNumber:cell.textLabel.text];
    [self.citizenListPopover dismissPopoverAnimated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除单元格与数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Citizen *temp=[self.citizenList objectAtIndex:indexPath.row];
        NSString *selectedAutoNumber=[_delegate getAutoNumberDelegate];
        if ([selectedAutoNumber isEqualToString:temp.automobile_number]) {
            [self.delegate clearAutoInfo];
        }
        if (![temp.automobile_number isEmpty] && temp.automobile_number!=nil) {
            NSDictionary *deleteCitizen=[NSDictionary dictionaryWithObject:temp.automobile_number forKey:@"citizen_name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteCitizen" object:nil userInfo:deleteCitizen];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCitizen" object:nil];
        [self deleteCitizenInfo:temp];
        [self.citizenList removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            if (self.citizenList.count==1) {
                [self.delegate setAutoNumber:[[self.citizenList objectAtIndex:0] valueForKey:@"automobile_number"]];
                [self.citizenListPopover dismissPopoverAnimated:YES];
            }
        });
    }
    
    //增加单元格，并增加数据
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        Citizen *newCitizen=[Citizen newDataObjectWithEntityName:@"Citizen"];
        newCitizen.proveinfo_id = self.caseID;
        [self.citizenList addObject:newCitizen];
        NSIndexPath *indexPathForInsert=[NSIndexPath indexPathForRow:self.citizenList.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForInsert] withRowAnimation:UITableViewRowAnimationRight];
        UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPathForInsert];
        UITextField *newTextField=[[UITextField alloc] initWithFrame:CGRectMake(myCell.frame.origin.x+6, (myCell.frame.size.height-31)/2, myCell.frame.size.width-100, 31)];
        newTextField.borderStyle=UITextBorderStyleRoundedRect;
        newTextField.textColor=[UIColor blackColor];
        newTextField.returnKeyType=UIReturnKeyDefault;
        newTextField.textAlignment=UITextAlignmentLeft;
        newTextField.text=@"";
        newTextField.font=[UIFont systemFontOfSize:17];
        newTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        newTextField.keyboardType=UIKeyboardTypeDefault;
        newTextField.tag=1007;
        [myCell.contentView addSubview:newTextField];
    }
} 

- (IBAction)btnEdit:(id)sender {
    if ([self.citizenListView isEditing]) {
        [(UIBarButtonItem *)sender setTitle:@"编辑"];
        [(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleBordered];
        [self.citizenListView setEditing:NO animated:YES];
        
        //储存添加的车牌号
        for (int i=0; i<self.citizenList.count; i++) {
            NSIndexPath *index=[NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *myCell=[self.citizenListView cellForRowAtIndexPath:index];
            for (UITextField *textField in myCell.contentView.subviews) {
                if ([textField isKindOfClass:[UITextField class]]) {
                    NSString *tempString=textField.text;
                    tempString=[tempString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    textField.text=tempString.uppercaseString;
                    //将车牌号保存
                    Citizen *citizen=[self.citizenList objectAtIndex:i];
                    NSString *autoNumberNew=textField.text;
                    NSString *autoNumberOriginal=citizen.automobile_number;
                    citizen.automobile_number=autoNumberNew;
                    //车牌号不为空时，自动根据车号获取所在地信息
                    if (autoNumberNew.length>2) {
                        NSString *provinceNew=[autoNumberNew substringToIndex:1];
                        NSString *cityCodeNew=[autoNumberNew substringWithRange:NSMakeRange(1, 1)];
                        if (autoNumberOriginal.length>2) {
                            NSString *provinceOriginal=[autoNumberOriginal substringToIndex:1];
                            NSString *cityCodeOriginal=[autoNumberOriginal substringWithRange:NSMakeRange(1, 1)];
                            //若更改当前车号，则所在地信息随之更新
                            if ((![provinceNew isEqualToString:provinceOriginal]) || (![cityCodeNew isEqualToString:cityCodeOriginal])) {
                                citizen.automobile_address=[citizen.automobile_number autoAddressFromAutoNumber];
                            }
                        } else {
                            citizen.automobile_address=[citizen.automobile_number autoAddressFromAutoNumber];
                        }
                    }
                    citizen.proveinfo_id=_caseID;
                    citizen.nexus=@"当事人";
                    [[AppDelegate App] saveContext];
                    [textField removeFromSuperview];
                }
            }
        }        
        //删除空数据
        for (int i=0; i<self.citizenList.count; i++) {
            Citizen *citizen=[self.citizenList objectAtIndex:i];
            if ([citizen.automobile_number isEmpty] || citizen.automobile_number==nil) {
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                [context deleteObject:citizen];
                [self.citizenList removeObject:citizen];
                [[AppDelegate App] saveContext];
            }
        }

        //删除同一案号下重复车号数据
        for (int i=0; i<self.citizenList.count; i++) {
            Citizen *citizeni=[self.citizenList objectAtIndex:i];
            for (int j=0; j<self.citizenList.count; j++) {
                Citizen *citizenj=[self.citizenList objectAtIndex:j];
                if (([citizeni.automobile_number isEqualToString:citizenj.automobile_number]) && ([citizeni.proveinfo_id isEqualToString:citizenj.proveinfo_id]) && (i!=j)) {
                    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                    [context deleteObject:citizenj];
                    [self.citizenList removeObjectAtIndex:j];
                    [[AppDelegate App] saveContext];
                } 
            }
        }        
        
        //消息，通知车号列表已变动，其他读取车号信息的ViewController进行数据重载
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCitizen" object:nil];
        [self.citizenListView reloadData];
        
        //如只有一个车号，自动选定
        if (self.citizenList.count==1) {
            [_delegate  setAutoNumber:[[self.citizenList objectAtIndex:0] valueForKey:@"automobile_number"]];
            [self.citizenListPopover dismissPopoverAnimated:YES];
        }
    } else {
        [(UIBarButtonItem *)sender setTitle:@"完成"];
        [(UIBarButtonItem *)sender setStyle:UIBarButtonItemStyleDone];
        [self.citizenListView setEditing:YES animated:YES];
        
        //使列表内各项目可编辑
        for (int i=0; i<self.citizenList.count; i++) {            
            UITableViewCell *myCell=[self.citizenListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            UITextField *newTextField=[[UITextField alloc] initWithFrame:CGRectMake(myCell.frame.origin.x+6, (myCell.frame.size.height-31)/2, myCell.frame.size.width-100, 31)];
            newTextField.borderStyle=UITextBorderStyleRoundedRect;
            newTextField.textColor=[UIColor blackColor];
            newTextField.returnKeyType=UIReturnKeyDone;
            newTextField.textAlignment=UITextAlignmentLeft;
            newTextField.text=myCell.textLabel.text;
            newTextField.font=[UIFont systemFontOfSize:17];
            newTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            newTextField.keyboardType=UIKeyboardTypeDefault;
            [myCell.contentView addSubview:newTextField];
            myCell.textLabel.text=@"";
            newTextField.tag=1007;
        }           
    }        
}

-(void)deleteCitizenInfo:(Citizen *)citizen{
    NSString *caseID=citizen.proveinfo_id;
    NSString *citizenName=citizen.automobile_number;
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@",caseID];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    NSInteger numberOfCitizen=tempArray.count;
    tempArray=nil;
    if (numberOfCitizen-1>1) {
        entity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
        predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && citizen_name==%@",caseID,citizenName];    
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        tempArray=[context executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject *obj in tempArray) {
            [context deleteObject:obj];
        }
    } else {
        entity=[NSEntityDescription entityForName:@"CaseDeformation" inManagedObjectContext:context];
        predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && (citizen_name==%@ || citizen_name==%@)",caseID,citizenName,@"共同"];    
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:predicate];
        tempArray=[context executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject *obj in tempArray) {
            [context deleteObject:obj];
        }
    }
    entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
    predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@ && citizen_name == %@",caseID,citizenName];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    tempArray=[context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in tempArray) {
        [context deleteObject:obj];
    }
    [context deleteObject:citizen];
    [[AppDelegate App] saveContext];
}
@end
