//
//  initialSetting.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/01/07.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface initialSetting : UIViewController
- (IBAction)MemberLoginPressed:(id)sender;
- (IBAction)NormalLoginPressed:(id)sender;
- (IBAction)NewRegPressed:(id)sender;
- (IBAction)BackPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (weak, nonatomic) IBOutlet UIButton *NewRegButton;
@property (weak, nonatomic) IBOutlet UIButton *NormalLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *MemberLoginButton;

@end
