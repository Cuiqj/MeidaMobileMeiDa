//
//  AnswererPickerViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnswererPickerViewController.h"

@interface AnswererPickerViewController ()
@property (nonatomic,retain) NSArray *dataArray;
@end

@implementation AnswererPickerViewController
@synthesize delegate=_delegate;
@synthesize pickerPopover=_pickerPopover;
@synthesize dataArray=_dataArray;

//弹出列表类型，0为被询问人类型，1为被询问人姓名，2为常见问题，3为常见答案
@synthesize pickerType=_pickerType;


-(void)viewWillAppear:(BOOL)animated{
    switch (self.pickerType) {
        case 0:{
            NSString *caseID=[self.delegate getCaseIDDelegate];
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@",caseID];
            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
            self.dataArray=[tempArray valueForKeyPath:@"@distinctUnionOfObjects.nexus"];
        }
            break;
        case 1:{           
            NSString *caseID=[self.delegate getCaseIDDelegate];
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity=[NSEntityDescription entityForName:@"Citizen" inManagedObjectContext:context];
            NSString *nexusString=[self.delegate getNexusDelegate];
            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
            if (![nexusString isEmpty]) {
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(proveinfo_id==%@) && (nexus==%@)",caseID,nexusString];
                [fetchRequest setEntity:entity];
                [fetchRequest setPredicate:predicate];
                self.dataArray=[context executeFetchRequest:fetchRequest error:nil];
            } else {
                self.dataArray=nil;
            }   
        }
            break;
        case 2:{
            //初始化常用问题    
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity=[NSEntityDescription entityForName:@"InquireAskSentence" inManagedObjectContext:context];
            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:nil];
            NSSortDescriptor *sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"the_index.integerValue" ascending:YES];
            self.dataArray=[context executeFetchRequest:fetchRequest error:nil];
            self.dataArray=[self.dataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
        }
            break;
        case 3:{
            //根据选中的问题，载入常用答案
            NSString *askID=[self.delegate getAskIDDelegate];
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *askEntity=[NSEntityDescription entityForName:@"InquireAnswerSentence" inManagedObjectContext:context];
            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
            if ([askID isEmpty]) {
                [fetchRequest setPredicate:nil];
            } else {
                NSPredicate *predicate=[NSPredicate predicateWithFormat:@"ask_id==%@",askID];
                [fetchRequest setPredicate:predicate];
            }
            [fetchRequest setEntity:askEntity];    
            self.dataArray=[context executeFetchRequest:fetchRequest error:nil]; 
        }
            break;
        default:
            break;
    }

    
}

-(void)viewDidUnload{
    [self setDelegate:nil];
    [self setPickerPopover:nil];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    // Configure the cell...
    switch (self.pickerType) {
        case 0:
            cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"party"];
            break;
        case 2:
        case 3:{
            cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines=0;
            cell.textLabel.font=[UIFont systemFontOfSize:17];
            cell.textLabel.text=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"sentence"];
        }
            break;
        default:
            break;
    }    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    switch (self.pickerType) {
        case 0:
            [self.delegate setNexusDelegate:cell.textLabel.text];
            break;
        case 1:
            [self.delegate  setAnswererDelegate:cell.textLabel.text];
            break;
        case 2:
            [self.delegate setAskSentence:cell.textLabel.text withAskID:[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"myid"]];
            break;
        case 3:
            [self.delegate setAnswerSentence:cell.textLabel.text];
            break;
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];    
}

@end
