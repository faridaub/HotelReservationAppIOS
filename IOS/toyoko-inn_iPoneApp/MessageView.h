//
//  MessageView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)BackPressed:(id)sender;

@end
