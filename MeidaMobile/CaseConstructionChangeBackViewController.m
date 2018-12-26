//
//  CaseConstructionChangeBackViewController.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-9.
//
//

#import "CaseConstructionChangeBackViewController.h"
#import "ConstructionChangeBack.h"

@interface CaseConstructionChangeBackViewController ()

@end

@implementation CaseConstructionChangeBackViewController
@synthesize textNo = _textNo;
@synthesize textSendname = _textSendname;
@synthesize textSendate = _textSendate;
@synthesize textSendNO = _textSendNO;
@synthesize textRemark = _textRemark;

@synthesize pickerPopover = _pickerPopover;
@synthesize rel_id = _rel_id;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewDidLoad
{
    [self LoadPaperSettings:@"ConstructionTable"];
    [self loadPageInfo];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)loadPageInfo{
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.textSendate]) {
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)textTouch:(UITextField *)sender {
    //时间选择
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        [datePicker showdate:self.textSendate.text];
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        
        CGRect rect = sender.frame;
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
}

-(void)setDate:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *temp=[dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时"];
    NSString *dateString=[dateFormatter stringFromDate:temp];
    self.textSendate.text = dateString;
}

//- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        [self drawStaticTable:@"ConstructionTable"];
//        
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:filePath];
//    } else {
//        return nil;
//    }
//}
//
//- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
//    if (![filePath isEmpty]) {
//        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
//        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
//        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
//        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
//        
//        UIGraphicsEndPDFContext();
//        return [NSURL fileURLWithPath:formatFilePath];
//    } else {
//        return nil;
//    }
//}

- (IBAction)btnPrint:(id)sender{
    //保存数据
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    ConstructionChangeBack *construction = [NSEntityDescription insertNewObjectForEntityForName:@"ConstructionChangeBack" inManagedObjectContext:context];
    construction.rel_id = self.rel_id;
    construction.no = self.textNo.text;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"yyyy年MM月dd日HH时"];
    construction.sendate = [dateFormat dateFromString:self.textSendate.text];
    construction.sendNO = self.textSendNO.text;
    construction.sendname = self.textSendname.text;
    construction.sendcontent = self.textRemark.text;
    [[AppDelegate App] saveContext];
    //打印
    NSString *fileName=[NSString stringWithFormat:@"%@-%d.pdf",@"施工整改通知书",0];
    NSArray *arrayPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[arrayPaths objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    if (![fullPath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(fullPath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        //[self drawStaticTable:@"ConstructionTable"];
        [self drawDateTable:@"ConstructionTable" withDataModel:construction];
        UIGraphicsEndPDFContext();
        if ([UIPrintInteractionController isPrintingAvailable]) {
            UIPrintInteractionController * printer=[UIPrintInteractionController sharedPrintController];
            [printer setDelegate:self];
            UIPrintInfo *printInfo=[UIPrintInfo printInfo];
            printInfo.jobName=[fullPath lastPathComponent];
            printInfo.outputType=UIPrintInfoOutputGeneral;
            printInfo.orientation = UIPrintInfoOrientationPortrait;
            printInfo.duplex = UIPrintInfoDuplexNone;
            printer.printInfo=printInfo;
            printer.printingItem=[NSData dataWithContentsOfFile:fullPath];
            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
            ^(UIPrintInteractionController *printController, BOOL completed, NSError *error ) {
                if (!completed && error) {
                    NSLog(@"Printing could not complete because of error: %@", [error localizedDescription]);
                }
            };
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [printer presentFromRect:[sender frame] inView:self.view animated:YES completionHandler:completionHandler];
            } else {
                [printer presentAnimated:YES completionHandler:completionHandler];
            }
        } else {
            NSLog(@"AirPrinter NOT Available");
        }
    }
}
- (IBAction)btnBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
@end
