//
//  Laws.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Laws : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * remark;

+ (Laws *) lawsForLawID:(NSString *)lawID;
@end
