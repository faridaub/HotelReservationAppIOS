//
//  RoomTypeList.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/27.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "RoomTypeList.h"
#import "RoomInfoView.h"
#import "PlanList.h"
#import "Constant.h"
#import "UIImage+UISegmentIconAndText.h"

@interface RoomTypeList ()

@end

@implementation RoomTypeList

#if 0
static NSDictionary *items;
#endif

#define BUTTON_HEIGHT 30
#define MARGIN 5
#define ARROW_MARGIN 10
#define NUM_ROWS 1

#define DEFAULT_IMAGE @"http://www.toyoko-inn.com/images/app/deluxe_twin.jpg"/*@"http://www.toyoko-inn.com/sp/images/H243r1.jpeg"*/

#define IMAGE_MAXWIDTH 260.0
#define IMAGE_MAXHEIGHT 200.0

static NSArray *roomlist;
static NSMutableDictionary *typelist;

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
    items = [[NSDictionary alloc] initWithObjectsAndKeys:
             @"喫煙ダブル",@"room_name",
             @"2",@"capacity",
             @"¥28,500",@"mem_price",
             @"¥35,200",@"norm_price",
             @"http://www.toyoko-inn.com/sp/images/H243r5.jpeg",@"image",
             @"残り5室",@"roomsleft",
             @"YES",@"smoking",
             nil];
#endif
    //[self AddMapButton];
#if 0
    if(NUM_ROWS*_tableView.rowHeight < _tableView.frame.size.height)
    {
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.rowHeight*NUM_ROWS);
    }   
#endif
    
    //query the room types
    self.delegate = self;
    [self addRequestFields:_searchDict];
    [self setApiName:@"search_room_type_vacant_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(roomlist == nil)
        return 0;
    else
        return [roomlist count];
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
    NSDictionary *items = roomlist[indexPath.row];
    
    NSString *cellIdentifier = @"Detail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *roomImage; //tag 1
    UIImageView *smokingIcon; //tag 2
    UILabel *roomName; //tag 3
    UILabel *priceLabel; //tag 4
    UIButton *rooms; //tag 5
    UILabel *capacity; //tag 7
    UIButton *reservButton; //tag 8
    
    if([[cell viewWithTag:1]isKindOfClass:[UIImageView class]])
    {
        roomImage = (UIImageView*)[cell viewWithTag:1];
    }
    
    if([[cell viewWithTag:2]isKindOfClass:[UIImageView class]])
    {
        smokingIcon = (UIImageView*)[cell viewWithTag:2];
        
        UIImage *smoking = [UIImage imageNamed:@"喫煙マーク"];
        UIImage *nonsmoking = [UIImage imageNamed:@"禁煙マーク"];
        
        if([[items objectForKey:SMOKING_FLAG] isEqualToString:@"Y"])
        {
            smokingIcon.image = smoking;
        }
        else
        {
            smokingIcon.image = nonsmoking;
        }
    }
    
    if([[cell viewWithTag:3]isKindOfClass:[UILabel class]])
    {
        roomName = (UILabel*)[cell viewWithTag:3];
    }
    
    if([[cell viewWithTag:4]isKindOfClass:[UILabel class]])
    {
        priceLabel = (UILabel*)[cell viewWithTag:4];
        [self AddFormattedString2:priceLabel dict:items];
        //[priceLabel sizeToFit];
    }
    
    if([[cell viewWithTag:5]isKindOfClass:[UIButton class]])
    {
        rooms = (UIButton*)[cell viewWithTag:5];
        [rooms.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        
        if(items[NUM_REMAINING_ROOMS]!=nil) //there are some rooms left
        {
            rooms.hidden = NO;
            if([items[NUM_REMAINING_ROOMS] integerValue] < 10)
            {
                [rooms setTitle:[NSString stringWithFormat:@"残り%d室", [items[NUM_REMAINING_ROOMS] intValue]] forState:UIControlStateNormal];
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
    
    if([[cell viewWithTag:7]isKindOfClass:[UILabel class]])
    {
        capacity = (UILabel*)[cell viewWithTag:7];
        UIImage *person = [UIImage imageNamed:@"定員アイコン"];
#if 0
        CGRect rect;
        rect.size = person.size;
        rect.origin.x = 0;
        rect.origin.y = 0;
        
        rect.size.width /= 2.0f;
        rect.size.height /= 2.0f;
        
        UIImage *person2 = [UIImage resize:person rect:rect];
#endif
        
        int max_people = [items[MAX_PEOPLE] intValue];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = person;
#if 1
        CGRect rect;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.width = person.size.width / 2.0f;
        rect.size.height = person.size.height / 2.0f;
        
        textAttachment.bounds = rect;
#endif
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        
        for(int i=0; i<max_people; i++)
        {
            [attr appendAttributedString:attrStringWithImage];
        }
        
        capacity.attributedText = attr;
    }
    
    if([[cell viewWithTag:8]isKindOfClass:[UIButton class]])
    {
        reservButton = (UIButton*)[cell viewWithTag:8];
        reservButton.clipsToBounds = YES;
        reservButton.layer.cornerRadius = 5.0f;
    }
    
    roomName.text = items[ROOM_NAME];
    
    NSString *url;
    if(items[IMAGE_URL]!=nil) //set
    {
        url = items[IMAGE_URL];
        if([url isEqualToString:@""]) //empty URL
        {
            url = DEFAULT_IMAGE;
        }
        url = [ url stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([url isEqualToString:@""]) //empty URL
        {
            url = DEFAULT_IMAGE;
        }
    }
    else
    {
        url = DEFAULT_IMAGE;
    }
    
#if 0
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if(urlData)
    {
        UIImage *tmpImg = [UIImage imageWithData:urlData];
        roomImage.image = tmpImg;
    }
#else
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    cell.imageView.image = nil;
    dispatch_async(q_global, ^{
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if(urlData)
        {
            UIImage *tmpImg = [UIImage imageWithData:urlData];
            dispatch_async(q_main, ^{
                roomImage.image = tmpImg;
            });
        }
    });
#endif
    
    [reservButton addTarget:self action:@selector(ReservPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#if 0
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath called");
    
    NSDictionary *items = roomlist[indexPath.row];
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //To remove the subviews for recycled cells
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    //add image
#if 0
    if([items objectForKey:IMAGE_URL]!=nil)
    {
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[items objectForKey:IMAGE_URL]]];
        if(urlData)
        {
            UIImage *tmpImg = [UIImage imageWithData:urlData];
            cell.imageView.image = tmpImg;
            cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [cell.imageView setContentMode: UIViewContentModeCenter ];
        }
    }
#endif
    NSString *url;
    if(items[IMAGE_URL]!=nil) //set
    {
        url = items[IMAGE_URL];
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
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    UIButton *reservButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                       cell.contentView.frame.origin.x+cell.separatorInset.left,
                                                                       cell.contentView.frame.origin.y+cell.contentView.frame.size.height-BUTTON_HEIGHT-MARGIN,
                                                                       cell.contentView.frame.size.width-cell.separatorInset.left-MARGIN, BUTTON_HEIGHT)];
    [reservButton setBackgroundColor:[Constant DescBlueColor]];
    [reservButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reservButton setTitle:@"予約する" forState:UIControlStateNormal];
    [reservButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    reservButton.tag = indexPath.row; //use tag to find out which row the button belongs
    [reservButton addTarget:self action:@selector(ReservPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:reservButton];
    
    //add the right arrow to the reserve button
    UIImage *arrow = [UIImage imageNamed:@"右矢印"];
    UIImageView *arrowImgv = [[UIImageView alloc] initWithFrame:CGRectMake(
                    reservButton.frame.size.width-arrow.size.width/2-ARROW_MARGIN,
                    (reservButton.frame.size.height-arrow.size.height/2)/2,
                    arrow.size.width/2, arrow.size.height/2)];
    arrowImgv.image = arrow;
    [arrowImgv setContentMode: UIViewContentModeScaleAspectFit ];
    [reservButton addSubview:arrowImgv];
    
    [self AddFormattedString:cell dict:items];
    
    if([items objectForKey:NUM_REMAINING_ROOMS]!=nil) //there are some rooms left
    {
        //create rooms icon and button and add them to cell
        UIImage *roomsIcon = [UIImage imageNamed:@"残室アイコン"];
        UIButton *rooms = [[UIButton alloc] initWithFrame:CGRectMake(cell.imageView.frame.origin.x - roomsIcon.size.width/2.0+MARGIN,
                                                                     cell.imageView.frame.origin.y+cell.imageView.frame.size.height-roomsIcon.size.height/2.0,
                                                                     roomsIcon.size.width+cell.imageView.frame.size.width/2.0,
                                                                     roomsIcon.size.height)];
#if 1
        rooms.tag = 1; //add tag for reuse purpose
#endif
        [rooms setBackgroundColor:[Constant AppRedColor]];
        [rooms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rooms.titleLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:10.0f];
        [rooms setImage:roomsIcon forState:UIControlStateNormal];
        //rooms.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        float inset = roomsIcon.size.height/4.0;
        rooms.imageEdgeInsets = UIEdgeInsetsMake(inset, -inset, inset, 0.0);
        [rooms.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        [rooms setTitle:[NSString stringWithFormat:@"残り%d室",[[items objectForKey:NUM_REMAINING_ROOMS]intValue]] forState:UIControlStateNormal];
#if 0
        [cell addSubview:rooms];
#else
        [cell.contentView addSubview:rooms];
#endif
        //bring the remaing rooms button to front
#if 0
        [cell bringSubviewToFront:rooms];
#else
        [cell.contentView bringSubviewToFront:rooms];
#endif
        [cell sendSubviewToBack:cell.imageView];
    }
    
    return cell;
}
#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:_searchDict];
    dict[ROOM_TYPE] = roomlist[indexPath.row][ROOM_TYPE];

    //20150529: add plan code
    NSDictionary *planlist = typelist[dict[ROOM_TYPE]];
    if(planlist.count == 1) //one plan only
    {
        dict[PLAN_CODE] = roomlist[indexPath.row][PLAN_CODE];
        RoomInfoView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomInfoView"];
        
        next.searchDict = [dict mutableCopy];
        next.inputDict = roomlist[indexPath.row];
        next.htlName = _htlName;
        [self presentViewController:next animated:YES completion:^ {
        }];
    }
    else
    {
        PlanList *next = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanList"];
        next.searchDict = [dict mutableCopy];
        next.htlName = _htlName;
        next.planlist = [planlist allValues];
        next.title = self.title;
        [self presentViewController:next animated:YES completion:^ {
        }];
    }   
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)MapPressed:(id)sender {
}

- (void)ReservPressed:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:_searchDict];
#if 1
    UITableViewCell* cell;
    UIView* tmp = button.superview;
#if 0
    NSLog(@"superview of button: %@", NSStringFromClass([button.superview class]));
    NSLog(@"superview2 of button: %@", NSStringFromClass([button.superview.superview class]));
#endif
#if 1
    while(tmp != nil)
    {
        //NSLog(@"view's class: %@",NSStringFromClass([tmp class]));
        if([tmp isKindOfClass:[UITableViewCell class]])
        {
            cell = (UITableViewCell*)tmp;
            break;
        }
        else
            tmp = tmp.superview;
    }
#else
    if([button.superview isKindOfClass:[UITableViewCell class]])
        cell = (UITableViewCell*)button.superview;
    else
        cell = (UITableViewCell*)button.superview.superview;
#endif
    
#if 1
    UITableView* table;
    tmp = cell.superview;
    while(tmp != nil)
    {
        NSLog(@"view's class: %@",NSStringFromClass([tmp class]));
        if([tmp isKindOfClass:[UITableView class]])
        {
            table = (UITableView*)tmp;
            break;
        }
        else
            tmp = tmp.superview;
    }
#endif
    
    //UITableView* table = (UITableView *)[cell superview];
    NSIndexPath* index = [table indexPathForCell:cell];
#endif

    [self tableView:_tableView didSelectRowAtIndexPath:index];
    /*
#if 0
    dict[ROOM_TYPE] = roomlist[button.tag][ROOM_TYPE];
#else
    dict[ROOM_TYPE] = roomlist[index.row][ROOM_TYPE];
#endif
    
    RoomInfoView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomInfoView"];
    //20150529: add plan code
#if 1
    if(roomlist[index.row][PLAN_CODE])
    {
        dict[PLAN_CODE] = roomlist[index.row][PLAN_CODE];
    }
#endif
    next.searchDict = [dict mutableCopy];
#if 0
    next.inputDict = roomlist[button.tag];
#else
    next.inputDict = roomlist[index.row];
#endif
    next.htlName = _htlName;
    
    [self presentViewController:next animated:YES completion:^ {
    }];
     */
}

#if 0
-(void)AddMapButton
{
    CGRect r;
    
    UIButton *mapButton;
    
    r.size.width = 30/*[UIImage imageNamed:@"地図アイコン"].size.width*/;
    r.size.height = r.size.width;
    r.origin.x = 0/*MARGIN*/;
    r.origin.y = 0/*MARGIN*/;
        
    mapButton = [[UIButton alloc] initWithFrame:r];
    [mapButton.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [mapButton setTitle:@"MAP" forState:UIControlStateNormal];
    [mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mapButton setBackgroundColor:[UIColor blueColor]];
        
    [mapButton setImage:[UIImage imageNamed:@"地図アイコン"] forState:UIControlStateNormal];
    //mapButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [mapButton.imageView setContentMode: UIViewContentModeScaleAspectFit ];
    mapButton.imageEdgeInsets = UIEdgeInsetsMake(4.0, 5.0, 10.0, 5.0);
    mapButton.titleEdgeInsets = UIEdgeInsetsMake(20.0, -37.5, 0.0, 0.0);
   
    
    //[cell.contentView addSubview:_mapButton];
    //[mapButton addTarget:self action:@selector(MapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_mapButton setCustomView:mapButton];
}
#endif

-(void)AddFormattedString2:(UILabel*)label dict:(NSDictionary*)dict
{
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    NSAttributedString *member=[[NSMutableAttributedString alloc] initWithString:@" 会員 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppRedColor]}];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSAttributedString *normal=[[NSMutableAttributedString alloc] initWithString:@" 一般 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppDarkBlueColor]}];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
    NSAttributedString *space=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *mem_price=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:MEMBER_OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *norm_price=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:OFFICIAL_DISCOUNT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *linebreak=[[NSMutableAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSMutableAttributedString *tmp=[[NSMutableAttributedString alloc] initWithAttributedString:member];
    [tmp appendAttributedString:space];
    [tmp appendAttributedString:mem_price];
    [tmp appendAttributedString:linebreak];
    [tmp appendAttributedString:normal];
    [tmp appendAttributedString:space];
    [tmp appendAttributedString:norm_price];
    [tmp appendAttributedString:space];
    
    label.attributedText = tmp;
}

-(void)AddFormattedString:(UITableViewCell*)cell dict:(NSDictionary*)dict
{
    UIImage *smoking = [UIImage imageNamed:@"喫煙マーク"];
    UIImage *nonsmoking = [UIImage imageNamed:@"禁煙マーク"];
    UIImage *person = [UIImage imageNamed:@"定員アイコン"];
    
    float x, y;
    
    //add the 1st line
    x = cell.separatorInset.left;
    y = cell.imageView.frame.origin.y+MARGIN;
    
    UIImageView *smokingMark = [[UIImageView alloc] initWithFrame:CGRectMake(x, y,                                                                        15, 15)];
    [smokingMark setContentMode: UIViewContentModeScaleAspectFit ];
    
    if([[dict objectForKey:SMOKING_FLAG] isEqualToString:@"Y"])
    {
        smokingMark.image = smoking;
    }
    else
    {
        smokingMark.image = nonsmoking;
    }
    //add the smoking/nonsmoking mark
    [cell.contentView addSubview:smokingMark];
    x+=smokingMark.frame.size.width;
    
    //compose the room name
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:ROOM_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(x, y, [s1 size].width, [s1 size].height)];
    roomName.attributedText = s1;
    [cell.contentView addSubview:roomName];
    x+=roomName.frame.size.width;
    
    //compose the "capacity" and people marks
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12.0f];
    
    NSAttributedString *capacity=[[NSMutableAttributedString alloc] initWithString:@" 定員 " attributes:@{NSFontAttributeName:font, NSBackgroundColorAttributeName:[UIColor lightGrayColor], NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    x = cell.contentView.frame.size.width  - [capacity size].width - [[dict objectForKey:MAX_PEOPLE]intValue]*(person.size.width/2+1)-MARGIN*2;
    
    UILabel *capaLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, [capacity size].width, [capacity size].height)];
    capaLabel.attributedText = capacity;
    [cell.contentView addSubview:capaLabel];
    x += [capacity size].width;
    
    //add the person icons
    //add the background label for the gray BG of person icons
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, [[dict objectForKey:MAX_PEOPLE]intValue]*(person.size.width/2)+2*MARGIN, person.size.height/2)];
    bgLabel.backgroundColor=[UIColor grayColor];
    [cell.contentView addSubview:bgLabel];
    
    //add the person icons to the BG label
    for(int i=0;i < [[dict objectForKey:MAX_PEOPLE]intValue]; i++)
    {
        UIImageView *imgv;
#if 0
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN+i*(person.size.width/2+1), 0, person.size.width/2, person.size.height/2)];
#else
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(x+MARGIN+i*(person.size.width/2+1), y, person.size.width/2, person.size.height/2)];
#endif
        [imgv setContentMode: UIViewContentModeScaleAspectFit ];
        
        imgv.image = person;
        imgv.backgroundColor = [UIColor grayColor];
        imgv.alpha = 1.0;
#if 0
        [bgLabel addSubview:imgv];
#else
        [cell.contentView addSubview:imgv];
#endif
        [bgLabel bringSubviewToFront:imgv];
    }
    y+=smokingMark.frame.size.height + MARGIN;
    x = cell.separatorInset.left;
    
    //add the 2nd and 3rd line
    //2nd line, member price, starts with red BG and white FG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSAttributedString *member=[[NSMutableAttributedString alloc] initWithString:@" 会員 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppRedColor]}];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSAttributedString *normal=[[NSMutableAttributedString alloc] initWithString:@" 一般 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppDarkBlueColor]}];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
    NSAttributedString *space=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *mem_price=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:MEMBER_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *norm_price=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:LISTED_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *linebreak=[[NSMutableAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSMutableAttributedString *tmp=[[NSMutableAttributedString alloc] initWithAttributedString:member];
    [tmp appendAttributedString:space];
    [tmp appendAttributedString:mem_price];
    [tmp appendAttributedString:linebreak];
    [tmp appendAttributedString:normal];
    [tmp appendAttributedString:space];
    [tmp appendAttributedString:norm_price];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, [tmp size].width, [tmp size].height)];
    priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.numberOfLines = 0;
    priceLabel.attributedText = tmp;
    
    [cell.contentView addSubview:priceLabel];
    NSLog(@"cell imgv:%f %f %f %f",cell.imageView.frame.origin.x, cell.imageView.frame.origin.y,
          cell.imageView.frame.size.width, cell.imageView.frame.size.height);
}

-(void)DistinctRoomType:(NSArray*)list
{
    typelist = [[NSMutableDictionary alloc]init];
    
    for(NSDictionary *dict in list)
    {
        NSString *roomType = dict[ROOM_TYPE];
        if(typelist[roomType] == nil) //not inserted yet
        {
            NSMutableDictionary *planlist = [[NSMutableDictionary alloc]init];
            planlist[dict[PLAN_CODE]] = dict;
            typelist[roomType] = planlist;
        }
        else
        {
            NSMutableDictionary *planlist = typelist[roomType];
            planlist[dict[PLAN_CODE]] = dict;
        }
    }
    
    NSMutableArray *unique_room = [[NSMutableArray alloc] init];
    for(NSString *roomType in [typelist allKeys])
    {
        NSDictionary *planlist = typelist[roomType];
        
        if(planlist.count == 1) //one plan only, 0000 or 3Q gomen
        {
            [unique_room addObject:[planlist allValues][0]];
            continue;
        }
        
        //more than 2 or more plans
        if(planlist[@"0000"]) //basic plan exists
        {
            [unique_room addObject:planlist[@"0000"]];
            continue;
        }
        //TODO: room type without basic plan?
    }
    NSLog(@"room types: %@",unique_room);
#if 1
    NSSortDescriptor *sortDist = [[NSSortDescriptor alloc] initWithKey:MAX_PEOPLE ascending:YES];
    //sort by capacity
    roomlist = [unique_room sortedArrayUsingDescriptors:@[sortDist]];
    //roomlist = unique_room;
#endif
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        roomlist = data[@"roomList"];
        [self DistinctRoomType:roomlist];
        [_tableView reloadData];
    }
    else if([data[@"errrCode"] isEqualToString:@"BAPI1004"])
    {
        //make the view empty
        roomlist = @[];
        [_tableView reloadData];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"空室がありません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
    else if([data[@"errrCode"] isEqualToString:@"BAPI1007"])
    {
        //make the view empty
        roomlist = @[];
        [_tableView reloadData];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"検索対象ホテルは全部満室です。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
    else
    {
        //make the view empty
        roomlist = @[];
        [_tableView reloadData];
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
