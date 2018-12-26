//
//  MatchLaw.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MatchLaw : NSManagedObject

@property (nonatomic, retain) NSString * casetype_id;
@property (nonatomic, retain) NSString * filetype_id;
@property (nonatomic, retain) NSString * lawbreakingaction_id;
@property (nonatomic, retain) NSString * myid;

+ (NSArray *)matchLawsForLawbreakingActionID:(NSString *)lawbreakActionID;
@end
