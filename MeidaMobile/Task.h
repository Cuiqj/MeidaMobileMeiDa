//
//  Task.h
//  GDRMMobile
//
//  Created by Sniper One on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface Task : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * node_id;
@property (nonatomic, retain) NSString * node_name;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSNumber * isuploaded;

@end
