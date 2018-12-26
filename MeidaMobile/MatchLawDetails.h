//
//  MatchLawDetails.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MatchLawDetails : NSManagedObject

@property (nonatomic, retain) NSString * law_id;
@property (nonatomic, retain) NSString * lawitem_id;
@property (nonatomic, retain) NSString * matchlaw_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * type;

+ (NSArray *) matchLawDetailsForMatchlawID:(NSString *)matchlawID;
@end
