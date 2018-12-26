//
//  ServerSettingController2.m
//  GDYZMobile
//
//  Created by maijunjin on 14-11-3.
//
//

#import "ServerSettingController.h"

@interface ServerSettingController ()

@end

@implementation ServerSettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.txtServer.text = [AppDelegate App].serverAddress;
    self.txtFile.text = [AppDelegate App].fileAddress;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewDidUnload
{
    [self setTxtServer:nil];
    [self setTxtFile:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSave:(id)sender {
    NSString *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.txtServer.text, self.txtFile.text, nil]
                                                                   forKeys:[NSArray arrayWithObjects: @"server address", @"file address", nil]];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSMutableDictionary *plistDict = [[NSPropertyListSerialization
                                       propertyListFromData:plistXML
                                       mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                       format:&format
                                       errorDescription:&errorDesc] mutableCopy];
    [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
    }
    [AppDelegate App].serverAddress=self.txtServer.text;
    [AppDelegate App].fileAddress=self.txtFile.text;
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)btnDismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
