//
//  UploadRecord.m
//  GDRMMobile
//
//  Created by coco on 13-7-5.
//
//

#import "UploadRecord.h"
#import "BaseManageObject.h"
#import "UploadedRecordList.h"
#import "Inspection.h"
@interface UploadRecord()
@property (nonatomic,strong) NSMutableArray* fileListArray;
@end

@implementation UploadRecord

@synthesize fileListArray = _fileListArray;

- (void)addUploadedRecord:(NSString*)tableName WitdData:(id) data{
    if(!_fileListArray){
        _fileListArray = [NSMutableArray array];
    }
    if ([data isKindOfClass:[BaseManageObject class]]) {
        NSString *findStr = [(BaseManageObject *)data signStr];
        if (![findStr isEmpty]) {
            NSMutableDictionary *content = [NSMutableDictionary dictionary];
            [content setObject:tableName forKey:@"tableName"];
            
            [content setObject:findStr forKey:@"findStr"];
            [_fileListArray addObject:content];
        }
    }
}

- (void)didWriteDB
{
    NSManagedObjectContext* managedObjectContext = [[AppDelegate App] managedObjectContext];
    NSError* error;
    for(NSDictionary* config in _fileListArray)
    {
         NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadedRecordList" inManagedObjectContext:managedObjectContext];
        UploadedRecordList* rec = [[UploadedRecordList alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        rec.tableName = [config objectForKey:@"tableName"];
        rec.findStr = [config objectForKey:@"findStr"];
        rec.uploadedDate = [NSDate date];
        [managedObjectContext save:&error];
    }
}

- (void)asyncDel{
//    dispatch_queue_t myqueue=dispatch_queue_create("DelOldUploadedData", nil);
//    dispatch_async(myqueue, ^(void){
        [self getUploadedRecords:10];
//    });
//    dispatch_release(myqueue);
}

- (void)getUploadedRecords:(int)count
{
    NSError* error;
    NSManagedObjectContext* managedObjectContext = [[AppDelegate App] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadedRecordList" inManagedObjectContext:managedObjectContext];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uploadedDate < %@", [NSDate dateWithTimeIntervalSinceNow:-secondsPerDay*30]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    request.fetchLimit = count;
    NSArray* fileList = [managedObjectContext executeFetchRequest:request error:&error];
    [self removeExpireRecord:fileList];
}


- (void)removeExpireRecord:(NSArray*)fileList
{
    NSManagedObjectContext* managedObjectContext = [[AppDelegate App] managedObjectContext];
    for(UploadedRecordList* rec in fileList){
        if(rec){
            NSEntityDescription *entity = [NSEntityDescription entityForName:rec.tableName inManagedObjectContext:managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:rec.findStr];
            [request setEntity:entity];
            [request setPredicate:predicate];
            NSArray *result=[managedObjectContext executeFetchRequest:request error:nil];
            if (result && [result count]>0) {
                for (NSManagedObject *obj in result) {
                    [managedObjectContext deleteObject:obj];
                }
            }
            [managedObjectContext deleteObject:rec];
        }
    }
    NSError* error;
    [managedObjectContext save:&error];
}


@end
