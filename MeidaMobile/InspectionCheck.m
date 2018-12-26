//
//  InspectionCheck.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InspectionCheck.h"


@implementation InspectionCheck

@dynamic checkresult;
@dynamic checktext;
@dynamic inspectionid;
@dynamic isuploaded;
@dynamic myid;
@dynamic remark;

- (NSString *) signStr{
    if (![self.inspectionid isEmpty]) {
        return [NSString stringWithFormat:@"inspectionid == %@", self.inspectionid];
    }else{
        return @"";
    }
}

@end
