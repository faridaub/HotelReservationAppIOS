//
//  ToyokoEcoplanCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/18.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoEcoplanCell : ToyokoCustomCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *date1;
@property (weak, nonatomic) IBOutlet UIButton *date2;
@property (weak, nonatomic) IBOutlet UIButton *date3;
@property (weak, nonatomic) IBOutlet UIButton *date4;
@property (weak, nonatomic) IBOutlet UIButton *date5;
@property (weak, nonatomic) IBOutlet UIButton *date6;
@property (weak, nonatomic) IBOutlet UIButton *date7;
//@property (weak, nonatomic) IBOutlet UIButton *dateNoSpecify;
@property NSMutableArray *selectedArray;
@property BOOL isNoSpecify;
@property NSArray *buttons;

@property (nonatomic) NSMutableDictionary *dict;

- (IBAction)ButtonPressed:(id)sender;
- (void)setDates:(NSArray*)dates selectedDates:(NSArray*)selectedDates;
- (NSArray*)getSelectedDates;
- (BOOL)isNoSpecifySelected;
//- (void)setNoSpecifySelected:(BOOL)selected;
@end
