//
//  ConstructionChangeBack.m
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-10.
//
//

#import "ConstructionChangeBack.h"


@implementation ConstructionChangeBack

@dynamic myid;
@dynamic no;
@dynamic rel_id;
@dynamic sendate;
@dynamic sendcontent;
@dynamic sendname;
@dynamic sendNO;
@dynamic isuploaded;

- (NSString *)signStr{
    if (![self.rel_id isEmpty]) {
        return [NSString stringWithFormat:@"rel_id == %@", self.rel_id];
    }else{
        return @"";
    }
}

@end
