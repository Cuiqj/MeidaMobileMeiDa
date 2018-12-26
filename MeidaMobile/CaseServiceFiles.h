//
//  CaseServiceFiles.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseManageObject.h"

#ifdef DEBUG
#define DOC_TEMPLATES_NAME_ARRAY @[\
@"勘验检查笔录",\
@"询问笔录",\
@"赔（补）偿通知书",\
@"现场平面图",\
@"送达回证",\
@"赔（补）偿清单",\
@"施工整改通知书"\
]
#define DOC_TEMPLATES_FULLNAME_ARRAY @[\
@"公路赔（补）偿案件勘验检查笔录",\
@"询问笔录",\
@"公路赔（补）偿通知书",\
@"路产索赔现场勘查图",\
@"公路赔（补）偿案件管理文书送达回证",\
@"损坏公路设施索赔清单",\
@"施工整改通知书（回执）",\
@"责令车辆停驶通知书"\
]
#else
#define DOC_TEMPLATES_NAME_ARRAY @[\
@"勘验检查笔录",\
@"询问笔录",\
@"赔（补）偿通知书",\
@"现场平面图",\
@"送达回证",\
@"赔（补）偿清单"\
]
#define DOC_TEMPLATES_FULLNAME_ARRAY @[\
@"公路赔（补）偿案件勘验检查笔录",\
@"询问笔录",\
@"公路赔（补）偿通知书",\
@"路产索赔现场勘查图",\
@"公路赔（补）偿案件管理文书送达回证",\
@"损坏公路设施索赔清单"\
]
#endif
#define DEFAULT_SERVICE_FILE1_INDEX 0+2
#define DEFAULT_SERVICE_FILE2_INDEX 0+5

@interface CaseServiceFiles : BaseManageObject

@property (nonatomic, retain) NSString * receipt_date;
@property (nonatomic, retain) NSString * receipter_name;
@property (nonatomic, retain) NSString * service_file;
@property (nonatomic, retain) NSString * servicereceipt_id;
@property (nonatomic, retain) NSString * servicer_name;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * isuploaded;

+ (NSArray *)caseServiceFilesForCase:(NSString *)caseID;
+ (NSArray *)caseServiceFilesForCaseServiceReceipt:(NSString *)receiptID;
+ (CaseServiceFiles *)newCaseServiceFilesForCaseServiceReceipt:(NSString *)receiptID;
+ (NSArray *)addDefaultCaseServiceFilesForCase:(NSString *)caseID  forCaseServiceReceipt:(NSString *)receiptID;
@end
