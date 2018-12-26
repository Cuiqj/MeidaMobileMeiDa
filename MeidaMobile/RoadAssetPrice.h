//
//  RoadAssetPrice.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoadAssetPrice : NSManagedObject

@property (nonatomic, retain) NSString * document_name;
@property (nonatomic, retain) NSNumber * is_unvarying;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * roadasset_type;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, retain) NSString * unit_name;

@end
