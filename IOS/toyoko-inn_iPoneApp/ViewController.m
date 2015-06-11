//
//  ViewController.m
//  toyoko-inn_iPoneApp
//
//  Created by 中崎拓真 on 2014/01/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:_URL /*@"http://www.toyoko-inn.com/sp/?bApp=1"*/];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_indicator1 startAnimating];
    [self upDateButton];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicator1 stopAnimating];
    [self upDateButton];
#if 0
    NSString *command =[NSString stringWithFormat:@"var meta = document.createElement('meta');var iniScale = screen.width / 320;meta.setAttribute('name', 'viewport');meta.setAttribute('content','width=320, initial-scale=' + iniScale + ', minimum-scale=0.5, maximum-scale=3.0, user-scalable=1');document.getElementsByTagName('head')[0].appendChild(meta);"];
    [webView stringByEvaluatingJavaScriptFromString:command];
#endif
}

- (IBAction)topBtnDidPush:(id)sender {
    // View Top page
#if 0
    NSURL *url = [NSURL URLWithString:@"http://www.toyoko-inn.com/sp/?bApp=1"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
#else
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
#endif
}

- (IBAction)backBtnDidPush:(id)sender {
    // go back page
    if(_webView.canGoBack)
        [_webView goBack];
    else //no previous page anymore -- Kaiyuan.Ho 20140404
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
}

- (IBAction)reloadBtnDidPush:(id)sender {
    // page reload
    [_webView reload];
}

- (IBAction)stopBtnDidPush:(id)sender {
    // stop reuest
    [_webView stopLoading];
}

- (IBAction)forwardBtnDidPush:(id)sender {
    // forward page
    [_webView goForward];
}

- (void)upDateButton
{
    //Make goBack always available to rewind to previous view -- Kaiyuan.Ho 20140404
    //_backBtn.enabled = _webView.canGoBack;
    _forwardBtn.enabled = _webView.canGoForward;
    _stopBtn.enabled = _webView.loading;
}


@end
