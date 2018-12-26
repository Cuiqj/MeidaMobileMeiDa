//
//  InquireAnswerSentence.h
//  GDRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InquireAnswerSentence : NSManagedObject

@property (nonatomic, retain) NSString * ask_id;
@property (nonatomic, retain) NSString * sentence;

@end
