//
//  ToyokoEcoplanCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/18.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoEcoplanCell.h"

@implementation ToyokoEcoplanCell

static UIImage *radioOff, *radioOn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    NSArray *controls = @[_date1, _date2, _date3, _date4, _date5, _date6, _date7, /*_dateNoSpecify,*/ _titleLabel];
    _buttons = @[_date1, _date2, _date3, _date4, _date5, _date6, _date7, /*_dateNoSpecify*/];
    _selectedArray =[[NSMutableArray alloc]init];
    _isNoSpecify = NO;
    
    for(UIView *view in controls)
    {
        [view.layer setBorderColor:[UIColor blackColor].CGColor];
        [view.layer setBorderWidth:0.5f];
    }
    
    radioOff = [UIImage imageNamed:@"ラジオオフ"];
    radioOn = [UIImage imageNamed:@"ラジオオン"];
    
    float imgHeight = radioOn.size.height/2.0f;
    float imgWidth = radioOn.size.width/2.0f;
#if 0
    _dateNoSpecify.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _dateNoSpecify.titleLabel.textAlignment = NSTextAlignmentCenter;
    _dateNoSpecify.titleLabel.numberOfLines = 0;
#endif
    for(UIButton *btn in _buttons)
    {
        CGRect r;
        
        //calculate the position of image, top-center aligned
        r.origin.x = (btn.frame.size.width - imgWidth)/2;
        r.origin.y = (btn.frame.size.height - imgHeight - btn.titleLabel.frame.size.height)/2;
        r.size.height = imgHeight;
        r.size.width = imgWidth;
        
        //NSLog(@"r: %@", NSStringFromCGRect(r));
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:r];
        imgv.image = radioOff; //default is not selected
        imgv.tag = 1; //set the tag number to get the subview directly
        [imgv setContentMode:UIViewContentModeScaleAspectFit];
        [btn addSubview:imgv];
    }
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)ButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSString *title = button.titleLabel.text;
    NSLog(@"%@ pressed", title);
#if 0
    if(button != _dateNoSpecify) //date button is touched
    {
#endif
        if([_selectedArray containsObject:title]) //the touched date is selected
        {
            [_selectedArray removeObject:title];
            //to deselect the button
            [self setButtonSelected:button selected:NO];
        }
        else
        {
            [_selectedArray addObject:title];
            //to select the button
            [self setButtonSelected:button selected:YES];
        }
#if 0
    }
    else //no specify button is touched
    {
        [self setNoSpecifySelected:!_isNoSpecify];
    }
#endif
    NSLog(@"selected items:%@", _selectedArray);
    _dict[@"value"] = _selectedArray;
}

- (void)setDates:(NSArray*)dates selectedDates:(NSArray*)selectedDates
{
    NSUInteger max = dates.count;
    if(max>7) //max 7 nights
        max=7;
    
    for(NSUInteger i=0;i<max;i++)
    {
        UIButton *btn = _buttons[i];
        [btn setTitle:dates[i] forState:UIControlStateNormal];
        
        //check if the button is selected
        if([selectedDates containsObject:dates[i]])
            [self setButtonSelected:btn selected:YES];
        else
            [self setButtonSelected:btn selected:NO];
    }
    
    if(max<7)
    {
        for(NSUInteger i=max;i<7;i++)
        {
            UIButton *btn = _buttons[i];
            btn.enabled = NO;
            [btn setTitle:@"" forState:UIControlStateNormal ];
        }
    }
    
    if(selectedDates != nil)
    {
        [_selectedArray removeAllObjects];
        [_selectedArray addObjectsFromArray:selectedDates];
    }
}

- (NSArray*)getSelectedDates
{
    return _selectedArray;
}

- (BOOL)isNoSpecifySelected
{
    return _isNoSpecify;
}

#if 0
- (void)setNoSpecifySelected:(BOOL)isSelected
{
    _isNoSpecify = isSelected;
    
    if(_isNoSpecify)
        _dict[@"ecoChckn"] = @"Y";
    else
        _dict[@"ecoChckn"] = @"N";
    
    //handle the no specify button
    [self setButtonSelected:_dateNoSpecify selected:_isNoSpecify];
        
    //handle other buttons
    for(UIButton* button in _buttons)
    {
        if(button != _dateNoSpecify)
        {
            if(_isNoSpecify) //no specify state
            {
                [self setButtonSelected:button selected:NO];
                button.enabled = NO;
            }
            else //specify state
            {
                //make each button enable if it has a title
                if(![button.currentTitle isEqualToString:@""])
                {
                    //NSLog(@"set the button with title %@ to enabled",button.titleLabel.text);
                    button.enabled = YES;
                }
            }
        }
    }

    //handle the selected array
    if(_isNoSpecify)
    {
        [_selectedArray removeAllObjects];
    }
    _dict[@"value"] = _selectedArray;
}
#endif

-(void)setButtonSelected:(UIButton*)button selected:(BOOL)selected
{
    UIView *view =[button viewWithTag:1];
    if([view isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView*)view;
        if(selected)
            imageView.image = radioOn;
        else
            imageView.image = radioOff;
    }
}

-(void)setDict:(NSMutableDictionary*)dict
{
    _dict = dict;
    _dict[@"ecoChckn"] = @"N"; //no "specify when checkin" option anymore
}

-(void)adjustSubview
{
    //adjust the positions of each button
    //NSLog(@"ecoplan contentView:%@", NSStringFromCGRect(self.contentView.frame));
    CGFloat width = self.contentView.frame.size.width;
    CGFloat cellWidth = width / 7.0f;
    
    CGRect r;
    r.origin.y = ((UIButton*)_buttons[0]).frame.origin.y;
    r.origin.x = self.leftMargin;
    r.size.height = ((UIButton*)_buttons[0]).frame.size.height;
    
    //setup the 7 dates button
    for(int i=0;i<7;i++)
    {
        UIButton *btn = _buttons[i];
        r.size.width = cellWidth;
        [btn setFrame:r];
        r.origin.x += cellWidth;
    }
    
    //setup the label
    r.origin.x = self.leftMargin;
    r.origin.y = _titleLabel.frame.origin.y;
    r.size.height = _titleLabel.frame.size.height;
    r.size.width = self.contentView.frame.size.width - self.leftMargin -self.rightMargin;
    [_titleLabel setFrame:r];
#if 0
    //setup the "select when checkin" button
    r = _dateNoSpecify.frame;
    r.size.width = cellWidth*1.5f;
    r.origin.x = self.leftMargin + cellWidth*7.0f;
    [_dateNoSpecify setFrame:r];
#endif
}
@end
