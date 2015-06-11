//
//  ToyokoBusiPak.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/16.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

//customized table-in-cell UITableViewCell for business pack and business trip pack
@interface ToyokoBusiPak : ToyokoCustomCell

@property (weak, nonatomic) UIButton *busipak1;
@property (weak, nonatomic) UIButton *busipak2;
@property (weak, nonatomic) UIButton *busipak3;

@property NSArray *btns;
@property (nonatomic) NSInteger value;

@property NSMutableString *formatStr1, *formatStr2;
//numeric values to fill in to line 1 and line 2
@property NSMutableArray *values1, *values2;

@property (nonatomic) NSMutableDictionary *dict;

- (void)setValues:(NSArray*)values1 values2:(NSArray*)values2;
- (void)setFormattedStrings:(NSString*)str1 str2:(NSString*)str2;
- (void)setSelectedIndex:(NSInteger)selected;
- (NSInteger)getSelectedIndex;
- (void)ButtonPressed:(id)sender;

@end
