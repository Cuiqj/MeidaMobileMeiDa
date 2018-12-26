//
//  Inspection.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface Inspection : BaseManageObject

@property (nonatomic, retain) NSString * carcode;
@property (nonatomic, retain) NSString * classe;
@property (nonatomic, retain) NSDate * date_inspection;
@property (nonatomic, retain) NSString * delivertext;
@property (nonatomic, retain) NSString * duty_leader;
@property (nonatomic, retain) NSString * inspection_description;
@property (nonatomic, retain) NSNumber * inspection_milimetres;
@property (nonatomic, retain) NSString * inspection_place;
@property (nonatomic, retain) NSString * inspectionor_name;
@property (nonatomic, retain) NSNumber * isdeliver;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * recorder_name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * time_end;
@property (nonatomic, retain) NSDate * time_start;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSString * fuzeren;
@property (nonatomic, retain) NSString * yjsx;
@property (nonatomic, retain) NSString * yjzb;
@property (nonatomic, retain) NSString * yjr;
@property (nonatomic, retain) NSString * jsr;
@property (nonatomic, retain) NSDate * yjsj;

+ (NSArray *)inspectionForID:(NSString *)inspectionID;
@end
