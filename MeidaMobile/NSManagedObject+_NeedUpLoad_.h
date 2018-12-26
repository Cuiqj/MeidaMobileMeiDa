//
//  NSManagedObject+_NeedUpLoad_.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (_NeedUpLoad_)

//取所有未上传的数据
+ (NSArray *)uploadArrayOfObject;

//新建表数据，并填充表ID
+ (id)newDataObjectWithEntityName:(NSString *)entityName;

//根据表结构生成上传数据结构描述xml字段
+ (NSString *)complexTypeString;

//根据数据生成上传数据字段;
- (NSString *)dataXMLString;
@end
