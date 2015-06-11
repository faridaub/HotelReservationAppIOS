//
//  ToyokoPickerCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoPickerCell.h"
#import "Constant.h"

@implementation ToyokoPickerCell

#define MAX_HEIGHT 220
#define MIN_HEIGHT 44
//#define INSIDE_MARGIN 5.0f

static UIModalPresentationStyle prevStyle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        //_forceLoaded = NO;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _picker.delegate = self;
    _picker.dataSource = self;
    //[_picker.layer setBorderColor:[[UIColor grayColor]CGColor]];
    //[_picker.layer setBorderWidth:1.0];
    
    //adjust the width of picker
    CGRect r = _picker.frame;
    r.size.width = self.frame.size.width;
    _picker.frame = r;
    
    [_button.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_button.layer setBorderWidth:1.0];
    _button.layer.cornerRadius = 5.0f;
    _button.clipsToBounds = YES;
    
    _DoneButton.clipsToBounds = YES;
    _DoneButton.layer.cornerRadius = 5.0f;
    
    _maxHeight = MAX_HEIGHT;
    _minHeight = MIN_HEIGHT;
    
    self.leftMargin = 8;
    self.rightMargin = 8;
    _listbox = nil;
    //_forceLoaded = NO;
}

-(void)setExpanded:(BOOL)expanded initial:(BOOL)initial
{
#if POPUPMENU
#else
    NSLog(@"isExpanded=%d, expanded=%d",_isExpanded, expanded);
    _isExpanded = expanded;
    _picker.hidden = !_isExpanded; //To show or hide the picker
    _DoneButton.hidden = _picker.hidden;
    
#if 0
    NSLog(@"key window: %@", [UIApplication sharedApplication].keyWindow);
#endif
#if 1
    if(expanded)
        [self reload];
#endif
    
    if(_dict)
        _dict[@"expanded"] = [NSNumber numberWithBool:_isExpanded];
    
    //check if tableView and index are set
    if(_tableView && _index && !initial) //To reload the picker row
    {
        //NSLog(@"trying update cell at row %d", _index.row);
        [_tableView beginUpdates];
        [_tableView reloadRowsAtIndexPaths:@[_index] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
    }
#endif
}

-(void)setHeight:(CGFloat)min max:(CGFloat)max
{
    _maxHeight = max;
    _minHeight = min;
}

-(void)setChoices:(NSArray*)choices
{
    _items = choices;
#if 1
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.minimumLineHeight = _button.frame.size.height;
    CGFloat baseline = (_button.frame.size.height - [[NSString stringWithFormat:@"%@  ▼ ", _items[_value]] sizeWithFont: _button.titleLabel.font].height/*_button.titleLabel.font.pointSize*/)/2.0f;
    NSDictionary *dict = @{NSFontAttributeName:_button.titleLabel.font, NSForegroundColorAttributeName:[UIColor blackColor], NSBackgroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:style, NSBaselineOffsetAttributeName:@(baseline)};
    
    NSDictionary *dict2 = @{NSFontAttributeName:_button.titleLabel.font, NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName:[UIColor grayColor],                           NSParagraphStyleAttributeName: style, NSBaselineOffsetAttributeName:@(baseline)};
#endif
    if(_value >=0 && _value < _items.count)
    {
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", _items[_value]] attributes:dict];
        NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:@" ▼ " attributes:dict2];
        [attr1 appendAttributedString:attr2];
#if 0
        [_button setTitle:[NSString stringWithFormat:@"%@  ▼ ", [_items objectAtIndex:_value]] forState:UIControlStateNormal];
#else
        [_button setAttributedTitle:attr1 forState:UIControlStateNormal];
#endif
    }
    
    UIFont *font = _button.titleLabel.font;
#if 0
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = 5.0f;
    style.headIndent = 5.0f;
    style.tailIndent = 5.0f;
#endif
    CGSize size;
    _maxButtonWidth = 0;
    for(NSString *str in choices)
    {
#if 1
        size = [[NSString stringWithFormat:@"%@  ▼ ", str] sizeWithFont: font];
#else
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ▼", str] attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
        CGRect rect = [attr boundingRectWithSize:(CGSize){self.frame.size.width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin                                         context:nil];
        size = rect.size;
#endif
        if(size.width > _maxButtonWidth)
            _maxButtonWidth = size.width;
    }
    NSLog(@"max width=%f", _maxButtonWidth);
    _maxButtonWidth += _button.titleEdgeInsets.left + _button.titleEdgeInsets.right;
    
    CGRect r = _button.frame;
    r.origin.x = self.contentView.frame.size.width - _maxButtonWidth - self.rightMargin ;
    r.size.width = _maxButtonWidth;
    
    [_button setFrame:r];
    
    r = _label.frame;
    r.size.width = self.contentView.frame.size.width - _maxButtonWidth - self.leftMargin -self.rightMargin;
    [_label setFrame:r];
}

-(void)setTable:(UITableView*)tableview index:(NSIndexPath*)index
{
    _tableView = tableview;
    _index = [NSIndexPath indexPathForRow:index.row inSection:index.section];
}

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
}

- (IBAction)buttonPressed:(id)sender {
#if POPUPMENU
    UIViewController *topVC = [Constant getTopVC];
    _listbox = (ListBoxVC*)[topVC.storyboard instantiateViewControllerWithIdentifier:@"ListBox"];/*[[[NSBundle mainBundle] loadNibNamed:@"ListBox"
                                                         owner:self
                                                       options:nil] lastObject];*/
    [_listbox setData:_items index:_value];
    _listbox.title/*titleLabel.text*/ = [self getTitle];
    _listbox.delegate = self;
    //UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    prevStyle = topVC.modalPresentationStyle;
    
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        topVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    else
    {
        _listbox.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    [topVC presentViewController:_listbox animated:YES completion:nil];
#else
    [self setExpanded:!_isExpanded initial:NO];
    
    //To scroll to the view in order to show the whole cell
    if(_isExpanded)
    {
        [_tableView scrollToRowAtIndexPath:_index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
#endif
}

- (IBAction)DonePressed:(id)sender {
    //close when done is pressed
    [self setExpanded:NO initial:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _items.count;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected row %ld, str=%@",(long)row, _items[row]);
    _value = row;
    
    NSString *str = [NSString stringWithFormat:@"%@ ▼", _items[row]];
    
    [_button setTitle:str forState:UIControlStateNormal];
    [_button setTitle:str forState:UIControlStateHighlighted];
    [_button setTitle:str forState:UIControlStateSelected];
    //[_button setNeedsDisplay];
    //[_button drawRect:_button.bounds];
    
    if(_dict)
        _dict[@"value"] = [NSNumber numberWithInteger:_value];
    
    //20141022_KaiyuanHo: reload the row after item is chosen
    //[self setExpanded:NO initial:NO]; //item selected, close the picker
}

-(NSString*)pickerView:
(UIPickerView*)pickerView
           titleForRow:(NSInteger)row
          forComponent:(NSInteger)component
{
    return _items[row];
}

#if POPUPMENU
- (void)SetIndex:(NSInteger)index
{
    _value = index;
    if(_dict)
        _dict[@"value"] = @(index);
    
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:@[_index] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    
    UIViewController *topVC = [Constant getTopVC];
    topVC.modalPresentationStyle = prevStyle;
}
#endif

#if 0
- (CGSize)sizeWithData:(id)data
{
    //NSLog(@"sizeWithData called, stack=%@", [NSThread callStackSymbols]);
    CGSize s;
    s.width = self.frame.size.width;
    if(_isExpanded)
        s.height = _maxHeight;
    else
        s.height = _minHeight;
    
    NSLog(@"isExpanded: %d", _isExpanded);
    NSLog(@"current height = %f", s.height);
    
    return s;
}
#endif

-(void)reload
{
//    if(!_forceLoaded)
//    {
        NSLog(@"force load ok");
        [_picker reloadAllComponents];
//        _forceLoaded = YES;
        //To initial the picker
        [_picker selectRow:_value inComponent:0 animated:NO];
//    }
}

-(void)setTitle:(NSString *)title
{
    _label.text = title;
}

-(NSString*)getTitle
{
    return _label.text;
}

-(void)setAttrTitle:(NSAttributedString *)title
{
    _label.attributedText = title;
}

@end
