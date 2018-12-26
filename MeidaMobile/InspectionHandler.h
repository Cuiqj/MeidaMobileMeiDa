//
//  InspectionHandler.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-9-7.
//
//

#import <Foundation/Foundation.h>

@protocol InspectionHandler <NSObject>
@optional
//加入新巡查记录后，刷新记录
-(void)reloadRecordData;

//上班后，设置巡查ID
-(void)setInspectionDelegate:(NSString *)aInspectionID;

//直接退回至主页面
-(void)popBackToMainView;

//重新监视键盘消息
- (void)addObserverToKeyBoard;
@end
