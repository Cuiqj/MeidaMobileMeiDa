//
//  LawbreakingAction.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LawbreakingAction : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * casetype_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)LawbreakingActionsForCasetype:(NSString *)caseTypeID;

+ (NSArray *)LawbreakingActionsForCase:(NSString *)myID;
@end
