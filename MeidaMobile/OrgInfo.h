//
//  OrgInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-20.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrgInfo : NSManagedObject

@property (nonatomic, retain) NSString * belongtoorg_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * orgname;
@property (nonatomic, retain) NSString * orgshortname;
@property (nonatomic, retain) NSString * typecode;
@property (nonatomic, retain) NSString * orgcode;
@property (nonatomic, retain) NSString * bankaccount;
@property (nonatomic, retain) NSString * orgdesc;
@property (nonatomic, retain) NSString * principal;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * faxnumber;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * linkman;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * remark;

+ (OrgInfo *)orgInfoForOrgID:(NSString *)orgID;
@end
