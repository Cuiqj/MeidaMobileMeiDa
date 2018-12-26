//
//  ParkingNode.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface ParkingNode : BaseManageObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * officeAddress;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSDate * date_start;
@property (nonatomic, retain) NSDate * resume_date;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * pile_no;//拼接后的桩号
@property (nonatomic, retain) NSString * stop_reason;


+ (void)deleteAllParkingNodeForCase:(NSString *)caseID;

+ (NSArray *)parkingNodesForCase:(NSString *)caseID;
+ (ParkingNode *)parkingNode:(NSString *)caseID citizen_name:(NSString*)citizen_name;
+ (void)deleteAllParkingNode:(NSArray *)citizenNames caseId:(NSString*)caseID;
@end
