//
//  HotelListView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/24.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "HotelListView.h"
#import "Constant.h"
#import "MapView.h"
#import "HotelInfoView.h"

@interface HotelListView ()

@end

@implementation HotelListView

#define LABEL_HEIGHT 21.5
#define MARGIN 5

#define IMAGE_MAXWIDTH 200.0
#define IMAGE_MAXHEIGHT 273.0

#define ROOMS_MARGIN 10.0

#define DEFAULT_IMAGE @"http://toyoko-inn.com/hotel/images/h263h1.jpg"

#if 0
static NSDictionary *items;
#endif
static NSString *selectedHotelCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_NaviBar.topItem.title = self.title;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5f;
    [label setText:self.title];
    _NaviBar.topItem.titleView = label;
#if 0
    items = [NSDictionary dictionaryWithObjectsAndKeys:
             @"東横INNアキバ浅草橋駅東口",HOTEL_NAME,
             @"¥6,300",MEMBER_OFFICIAL_DISCOUNT_PRICE,
             @"¥7,300",MEMBER_PRICE,
             @"¥6,800",OFFICIAL_DISCOUNT_PRICE,
             @"¥7,800",LISTED_PRICE,
             @"JR総武線「浅草橋駅」東口より徒歩3分",@"access",
             @"現在地から%@", ],DISTANCE_FROM_CURRENT_POSITION,
             @"http://toyoko-inn.com/hotel/images/h263h1.jpg",@"image",
             @"残り5室", @"roomsleft",
             nil];
#endif
    
    _ConstraintButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _SortButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [_ConstraintButton.imageView setContentMode:UIViewContentModeCenter];
    [_SortButton.imageView setContentMode:UIViewContentModeCenter];
    _ConstraintButton.clipsToBounds = YES;
    _SortButton.clipsToBounds = YES;
    _ConstraintButton.layer.cornerRadius = 10;
    _SortButton.layer.cornerRadius = 10;
    _SortButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _SortButton.titleLabel.minimumScaleFactor = 0.5f;
    
    [_tableView.layer setBorderWidth:0.5f];
    [_tableView.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //use auto layout now...size calculation not used anymore
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    //move the 2 buttons to the bottom of screen, and enlarge the table
    
    [_ConstraintButton setFrame:CGRectMake(_ConstraintButton.frame.origin.x,
                                           r.size.height - _ConstraintButton.frame.size.height,
                                           _ConstraintButton.frame.size.width,
                                           _ConstraintButton.frame.size.height)];
    [_SortButton setFrame:CGRectMake(_SortButton.frame.origin.x,
                                     r.size.height - _SortButton.frame.size.height,
                                     _SortButton.frame.size.width,
                                     _SortButton.frame.size.height)];
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x,
                                    _tableView.frame.origin.y,
                                    _tableView.frame.size.width,
                                    r.size.height-_tableView.frame.origin.y-_SortButton.frame.size.height/*-MARGIN*/)];
#endif
    if(_inputArray.count < 2) //need 2 or more objects for sorting
    {
        _SortButton.enabled = NO;
    }
    else //equal or more than 2
    {
        NSDictionary *dict = _inputArray[0];
        NSString *distance = dict[DISTANCE_FROM_CURRENT_POSITION];
        if(distance == nil) //not set
            distance = @"";
        
        _SortButton.enabled = YES;
        if([distance isEqualToString:@""]) //empty or not set
        {
            [_SortButton setTitle:@"おすすめ順" forState:UIControlStateNormal];
            [_SortButton setImage:[UIImage imageNamed:@"おすすめ順"] forState:UIControlStateNormal];
        }
        else
        {
            [_SortButton setTitle:@"近い順" forState:UIControlStateNormal];
        }
        
        //20150428: pre-sort the array
        double delayInSeconds = 0.5f; //delay 0.1 sec
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //[self SortPressed:_SortButton];
            if([distance isEqualToString:@""]) //distance not available
            {
                [self SortByRooms];
            }
            else
            {
                [self SortByDistance];
            }
            [_tableView reloadData];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
    
    //change the text when the previous view is not home view
#if 0
    NSLog(@"previous view: %@", self.presentingViewController);
    NSLog(@"root view: %@", self.view.window.rootViewController);
#endif
    if(![NSStringFromClass([self.presentingViewController class]) isEqualToString:@"SearchEntry"])
    {
        _BackButton.title = @"戻る";
    }
    else
    {
        _BackButton.title = @"ホーム";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)MoveToHotel:(NSString*)htlCode
{
#if 0
    NSDictionary *inputDict;
    for(NSDictionary *dict in _inputArray)
    {
        if(![htlCode isEqualToString:dict[HOTEL_CODE]])
        {
            continue;
        }
        else //matched
        {
            inputDict = dict;
        }
    }
#endif
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[HOTEL_CODE] = htlCode;
    selectedHotelCode = htlCode;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
    
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"search_hotel_details_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSDictionary *inputDict = _inputArray[indexPath.row];
    
    dict[HOTEL_CODE] = inputDict[HOTEL_CODE];
    selectedHotelCode = inputDict[HOTEL_CODE];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
    
    self.delegate = self;
    [self addRequestFields:dict];
    [self setApiName:@"search_hotel_details_api"];
    [self setSecure:NO];
    
    [self sendRequest];

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_inputArray count]/*3*/;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath called, index=%ld", (long)indexPath.row);
    
    NSString *cellIdentifier = @"Detail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = _inputArray[indexPath.row];
    
    UIImageView *imgv;
    UILabel *label;
    UIImageView *distanceMark;
    UILabel *distanceLabel;
    UIButton *rooms;
    
    //main image view
    if([[cell viewWithTag:1]isKindOfClass:[UIImageView class]])
    {
        imgv = (UIImageView*)[cell viewWithTag:1];
    }
    
    //main label
    if([[cell viewWithTag:2]isKindOfClass:[UILabel class]])
    {
        label = (UILabel*)[cell viewWithTag:2];
    }
    
    //distance icon
    if([[cell viewWithTag:3]isKindOfClass:[UIImageView class]])
    {
        distanceMark = (UIImageView*)[cell viewWithTag:3];
    }
    
    //distance label
    if([[cell viewWithTag:4]isKindOfClass:[UILabel class]])
    {
        distanceLabel = (UILabel*)[cell viewWithTag:4];
        [distanceLabel.layer setBorderWidth:0.5f];
        [distanceLabel.layer setBorderColor:[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:10.0/255.0 alpha:1.0].CGColor];
    }
    
    if(dict[DISTANCE_FROM_CURRENT_POSITION] != nil)
    {
        if([dict[DISTANCE_FROM_CURRENT_POSITION] isEqualToString:@""] == NO)
        {
            distanceLabel.hidden = NO;
            distanceMark.hidden = NO;
            
            UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
            NSMutableAttributedString *tmpStr=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSBackgroundColorAttributeName:[UIColor whiteColor]}];
            
            NSString *distanceStr = [NSString stringWithFormat:@"現在地から%@", dict[DISTANCE_FROM_CURRENT_POSITION]];
            NSMutableAttributedString *distance=[[NSMutableAttributedString alloc] initWithString:distanceStr attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSBackgroundColorAttributeName:[UIColor whiteColor]}];
            [tmpStr appendAttributedString:distance];
            [distanceLabel setAttributedText:tmpStr];
        }
        else
        {
            distanceLabel.hidden = YES;
            distanceMark.hidden = YES;
        }
    }
    else
    {
        distanceLabel.hidden = YES;
        distanceMark.hidden = YES;
    }
    
    //remaining rooms button
    if([[cell viewWithTag:5]isKindOfClass:[UIButton class]])
    {
        rooms = (UIButton*)[cell viewWithTag:5];
        [rooms.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        
        if(dict[NUM_REMAINING_ROOMS]!=nil) //there are some rooms left
        {
            rooms.hidden = NO;
            if([dict[NUM_REMAINING_ROOMS] integerValue] < 10)
            {
                [rooms setTitle:[NSString stringWithFormat:@"残り%d室", [dict[NUM_REMAINING_ROOMS] intValue]] forState:UIControlStateNormal];
            }
            else
            {
                //To hide the real number of remaining rooms when more than 10 rooms left
                [rooms setTitle:@"空室あり" forState:UIControlStateNormal];
            }
        }
        else //no remaining room info
        {
            rooms.hidden = YES;
        }
    }
    
    NSString *url;
    if(dict[IMAGE_URL]!=nil) //set
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
    
#if 1
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    cell.imageView.image = nil;
    dispatch_async(q_global, ^{
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *tmpImg;
        
        if(urlData)
        {
            tmpImg = [UIImage imageWithData:urlData];
            dispatch_async(q_main, ^{
                imgv.image = tmpImg;
                [cell layoutSubviews];
            });
        }
    });
#endif
    UIView *superview = imgv.superview;
    [superview bringSubviewToFront:rooms];
    
    //fill the descriptions
    [self AddFormattedString:dict label:label];
    
    return cell;
}

#if 0
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath called, index=%ld", (long)indexPath.row);
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = _inputArray[indexPath.row];
    
    //To remove the subviews for recycled cells
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    NSString *url;
    if(dict[IMAGE_URL]!=nil) //set
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
    UIImage *tmpImg;
    //float ratio = 0.5; //default ratio
    if(urlData)
    {
        tmpImg = [UIImage imageWithData:urlData];
        cell.imageView.image = tmpImg;
        NSLog(@"image w:%f, h:%f", tmpImg.size.width, tmpImg.size.height);
        
        if(cell.imageView.image.size.width <= IMAGE_MAXWIDTH &&
           cell.imageView.image.size.height <= IMAGE_MAXHEIGHT)
        {
            cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [cell.imageView setContentMode: UIViewContentModeCenter ];
        }
        else
        {
            float ratioW = IMAGE_MAXWIDTH/cell.imageView.image.size.width;
            float ratioH = IMAGE_MAXHEIGHT/cell.imageView.image.size.height;
            
            float ratio = MIN(ratioH, ratioW);
            
            ratio *= 0.5;
            
            cell.imageView.transform = CGAffineTransformMakeScale(ratio, ratio);
            [cell.imageView setContentMode: UIViewContentModeCenter ];
        }
    }
#if 1
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
#endif
    UIImage *distanceMark = [UIImage imageNamed:@"現在地距離アイコン"];
    
    //add the distance label
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(distanceMark.size.width/2.0+cell.separatorInset.left-1,cell.contentView.frame.size.height-LABEL_HEIGHT-MARGIN,
    cell.contentView.frame.size.width-distanceMark.size.width/2.0-cell.separatorInset.left, LABEL_HEIGHT)];
    [label.layer setBorderWidth:0.5];
    [label.layer setBorderColor:[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:10.0/255.0 alpha:1.0].CGColor];
    
    //add the distance icon
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(cell.separatorInset.left, cell.contentView.frame.size.height-LABEL_HEIGHT-MARGIN, distanceMark.size.width/2.0, LABEL_HEIGHT)];
    
    [imgv setImage:distanceMark];
    //imgv.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [imgv setContentMode: UIViewContentModeScaleAspectFit ];
    
    //if distance is not set, do not display
    if(dict[DISTANCE_FROM_CURRENT_POSITION] != nil)
        if([dict[DISTANCE_FROM_CURRENT_POSITION] isEqualToString:@""] == NO)
        {
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:imgv];
        }
    
    if(dict[NUM_REMAINING_ROOMS]!=nil) //there are some rooms left
    {
        //float ImgWidth = tmpImg.size.width * ratio;
        //float ImgHeight = tmpImg.size.height * ratio;
        
        //create rooms icon and button and add them to cell
        UIImage *roomsIcon = [UIImage imageNamed:@"残室アイコン"];
#if 0
        UIButton *rooms = [[UIButton alloc] initWithFrame:CGRectMake(cell.imageView.frame.origin.x - roomsIcon.size.width/2.0+MARGIN,
            cell.imageView.frame.origin.y+cell.imageView.frame.size.height/*ImgHeight*/-roomsIcon.size.height/2.0,
            roomsIcon.size.width+cell.imageView.frame.size.width/*ImgWidth*//2.0,
            roomsIcon.size.height)];
#else
        UIButton *rooms = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     cell.contentView.frame.size.height-ROOMS_MARGIN-roomsIcon.size.height,
                                                                     roomsIcon.size.width+cell.imageView.frame.size.width/*ImgWidth*//2.0,
                                                                     roomsIcon.size.height)];
#endif
        [rooms setBackgroundColor:[Constant AppRedColor]];
        [rooms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rooms.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:10.0f];
        [rooms setImage:roomsIcon forState:UIControlStateNormal];
        //rooms.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        float inset = roomsIcon.size.height/4.0;
        rooms.imageEdgeInsets = UIEdgeInsetsMake(inset, -inset, inset, 0.0);
        [rooms.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        rooms.titleLabel.adjustsFontSizeToFitWidth = YES;
        rooms.titleLabel.minimumScaleFactor = 0.5f;
        [rooms setTitle:[NSString stringWithFormat:@"残り%d室", [dict[NUM_REMAINING_ROOMS] intValue]] forState:UIControlStateNormal];
#if 0
        [cell addSubview:rooms];
#else
        [cell.contentView addSubview:rooms];
#endif
        //bring the remaing rooms button to front
        [cell.contentView bringSubviewToFront:rooms];
        [cell sendSubviewToBack:cell.imageView];
    }
    
    [self AddFormattedString:cell dict:dict label:label];
    
    return cell;
}
#endif

-(void)AddFormattedString:(NSDictionary*)dict label:(UILabel*)label
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:dict[HOTEL_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSMutableAttributedString *linebreak=[[NSMutableAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    
    //2nd line, member price, starts with red BG and white FG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *member=[[NSMutableAttributedString alloc] initWithString:@" 会員 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppRedColor]}];
    
    //member lower price, gray FG and white BG
    NSMutableAttributedString *space=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor redColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSMutableAttributedString *mem_low=[[NSMutableAttributedString alloc] initWithString:dict[MEMBER_OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppRedColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //arrow, gray FG and white BG
    NSMutableAttributedString *arrow=[[NSMutableAttributedString alloc] initWithString:@" ▶ " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //member higher price, red FG and white BG, bigger bold font
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *mem_high=[[NSMutableAttributedString alloc] initWithString:dict[MEMBER_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //add the 2nd line
    //if price varies
    if(![dict[MEMBER_OFFICIAL_DISCOUNT_PRICE] isEqualToString:dict[MEMBER_PRICE]])
    {
        [s1 appendAttributedString:member];
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:mem_high];
        [s1 appendAttributedString:arrow];
        [s1 appendAttributedString:mem_low];
        [s1 appendAttributedString:linebreak];
    }
    else
    {
        [s1 appendAttributedString:member];
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:mem_low];
        [s1 appendAttributedString:linebreak];
    }
    
    //3rd line, normal price, starts with white FG and blue BG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *normal=[[NSMutableAttributedString alloc] initWithString:@" 一般 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppDarkBlueColor]}];
    
    //normal lower price, gray FG and white BG
    NSMutableAttributedString *norm_low=[[NSMutableAttributedString alloc] initWithString:dict[OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppRedColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //normal higher price, red FG and white BG, bigger bold font
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *norm_high=[[NSMutableAttributedString alloc] initWithString:dict[LISTED_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //add the 3rd line
    //if price varies
    if(![dict[LISTED_PRICE] isEqualToString:dict[OFFICIAL_DISCOUNT_PRICE]])
    {
        [s1 appendAttributedString:normal];
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:norm_high];
        [s1 appendAttributedString:arrow];
        [s1 appendAttributedString:norm_low];
        [s1 appendAttributedString:linebreak];
    }
    else
    {
        [s1 appendAttributedString:normal];
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:norm_low];
        [s1 appendAttributedString:linebreak];
    }
    
    if(dict[@"accssInfmtn"]!=nil)
    {
        //4th line, access, starts with black FG and white BG, smaller font
        font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
        NSMutableAttributedString *access=[[NSMutableAttributedString alloc] initWithString:dict [@"accssInfmtn"] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //add the 4th line
        [s1 appendAttributedString:access];
    }
    
    [s1 appendAttributedString:linebreak];
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [label setAttributedText:s1];
    
    //[label sizeToFit];
}

-(void)AddFormattedString:(UITableViewCell*)cell dict:(NSDictionary*)dict label:(UILabel*)label
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:dict[HOTEL_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSMutableAttributedString *linebreak=[[NSMutableAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    
    //2nd line, member price, starts with red BG and white FG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *member=[[NSMutableAttributedString alloc] initWithString:@" 会員 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppRedColor]}];
    
    //member lower price, gray FG and white BG
    NSMutableAttributedString *space=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor redColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSMutableAttributedString *mem_low=[[NSMutableAttributedString alloc] initWithString:dict [MEMBER_OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppRedColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //arrow, gray FG and white BG
    NSMutableAttributedString *arrow=[[NSMutableAttributedString alloc] initWithString:@" ▶ " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //member higher price, red FG and white BG, bigger bold font
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *mem_high=[[NSMutableAttributedString alloc] initWithString:dict [MEMBER_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //add the 2nd line
    [s1 appendAttributedString:member];
    [s1 appendAttributedString:space];
    [s1 appendAttributedString:mem_high];
    [s1 appendAttributedString:arrow];
    [s1 appendAttributedString:mem_low];
    [s1 appendAttributedString:linebreak];
    
    //3rd line, normal price, starts with white FG and blue BG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *normal=[[NSMutableAttributedString alloc] initWithString:@" 一般 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppDarkBlueColor]}];
    
    //normal lower price, gray FG and white BG
    NSMutableAttributedString *norm_low=[[NSMutableAttributedString alloc] initWithString:dict [OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppRedColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //normal higher price, red FG and white BG, bigger bold font
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *norm_high=[[NSMutableAttributedString alloc] initWithString:dict [LISTED_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //add the 3rd line
    [s1 appendAttributedString:normal];
    [s1 appendAttributedString:space];
    [s1 appendAttributedString:norm_high];
    [s1 appendAttributedString:arrow];
    [s1 appendAttributedString:norm_low];
    [s1 appendAttributedString:linebreak];
    
    if(dict[@"accssInfmtn"]!=nil)
    {
        //4th line, access, starts with black FG and white BG, smaller font
        font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
        NSMutableAttributedString *access=[[NSMutableAttributedString alloc] initWithString:dict [@"accssInfmtn"] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
        
        //add the 4th line
        [s1 appendAttributedString:access];
    }
#if 1
    //To make the text top aligned
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:linebreak];
#endif
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setAttributedText:s1];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    NSMutableAttributedString *tmpStr=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    if(dict[DISTANCE_FROM_CURRENT_POSITION] != nil)
        if([dict[DISTANCE_FROM_CURRENT_POSITION] isEqualToString:@""] == NO)
        {
            NSString *distanceStr = [NSString stringWithFormat:@"現在地から%@", dict[DISTANCE_FROM_CURRENT_POSITION]];
            NSMutableAttributedString *distance=[[NSMutableAttributedString alloc] initWithString:distanceStr attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
            [tmpStr appendAttributedString:distance];
            [label setAttributedText:tmpStr];
        }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@",data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        HotelInfoView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelInfoView"];
        next.inputDict = data;
        if(selectedHotelCode)
            next.hotelCode = selectedHotelCode;
        
        [self presentViewController:next animated:YES completion:^ {
        }];
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}

- (IBAction)ConstraintPressed:(id)sender {
}

- (void)SortByDistance
{
    NSSortDescriptor *sortDist = [[NSSortDescriptor alloc] initWithKey:DISTANCE_FROM_CURRENT_POSITION ascending:YES];
    //sort by distance
    _inputArray = [_inputArray sortedArrayUsingDescriptors:@[sortDist]];
}

- (void)SortByPrice
{
    NSSortDescriptor *sortDist;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:MEMBER_NUM])
    {
        sortDist = [[NSSortDescriptor alloc] initWithKey:MEMBER_PRICE ascending:YES];
    }
    else
    {
        sortDist = [[NSSortDescriptor alloc] initWithKey:LISTED_PRICE ascending:YES];
    }
    _inputArray = [_inputArray sortedArrayUsingDescriptors:@[sortDist]];
}

- (void)SortByRooms
{
    NSComparator comp = ^(id obj1, id obj2) {
        NSInteger rank1 = [obj1 integerValue];
        NSInteger rank2 = [obj2 integerValue];
        NSComparisonResult result = [@(rank1) compare:@(rank2)];
        //NSLog(@"obj1 2 result: %d:%d:%d", rank1, rank2, result);
        return (NSComparisonResult)result;
    };
    //recommended ranking, show the most remaining hotel on the top
    NSSortDescriptor *sortDist = [[NSSortDescriptor alloc] initWithKey:NUM_REMAINING_ROOMS ascending:NO comparator:comp];
    _inputArray = [_inputArray sortedArrayUsingDescriptors:@[sortDist]];
}

-(void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //NSString *person_uid = [ud stringForKey:PERSON_UID];
    
    switch (buttonIndex)
    {
        case 0:
            [self SortByRooms];
            [_SortButton setImage:[UIImage imageNamed:@"おすすめ順"] forState:UIControlStateNormal];
            break;
            
        case 1:
            [self SortByPrice];
            [_SortButton setImage:[UIImage imageNamed:@"安い順"] forState:UIControlStateNormal];
            break;
            
        case 2: //distance
            [self SortByDistance];
            [_SortButton setImage: [UIImage imageNamed:@"場所アイコン"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)showSortActionSheet
{
    Class class = NSClassFromString(@"UIAlertController");
    
    BOOL isDistanceAvail = NO;
    
    NSString *msg;
    msg = @"並び替え";
    
    NSDictionary *dict = _inputArray[0];
    NSString *distance = dict[DISTANCE_FROM_CURRENT_POSITION];
    if(distance == nil) //not set
        distance = @"";
    
    if(![distance isEqualToString:@""]) //distance set
        isDistanceAvail = YES;
    
    if(class){ //iOS8, use alert controller
        // UIAlertControllerを使ってアクションシートを表示
        UIAlertController *actionSheet = nil;
        
        actionSheet = [UIAlertController alertControllerWithTitle:@"確認"
                                                          message:msg
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"おすすめ順"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          [self SortByRooms];
                                                          [_tableView reloadData];
                                                          [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                        [_SortButton setTitle:@"おすすめ順" forState:UIControlStateNormal];
                                                        [_SortButton setImage:[UIImage imageNamed:@"おすすめ順"] forState:UIControlStateNormal];
                                                      }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"安い順"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          [self SortByPrice];
                                                          [_tableView reloadData];
                                                          [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                          [_SortButton setTitle:@"安い順" forState:UIControlStateNormal];
                                                          [_SortButton setImage:[UIImage imageNamed:@"安い順"] forState:UIControlStateNormal];
                                                      }]];
        if(isDistanceAvail)
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"近い順"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction *action){
                                                          [self SortByDistance];
                                                          [_tableView reloadData];
                                                          [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                          [_SortButton setTitle:@"近い順" forState:UIControlStateNormal];
                                                          [_SortButton setImage: [UIImage imageNamed:@"場所アイコン"] forState:UIControlStateNormal];
                                                      }]];
        }
        
        // ユニバーサルアプリかiPadアプリの場合は、
        // UIPopoverPresentationControllerを使った以下のコードが無いと落ちてしまうので注意
        // （このコードがあっても、iPhoneでの実行時には何も変化なし）
        actionSheet.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *pop = actionSheet.popoverPresentationController;
        pop.sourceView = self.view;
        //TODO: set the correct rectangle
        pop.sourceRect = CGRectMake(100.0, 100.0, 20.0, 20.0);
        
        [self presentViewController:actionSheet
                           animated:YES
                         completion:nil];
    }else{ //iOS 7 or earlier, use action sheet
        // UIActionSheetを使ってアクションシートを表示
        UIActionSheet *as = [[UIActionSheet alloc] init];
        as.delegate = self;
        as.title = msg;
        [as addButtonWithTitle:@"おすすめ順"];
        [as addButtonWithTitle:@"安い順"];
        if(isDistanceAvail)
        {
            [as addButtonWithTitle:@"近い順"];
        }
        
        as.destructiveButtonIndex = 0;
        as.cancelButtonIndex = -1;
        [as showInView:self.view];
    }
}

- (IBAction)SortPressed:(id)sender {
    NSDictionary *dict = _inputArray[0];
    NSString *distance = dict[DISTANCE_FROM_CURRENT_POSITION];
    if(distance == nil) //not set
        distance = @"";
    
    if(![distance isEqualToString:@""]) //distance is set
    {
        //show action sheet
        [self showSortActionSheet];
    }
    else
    {
        //no distance available, sort by remaining rooms only
        [self.ai startAnimating];
        [self SortByRooms];
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.ai stopAnimating];
    }
   
}

- (IBAction)MapPressed:(id)sender {
    MapView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    
    next.centerLatt = _lttd;
    next.centerLngtd = _lngtd;
    
    next.searchDict = _searchDict;
    next.inputArray = _inputArray;
    next.title = self.title;
    next.isSingleHotelMode = NO; //added for one hotel only mode modification
    
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}
@end
