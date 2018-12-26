//
//  CheckItemDetails.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-7.
//
//

#import "CheckItemDetails.h"


@implementation CheckItemDetails

@dynamic checkitems_id;
@dynamic caption;
@dynamic theindex;
@dynamic remark;

+ (NSArray *)detailsForItem:(NSString *)checkItemID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if ([checkItemID isEmpty]) {
        [fetchRequest setPredicate:nil];
    } else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"checkitems_id == %@",checkItemID]];
    }
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"theindex.integerValue" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
