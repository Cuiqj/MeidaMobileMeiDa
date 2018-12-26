//
//  TempCheckItem.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-12.
//
//

#import <Foundation/Foundation.h>


//自定义检查项目存储对象，便于修改和保存
@interface TempCheckItem: NSObject;
@property (nonatomic,copy) NSString *checkText;
@property (nonatomic,copy) NSString *checkResult;
@property (nonatomic,copy) NSString *remarkText;
@property (nonatomic,copy) NSString *itemID;
@end

