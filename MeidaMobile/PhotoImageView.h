//
//  PhotoImageView.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-8-27.
//
//

#import <UIKit/UIKit.h>

@protocol PhotoDelegate;

@interface PhotoImageView : UIImageView
@property (nonatomic,weak) id<PhotoDelegate> delegate;
@end
        
@protocol PhotoDelegate <NSObject>
//-(void)
@end