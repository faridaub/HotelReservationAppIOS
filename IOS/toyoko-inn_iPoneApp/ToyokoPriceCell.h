//
//  ToyokoPriceCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/31.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoPriceCell : ToyokoCustomCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property NSString *str1, *str2;
-(void)setStrings:(NSString*)str1 str2:(NSString*)str2;

@end
