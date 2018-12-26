//
//  InitIconModel.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitIconModel.h"
#import "TBXML.h"
#import "IconModels.h"
#import "IconItems.h"
#import "IconTexts.h"

@implementation InitIconModel

-(void)downLoadIconModels{
    WebServiceInit;
    [service downloadDataSet:@"select * from Icon"];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"IconModels"];
    [[AppDelegate App] clearEntityForName:@"IconTexts"];
    [[AppDelegate App] clearEntityForName:@"IconItems"];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    
    TBXMLElement *r1 = [TBXML childElementNamed:@"DownloadDataSetResponse" parentElement:rf];
    TBXMLElement *r2 = [TBXML childElementNamed:@"DownloadDataSetResult" parentElement:r1];
    TBXMLElement *r3 = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:r2];
    TBXMLElement *r4 = [TBXML childElementNamed:@"NewDataSet" parentElement:r3];
    
    TBXMLElement *author=[TBXML childElementNamed:@"Table" parentElement:r4];
    //递归读Icon表中的Items内容
    while (author) {
        TBXMLElement *items=[TBXML childElementNamed:@"items" parentElement:author];
        @autoreleasepool {
            if (items!=nil) {
                NSString *itemsContent=[TBXML textForElement:items];
                itemsContent=[self stringToXMLNormalized:itemsContent];                
                
                TBXML *tbxmlItems=[TBXML newTBXMLWithXMLString:itemsContent error:&error];
                TBXMLElement *rootIcon=tbxmlItems.rootXMLElement;
                NSString *iconID    =[TBXML valueOfAttributeNamed:@"Id"     forElement:rootIcon];
                NSString *iconType  =[TBXML valueOfAttributeNamed:@"Type"   forElement:rootIcon];
                NSString *iconName  =[TBXML valueOfAttributeNamed:@"Name"   forElement:rootIcon];
                NSString *iconLeft  =[TBXML valueOfAttributeNamed:@"Left"   forElement:rootIcon];
                NSString *iconTop   =[TBXML valueOfAttributeNamed:@"Top"    forElement:rootIcon];
                NSString *iconWidth =[TBXML valueOfAttributeNamed:@"Width"  forElement:rootIcon];
                NSString *iconHeight=[TBXML valueOfAttributeNamed:@"Height" forElement:rootIcon];
                NSString *iconAngle =[TBXML valueOfAttributeNamed:@"Angle"  forElement:rootIcon];
                //递归读Item内XML文件中Icon下Items内的坐标属性
                TBXMLElement *rootItems=[TBXML childElementNamed:@"Items" parentElement:rootIcon];
                TBXMLElement *xmlIconItems=[TBXML childElementNamed:@"IconItem" parentElement:rootItems];
                NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
                NSEntityDescription *modelsEntity=[NSEntityDescription entityForName:@"IconModels" inManagedObjectContext:entitySaveContext];
                IconModels *iconModel=[[IconModels alloc] initWithEntity:modelsEntity insertIntoManagedObjectContext:entitySaveContext];
                
                iconModel.itemsxml = itemsContent;
                
                iconModel.iconid=iconID;
                [iconModel setValue:iconType   forKey:@"icontype"];
                [iconModel setValue:iconName   forKey:@"iconname"];
                [iconModel setValue:iconLeft   forKey:@"iconleft"];
                [iconModel setValue:iconTop    forKey:@"icontop"];
                [iconModel setValue:iconWidth  forKey:@"iconwidth"];
                [iconModel setValue:iconHeight forKey:@"iconheight"];
                iconModel.iconangle=iconAngle;
                while (xmlIconItems) {
                    @autoreleasepool {
                        NSString *itemType=[TBXML valueOfAttributeNamed:@"Type" forElement:xmlIconItems];
                        NSString *itemX1  =[TBXML valueOfAttributeNamed:@"X1"   forElement:xmlIconItems];
                        NSString *itemY1  =[TBXML valueOfAttributeNamed:@"Y1"   forElement:xmlIconItems];
                        NSString *itemX2  =[TBXML valueOfAttributeNamed:@"X2"   forElement:xmlIconItems];
                        NSString *itemY2  =[TBXML valueOfAttributeNamed:@"Y2"   forElement:xmlIconItems];
                        NSEntityDescription *itemsEntity=[NSEntityDescription entityForName:@"IconItems" inManagedObjectContext:entitySaveContext];
                        IconItems *iconItem=[[IconItems alloc] initWithEntity:itemsEntity insertIntoManagedObjectContext:entitySaveContext];
                        iconItem.itemtype=itemType;
                        iconItem.itemx1=[[NSNumber alloc] initWithFloat:[itemX1 floatValue]];
                        iconItem.itemy1=[[NSNumber alloc] initWithFloat:[itemY1 floatValue]];
                        iconItem.itemx2=[[NSNumber alloc] initWithFloat:[itemX2 floatValue]];
                        iconItem.itemy2=[[NSNumber alloc] initWithFloat:[itemY2 floatValue]];
                        [iconItem setValue:iconModel forKey:@"model"];
                        [iconModel addItemsObject:iconItem];
                    }
                    xmlIconItems=xmlIconItems->nextSibling;
                }
                //递归读Item内XML文件中Icon下Texts内的文字信息
                TBXMLElement *rootTexts=[TBXML childElementNamed:@"Texts" parentElement:rootIcon];
                if (rootTexts != nil) {
                    TBXMLElement *iconText=[TBXML childElementNamed:@"Text" parentElement:rootTexts];
                    while (iconText) {
                        @autoreleasepool {
                            NSString *textName    = [TBXML valueOfAttributeNamed:@"Name"     forElement:iconText];
                            NSString *textFontSize= [TBXML valueOfAttributeNamed:@"FontSize" forElement:iconText];
                            NSString *textLeft    = [TBXML valueOfAttributeNamed:@"Left"     forElement:iconText];
                            NSString *textTop     = [TBXML valueOfAttributeNamed:@"Top"      forElement:iconText];
                            NSString *textWidth   = [TBXML valueOfAttributeNamed:@"Width"    forElement:iconText];
                            NSString *textHeight  = [TBXML valueOfAttributeNamed:@"Height"   forElement:iconText];
                            NSEntityDescription *textsEntity=[NSEntityDescription entityForName:@"IconTexts" inManagedObjectContext:entitySaveContext];
                            IconTexts *iconText=[[IconTexts alloc] initWithEntity:textsEntity insertIntoManagedObjectContext:entitySaveContext];
                            iconText.textname    = textName;
                            iconText.textfontsize= textFontSize;
                            iconText.textleft    = textLeft;
                            iconText.texttop     = textTop;
                            iconText.textwidth   = textWidth;
                            iconText.textHeight  = textHeight;
                            iconText.model       = iconModel;
                            [iconModel addTextsObject:iconText];
                        } 
                        iconText=iconText->nextSibling;
                    }
                } else {
                    [iconModel setNilValueForKey:@"texts"];
                }
            }
            [[AppDelegate App] saveContext];
        }
        author=author->nextSibling;
    }
}

//服务端返回XML字符串调整
-(NSString *)stringToXMLNormalized:(NSString *) inString;{
    if (inString != nil) {
        inString=[inString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
        inString=[inString stringByReplacingOccurrencesOfString:@"&#xd;" withString:@""];
        inString=[inString stringByReplacingOccurrencesOfString:@"\r"    withString:@""];
        inString=[inString stringByReplacingOccurrencesOfString:@"\n"    withString:@""];
        inString=[inString stringByReplacingOccurrencesOfString:@"  "    withString:@""];
        inString=[inString stringByReplacingOccurrencesOfString:@"?<?"   withString:@"<?"];
        inString=[inString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        return inString;
    } else {
        return nil;
    }
}

@end
