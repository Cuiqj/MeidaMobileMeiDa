//
//  LawItems.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LawItems : NSManagedObject

@property (nonatomic, retain) NSString * law_id;
@property (nonatomic, retain) NSString * lawitem_desc;
@property (nonatomic, retain) NSString * lawitem_no;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * remark;

+ (LawItems *) lawItemForLawID:(NSString *)lawID andItemNo:(NSString *)itemNo;

@end
