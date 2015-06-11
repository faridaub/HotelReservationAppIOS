//
//  landmark.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "landmark.h"
#import "Constant.h"


@implementation landmark

#define DEFAULT_IMAGE @"http://toyoko-inn.com/hotel/images/h263h1.jpg"

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //NSLog(@"frame: %@", NSStringFromCGRect(frame));
    return self;
}

- (void)awakeFromNib
{
    [_roomsLeftButton.imageView setContentMode: UIViewContentModeScaleAspectFit];
    [_hotelImageView setContentMode: UIViewContentModeScaleAspectFit];
    [_distanceLabel.layer setBorderWidth:0.5f];
    [_distanceLabel.layer setBorderColor:[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:10.0/255.0 alpha:1.0].CGColor];
    
    _distanceImg.hidden = NO;
    _distanceLabel.hidden = NO;
    
    //NSLog(@"frame: %@", NSStringFromCGRect(self.frame));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setDict:(NSDictionary*)dict
{
    if(dict[NUM_REMAINING_ROOMS])
    {
        _roomsLeftButton.hidden = NO;
        if([dict[NUM_REMAINING_ROOMS] integerValue] < 10)
        {
        NSString *roomsleft = [NSString stringWithFormat:@"残り%d室", [dict[NUM_REMAINING_ROOMS] intValue]];
        [_roomsLeftButton setTitle:roomsleft forState:UIControlStateNormal];
        }
        else
        {
            //To hide the real number of remaining rooms when more than 10 rooms left
            [_roomsLeftButton setTitle:@"空室あり" forState:UIControlStateNormal];
        }
    }
    else
    {
        _roomsLeftButton.hidden = YES;
    }
    
    NSString *distanceStr = [NSString stringWithFormat:@"現在地から%@", dict[DISTANCE_FROM_CURRENT_POSITION]];
    _distanceLabel.text = [NSString stringWithFormat:@" %@",distanceStr];
    
    NSString *url;
    if(dict[IMAGE_URL]!=nil) //not set
    {
        url = dict[IMAGE_URL];
        if([url isEqualToString:@""]) //empty URL
        {
            url = DEFAULT_IMAGE;
        }
    }
    else
    {
        url = DEFAULT_IMAGE;
    }
    
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if(urlData)
    {
        UIImage *tmpImg = [UIImage imageWithData:urlData];
        _hotelImageView.image = tmpImg;
        //_hotelImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [_hotelImageView setContentMode: UIViewContentModeScaleAspectFit ];
    }
    
    if(dict[DISTANCE_FROM_CURRENT_POSITION] == nil)
    {
        _distanceImg.hidden = YES;
        _distanceLabel.hidden = YES;
    }
    else if([dict[DISTANCE_FROM_CURRENT_POSITION] isEqualToString:@""])
    {
        _distanceImg.hidden = YES;
        _distanceLabel.hidden = YES;
    }
    
    [self AddFormattedString:dict];
}

- (IBAction)ClosePressed:(id)sender {
    if(_mapView) //avoid null pointer
    {
        if(_mapView.selectedMarker)
            _mapView.selectedMarker = nil;
    }

}

//add formatted string
-(void)AddFormattedString:(NSDictionary*)dict
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 5.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:HOTEL_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSMutableAttributedString *linebreak=[[NSMutableAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    
    if(!_isSingleHotelMode) //there is not price info in single hotel mode
    {
        //2nd line, member price, starts with red BG and white FG
        font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
        NSMutableAttributedString *member=[[NSMutableAttributedString alloc] initWithString:@" 会員 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppRedColor]/*[UIColor redColor]*/}];
        
        //member lower price, gray FG and white BG
        NSMutableAttributedString *space=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        NSMutableAttributedString *mem_low=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:MEMBER_OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //arrow, gray FG and white BG
        NSMutableAttributedString *arrow=[[NSMutableAttributedString alloc] initWithString:@" ▶ " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //member higher price, red FG and white BG, bigger bold font
        font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
        NSMutableAttributedString *mem_high=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:MEMBER_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppRedColor]/*[UIColor redColor]*/, NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //add the 2nd line
        [s1 appendAttributedString:member];
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:mem_high];
        [s1 appendAttributedString:arrow];
        [s1 appendAttributedString:mem_low];
        [s1 appendAttributedString:linebreak];
        
        //3rd line, normal price, starts with white FG and blue BG
        font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
        NSMutableAttributedString *normal=[[NSMutableAttributedString alloc] initWithString:@" 一般 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppDarkBlueColor]/*[UIColor blueColor]*/}];
        
        //normal lower price, gray FG and white BG
        NSMutableAttributedString *norm_low=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //normal higher price, red FG and white BG, bigger bold font
        font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
        NSMutableAttributedString *norm_high=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:LISTED_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppRedColor]/*[UIColor redColor]*/, NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //add the 3rd line
        [s1 appendAttributedString:normal];
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:norm_high];
        [s1 appendAttributedString:arrow];
        [s1 appendAttributedString:norm_low];
        [s1 appendAttributedString:linebreak];
    }
    
    //4th line, access, starts with black FG and white BG, smaller font
    if(dict[@"accssInfmtn"] != nil)
    {
        font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
        NSMutableAttributedString *access=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:@"accssInfmtn"] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //add the 4th line
        [s1 appendAttributedString:access];
    }
    
    _textLabel.attributedText = s1;
}
@end
