//
//  TextView.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/12/03.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *NaviBar;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSString *text;
@property NSString *viewTitle;

@end
