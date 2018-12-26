//
//  OrgInfo.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-20.
//
//

#import "OrgInfo.h"


@implementation OrgInfo

@dynamic belongtoorg_id;
@dynamic myid;
@dynamic orgname;
@dynamic orgshortname;
@dynamic typecode;
@dynamic orgcode;
@dynamic bankaccount;
@dynamic orgdesc;
@dynamic principal;
@dynamic address;
@dynamic faxnumber;
@dynamic level;
@dynamic linkman;
@dynamic postcode;
@dynamic telephone;
@dynamic remark;

+ (OrgInfo *)orgInfoForOrgID:(NSString *)orgID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",orgID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}

@end
