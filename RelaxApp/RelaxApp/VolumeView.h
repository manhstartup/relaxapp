//
//  VolumeView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^VolumeViewCallback)();
typedef void (^DismissCallback)();

@interface VolumeView : UIView
{
    NSTimer *timer;
}
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UIButton *btnDecrease;
@property (nonatomic, strong) IBOutlet UIButton *btnIncrease;
@property (nonatomic, strong) IBOutlet UIImageView *vBackGround;
-(void)addContraintSupview:(UIView*)viewSuper;
-(instancetype)initWithClassName:(NSString*)className;
@property (nonatomic,copy) VolumeViewCallback callback;
@property (nonatomic,copy) DismissCallback callbackDismiss;

@end
