//
//  DistanceSetting.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "DistanceSetting.h"

@interface DistanceSetting ()

@end

@implementation DistanceSetting

NSString *distFormat;
#define DEFAULT_DISTANCE 5.0f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if 1
    _SaveButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [_SaveButton.imageView setContentMode: UIViewContentModeCenter];
    _SaveButton.clipsToBounds = YES;
    _SaveButton.layer.cornerRadius = 10;
#endif
    distFormat = [_DistIndicator.text copy];
    //TODO: use the input distance
    if(_initDist >= _DistanceSlider.minimumValue && _initDist <= _DistanceSlider.maximumValue)
    {
        _DistIndicator.text = [NSString stringWithFormat:distFormat, _initDist];
        _DistanceSlider.value = _initDist;
    }
    else
        _DistIndicator.text = [NSString stringWithFormat:distFormat, DEFAULT_DISTANCE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackPressed:(id)sender {
    if([self.SettingDelegate respondsToSelector:@selector(SettingDone:)])
    {
        [self.SettingDelegate SettingDone:_DistanceSlider.value];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)setDistance:(CGFloat)distance
{
    [_DistanceSlider setValue:distance];
    _DistIndicator.text = [NSString stringWithFormat:distFormat, distance];
}

- (IBAction)DistanceChanged:(id)sender {
    UISlider *sl = (UISlider*)sender;
    if([self.SettingDelegate respondsToSelector:@selector(SettingChanged:)])
    {        
        [self.SettingDelegate SettingChanged:sl.value];
    }
    _DistIndicator.text = [NSString stringWithFormat:distFormat, sl.value];
}

- (IBAction)SavePressed:(id)sender {
    if([self.SettingDelegate respondsToSelector:@selector(SettingDone:)])
    {
        [self.SettingDelegate SettingDone:_DistanceSlider.value];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
}

-(void)connectionFailed:(NSError*)error
{
}
@end
