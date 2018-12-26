//
//  ConstructionChangeBack.h
//  GDRMMobile
//
//  Created by 高 峰 on 13-7-10.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

@interface ConstructionChangeBack : BaseManageObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * no;
@property (nonatomic, retain) NSString * rel_id;
@property (nonatomic, retain) NSDate * sendate;
@property (nonatomic, retain) NSString * sendcontent;
@property (nonatomic, retain) NSString * sendname;
@property (nonatomic, retain) NSString * sendNO;
@property (nonatomic, retain) NSNumber * isuploaded;

@end
