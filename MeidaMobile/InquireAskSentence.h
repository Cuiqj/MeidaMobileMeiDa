//
//  InquireAskSentence.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InquireAskSentence : NSManagedObject

@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * the_index;
@property (nonatomic, retain) NSString * sentence;

@end
