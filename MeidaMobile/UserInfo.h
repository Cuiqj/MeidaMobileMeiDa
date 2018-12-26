//
//  UserInfo.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * cardid;
@property (nonatomic, retain) NSString * duty;
@property (nonatomic, retain) NSString * exelawid;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * username;

+ (UserInfo *)userInfoForUserID:(NSString *)userID;

+ (NSArray *)allUserInfo;

+ (NSString *)orgAndDutyForUserName:(NSString *)username;
@end
