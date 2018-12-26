//
//  MatchLawDetails.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "MatchLawDetails.h"


@implementation MatchLawDetails

@dynamic law_id;
@dynamic lawitem_id;
@dynamic matchlaw_id;
@dynamic myid;
@dynamic type;

+ (NSArray *) matchLawDetailsForMatchlawID:(NSString *)matchlawID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"matchlaw_id == %@ ",matchlawID]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
