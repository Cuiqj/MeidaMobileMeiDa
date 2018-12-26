//
//  CaseMapPrinterViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "CasePrintViewController.h"

@interface CaseMapPrinterViewController : CasePrintViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelLocality;
@property (weak, nonatomic) IBOutlet UILabel *labelCitizen;
@property (weak, nonatomic) IBOutlet UILabel *labelWeather;
@property (weak, nonatomic) IBOutlet UILabel *labelRoadType;
@property (weak, nonatomic) IBOutlet UITextView *textViewRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelProver;
@property (weak, nonatomic) IBOutlet UILabel *labelDraftMan;
@property (weak, nonatomic) IBOutlet UILabel *labelDraftTime;
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;

@end
