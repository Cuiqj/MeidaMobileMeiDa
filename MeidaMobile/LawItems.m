//
//  LawItems.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "LawItems.h"


@implementation LawItems

@dynamic law_id;
@dynamic lawitem_desc;
@dynamic lawitem_no;
@dynamic myid;
@dynamic remark;

+ (LawItems *) lawItemForLawID:(NSString *)lawID andItemNo:(NSString *)itemNo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"law_id == %@ && myid == %@",lawID, itemNo]];
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if (result && [result count]>0) {
        return [result objectAtIndex:0];
    }else{
        return nil;
    }
}
@end
