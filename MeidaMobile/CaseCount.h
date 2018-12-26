//
//  CaseCount.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseCount : NSManagedObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSNumber * sum;
@property (nonatomic, retain) NSString * chinese_sum;
@property (nonatomic, retain) NSArray *case_count_list;

-(NSString *) chinese_sum_sw;
-(NSString *) chinese_sum_w;
-(NSString *) chinese_sum_q;
-(NSString *) chinese_sum_b;
-(NSString *) chinese_sum_s;
-(NSString *) chinese_sum_y;
-(NSString *) chinese_sum_j;
-(NSString *) chinese_sum_f;


@end
