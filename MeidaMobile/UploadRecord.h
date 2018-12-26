//
//  UploadRecord.h
//  GDRMMobile
//
//  Created by coco on 13-7-5.
//
//

#import <Foundation/Foundation.h>

@interface UploadRecord : NSObject


- (void)addUploadedRecord:(NSString*)tableName WitdData:(id) data;
- (void)didWriteDB;
- (void)getUploadedRecords:(int)count;
- (void)removeExpireRecord:(NSArray*)fileList;
- (void)asyncDel;
@end
