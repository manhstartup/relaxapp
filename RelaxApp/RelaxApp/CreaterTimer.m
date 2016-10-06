//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "CreaterTimer.h"
#import "Define.h"
#import "FileHelper.h"
@interface CreaterTimer ()
{
    NSArray *_arrCategory;
    NSDictionary *dicChooseCategory;
    int statusPlay;
}
@end

@implementation CreaterTimer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vContent.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.vViewNav.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_FAVORITE);
    // read cache favorite
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    _arrCategory = arrTmp;
    _timeToSetOff.backgroundColor = [UIColor whiteColor];
    if (_timerType == TIMER_COUNTDOWN) {
        _timeToSetOff.datePickerMode =UIDatePickerModeCountDownTimer;
    }
    else
    {
        _timeToSetOff.datePickerMode =UIDatePickerModeTime;
    }
//    [_timeToSetOff setValue:[UIColor whiteColor] forKey:@"textColor"];
//    [_timeToSetOff setValue:@(0.8) forKey:@"alpha"];
    [self.tfTitle setValue:[UIColor whiteColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    self.imgCheckPause.hidden = YES;
    self.imgCheckPlaying.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setCallback:(CreaterTimerCallback)callback
{
    _callback =callback;
}
-(IBAction)statusAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 11) {
        statusPlay = 2;
        self.imgCheckPlaying.hidden = NO;
        self.imgCheckPause.hidden = YES;
    }
    else
    {
        statusPlay = 1;
        self.imgCheckPlaying.hidden = YES;
        self.imgCheckPause.hidden = NO;
    }
}
-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)saveAction:(id)sender
{
    if (_tfTitle.text.length > 0) {
        if (statusPlay <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                            message:@"Chooses Pause or Playing"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (_typeMode == MODE_CREATE) {
           int rowPickerView = (int)[_pickerFavorite selectedRowInComponent:0];
            dicChooseCategory = _arrCategory[rowPickerView];
            //read in cache
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            
            NSDictionary *lastTimer = [arrTmp lastObject];
            int _id = [lastTimer[@"id"] intValue] + 1;
            NSDictionary *dic = @{@"id": @(_id),
                                  @"name": _tfTitle.text,
                                  @"enabled": @(0),
                                  @"description":_timerType == TIMER_COUNTDOWN? @"Countdown":@"Timer",
                                  @"timer": _timeToSetOff.date,
                                  @"type": @(_timerType),
                                  @"id_favorite":dicChooseCategory[@"id"]?dicChooseCategory[@"id"]:@"",
                                  @"isplay": statusPlay==2?@(1):@(0)
                                  };
            NSMutableArray *arrSave = [NSMutableArray new];
            if (arrTmp) {
                [arrSave addObjectsFromArray:arrTmp];
            }
            [arrSave addObject:dic];
            //save cache
            [arrSave writeToFile:strPath atomically:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                            message:@"Success"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            if (_callback) {
                _callback();
            }


        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                        message:@"Enter Name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}
//MARK: - PICKER VIEW DELEGATE
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _arrCategory.count;
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dicFavo = _arrCategory[row];
    return [NSString stringWithFormat:@"%@",dicFavo[@"name"]];
}
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
 }

@end
