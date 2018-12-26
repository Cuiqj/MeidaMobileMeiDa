//
//  CaseInquire.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-19.
//
//

#import "CaseInquire.h"


@implementation CaseInquire

@dynamic address;
@dynamic age;
@dynamic answerer_name;
@dynamic proveinfo_id;
@dynamic company_duty;
@dynamic date_inquired;
@dynamic inquirer_name;
@dynamic inquiry_note;
@dynamic isuploaded;
@dynamic locality;
@dynamic myid;
@dynamic phone;
@dynamic postalcode;
@dynamic recorder_name;
@dynamic relation;
@dynamic sex;

- (NSString *) signStr{
    if (![self.proveinfo_id isEmpty]) {
        return [NSString stringWithFormat:@"proveinfo_id == %@", self.proveinfo_id];
    }else{
        return @"";
    }
}

+(CaseInquire *)inquireForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate;
    predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *tempArray=[context executeFetchRequest:fetchRequest error:nil];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return nil;
    }
}

@end
