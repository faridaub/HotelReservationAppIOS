//
//  AddressCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2015/03/25.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
- (CGFloat)getTextlabelWidth;
@end
