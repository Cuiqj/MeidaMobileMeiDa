//
//  FileCode.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-8.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FileCode : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * file_name;
@property (nonatomic, retain) NSString * province_code;
@property (nonatomic, retain) NSString * organization_code;
@property (nonatomic, retain) NSString * lochus_code;
@property (nonatomic, retain) NSString * file_code;
@property (nonatomic, retain) NSNumber * year_digit;
@property (nonatomic, retain) NSNumber * serial_digit;
@property (nonatomic, retain) NSNumber * is_year_first;
@property (nonatomic, retain) NSString * rowguid;

+ (FileCode *)fileCodeWithPredicateFormat:(NSString *)predicateStr;

@end
