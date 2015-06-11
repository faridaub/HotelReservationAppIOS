//
//  ViewController.h
//  toyoko-inn_iPoneApp
//
//  Created by 中崎拓真 on 2014/01/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator1;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)topBtnDidPush:(id)sender;
- (IBAction)backBtnDidPush:(id)sender;
- (IBAction)reloadBtnDidPush:(id)sender;
- (IBAction)stopBtnDidPush:(id)sender;
- (IBAction)forwardBtnDidPush:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *topBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property NSString* URL;

@end
