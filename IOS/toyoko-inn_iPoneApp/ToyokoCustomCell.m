//
//  ToyokoCustomCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomCell.h"
#import "Constant.h"
#define DEFAULT_MARGIN 5
#define CELL_WIDTH 320
#define BORDER_WIDTH 1.0f

#define BGLABEL_TAG 10

@implementation ToyokoCustomCell

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    //your custom initialization code
    self.topMargin = 5;
    self.bottomMargin = 5;
    self.leftMargin = 8;
    self.rightMargin = 8;
    
#if 1
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.5;
#endif
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.topMargin = 5;
        self.bottomMargin = 5;
        self.leftMargin = 8;
        self.rightMargin = 8;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttrTitle:(NSAttributedString*)newTitle
{ 
    _AttrTitle = newTitle;
    self.textLabel.attributedText = _AttrTitle;
#if 0
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.numberOfLines = 0;
#endif
}

-(void)setTitle:(NSString*)newTitle
{
    _title = newTitle;
    self.textLabel.text = _title;
#if 0
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.numberOfLines = 0;
#endif
}

-(NSString*)getTitle
{
    return _title;
}

-(NSAttributedString*)getAttrTitle
{
    return _AttrTitle;
}

//do nothing
-(void)setValue:(id)value
{
}

//Warning: This method must be overridden
-(id)getValue
{
    return nil;
}

-(void)setDetail:(NSString*)str
{
    self.detailTextLabel.text = str;
}

-(void)setAttrDetail:(NSAttributedString*)attr
{
    self.detailTextLabel.attributedText = attr;
}

//To be overridden for the cells with an input
-(void)setDict:(NSMutableDictionary*)dict
{
}

//To override for the cells with subview
-(void)adjustSubview
{
}

-(void)setRequired:(BOOL)required
{
    _requiredMark = required;
}

//To show/hide border
-(void)setBorder:(BOOL)border
{
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    
    if(border)
        [self.layer setBorderWidth:0.5f];
    else
        [self.layer setBorderWidth:0.0f];
}

-(void)setLabel:(BOOL)label color:(UIColor *)color border:(NSArray*)border
{
    _bgLabel = (UILabel*)[self.contentView viewWithTag:BGLABEL_TAG];
    NSArray *borderKey = @[@"top", @"bottom", @"left", @"right"];
    if(label)
    {
        
        if(_bgLabel == nil)
        {
            CGRect r = self.frame;
            r.origin.x = DEFAULT_MARGIN;
            r.size.width = CELL_WIDTH-DEFAULT_MARGIN*2;
            _bgLabel = [[UILabel alloc] initWithFrame:r];
            _bgLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            _bgLabel.tag = BGLABEL_TAG; //temporary number
            [self.contentView addSubview:_bgLabel];
            [self.contentView sendSubviewToBack:_bgLabel];

        }
        
#if 0
        NSLog(@"cell subviews: %@",self.contentView.subviews);
#endif
        _bgLabel.hidden = NO;
        _bgLabel.backgroundColor = color;

        for(NSString *str in borderKey)
        {
            if([border containsObject:str]) //border to create
            {
                NSLog(@"to add border %@", str);
                CALayer *layer = [CALayer layer];
                
                if([str isEqualToString:@"top"])
                {
                    layer.frame = CGRectMake(0, 0, _bgLabel.frame.size.width, BORDER_WIDTH);
                }
                else if([str isEqualToString:@"bottom"])
                {
                    layer.frame = CGRectMake(0, _bgLabel.frame.size.height - BORDER_WIDTH, _bgLabel.frame.size.width, BORDER_WIDTH);
                }
                else if([str isEqualToString:@"left"])
                {
                    layer.frame = CGRectMake(0, 0, BORDER_WIDTH, _bgLabel.frame.size.height);
                }
                else if([str isEqualToString:@"right"])
                {
                    layer.frame = CGRectMake(_bgLabel.frame.size.width - BORDER_WIDTH, 0, BORDER_WIDTH, _bgLabel.frame.size.height);
                }
                layer.name = str;
                layer.backgroundColor = [UIColor darkGrayColor].CGColor;
                [_bgLabel.layer addSublayer:layer];
                [layer setNeedsDisplay];
                [layer displayIfNeeded];
            }
            else //border to remove
            {
                NSLog(@"to remove border %@", str);
                //to avoid NSGenericException, remove layer in another loop
                NSMutableArray *tmpArray = [NSMutableArray array];
                for (CALayer *layer in _bgLabel.layer.sublayers)
                {
                    if([layer.name isEqualToString:str])
                    {
                        //[layer removeFromSuperlayer];
                        [tmpArray addObject:layer];
                    }
                }
                
                for(CALayer *layer in tmpArray)
                {
                    [layer removeFromSuperlayer];
                }
                [tmpArray removeAllObjects];
            }
        }
    }
    else //remove all labels
    {
        if(_bgLabel != nil)
        {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for(CALayer *layer in _bgLabel.layer.sublayers)
            {
                if([borderKey containsObject:layer.name]) //extra custom layer
                {
                    //[layer removeFromSuperlayer];
                    [tmpArray addObject:layer];
                }
            }
            for(CALayer *layer in tmpArray)
            {
                [layer removeFromSuperlayer];
            }
            [tmpArray removeAllObjects];
        }
    }
}

-(void)autoAttrTitle
{
    UIFont *font = self.textLabel.font;
    font = [UIFont boldSystemFontOfSize:font.pointSize];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    NSMutableAttributedString *s0=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSBackgroundColorAttributeName:[Constant textHeaderColor]/*[UIColor blueColor]*/, NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *s0_1 = [[NSAttributedString alloc] initWithString:@" "  attributes:@{NSFontAttributeName:font}];
    
    NSAttributedString *s1=[[NSAttributedString alloc] initWithString:[self getTitle] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSBackgroundColorAttributeName:[UIColor clearColor], NSParagraphStyleAttributeName: paragraph}];
#if 0
    font = [UIFont systemFontOfSize:font.pointSize-6.0];
    NSAttributedString *s2=[[NSAttributedString alloc] initWithString:@" 必須 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName:[Constant AppRedColor]/*[UIColor redColor]*/, NSParagraphStyleAttributeName: paragraph}];
#else
    UIImage *required = [UIImage imageNamed:@"必須マーク"];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = required;
    CGRect rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = required.size.width / 2.0f;
    rect.size.height = required.size.height / 2.0f;
    
    textAttachment.bounds = rect;
    
    NSAttributedString *s2 = [NSAttributedString attributedStringWithAttachment:textAttachment];
#endif
    
    [s0 appendAttributedString:s0_1];
    [s0 appendAttributedString:s1];
    
    if(_requiredMark)
        [s0 appendAttributedString:s2];
    
    [self setAttrTitle:s0];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //adjust the positions of text labels for special style only
    if([self.reuseIdentifier isEqualToString:@"2Cols"])
    {
#if 0
        NSArray *labels = @[self.textLabel, self.detailTextLabel];

        CGFloat cellHeight = self.frame.size.height;
        CGRect r;
#if 0
        //adjust the horizontal position of 2 labels
        float diff = self.detailTextLabel.frame.size.width;
        [self.detailTextLabel sizeToFit];
        diff -= self.detailTextLabel.frame.size.width;
        r = self.detailTextLabel.frame;
        r.origin.x += diff;
        NSLog(@"diff: %f", diff);
        self.detailTextLabel.frame = r;
#endif
        for(UILabel *label in labels)
        {
            //[label sizeToFit]; //shrink once before alignment
            r = label.frame;
            //NSLog(@"text label frame:%@",NSStringFromCGRect(r));
            
            r.origin.y = (cellHeight - r.size.height)/2; //center aligned
            [label setFrame:r];
        }
#endif
    }
    else if([self.reuseIdentifier isEqualToString:@"Description"] ||
            [self.reuseIdentifier isEqualToString:@"Picker"])
    {
        CGFloat cellHeight = self.frame.size.height;
        CGRect borderRect;
        _bgLabel = (UILabel*)[self.contentView viewWithTag:BGLABEL_TAG];
        CALayer *leftBorder, *rightBorder, *bottomBorder;
        
        if(_bgLabel)
        {
            for (CALayer *layer in _bgLabel.layer.sublayers)
            {
                if([layer.name isEqualToString:@"left"])
                    leftBorder = layer;
                
                if([layer.name isEqualToString:@"right"])
                    rightBorder = layer;
                
                if([layer.name isEqualToString:@"bottom"])
                    bottomBorder = layer;
            }
            
            if(leftBorder)
            {
                borderRect = leftBorder.frame;
                borderRect.size.height = cellHeight;
                leftBorder.frame = borderRect;
                [leftBorder setNeedsDisplay];
                [leftBorder displayIfNeeded];
            }
            if(rightBorder)
            {
                borderRect = rightBorder.frame;
                borderRect.size.height = cellHeight;
                rightBorder.frame = borderRect;
                [rightBorder setNeedsDisplay];
                [rightBorder displayIfNeeded];
            }
            if(bottomBorder)
            {
                NSLog(@"cell height: %f",cellHeight);
                borderRect = bottomBorder.frame;
                borderRect.origin.y = cellHeight-BORDER_WIDTH;
                bottomBorder.frame = borderRect;
                [bottomBorder setNeedsDisplay];
                [bottomBorder displayIfNeeded];
            }
        }
    }
}
@end
