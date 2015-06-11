//
//  MessageView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "MessageView.h"

@interface MessageView ()

@end

@implementation MessageView

static NSString *title;
static NSString *date;
static NSString *html;

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
    title = @"test123";
    date = @"2014年7月1日";
    html = @"<html><body><h1>test123</h1></body></html>";
    
    _titleLabel.text = title;
    _dateLabel.text = date;
    [_webView loadHTMLString:html baseURL:nil];
    
    [_titleLabel.layer setBorderColor:[UIColor blackColor].CGColor];
    [_titleLabel.layer setBorderWidth:0.5f];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"URL: %@",[request URL]);
    return YES;
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
