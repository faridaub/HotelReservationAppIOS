//
//  ToyokoSegmentCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoSegmentCell.h"

@implementation ToyokoSegmentCell

//#define MAX_WIDTH 130

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
        // Initialization code
#if 0
        [_segment setSelectedSegmentIndex:_value];
#endif
    _segment.apportionsSegmentWidthsByContent = YES;
    
//    /*[[UISegmentedControl appearance]*/ [_segment setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0f],UITextAttributeFont: [UIFont systemFontOfSize:10.0f]} forState:UIControlStateNormal];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
#if 0
        [_segment setSelectedSegmentIndex:_value];
#endif
        _segment.apportionsSegmentWidthsByContent = YES;
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
-(void)setSegmentTitles:(NSArray*)titles
{
    NSUInteger i;
    NSUInteger max = MAX(titles.count, _segment.numberOfSegments);
    for(i=0;i<max;i++)
    {
        [_segment setTitle:titles[i] forSegmentAtIndex:i];
    }
    [_segment setSelectedSegmentIndex:_value];
}

- (IBAction)valueChanged:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    NSInteger value = seg.selectedSegmentIndex;
    _value = value;
    _dict[@"value"] = [NSNumber numberWithInt:(int)_segment.selectedSegmentIndex];
}

- (id)getValue
{
    return [NSNumber numberWithInteger:_segment.selectedSegmentIndex];
}

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
}

-(void)adjustSubview
{
    //NSLog(@"contentView:%@",NSStringFromCGRect(self.contentView.frame));
    //NSLog(@"segment:%@",NSStringFromCGRect(_segment.frame));
    _segment.clipsToBounds = YES;
    _segment.layer.cornerRadius = 5.0f;
    
#if 1
    for (id segment in _segment.subviews) {
        for(id label in [segment subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                UILabel *Label = (UILabel*)label;
                [Label setAdjustsFontSizeToFitWidth: YES];
                [Label setMinimumScaleFactor: 0.3f];
                [Label setAdjustsLetterSpacingToFitWidth:YES];
            }
        }
    }
#endif
    
    [_segment setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0f], NSForegroundColorAttributeName:[UIColor darkGrayColor]/*,UITextAttributeFont: [UIFont systemFontOfSize:10.0f]*/} forState:UIControlStateNormal];
    [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];

    for(int i=0;i<_segment.numberOfSegments;i++)
    {
        [_segment setWidth:0.0 forSegmentAtIndex:i];
    }
    
    //[_segment sizeToFit];
    
    CGRect r;
    r.origin.y = (self.contentView.frame.size.height - _segment.frame.size.height)/2;
    r.origin.x = self.contentView.frame.size.width - _segment.frame.size.width - self.rightMargin;
    r.size = _segment.frame.size;
    
    [_segment setFrame:r];
    _segment.apportionsSegmentWidthsByContent = YES;

}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //make the text label auto-shrink and vertically center aligned
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.5f;
    self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    [self adjustSubview];
    
    CGRect r = self.textLabel.frame;
    r.size.width = _segment.frame.origin.x - self.textLabel.frame.origin.x - self.leftMargin;
    [self.textLabel setFrame: r];
}
@end
