//
//  InitInspectionCheck.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import "InitData.h"
#import "CheckHandle.h"
#import "CheckStatus.h"
#import "CheckReason.h"
#import "CheckType.h"
#import "CheckItemDetails.h"
#import "CheckItems.h"

@interface InitCheckType :InitData
- (void)downLoadCheckType;
@end

@interface InitCheckReason : InitData
- (void)downLoadCheckReason;
@end

@interface InitCheckHandle : InitData
- (void)downLoadCheckHandle;
@end

@interface InitCheckStatus : InitData
- (void)downLoadCheckStatus;
@end

@interface InitCheckItems : InitData
- (void)downloadCheckItems;
@end

@interface InitCheckItemDetails : InitData
- (void)downloadCheckItemDetails;
@end