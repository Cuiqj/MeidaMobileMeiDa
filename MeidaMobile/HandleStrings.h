//
//  HandleStrings.h
//  MeidaMobile
//
//  Created by maijunjin on 15/7/17.
//
//

#import <Foundation/Foundation.h>

@interface HandleStrings : NSObject
//要返回的字符串
@property (nonatomic, retain) NSString * returnString;
//原本的字符串经过处理之后，比如截取之后剩下的内容
@property (nonatomic, retain) NSString * handleString;
@end
