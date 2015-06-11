//
//  ToyokoButtonCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoButtonCell.h"

@implementation ToyokoButtonCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
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

-(void)setIcon:(UIImage*)icon
{
    self.imageView.image = icon;
    self.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.imageView setContentMode: UIViewContentModeCenter];
}

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UIFont *font = self.textLabel.font;
    font = [UIFont boldSystemFontOfSize:font.pointSize];
    
    self.textLabel.font = font;
}

- (IBAction)buttonPressed:(id)sender {
    if(_PressedAction && _delegate)
    {
        if([_delegate respondsToSelector:_PressedAction])
            [_delegate performSelector:_PressedAction];
    }
}

- (void)setButtonTitle:(NSString*)title
{
    _buttonTitle = title;
    [_button setTitle:_buttonTitle forState:UIControlStateNormal];
}

- (void)setAction:(SEL)action
{
    _PressedAction = action;
}

-(void)adjustSubview
{
    //NSLog(@"contentView:%@",NSStringFromCGRect(self.contentView.frame));
    //NSLog(@"button:%@",NSStringFromCGRect(_button.frame));
    [self.textLabel sizeToFit];
#if 0
    CGRect r;
    r.origin.y = (self.contentView.frame.size.height - _button.frame.size.height)/2;
    r.origin.x = self.contentView.frame.size.width - _button.frame.size.width - self.rightMargin;
    r.size = _button.frame.size;

    [_button setFrame:r];
#endif
    self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
}

- (void)setButtonHidden:(BOOL)hidden
{
    _button.hidden = hidden;
}

#if 0
- (void)setDelegate:(id)target
{
    self.delegate = target;
}
#endif

- (void) layoutSubviews {
    [super layoutSubviews];
    //[self adjustSubview];
    
    CGRect r;
    r.origin.y = (self.contentView.frame.size.height - _button.frame.size.height)/2;
    r.origin.x = self.contentView.frame.size.width - _button.frame.size.width - self.rightMargin;
    r.size = _button.frame.size;
    
    [_button setFrame:r];
    _button.clipsToBounds = YES;
    _button.layer.cornerRadius = 5.0f;
    
    self.textLabel.numberOfLines = 3;
#if 1
    CGRect rect = self.textLabel.frame;
    rect.size.width -= _button.frame.size.width;
    self.textLabel.frame = rect;
#endif
}
@end
