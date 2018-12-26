//
//  TrafficRecord.m
//  GDRMMobile
//
//  Created by coco on 13-7-8.
//
//

#import "TrafficRecord.h"


@implementation TrafficRecord

@dynamic car;
@dynamic clend;
@dynamic clstart;
@dynamic fix;
@dynamic happentime;
@dynamic myid;
@dynamic infocome;
@dynamic isend;
@dynamic lost;
@dynamic paytype;
@dynamic property;
@dynamic rel_id;
@dynamic remark;
@dynamic roadsituation;
@dynamic station;
@dynamic type;
@dynamic wdsituation;
@dynamic zjend;
@dynamic zjstart;
@dynamic isuploaded;
@dynamic iszj;
@dynamic issg;

- (NSString *) signStr{
    if (![self.rel_id isEmpty]) {
        return [NSString stringWithFormat:@"rel_id == %@", self.rel_id];
    }else{
        return @"";
    }
}
@end
