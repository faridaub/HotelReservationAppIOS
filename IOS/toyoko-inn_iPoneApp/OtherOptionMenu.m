//
//  OtherOptionMenu.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/03.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "OtherOptionMenu.h"
#import "ViewController.h"

@interface OtherOptionMenu ()

@end

@implementation OtherOptionMenu

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
    
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iOSVersion >= 7.0) //change the UI of buttons to add the border
    {
        [_ReserveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ReserveButton setBackgroundColor:[UIColor blueColor]];
        
        [_PointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_PointButton setBackgroundColor:[UIColor blueColor]];
        
        [_SettingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_SettingButton setBackgroundColor:[UIColor blueColor]];
        
        [_GuideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_GuideButton setBackgroundColor:[UIColor blueColor]];
        
        [_InquiryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_InquiryButton setBackgroundColor:[UIColor blueColor]];
    }

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

- (IBAction)ReservePressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://yoyaku.4and5.com/mb/html/rvmb_entryMmbrshpTypeRsrvCntnt.html?guid=ON&f=4&rf=1&toyokoTop=true&ma=&sid=&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)PointPessed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://yoyaku.4and5.com/mb/html/rvmb_athntctMmbrshp45CnfrmPnt.html?guid=ON&f=4&rf=1&toyokoTop=true&topPage=1&ma=&sid=&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)SettingPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://yoyaku.4and5.com/mb/html/rvmb_settingChgNameBrth.html?guid=ON&f=4&rf=1&toyokoTop=true&ma=&sid=&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)GuidePressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/i/etc/guidance.html?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)InquiryPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/i/etc/reference.html?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

@end
