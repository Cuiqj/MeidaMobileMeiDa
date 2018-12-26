//
//  Task.m
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import "Task.h"


@implementation Task

@dynamic myid;
@dynamic node_id;
@dynamic node_name;
@dynamic project_id;
@dynamic start_time;
@dynamic isuploaded;

- (NSString *) signStr{
    if (![self.myid isEmpty]) {
        return [NSString stringWithFormat:@"myid == %@", self.myid];
    }else{
        return @"";
    }
}
@end
