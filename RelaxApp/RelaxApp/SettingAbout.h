//
//  CreaterTimer.h
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "BaseView.h"
typedef void (^SettingAboutCallback)();

@interface SettingAbout : BaseView
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (nonatomic,copy) SettingAboutCallback callback;

@end
