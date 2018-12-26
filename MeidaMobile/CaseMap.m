//
//  CaseMap.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-16.
//
//

#import "CaseMap.h"


@implementation CaseMap

@dynamic myid;
@dynamic isuploaded;
@dynamic caseinfo_id;
@dynamic draftsman_name;
@dynamic draw_time;
@dynamic road_type;
@dynamic remark;
@dynamic map_item;

- (NSString *) signStr{
    if (![self.caseinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
    }else{
        return @"";
    }
}

+ (CaseMap *)caseMapForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSString *)map_remark{
    return self.remark;
}

- (NSString *)map_file{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",self.caseinfo_id];
    mapPath=[documentPath stringByAppendingPathComponent:mapPath];
    NSString *mapName = @"casemap.jpg";
    NSString *filePath=[mapPath stringByAppendingPathComponent:mapName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }else{
        return nil;
    }
}
@end
