//
//  InitLaws.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import "InitData.h"

@interface InitLaws : InitData
- (void)downLoadLaws;
@end


@interface InitLawBreakingAction : InitData
- (void)downloadLawBreakingAction;
@end

@interface InitLawItems : InitData
- (void)downloadLawItems;
@end

@interface InitMatchLaw : InitData
- (void)downloadMatchLaw;
@end

@interface InitMatchLawDetails : InitData
- (void)downloadMatchLawDetails;
@end