//
//  ToyokoPickerCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"
#import "TLDynamicSizeView.h"
#import "ListBoxVC.h"

#define POPUPMENU   1

@interface ToyokoPickerCell : ToyokoCustomCell<UIPickerViewDelegate, UIPickerViewDataSource/*TLDynamicSizeView*/
#if POPUPMENU
,ListBoxDelegate
#endif
>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)DonePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
@property (nonatomic) NSMutableDictionary *dict;
@property (nonatomic) NSInteger value;
@property (nonatomic) CGFloat minHeight, maxHeight;
@property (nonatomic) NSArray *items;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSIndexPath *index;
@property (nonatomic) ListBoxVC *listbox;
//@property BOOL forceLoaded;
@property CGFloat maxButtonWidth;

-(void)setExpanded:(BOOL)expanded initial:(BOOL)initial;
-(void)setHeight:(CGFloat)min max:(CGFloat)max;
-(void)setChoices:(NSArray*)choices;
-(void)setTable:(UITableView*)tableview index:(NSIndexPath*)index;
-(void)reload; //To reload all data for the undesired initialization sequence
@end
