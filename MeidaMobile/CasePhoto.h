//
//  CasePhoto.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CasePhoto : NSManagedObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * photo_name;
+(NSArray *)casePhotosForCase:(NSString *)caseID;
+ (void)deletePhotoForCase:(NSString *)caseID photoName:(NSString *)photoName;
@end
