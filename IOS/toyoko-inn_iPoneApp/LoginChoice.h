//
//  LoginChoice.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyokoNetBase.h"

@interface LoginChoice : UIViewController
- (IBAction)BackPressed:(id)sender;
- (IBAction)BirthPWPressed:(id)sender;
- (IBAction)NameBirthPressed:(id)sender;
- (IBAction)MemberPressed:(id)sender;
- (IBAction)NormalPressed:(id)sender;
- (IBAction)InfoModifyPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BirthPWButton;
@property (weak, nonatomic) IBOutlet UIButton *NameBirthButton;
@property (weak, nonatomic) IBOutlet UIButton *MemberButton;
@property (weak, nonatomic) IBOutlet UIButton *NormalButton;
@property (weak, nonatomic) IBOutlet UIButton *InfoModifyButton;


@end
