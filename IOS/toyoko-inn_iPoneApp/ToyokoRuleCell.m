//
//  ToyokoRuleCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/08.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoRuleCell.h"
#import "Constant.h"

@implementation ToyokoRuleCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    //your custom initialization code
    self.topMargin = 20;
    self.bottomMargin = 20;
    self.leftMargin = 10;
    self.rightMargin = 10;
    
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
    
    [self setAttrTitle: [self MakeFormattedString:_str1 str2:_str2]];
    
}

-(NSAttributedString*)MakeFormattedString:(NSString*)str1 str2:(NSString*)str2
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    UIFont *font = self.textLabel.font;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:font.pointSize];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s0=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSBackgroundColorAttributeName:[Constant textHeaderColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *s0_1 = [[NSAttributedString alloc] initWithString:@" "  attributes:@{NSFontAttributeName:font}];
    
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:boldFont, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *linebreak=[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    UIFont *smallFont = [UIFont systemFontOfSize:font.pointSize-4.0];
    
    NSAttributedString *s2=[[NSMutableAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:smallFont, NSForegroundColorAttributeName:[UIColor darkGrayColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:s2];
    [s0 appendAttributedString:s0_1];
    [s0 appendAttributedString:s1];
    
    return s0;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    
    CGFloat cellHeight = self.frame.size.height;
    CGRect r = self.textLabel.frame;
    
    r.origin.y = (cellHeight - r.size.height)/2; //center aligned
    [self.textLabel setFrame:r];
    
    [self.textLabel.layer setBorderWidth:0.5f];
    [self.textLabel.layer setBorderColor:[UIColor blackColor].CGColor];
}

@end
