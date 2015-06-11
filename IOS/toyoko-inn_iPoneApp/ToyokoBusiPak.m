//
//  ToyokoBusiPak.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/16.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoBusiPak.h"

@implementation ToyokoBusiPak


static UIImage *radioOff, *radioOn;

#define DEFAULT_MARGIN 5

//formatted string (with %d) for line 1 and line 2

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

- (void)awakeFromNib
{
    //Add code to get the 3 button from tag to avoid the strange key-value exception
    _busipak1 = (UIButton*)[self viewWithTag:1];
    _busipak2 = (UIButton*)[self viewWithTag:2];
    _busipak3 = (UIButton*)[self viewWithTag:3];
    
    _btns = @[_busipak1, _busipak2, _busipak3];
    
    for(UIButton *btn in _btns)
    {
        [btn.layer setBorderColor:[UIColor blackColor].CGColor];
        [btn.layer setBorderWidth:0.5f];
        [btn.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        
        [btn addTarget:self action:@selector(ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    _value = -1; //no one selected
    
    _values1 = [[NSMutableArray alloc]init];
    _values2 = [[NSMutableArray alloc]init];
    
    _formatStr1 = [[NSMutableString alloc]init];
    _formatStr2 = [[NSMutableString alloc]init];
    
    radioOff = [UIImage imageNamed:@"ラジオオフ"];
    radioOn = [UIImage imageNamed:@"ラジオオン"];
}

-(void)setupButton:(UIButton *)button index:(NSInteger)index
{
    //TODO: customize the business pack items
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.numberOfLines = 0;
    
    NSAttributedString *tmp = [self MakeFormattedString:(NSInteger)_values1[index] value2:(NSInteger)_values2[index]];
    [button setAttributedTitle:tmp forState:UIControlStateNormal];
}

- (void)setValues:(NSArray*)v1 values2:(NSArray*)v2
{
    [_values1 removeAllObjects];
    [_values1 addObjectsFromArray:v1];
    
    [_values2 removeAllObjects];
    [_values2 addObjectsFromArray:v2];
    
    //TODO: add code to setup each button
    for(int i=0;i<_btns.count;i++)
    {
        [self setupButton:_btns[i] index:i];
    }
}

- (void)setFormattedStrings:(NSString*)str1 str2:(NSString*)str2
{
    [_formatStr1 setString:str1];
    [_formatStr2 setString:str2];
}

-(void)setValue:(NSInteger)value
{
    //_value = value;
    [self setSelectedIndex:value];
}

- (void)setSelectedIndex:(NSInteger)selected
{
    _value = selected;
    //change the state of buttons
    for(int i=0;i<_btns.count;i++)
    {
        UIButton *btn = _btns[i];
        if(i==_value)
        {
            [btn setImage:radioOn forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:radioOff forState:UIControlStateNormal];
        }
    }
    if(_dict)
    {
        _dict[@"value"] = @(_value);
    }
}

- (NSInteger)getSelectedIndex
{
    return _value;
}

- (void)ButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    int index=-1;
    for(int i=0;i<_btns.count;i++)
    {
        if(_btns[i] == button)
        {
            index = i;
            break;
        }
    }
    NSLog(@"index=%d", index);
    [self setSelectedIndex:index];
}

-(void)adjustSubview
{
    NSLog(@"busipak conteview: %@", NSStringFromCGRect(self.contentView.frame));
    if(self.leftMargin == 0) //not initialized
    {
        self.leftMargin = DEFAULT_MARGIN;
        self.rightMargin = DEFAULT_MARGIN;
        self.topMargin = DEFAULT_MARGIN;
        self.bottomMargin = DEFAULT_MARGIN;
    }
    
    CGRect r;
    r.origin.x = self.leftMargin;
    r.size.width = self.contentView.frame.size.width - self.leftMargin - self.rightMargin;
    
    for(UIButton *btn in _btns)
    {
        r.origin.y = btn.frame.origin.y;
        r.size.height = btn.frame.size.height;
        
        [btn setFrame:r];
        //NSLog(@"button r: %@",NSStringFromCGRect(r));
    }
}

-(void)setDict:(NSMutableDictionary*)dict
{
#if 0
    if(dict[@"value"])
    {
        [self setSelectedIndex:[dict[@"value"] integerValue]];
    }
#endif
    _dict = dict;
}

-(NSAttributedString*)MakeFormattedString:(NSInteger)value1 value2:(NSInteger)value2
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:_formatStr1, value1] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *linebreak=[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:10.0f];
    NSMutableAttributedString *s2=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:_formatStr2, value2] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];

    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:s2];
    
    //NSLog(@"attr str:%@", [s1 string]);
    
    return s1;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self adjustSubview];
}

@end
