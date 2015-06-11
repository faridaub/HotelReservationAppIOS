//
//  ToyokoRuleCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/08.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoRuleCell : ToyokoCustomCell
@property NSString *str1, *str2;
-(void)setStrings:(NSString*)str1 str2:(NSString*)str2;
-(NSAttributedString*)MakeFormattedString:(NSString*)str1 str2:(NSString*)str2;
@end
