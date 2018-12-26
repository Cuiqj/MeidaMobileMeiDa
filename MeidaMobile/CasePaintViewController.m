//
//  CasePaintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CasePaintViewController.h"
#import "CaseMap.h"
#import "CaseProveInfo.h"
#import "UserInfo.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLNode+CDATA.h"

//绘图放大倍数
#define zoom 3
#define FontSizeScaleFactor 0.9

//static NSString * const textAttriName[7] = {@"Name", @"FontSize", @"Left", @"Top" @"Width", @"Height", @"Angle"};
//static NSString * const iconAttriName[9] = {@"Id", @"Type", @"Name", @"Left", @"Top" @"Width", @"Height", @"Angle", @"Percent"};

@interface CasePaintViewController(){
    int selectedType;
    int selectedTool;
}

@property (nonatomic,retain) UIPopoverController *textInputPopover;
@property (nonatomic,retain) NSArray *iconTypeArray;
@property (nonatomic,retain) NSArray *paintToolsArray;
//@property (nonatomic,retain) NSString *roadModelID;

//add by lxm 2013.05.13
//增加标识是否已经被修改
@property (nonatomic,assign) BOOL isModify;


-(void)loadIconModelAtIndexPath:(NSIndexPath*)indexPath
                   InImageBoard:(UIImageView *)iconModelImage
                  OriginalPoint:(CGPoint) originalPoint;

@end


@implementation CasePaintViewController

@synthesize IconType=_IconType;
@synthesize IconModelName=_IconModelName;
@synthesize roadModelBoard=_roadModelBoard;
@synthesize paintBoard=_paintBoard;
@synthesize contentScrollView = _contentScrollView;
@synthesize segWidth = _segWidth;
@synthesize pageIndicator = _pageIndicator;
@synthesize caseID=_caseID;
@synthesize textInputPopover=_textInputPopover;
@synthesize iconTypeArray=_iconTypeArray;
@synthesize paintToolsArray=_paintToolsArray;
//@synthesize roadModelID = _roadModelID;

//add by lxm
@synthesize isModify;

#pragma mark - ViewInit

- (void)viewDidLoad{
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"现场勘验图-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];    
    
    self.iconTypeArray=@[@"模版",@"车辆",@"路产",@"绘图", @"说明"];
    self.paintToolsArray=@[@"直线",@"圆",@"矩形",@"点",@"曲线",@"箭头",@"双向箭头",@"虚线",@"护栏",@"草坪",@"文字标识",@"擦除"];
    
    UIFont *segFont = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.segWidth setTitleTextAttributes:attributes 
                                    forState:UIControlStateNormal];
    
    self.roadModelBoard=[[RoadModelBoard alloc] initWithFrame:CGRectMake(0.0f,0.0f, PaintAreaWidth, PaintAreaHeight)];
    self.roadModelBoard.image=nil;
    [self.roadModelBoard setUserInteractionEnabled:NO];
    [self.contentScrollView addSubview:self.roadModelBoard];
    
    self.paintBoard=[[PaintArea alloc] initWithFrame:CGRectMake(0.0f,0.0f, PaintAreaWidth, PaintAreaHeight)];
    self.paintBoard.delegate=self;
    [self.contentScrollView addSubview:self.paintBoard];
    [self.paintBoard setUserInteractionEnabled:NO];
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.IconType selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self.IconModelName reloadData];
    
    self.pageIndicator.numberOfPages=1;

    [super viewDidLoad];
    
 	// Do any additional setup after loading the view.
}

- (void)viewDidUnload{
    [self setIconType:nil];
    [self setIconModelName:nil];
    [self setRoadModelBoard:nil];
    [self setPaintBoard:nil];
    [self setSegWidth:nil];
    [self setPageIndicator:nil];
    [self setContentScrollView:nil];
    [self setCaseID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadCaseMap];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier=segue.identifier;
    if ([segueIdentifier isEqualToString:@"toRemarkTextEdit"]) {
        PaintRemarkTextViewController *prtVC=segue.destinationViewController;
        prtVC.caseID=self.caseID;
    }
}

#pragma mark - IBAction

- (IBAction)btnBack:(id)sender{
    /*
     *modify by lxm 2013.05.13
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"返回案件信息" message:@"当前草图未保存，是否返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];    
    [alert show];
    [alert setDelegate:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate reloadPaint];
     */
    [self.delegate reloadPaint];
    if(isModify)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"返回案件信息" message:@"当前草图未保存，是否返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setDelegate:self];
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//选择画图路面长度20米-120米
- (IBAction)chooseWidth:(id)sender {
    UISegmentedControl *segment=(UISegmentedControl *)sender;
    self.pageIndicator.numberOfPages=segment.selectedSegmentIndex+1;
    NSInteger numberOfPages=[segment titleForSegmentAtIndex:segment.selectedSegmentIndex].integerValue/20;
    
    CGFloat newWidth=numberOfPages*PaintAreaWidth;    
    CGRect newRect=CGRectMake(0, 0, newWidth, PaintAreaHeight);
    self.paintBoard.frame=newRect;
    NSInteger currentPage=self.pageIndicator.currentPage;
    CGRect currentRect;
    currentRect.origin=CGPointMake(currentPage*PaintAreaWidth, 0);
    currentRect.size=self.contentScrollView.frame.size;
    [self.paintBoard setNeedsDisplayInRect:self.contentScrollView.frame];
    self.contentScrollView.contentSize=newRect.size;
    self.roadModelBoard.frame=newRect;
    self.roadModelBoard.image=[self.roadModelBoard image];
}

- (IBAction)btnSave:(UIBarButtonItem *)sender {
    if (![self.caseID isEmpty]) {
        
        //add by lxm 2013.05.13
        isModify=NO;
        
        //dispatch_queue_t myqueue=dispatch_queue_create("PhotoSave", nil);
        //dispatch_async(myqueue, ^(void){
            UIGraphicsBeginImageContext(self.roadModelBoard.frame.size);
            CGRect contextRect = self.roadModelBoard.bounds;
            [self.roadModelBoard.image drawInRect:contextRect];
            [self.paintBoard.layer renderInContext:UIGraphicsGetCurrentContext()];

            UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *data = UIImageJPEGRepresentation(mapImage, 0.6);
            NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath=[pathArray objectAtIndex:0];
            NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
            mapPath=[documentPath stringByAppendingPathComponent:mapPath];
            if (![[NSFileManager defaultManager] fileExistsAtPath:mapPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:mapPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *mapName = @"casemap.jpg";
            NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
            [data writeToFile:filePath atomically:YES];
            CaseMap *casemap = [CaseMap caseMapForCase:self.caseID];
            if (casemap == nil) {
                casemap = [CaseMap newDataObjectWithEntityName:@"CaseMap"];
                casemap.caseinfo_id = self.caseID;
                casemap.map_item = @"";
                CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
                if (caseProveInfo && caseProveInfo.event_desc != nil) {
                    casemap.remark = caseProveInfo.event_desc;
                } else {
                    casemap.remark = [CaseProveInfo generateEventDescForCase:self.caseID];
                }
                
                casemap.road_type = @"沥青";
                casemap.draw_time = [NSDate date];
                NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
                casemap.draftsman_name = [[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
            }
            NSString *itemString = @"";
            NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"CaseMapTemplate" ofType:@"xml"];
            itemString = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
            DDXMLDocument *mapItemDoc = [[DDXMLDocument alloc] initWithXMLString:itemString options:0 error:nil];
            
            DDXMLElement *iconsNode = [[mapItemDoc nodesForXPath:@"/Map/Icons" error:nil] objectAtIndex:0];
            DDXMLElement *foreGroundItemsNode = [[mapItemDoc nodesForXPath:@"/Map/ForeGround/Items" error:nil] objectAtIndex:0];
            DDXMLElement *foreGroundTextsNode = [[mapItemDoc nodesForXPath:@"/Map/ForeGround/Texts" error:nil] objectAtIndex:0];
            DDXMLElement *backGroundNode = [[mapItemDoc nodesForXPath:@"/Map/BackGround" error:nil] objectAtIndex:0];
            DDXMLElement *pageAttri = [DDXMLNode attributeWithName:@"PageWidth" stringValue:[self.segWidth titleForSegmentAtIndex:self.segWidth.selectedSegmentIndex]];
            [backGroundNode addAttribute:pageAttri];
            DDXMLElement *idAttri = (DDXMLElement *)[backGroundNode attributeForName:@"Id"];
            [idAttri setStringValue:self.roadModelBoard.iconModelID];
            if (self.roadModelBoard.iconModelID != nil || ![self.roadModelBoard.iconModelID isEmpty]) {
                IconModels *icon = [IconModels iconModelforID:self.roadModelBoard.iconModelID];
                if (icon) {
                    DDXMLDocument *iconXML = [[DDXMLDocument alloc] initWithXMLString:icon.itemsxml options:0 error:nil];
                    DDXMLElement *itemsElement = [[[iconXML nodesForXPath:@"/Icon/Items" error:nil] lastObject] copy];
                    if (itemsElement == nil) {
                        itemsElement = [DDXMLElement elementWithName:@"Items" stringValue:nil];
                    }
                    DDXMLElement *textsElement = [[[iconXML nodesForXPath:@"/Icon/Texts" error:nil] lastObject] copy];
                    if (textsElement == nil) {
                        textsElement = [DDXMLElement elementWithName:@"Texts" stringValue:nil];
                    }
                    [backGroundNode insertChild:textsElement atIndex:0];
                    [backGroundNode insertChild:itemsElement atIndex:0];
                }
            }
        NSLog(@"subviews=%d",[self.paintBoard.subviews count]);

            for (MoveableImage *moveImage in self.paintBoard.subviews) {
                if ([moveImage isMemberOfClass:[MoveableImage class]]) {
                    NSString *nameString = moveImage.iconModelID;
                    NSString *fontSizeString;
                    if (moveImage.fontSize > 0) {
                        fontSizeString = [NSString stringWithFormat:@"%d",(int)moveImage.fontSize];
                    } else {
                        fontSizeString = nil;
                    }
                    NSString *leftString = [NSString stringWithFormat:@"%d",(int)((moveImage.center.x-moveImage.imageSize.width/2)/zoom)];
                    NSString *topString = [NSString stringWithFormat:@"%d",(int)((moveImage.center.y-moveImage.imageSize.height/2-RoadModelOffSet)/zoom)];
                    NSString *widthString = [NSString stringWithFormat:@"%d",(int)(moveImage.imageSize.width/zoom)];
                    NSString *heightString = [NSString stringWithFormat:@"%d",(int)(moveImage.imageSize.height/zoom)];

                    DDXMLElement *leftAttri = [DDXMLNode attributeWithName:@"Left" stringValue:leftString];
                    DDXMLElement *topAttri = [DDXMLNode attributeWithName:@"Top" stringValue:topString];
                    DDXMLElement *widthAttri = [DDXMLNode attributeWithName:@"Width" stringValue:widthString];
                    DDXMLElement *heightAttri = [DDXMLNode attributeWithName:@"Height" stringValue:heightString];                    
                    DDXMLElement *angleAttri;
                    if (moveImage.rotation >0.00001 || moveImage.rotation < -0.00001) {
                        angleAttri = [DDXMLNode attributeWithName:@"Angle" stringValue:[NSString  stringWithFormat:@"%d",(int)moveImage.rotation]];
                    } else {
                        angleAttri = [DDXMLNode attributeWithName:@"Angle" stringValue:@"0"];
                    }
                    if (moveImage.isText) {
                        DDXMLElement *nameAttri = [DDXMLNode attributeWithName:@"Name" stringValue:nameString];

                        DDXMLElement *fontSizeAttri = [DDXMLNode attributeWithName:@"FontSize" stringValue:fontSizeString];
                        DDXMLElement *textElement = [DDXMLNode elementWithName:@"Text" children:nil attributes:@[nameAttri, fontSizeAttri, leftAttri, topAttri, widthAttri, heightAttri, angleAttri]];
                        [foreGroundTextsNode addChild:textElement];
                    } else {
                        DDXMLElement *idAttri = [DDXMLNode attributeWithName:@"Id" stringValue:nameString];
                        DDXMLElement *typeAttri = [DDXMLNode attributeWithName:@"Type" stringValue:@""];
                        DDXMLElement *nameAttri = [DDXMLNode attributeWithName:@"Name" stringValue:@""];
                        DDXMLElement *percentAttri = [DDXMLNode attributeWithName:@"Percent" stringValue:@"1"];
                        IconModels *icon = [IconModels iconModelforID:moveImage.iconModelID];
                        DDXMLDocument *iconXML = [[DDXMLDocument alloc] initWithXMLString:icon.itemsxml options:0 error:nil];
                        DDXMLElement *itemsElement = [[[iconXML nodesForXPath:@"/Icon/Items" error:nil] lastObject] copy];
                        if (itemsElement == nil) {
                            itemsElement = [DDXMLElement elementWithName:@"Items" stringValue:nil];
                        }
                        DDXMLElement *textsElement = [[[iconXML nodesForXPath:@"/Icon/Texts" error:nil] lastObject] copy];
                        if (textsElement == nil) {
                            textsElement = [DDXMLElement elementWithName:@"Texts" stringValue:nil];
                        }
                        DDXMLElement *iconElement = [DDXMLNode elementWithName:@"Icon" children:@[itemsElement, textsElement] attributes:@[idAttri, typeAttri, nameAttri, leftAttri, topAttri, widthAttri, heightAttri, angleAttri, percentAttri]];
                        [iconsNode addChild:iconElement];
                    }
                }
            }
            for (DWStroke *stroke in self.paintBoard.dwStrokes) {
                NSString *typeString = [[NSString alloc] initWithFormat:@"%d", stroke.pathType];
                DDXMLElement *typeAttri = [DDXMLNode attributeWithName:@"Type" stringValue:typeString];
                NSString *x1String = [[NSString alloc] initWithFormat:@"%f", stroke.p1.x/zoom];
                NSString *y1String = [[NSString alloc] initWithFormat:@"%f", stroke.p1.y/zoom];
                NSString *x2String = [[NSString alloc] initWithFormat:@"%f", stroke.p2.x/zoom];
                NSString *y2String = [[NSString alloc] initWithFormat:@"%f", stroke.p2.y/zoom];
                DDXMLElement *x1Attri = [DDXMLNode attributeWithName:@"X1" stringValue:x1String];
                DDXMLElement *y1Attri = [DDXMLNode attributeWithName:@"Y1" stringValue:y1String];
                DDXMLElement *x2Attri = [DDXMLNode attributeWithName:@"X2" stringValue:x2String];
                DDXMLElement *y2Attri = [DDXMLNode attributeWithName:@"Y2" stringValue:y2String];
                DDXMLElement *itemElement = [DDXMLElement elementWithName:@"IconItem" children:nil attributes:@[typeAttri, x1Attri, y1Attri, x2Attri, y2Attri]];
                [foreGroundItemsNode addChild:itemElement];
            }
            casemap.map_item = [mapItemDoc XMLStringWithOptions:DDXMLNodeCompactEmptyElement];
        NSLog(@"map_Item=%@",casemap.map_item);

            casemap.isuploaded = @(NO);
            [[AppDelegate App] saveContext];
        //});
        //dispatch_release(myqueue);
    }
}
/*
- (IBAction)btnSave:(UIBarButtonItem *)sender {
    isModify=NO;
    
    if (![self.caseID isEmpty]) {
        UIGraphicsBeginImageContext(self.roadModelBoard.frame.size);
        CGRect contextRect = self.roadModelBoard.bounds;
        [self.roadModelBoard.image drawInRect:contextRect];
        [self.paintBoard.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *casemap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *data = UIImageJPEGRepresentation(casemap, 0.6);
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath=[pathArray objectAtIndex:0];
        NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseID];
        mapPath=[documentPath stringByAppendingPathComponent:mapPath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:mapPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:mapPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *mapName = @"casemap.jpg";
        NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        if ([data writeToFile:filePath atomically:YES]) {            
            
            CaseMap *casemap = [CaseMap caseMapForCase:self.caseID];
            if (casemap == nil) {
                casemap = [CaseMap newDataObjectWithEntityName:@"CaseMap"];
                casemap.caseinfo_id = self.caseID;
                casemap.map_item = @"";
                CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
                if (caseProveInfo && caseProveInfo.event_desc != nil) {
                    casemap.remark = caseProveInfo.event_desc;
                } else {
                    casemap.remark = [CaseProveInfo generateEventDescForCase:self.caseID];
                }
                
                casemap.road_type = @"沥青";
                casemap.draw_time = [NSDate date];
                NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
                casemap.draftsman_name = [[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
            }
            
            
            NSString *itemString = @"";
            NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"CaseMapTemplate" ofType:@"xml"];
            itemString = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
            DDXMLDocument *mapItemDoc = [[DDXMLDocument alloc] initWithXMLString:itemString options:0 error:nil];
            
            DDXMLElement *iconsNode = [[mapItemDoc nodesForXPath:@"/Map/Icons" error:nil] objectAtIndex:0];
            DDXMLElement *foreGroundItemsNode = [[mapItemDoc nodesForXPath:@"/Map/ForeGround/Items" error:nil] objectAtIndex:0];
            DDXMLElement *foreGroundTextsNode = [[mapItemDoc nodesForXPath:@"/Map/ForeGround/Texts" error:nil] objectAtIndex:0];
            DDXMLElement *backGroundNode = [[mapItemDoc nodesForXPath:@"/Map/BackGround" error:nil] objectAtIndex:0];
            DDXMLElement *pageAttri = [DDXMLNode attributeWithName:@"PageWidth" stringValue:[self.segWidth titleForSegmentAtIndex:self.segWidth.selectedSegmentIndex]];
            [backGroundNode addAttribute:pageAttri];
            DDXMLElement *idAttri = (DDXMLElement *)[backGroundNode attributeForName:@"Id"];
            [idAttri setStringValue:self.roadModelBoard.iconModelID];
            if (self.roadModelBoard.iconModelID != nil && ![self.roadModelBoard.iconModelID isEmpty]) {
                IconModels *icon = [IconModels iconModelforID:self.roadModelBoard.iconModelID];
                DDXMLDocument *iconXML = [[DDXMLDocument alloc] initWithXMLString:icon.itemsxml options:0 error:nil];
                DDXMLElement *itemsElement = [[[iconXML nodesForXPath:@"/Icon/Items" error:nil] lastObject] copy];
                if (itemsElement == nil) {
                    itemsElement = [DDXMLElement elementWithName:@"Items" stringValue:nil];
                }
                DDXMLElement *textsElement = [[[iconXML nodesForXPath:@"/Icon/Texts" error:nil] lastObject] copy];
                if (textsElement == nil) {
                    textsElement = [DDXMLElement elementWithName:@"Texts" stringValue:nil];
                }
                [backGroundNode insertChild:textsElement atIndex:0];
                [backGroundNode insertChild:itemsElement atIndex:0];
            }
            for (MoveableImage *moveImage in self.paintBoard.subviews) {
                if ([moveImage isMemberOfClass:[MoveableImage class]]) {
                    NSString *nameString = moveImage.iconModelID;
                    NSString *fontSizeString;
                    if (moveImage.fontSize > 0) {
                        fontSizeString = [NSString stringWithFormat:@"%d",(int)moveImage.fontSize];
                    } else {
                        fontSizeString = nil;
                    }
                    NSString *leftString = [NSString stringWithFormat:@"%f",(moveImage.center.x-moveImage.imageSize.width/2)];
                    NSString *topString = [NSString stringWithFormat:@"%f",(moveImage.center.y-moveImage.imageSize.height/2)];
                    NSString *widthString = [NSString stringWithFormat:@"%f",moveImage.imageSize.width];
                    NSString *heightString = [NSString stringWithFormat:@"%f",moveImage.imageSize.height];
                    
                    DDXMLElement *leftAttri = [DDXMLNode attributeWithName:@"Left" stringValue:leftString];
                    DDXMLElement *topAttri = [DDXMLNode attributeWithName:@"Top" stringValue:topString];
                    DDXMLElement *widthAttri = [DDXMLNode attributeWithName:@"Width" stringValue:widthString];
                    DDXMLElement *heightAttri = [DDXMLNode attributeWithName:@"Height" stringValue:heightString];
                    DDXMLElement *angleAttri;
                    if (moveImage.rotation >0.01 || moveImage.rotation < -0.01) {
                        angleAttri = [DDXMLNode attributeWithName:@"Angle" stringValue:[NSString  stringWithFormat:@"%f",moveImage.rotation]];
                    } else {
                        angleAttri = [DDXMLNode attributeWithName:@"Angle" stringValue:@"0"];
                    }
                    if (moveImage.isText) {
                        DDXMLElement *nameAttri = [DDXMLNode attributeWithName:@"Name" stringValue:nameString];
                        
                        DDXMLElement *fontSizeAttri = [DDXMLNode attributeWithName:@"FontSize" stringValue:fontSizeString];
                        DDXMLElement *textElement = [DDXMLNode elementWithName:@"Text" children:nil attributes:@[nameAttri, fontSizeAttri, leftAttri, topAttri, widthAttri, heightAttri, angleAttri]];
                        [foreGroundTextsNode addChild:textElement];
                    } else {
                        DDXMLElement *idAttri = [DDXMLNode attributeWithName:@"Id" stringValue:nameString];
                        DDXMLElement *typeAttri = [DDXMLNode attributeWithName:@"Type" stringValue:@""];
                        DDXMLElement *nameAttri = [DDXMLNode attributeWithName:@"Name" stringValue:@""];
                        DDXMLElement *percentAttri = [DDXMLNode attributeWithName:@"Percent" stringValue:@"1"];
                        IconModels *icon = [IconModels iconModelforID:moveImage.iconModelID];
                        DDXMLDocument *iconXML = [[DDXMLDocument alloc] initWithXMLString:icon.itemsxml options:0 error:nil];
                        DDXMLElement *itemsElement = [[[iconXML nodesForXPath:@"/Icon/Items" error:nil] lastObject] copy];
                        if (itemsElement == nil) {
                            itemsElement = [DDXMLElement elementWithName:@"Items" stringValue:nil];
                        }
                        DDXMLElement *textsElement = [[[iconXML nodesForXPath:@"/Icon/Texts" error:nil] lastObject] copy];
                        if (textsElement == nil) {
                            textsElement = [DDXMLElement elementWithName:@"Texts" stringValue:nil];
                        }
                        DDXMLElement *iconElement = [DDXMLNode elementWithName:@"Icon" children:@[itemsElement, textsElement] attributes:@[idAttri, typeAttri, nameAttri, leftAttri, topAttri, widthAttri, heightAttri, angleAttri, percentAttri]];
                        [iconsNode addChild:iconElement];
                    }
                }
            }
            for (DWStroke *stroke in self.paintBoard.dwStrokes) {
                NSString *typeString = [[NSString alloc] initWithFormat:@"%d", stroke.pathType];
                DDXMLElement *typeAttri = [DDXMLNode attributeWithName:@"Type" stringValue:typeString];
                NSString *x1String = [[NSString alloc] initWithFormat:@"%f", stroke.p1.x];
                NSString *y1String = [[NSString alloc] initWithFormat:@"%f", stroke.p1.y];
                NSString *x2String = [[NSString alloc] initWithFormat:@"%f", stroke.p2.x];
                NSString *y2String = [[NSString alloc] initWithFormat:@"%f", stroke.p2.y];
                DDXMLElement *x1Attri = [DDXMLNode attributeWithName:@"X1" stringValue:x1String];
                DDXMLElement *y1Attri = [DDXMLNode attributeWithName:@"Y1" stringValue:y1String];
                DDXMLElement *x2Attri = [DDXMLNode attributeWithName:@"X2" stringValue:x2String];
                DDXMLElement *y2Attri = [DDXMLNode attributeWithName:@"Y2" stringValue:y2String];
                DDXMLElement *itemElement = [DDXMLElement elementWithName:@"IconItem" children:nil attributes:@[typeAttri, x1Attri, y1Attri, x2Attri, y2Attri]];
                [foreGroundItemsNode addChild:itemElement];
            }
            casemap.map_item = [mapItemDoc XMLStringWithOptions:DDXMLNodeCompactEmptyElement];
            [[AppDelegate App] saveContext];
        }
    }
}
 */
#pragma mark - CasePaint Delegate

//当手指移动到边缘时自动换页
-(void)autoScrollPage:(CGFloat)offset{
    [self.contentScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

-(NSInteger)getCurrentPageDelegate{
    return self.pageIndicator.currentPage;
}

-(CGFloat)getCurrentContentSize{
    return self.contentScrollView.contentSize.width;
}

-(void)addMoveTextInRect:(CGRect)rect{
    TextInputViewController *textInputVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TextInputView"];
    textInputVC.view.frame=CGRectMake(self.contentScrollView.frame.origin.x+self.contentScrollView.frame.size.width/2-200, self.contentScrollView.frame.origin.y,400, 240);
    textInputVC.delegate=self;
    textInputVC.rectPresentFrom=rect;
    self.textInputPopover=[[UIPopoverController alloc] initWithContentViewController:textInputVC];
    
    [self.textInputPopover presentPopoverFromRect:[self.view convertRect:rect fromView:self.paintBoard] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    textInputVC.popover=self.textInputPopover;
}

#pragma mark - TextInput Delegate
-(void)inputString:(NSString *)text fontSize:(CGFloat)fontSize inRect:(CGRect)rect{
    MoveableImage *moveableImage=[[MoveableImage alloc] initWithFrame:rect];
    [moveableImage setUserInteractionEnabled:NO];
    moveableImage.image=nil;
    CGFloat drawFontSize;
    if (fontSize <= 0) {
        drawFontSize=21.0;
    } else {
        drawFontSize=fontSize;
    }
    UIFont *myFont=[UIFont fontWithName:@"STHeitiSC-Light" size:drawFontSize];
    CGSize actualSize=[text sizeWithFont:myFont constrainedToSize:CGSizeMake(rect.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    moveableImage.frame=CGRectMake(rect.origin.x, rect.origin.y, actualSize.width, actualSize.height);
    UIGraphicsBeginImageContext(actualSize);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [BRUSHCOLOR CGColor]);
    CGContextSetStrokeColorWithColor(context, [BRUSHCOLOR CGColor]);
    CGContextSetLineWidth(context, 2.0);
    [text drawInRect:CGRectMake(0, 0, actualSize.width, actualSize.height) withFont:myFont];
    moveableImage.image=UIGraphicsGetImageFromCurrentImageContext();
    moveableImage.iconModelID = text;
    moveableImage.isText = YES;
    moveableImage.imageSize = actualSize;
    moveableImage.fontSize = floorf(drawFontSize/FontSizeScaleFactor/zoom);
    UIGraphicsEndImageContext();
    
    [self.paintBoard insertSubview:moveableImage atIndex:0];
    [self.textInputPopover dismissPopoverAnimated:YES];
}

#pragma mark - UIScrollView Delegate

//scrollview Delegate，scrollview的拖动事件，在拖动时，在pageIndicator上显示当前页面数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageIndicator.currentPage = page;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITablView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows=0;
    switch (tableView.tag) {
        case 1:
            numberOfRows=self.iconTypeArray.count;
            break;
        case 2:{        
            switch (selectedType) {
                case 0:
                case 1:                
                case 2:{
                    NSString *type=[self.iconTypeArray objectAtIndex:selectedType];
                    NSMutableArray *icons=[[AppDelegate App] getIconInfoByType:type];
                    numberOfRows=icons.count;
                }                       
                    break;        
                case 3:
                    numberOfRows=self.paintToolsArray.count;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (tableView.tag) {
        case 1:
            //选择tableView,1对应选择大类，对应selectedType
        {
            static NSString *CellIdentifier = @"IconTypeCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"勘验左栏按钮" ofType:@"png"];
            UIImage *selectedBackImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
            UIImageView *backView=[[UIImageView alloc] initWithFrame:cell.frame];
            backView.image=selectedBackImage;
            cell.selectedBackgroundView=backView;
            cell.textLabel.text=[self.iconTypeArray objectAtIndex:indexPath.row];
        }    
            break;
        case 2:
            //1对应选择具体工具，对应selectedTool
        {    
            static NSString *CellIdentifier = @"Cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            switch (selectedType) {
                case 0:
                case 1:                
                case 2:{
                    NSString *seleType=[self.iconTypeArray objectAtIndex:selectedType];
                    NSMutableArray *icons=[[AppDelegate App] getIconInfoByType:seleType];
                    IconModels *iconModel=[icons objectAtIndex:indexPath.row];
                    cell.textLabel.text=iconModel.iconname;                    
                }                       
                    break;
               case 3:
                    cell.textLabel.text=[self.paintToolsArray objectAtIndex:indexPath.row];
                    break;                    
                default:
                        break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 1:{
            selectedType=indexPath.row;
            [self.IconModelName reloadData];
            selectedTool=-1;
            self.paintBoard.selectedTool=selectedTool;
            self.paintBoard.selectedType=selectedType;
            for (MoveableImage * moveImage in self.paintBoard.subviews) {
                if ([moveImage isMemberOfClass:[MoveableImage class]]) {
                    [moveImage setUserInteractionEnabled:YES];
                }                            
            }
            if (selectedType==4) {
                [self performSegueWithIdentifier:@"toRemarkTextEdit" sender:nil];
            }
        }
            break;
        case 2:{
            switch (selectedType) {
                case 0:
                {   
                    self.roadModelBoard.image=nil;
                    [self loadIconModelAtIndexPath:indexPath InImageBoard:self.roadModelBoard OriginalPoint:CGPointMake(0.0f,38.0f)];
                }
                    break;
                case 1:
                case 2:{
                    selectedTool=indexPath.row;
                    self.paintBoard.selectedTool=indexPath.row;
                    [self.paintBoard setUserInteractionEnabled:YES];
                    CGRect moveableRect=CGRectMake(self.paintBoard.frame.origin.x, self.paintBoard.frame.origin.y, 0.0f,0.0f);
                    MoveableImage *moveableIconImage=[[MoveableImage alloc] initWithFrame:moveableRect];
                    moveableIconImage.image=nil;
                    moveableIconImage.delegate=self;
                    moveableIconImage.isText = NO;
                    [self.paintBoard insertSubview:moveableIconImage atIndex:0];
                    [moveableIconImage setUserInteractionEnabled:YES];
                    [self.paintBoard setUserInteractionEnabled:YES];
                    [self loadIconModelAtIndexPath:indexPath InImageBoard:moveableIconImage OriginalPoint:CGPointMake(self.contentScrollView.bounds.size.width*0.4+self.contentScrollView.contentOffset.x, self.contentScrollView.bounds.size.height*0.4)];
                }
                    break;
                case 3:{
                    if (selectedTool!=indexPath.row){
                        selectedTool=indexPath.row;
                        self.paintBoard.selectedTool=indexPath.row;
                        [self.paintBoard setUserInteractionEnabled:YES];
                        for (MoveableImage * moveImage in self.paintBoard.subviews) {
                            if ([moveImage isMemberOfClass:[MoveableImage class]]) {
                                [moveImage setUserInteractionEnabled:NO];
                            }                            
                        }
                    }
                }
                    break;

                default:
                    break;
            }
        }
        default:
            break;
    }    
}

#pragma mark - Class Methods

-(void)loadIconModelAtIndexPath:(NSIndexPath*)indexPath
                   InImageBoard:(UIImageView *)iconModelImage
                  OriginalPoint:(CGPoint)originalPoint
{
    //add by lxm
    isModify=YES;
    
    UITableViewCell *selectedCell=[self.IconModelName cellForRowAtIndexPath:indexPath];
    NSString *iconName=selectedCell.textLabel.text;
    NSMutableArray *data=[[AppDelegate App] getIconInfoByName:iconName];
    if (data.count>0) {
        IconModels *model=[data lastObject];
        if (model != nil) {
            CGFloat imageRectWidth  = [model.iconwidth  floatValue]*zoom;

            [(id)iconModelImage setIconModelID:model.iconid];
            CGFloat imageRectHeight = [model.iconheight floatValue]*zoom;
            CGRect  imageRect=CGRectMake(originalPoint.x, originalPoint.y, imageRectWidth, imageRectHeight);
            
            CGFloat widthOfBackGround;
            if (![iconModelImage isMemberOfClass:[MoveableImage class]]) {
                widthOfBackGround=PaintAreaWidth*[self.segWidth titleForSegmentAtIndex:self.segWidth.selectedSegmentIndex].integerValue/20;
            } else {
                widthOfBackGround=-1.0;
                [(id)iconModelImage setImageSize:imageRect.size];
            }
            
            if (imageRectWidth < 200 || imageRectHeight < 50) {
                if (imageRectWidth<110) {
                    iconModelImage.frame=CGRectMake(originalPoint.x, originalPoint.y, imageRectWidth+100, imageRectHeight+30);
                } else {
                    iconModelImage.frame=CGRectMake(originalPoint.x, originalPoint.y, imageRectWidth+40, imageRectHeight+20);
                }
            } else {
                iconModelImage.frame=imageRect;
            }
            
            UIGraphicsBeginImageContext(imageRect.size);
            CGContextRef context=UIGraphicsGetCurrentContext();
            [iconModelImage setContentMode:UIViewContentModeCenter];
            NSMutableArray *imageStrokes=[[NSMutableArray alloc] initWithCapacity:1];
            if (model.items != nil) {
                NSSet *iconItems=model.items;
                for (IconItems *item in iconItems) {
                    CGPoint point1,point2;
                    point1.x=item.itemx1.floatValue*zoom;
                    point1.y=item.itemy1.floatValue*zoom;
                    point2.x=item.itemx2.floatValue*zoom;
                    point2.y=item.itemy2.floatValue*zoom;                    
                    DWStroke *stroke=[[DWStroke alloc] init];
                    stroke.path=[UIBezierPath bezierPath];      
                    stroke.isErasing=NO;
                    stroke.path.lineWidth=2.0;
                    stroke.brushColor=BRUSHCOLOR;
                    [imageStrokes addObject:stroke];
                    if ([item.itemtype isEqualToString:@"0"]) {
                        //直线
                        [stroke addLineP1:point1 P2:point2];
                    }
                    if ([item.itemtype isEqualToString:@"1"]) {
                        //圆
                        point2.x=(item.itemx1.floatValue+item.itemx2.floatValue)*zoom;
                        point2.y=(item.itemy1.floatValue+item.itemy2.floatValue)*zoom; 
                        [stroke addEllipseP1:point1 P2:point2];
                    }
                    if ([item.itemtype isEqualToString:@"2"]) {
                        //矩形
                        point2.x=(item.itemx1.floatValue+item.itemx2.floatValue)*zoom;
                        point2.y=(item.itemy1.floatValue+item.itemy2.floatValue)*zoom; 
                        [stroke addRectangleP1:point1 P2:point2 ];
                    }
                    if ([item.itemtype isEqualToString:@"3"]) {
                        //点
                        [stroke addDotAtP1:point1];
                    }
                    if ([item.itemtype isEqualToString:@"5"]) {
                        //箭头
                        [stroke addArrowP1:point1 P2:point2 ];
                    }
                    if ([item.itemtype isEqualToString:@"6"]) {
                        //双向箭头
                        [stroke addDoubleArrowP1:point1 P2:point2];
                    }
                    if ([item.itemtype isEqualToString:@"7"]) {
                        //虚线
                        [stroke addDashLineP1:point1 P2:point2 ];
                    }
                    if ([item.itemtype isEqualToString:@"8"]) {
                        //护栏
                        [stroke addGuardRailP1:point1 P2:point2 ];
                    }
                    if ([item.itemtype isEqualToString:@"9"]) {
                        //草坪
                        point2.x=(item.itemx1.floatValue+item.itemx2.floatValue)*zoom;
                        point2.y=(item.itemy1.floatValue+item.itemy2.floatValue)*zoom; 
                        [stroke addGrassP1:point1 P2:point2 ];
                    }            
                }                       
            }
            for (DWStroke *stroke in imageStrokes) {
                [stroke draw];
            }
            CGContextSetFillColorWithColor(context, [BRUSHCOLOR CGColor]);
            if (model.texts != nil) {
                NSSet *iconTexts=model.texts;
                for (IconTexts *text in iconTexts) {
                    CGPoint p0;
                    if (text.textleft.floatValue < 0) {
                        p0.x = 2*zoom;
                    } else {
                        p0.x=[text.textleft floatValue]*zoom;
                    }                    
                    p0.y=[text.texttop  floatValue]*zoom;
                    CGFloat textWidth   =[text.textwidth  floatValue]*zoom;
                    CGFloat textHeight  =[text.textHeight floatValue]*zoom;
                    CGRect textRect=CGRectMake(p0.x, p0.y, textWidth, textHeight);
                    CGFloat fontSize= floorf(FontSizeScaleFactor*[text.textfontsize floatValue]*zoom);
                    [text.textname drawInRect:textRect withFont:[UIFont fontWithName:@"STHeitiSC-Light" size:fontSize]];
                } 
            } 
            if (widthOfBackGround>0) {
                CGRect rectOfImageBoard=CGRectMake(0, 0, widthOfBackGround, PaintAreaHeight);
                iconModelImage.frame=rectOfImageBoard;
            }
            iconModelImage.image=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [imageStrokes removeAllObjects];
            if ([iconModelImage isMemberOfClass:[MoveableImage class]]) {
                if (selectedType==3 && selectedTool==10) {
                    [(MoveableImage *)iconModelImage setIconModelID:@"Text"]; 
                } else {
                    [(MoveableImage *)iconModelImage setIconModelID:model.iconid]; 
                }
            }
        }
    }
}

//载入图形
- (void)loadCaseMap{
    if (![self.caseID isEmpty]) {
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        if (caseMap.map_item && ![caseMap.map_item isEmpty]) {
            DDXMLDocument *rootNode = [[DDXMLDocument alloc] initWithXMLString:caseMap.map_item options:0 error:nil];
            
            DDXMLNode *pageWidthElement = [[[rootNode nodesForXPath:@"/Map/BackGround" error:nil] objectAtIndex:0] attributeForName:@"PageWidth"];
            DDXMLNode *idAttri = [[[rootNode nodesForXPath:@"/Map/BackGround" error:nil] objectAtIndex:0] attributeForName:@"Id"];
            self.roadModelBoard.iconModelID = idAttri.stringValue;
            [self.segWidth setSelectedSegmentIndex:pageWidthElement.stringValue.integerValue/20-1];
            [self chooseWidth:self.segWidth];
            
            NSArray *backGroundItemsArray = [rootNode nodesForXPath:@"/Map/BackGround/Items/IconItem" error:nil];
            NSArray *backGroundTextsArray = [rootNode nodesForXPath:@"/Map/BackGround/Texts/Text" error:nil];
            if (backGroundItemsArray.count > 0 || backGroundTextsArray.count > 0) {
                UIGraphicsBeginImageContext(CGSizeMake(PaintAreaWidth, ModelHeight));
                CGContextRef context=UIGraphicsGetCurrentContext();
                @autoreleasepool {
                    NSMutableArray *imageStrokes=[[NSMutableArray alloc] initWithCapacity:1];
                    for (DDXMLElement *item in backGroundItemsArray) {
                        CGPoint point1,point2;
                        point1.x = [item attributeForName:@"X1"].stringValue.floatValue * zoom;
                        point1.y = [item attributeForName:@"Y1"].stringValue.floatValue * zoom;
                        point2.x = [item attributeForName:@"X2"].stringValue.floatValue * zoom;
                        point2.y = [item attributeForName:@"Y2"].stringValue.floatValue * zoom;
                        NSInteger itemType = [item attributeForName:@"Type"].stringValue.integerValue;
                        DWStroke *stroke=[[DWStroke alloc] init];
                        [stroke addPathWithType:itemType P1:point1 P2:point2];
                        [imageStrokes addObject:stroke];
                    }
                    for (DWStroke *stroke in imageStrokes) {
                        [stroke draw];
                    }
                }
                
                CGContextSetFillColorWithColor(context, [BRUSHCOLOR CGColor]);
                for (DDXMLElement *text in backGroundTextsArray) {
                    CGPoint p0;
                    CGFloat textLeft = [text attributeForName:@"Left"].stringValue.floatValue * zoom;
                    CGFloat textTop = [text attributeForName:@"Top"].stringValue.floatValue * zoom;
                    CGFloat textWidth = [text attributeForName:@"Width"].stringValue.floatValue * zoom;
                    CGFloat textHeight = [text attributeForName:@"Height"].stringValue.floatValue * zoom;
                    CGFloat fontSize = floorf(FontSizeScaleFactor*[text attributeForName:@"FontSize"].stringValue.floatValue*zoom);
                    if (textLeft < 0) {
                        p0.x = 2 * zoom;
                    } else {
                        p0.x = textLeft;
                    }
                    p0.y = textTop;
                    CGRect textRect=CGRectMake(p0.x, p0.y, textWidth, textHeight);
                    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
                    [[text attributeForName:@"Name"].stringValue drawInRect:textRect withFont:font];
                }
                [self.roadModelBoard setImage:UIGraphicsGetImageFromCurrentImageContext()];
                UIGraphicsEndImageContext();
            }
            
            DDXMLNode *foreGroundNode = [[rootNode nodesForXPath:@"/Map/ForeGround" error:nil] objectAtIndex:0];
            NSArray *foreGroundItemsArray = [foreGroundNode nodesForXPath:@"Items/IconItem" error:nil];
            [self.paintBoard.dwStrokes removeAllObjects];
            for (DDXMLElement *item in foreGroundItemsArray) {
                CGPoint point1,point2;
                point1.x = [item attributeForName:@"X1"].stringValue.floatValue *zoom;
                point1.y = [item attributeForName:@"Y1"].stringValue.floatValue *zoom;
                point2.x = [item attributeForName:@"X2"].stringValue.floatValue *zoom;
                point2.y = [item attributeForName:@"Y2"].stringValue.floatValue *zoom;
                NSInteger itemType = [item attributeForName:@"Type"].stringValue.integerValue;
                DWStroke *stroke=[[DWStroke alloc] init];
                [stroke addPathWithType:itemType P1:point1 P2:point2];
                [self.paintBoard.dwStrokes addObject:stroke];
            }
            [self.paintBoard setNeedsDisplayInRect:self.contentScrollView.frame];
            NSArray *foreGroundTextsArray = [foreGroundNode nodesForXPath:@"Texts/Text" error:nil];
            for (DDXMLElement *text in foreGroundTextsArray) {
                CGFloat textLeft = [text attributeForName:@"Left"].stringValue.floatValue *zoom;
                CGFloat textTop = [text attributeForName:@"Top"].stringValue.floatValue *zoom;
                CGFloat textWidth = [text attributeForName:@"Width"].stringValue.floatValue *zoom;
                CGFloat textHeight = [text attributeForName:@"Height"].stringValue.floatValue *zoom ;
                CGFloat fontSize = floorf(FontSizeScaleFactor*[text attributeForName:@"FontSize"].stringValue.floatValue*zoom);
                NSString *textString = [text attributeForName:@"Name"].stringValue;
                [self inputString:textString fontSize:fontSize inRect:CGRectMake(textLeft, textTop, textWidth, textHeight)];
            }
            NSArray *iconsArray = [rootNode nodesForXPath:@"/Map/Icons/Icon" error:nil];
            for (DDXMLElement *icon in iconsArray) {
                CGFloat iconLeft = [icon attributeForName:@"Left"].stringValue.floatValue *zoom;
                CGFloat iconTop = [icon attributeForName:@"Top"].stringValue.floatValue *zoom;
                CGFloat iconWidth = [icon attributeForName:@"Width"].stringValue.floatValue *zoom;
                CGFloat iconHeight = [icon attributeForName:@"Height"].stringValue.floatValue *zoom;
                NSString *iconID = [icon attributeForName:@"Id"].stringValue;
                CGPoint iconCenter = CGPointMake(iconLeft + iconWidth/2, iconTop + iconHeight/2);
                
                CGRect iconFrame;
                if (iconWidth < 200 || iconHeight < 50) {
                    if (iconWidth<110) {
                        iconFrame = CGRectMake(iconCenter.x - (iconWidth+100)/2, iconCenter.y - (iconHeight+30)/2, iconWidth+100, iconHeight+30);
                    } else {
                        iconFrame = CGRectMake(iconCenter.x - (iconWidth+40)/2, iconCenter.y - (iconHeight+20)/2, iconWidth+40, iconHeight+20);
                    }
                } else {
                    iconFrame = CGRectMake(iconLeft , iconTop, iconWidth, iconHeight);
                }
                
                MoveableImage *iconModelImage=[[MoveableImage alloc] initWithFrame:iconFrame];
                iconModelImage.image=nil;
                iconModelImage.delegate=self;
                iconModelImage.isText = NO;
                [iconModelImage setIconModelID:iconID];
                [iconModelImage setImageSize:CGSizeMake(iconWidth, iconHeight)];
                [iconModelImage setContentMode:UIViewContentModeCenter];
                [self.paintBoard insertSubview:iconModelImage atIndex:0];
                
                UIGraphicsBeginImageContext(CGSizeMake(iconWidth, iconHeight));
                CGContextRef context=UIGraphicsGetCurrentContext();
                
                @autoreleasepool {
                    NSMutableArray *imageStrokes=[[NSMutableArray alloc] initWithCapacity:1];
                    NSArray *iconItemsArray = [icon nodesForXPath:@"Items/IconItem" error:nil];
                    for (DDXMLElement *item in iconItemsArray) {
                        CGPoint point1,point2;
                        point1.x = [item attributeForName:@"X1"].stringValue.floatValue * zoom;
                        point1.y = [item attributeForName:@"Y1"].stringValue.floatValue * zoom;
                        point2.x = [item attributeForName:@"X2"].stringValue.floatValue * zoom;
                        point2.y = [item attributeForName:@"Y2"].stringValue.floatValue * zoom;
                        NSInteger itemType = [item attributeForName:@"Type"].stringValue.integerValue;
                        DWStroke *stroke=[[DWStroke alloc] init];
                        [stroke addPathWithType:itemType P1:point1 P2:point2];
                        [imageStrokes addObject:stroke];
                    }
                    for (DWStroke *stroke in imageStrokes) {
                        [stroke draw];
                    }
                }
                
                CGContextSetFillColorWithColor(context, [BRUSHCOLOR CGColor]);
                NSArray *iconTextsArray = [icon nodesForXPath:@"Texts/Text" error:nil];
                for (DDXMLElement *text in iconTextsArray) {
                    CGPoint p0;
                    CGFloat textLeft = [text attributeForName:@"Left"].stringValue.floatValue * zoom;
                    CGFloat textTop = [text attributeForName:@"Top"].stringValue.floatValue * zoom;
                    CGFloat textWidth = [text attributeForName:@"Width"].stringValue.floatValue * zoom;
                    CGFloat textHeight = [text attributeForName:@"Height"].stringValue.floatValue * zoom;
                    CGFloat fontSize = floorf(FontSizeScaleFactor*[text attributeForName:@"FontSize"].stringValue.floatValue*zoom);
                    if (textLeft < 0) {
                        p0.x = 2 * zoom;
                    } else {
                        p0.x = textLeft;
                    }
                    p0.y = textTop;
                    CGRect textRect=CGRectMake(p0.x, p0.y, textWidth, textHeight);
                    UIFont *font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize];
                    [[text attributeForName:@"Name"].stringValue drawInRect:textRect withFont:font];
                }
                [iconModelImage setImage:UIGraphicsGetImageFromCurrentImageContext()];
                UIGraphicsEndImageContext();
                
                CGFloat rotation = [icon attributeForName:@"Angle"].stringValue.floatValue;
                if (rotation > 0.01 || rotation < -0.01) {
                    iconModelImage.transform = CGAffineTransformRotate(iconModelImage.transform, rotation/180*M_PI);
                    iconModelImage.rotation = rotation;
                } else {
                    iconModelImage.rotation = 0;
                }
            }
            for (MoveableImage *moveImage in self.paintBoard.subviews) {
                if ([moveImage isMemberOfClass:[MoveableImage class]]) {
                    [moveImage setUserInteractionEnabled:YES];
                }
            }
            [self.paintBoard setUserInteractionEnabled:YES];
        }
    }
}

@end
