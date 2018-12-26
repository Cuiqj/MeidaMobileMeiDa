//
//  ServerSettingController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataSyncController.h"
#import "OMGToast.h"

@interface  DataSyncController()
@property (retain, nonatomic) DataDownLoad *dataDownLoader;
@property (retain, nonatomic) DataUpLoad   *dataUploader;
- (void)upLoadFinished;
- (void)downLoadFinished;
@end

@implementation DataSyncController
@synthesize uibuttonInit   = _uibuttonInit;
@synthesize uibuttonReset  = _uibuttonReset;
@synthesize uibuttonUpload = _uibuttonUpload;
@synthesize dataDownLoader = _dataDownLoader;
@synthesize dataUploader   = _dataUploader;

- (DataUpLoad *)dataUploader{
    _dataUploader = nil;
    if (_dataUploader == nil) {
        _dataUploader = [[DataUpLoad alloc] init];
    }
    return _dataUploader;
}


- (DataDownLoad *)dataDownLoader{
    _dataDownLoader = nil;
    if (_dataDownLoader == nil) {
        _dataDownLoader = [[DataDownLoad alloc] init];
    }
    return _dataDownLoader;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [self setDataDownLoader:nil];
    [self setDataUploader:nil];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    self.versionName.text = VERSION_NAME;
    self.versionTime.text = VERSION_TIME;
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"小按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uibuttonInit setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonReset setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonUpload setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.updateDocFormatBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    imagePath=[[NSBundle mainBundle] pathForResource:@"服务器参数设置 -bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"设置服务器参数(请不要随意修改)"]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, 7)];
    [_setServerBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    ////////////////////
    UITapGestureRecognizer * openOrCloseDocFormatDebugGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isDebuging:)];
    openOrCloseDocFormatDebugGes.numberOfTouchesRequired = 2;
    openOrCloseDocFormatDebugGes.numberOfTapsRequired    = 6;
    openOrCloseDocFormatDebugGes.delegate                = self;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:openOrCloseDocFormatDebugGes];
    ////////////////////
    
    [self.updateDocFormatBtn setUserInteractionEnabled :NO];
    self.updateDocFormatBtn.alpha = 0;
    [super viewDidLoad];
}

//双击666 开启调试文书模式 hhhhh
- (void)isDebuging:(UITapGestureRecognizer *)sender{
    if (sender.numberOfTapsRequired == 6 && sender.numberOfTouchesRequired==2) {
        
        NSUserDefaults *defaultdata=[NSUserDefaults standardUserDefaults];
        if([defaultdata boolForKey:@"isDebugingDocFormat"]){
            [defaultdata setBool:![defaultdata boolForKey:@"isDebugingDocFormat"] forKey:@"isDebugingDocFormat"];
            [OMGToast showWithText:@"已关闭文书调试模式" bottomOffset:100 duration:3];
            NSLog(@"已关闭文书调试模式");
        }
        else{
            [defaultdata setBool:![defaultdata boolForKey:@"isDebugingDocFormat"] forKey:@"isDebugingDocFormat"];
            [OMGToast showWithText:@"已开启文书调试模式,请确保iPad能连接上服务器！" bottomOffset:100 duration:3];
            NSLog(@"已开启文书调试模式");
        }
        
    }
}
- (void)viewDidUnload
{
    
    [self setUibuttonInit:nil];
    [self setUibuttonReset:nil];
    [self setUibuttonUpload:nil];
    [self setDataDownLoader:nil];
    [self setDataUploader:nil];
    [self setSetServerBtn:nil];
    [self setVersionName:nil];
    [self setVersionTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (IBAction)btnInitData:(id)sender {
    [self.dataDownLoader startDownLoad];
}

- (IBAction)btnUpLoadData:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if (![inspectionID isEmpty] && inspectionID!=nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"当前还有未完成的巡查，请先交班再上传业务数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        if ([WebServiceHandler isServerReachable]) {
            [self.dataUploader uploadData];
        }
    }
}


- (void)downLoadFinished{
    self.dataDownLoader = nil;
}

- (void)upLoadFinished{
    self.dataUploader = nil;
}



- (IBAction)btnUpdateDocFormat:(UIButton *)sender {
    NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * libPath=[libPaths objectAtIndex:0 ];
    NSString * settingPath=[libPath stringByAppendingString:@"/Settings.plist"];
    NSPropertyListFormat format1;
    NSError *err;
    NSData* settingPlistData=[[NSFileManager defaultManager] contentsAtPath:settingPath];
    NSDictionary * settingDict=(NSDictionary*)[NSPropertyListSerialization propertyListWithData:settingPlistData options:NSPropertyListMutableContainersAndLeaves format:&format1 error:&err ];
    NSArray * docArray=[[settingDict objectForKey:@"FileToTableMapping"] allValues];
    NSString*success=@"ok";
    NSString*failDocNames=@"";
    for(NSString *docXMlName in docArray){
        NSString * remotePath=[NSString stringWithFormat:@"%@app/DocTemplates/%@%@", [AppDelegate App].serverAddress,docXMlName,@".xml"];
        NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *temp=[docXMlName stringByAppendingString:@".mustache"];
        NSString *destPath=[libraryDirectory stringByAppendingPathComponent:temp];
        NSError *error;
        //        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
        //        [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:remotePath] toURL:[NSURL URLWithString:destPath] error:&error];
        //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@app/XML/%@.xml",[AppDelegate App].serverAddress ,docXMlName]];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/DocTemplates/%@.mustache",[AppDelegate App].serverAddress ,docXMlName]];
        
        //创建动态URL请求,并初始化
        NSMutableURLRequest * request=[[NSMutableURLRequest alloc]initWithURL:url];
        
        //设置访问方式为POST
        [request setHTTPMethod:@"post"];
        
        //设置传参参数（字符串）
        //NSString * str=@"";
        
        //二进制的参数字符串
        //NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        
        //放在请求里
        //[request setHTTPBody:data];
        
        //发送请求
        NSData * resData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSData *data =[NSData dataWithContentsOfURL:url];
        if(data==nil){
            success=@"fuck";
            if([failDocNames isEqualToString:@""]){
                failDocNames=[NSString stringWithFormat:@"%@%@",failDocNames,docXMlName];
            }
            else{
                failDocNames=[NSString stringWithFormat:@"%@,%@",failDocNames,docXMlName];
            }
        }
        NSString * s=[[NSString alloc] initWithBytes: [resData bytes] length:[resData length] encoding:NSUTF8StringEncoding];
        NSString * s2=[[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        [s2 writeToFile:destPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@",s2);
    }
    NSString *message=[success isEqualToString:@"ok"]?@"更新完成！":@"更新失败，请检查网络连接";
    [[ [ UIAlertView alloc] initWithTitle:@"消息" message:message delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil]show];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isDebugingDocFormat"]&&![failDocNames isEqualToString:@""]){
        [OMGToast showWithText:[NSString stringWithFormat:@"%@文书更失败",failDocNames] bottomOffset:100 duration:3];
        
    }
    NSLog([NSString stringWithFormat:@"%@文书更失败",failDocNames]);
    
}

@end
