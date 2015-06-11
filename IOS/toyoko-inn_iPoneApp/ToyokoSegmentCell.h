//
//  ToyokoSegmentCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"

@interface ToyokoSegmentCell : ToyokoCustomCell
-(void)setSegmentTitles:(NSArray*)titles;
- (IBAction)valueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic) NSMutableDictionary *dict;
@property (nonatomic) NSInteger value;

@end
