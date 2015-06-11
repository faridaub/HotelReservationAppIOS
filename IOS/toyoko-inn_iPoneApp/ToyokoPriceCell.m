//
//  ToyokoPriceCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/31.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoPriceCell.h"

@implementation ToyokoPriceCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    _label = (UILabel*)[self viewWithTag:1];
    //your custom initialization code
    [_label.layer setBorderColor:[UIColor blackColor].CGColor];
    [_label.layer setBorderWidth:0.5f];
    
    self.leftMargin = 8;
    self.rightMargin = 8;
    
    return self;
}


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
-(void)setStrings:(NSString*)str1 str2:(NSString*)str2
{
    _str1 = str1;
    _str2 = str2;
    
    _label.attributedText = [self MakeFormattedString:_str1 str2:_str2];
}

-(NSAttributedString*)MakeFormattedString:(NSString*)str1 str2:(NSString*)str2
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    UIFont *font = _label.font;
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    NSAttributedString *linebreak=[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    NSAttributedString *s2=[[NSMutableAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor colorWithRed:170.0/255.0 green:4.0/255.0 blue:4.0/255.0 alpha:1.0]/*[UIColor redColor]*/, NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:s2];
    
    return s1;
}

-(void)adjustSubview
{
    CGRect r = _label.frame;
    r.origin.x = self.leftMargin;
    r.size.width = self.contentView.frame.size.width - self.leftMargin -self.rightMargin;
    [_label setFrame:r];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self adjustSubview];
}
@end
