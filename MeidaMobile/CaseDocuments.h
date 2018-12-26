//
//  CaseDocuments.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CaseInfo.h"

//记录生成文件的名字及路径
@interface CaseDocuments : NSManagedObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * document_name;
@property (nonatomic, retain) NSString * document_path;

+ (NSArray *)allDocumentShortNamesForCaseTypeID:(NSString *)caseTypeID;
+ (NSArray *)allDocumentFullNamesForCaseTypeID:(NSString *)caseTypeID;
+(NSArray *)caseDocumentsForCase:(NSString *)caseID docName:(NSString *)docName;
+ (BOOL)isExistingDocumentForCase:(NSString *)caseID docPath:(NSString *)docPath;
+ (void)deleteDocumentsForCase:(NSString *)caseID docName:(NSString *)docName;
@end
