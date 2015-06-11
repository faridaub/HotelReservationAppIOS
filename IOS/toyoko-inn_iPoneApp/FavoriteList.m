//
//  FavoriteList.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/02.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "FavoriteList.h"
#import "Constant.h"
#import "HotelInfoView.h"

//#define MARGIN 5
//#define IMAGE_MAXWIDTH 200.0
#define IMAGE_MAXHEIGHT 273.0

#define DEFAULT_IMAGE @"http://toyoko-inn.com/hotel/images/h263h1.jpg"

@interface FavoriteList ()

@end

@implementation FavoriteList

static NSMutableArray *items;
static NSInteger Count;

static int pageNum = 1;

#define IMAGE_MAXWIDTH 100.0
#define DEFAULT_IMAGE @"http://toyoko-inn.com/hotel/images/h263h1.jpg"
#define IMAGE_VERTICAL_MARGIN 10.0

static BOOL isLoadingHotelInfo = NO;
static NSString *selectedHotelCode;

static NSString const *API_NAME = @"search_favorite_hotel_api";

static BOOL reloadFlag;

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
#if 0
    items = [NSDictionary dictionaryWithObjectsAndKeys:
             @"東横INNアキバ浅草橋駅東口",@"hotel_name",
             @"¥6,300",@"mem_low",
             @"¥6,804",@"mem_tax",
             @"¥6,800",@"norm_low",
             @"¥7,344",@"norm_tax",
             @"2014年7月2日", @"date",
             @"2泊", @"nights",
             @"http://toyoko-inn.com/hotel/images/h263h1.jpg",@"image",
             nil];
#endif




#if 1
    //To query the favorite hotels
    isLoadingHotelInfo = NO;
    pageNum = 1;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[PAGE_NUM] = [NSString stringWithFormat:@"%d", pageNum];
        
        [self addRequestFields:dict];
        [self setApiName:(NSString*)API_NAME/*@"search_favorite_hotel_api"*/];
        [self setSecure:NO];
        
        [self sendRequest];
    }
#endif
    reloadFlag = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if 0
    //To query the favorite hotels
    isLoadingHotelInfo = NO;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[PAGE_NUM] = @"1"; //dummy
        
        [self addRequestFields:dict];
        [self setApiName:@"search_favorite_hotel_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
#endif
    //favorite list changed
    if(reloadFlag)
    {
        reloadFlag = NO;
        //To query the favorite hotels
        isLoadingHotelInfo = NO;
        pageNum = 1;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if([ud stringForKey:PERSON_UID])
        {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            self.delegate = self;
            dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
            dict[PAGE_NUM] = [NSString stringWithFormat:@"%d", pageNum];
            
            [self addRequestFields:dict];
            [self setApiName:(NSString*)API_NAME/*@"search_favorite_hotel_api"*/];
            [self setSecure:NO];
            
            [self sendRequest];
        }
    }
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
    return items.count/*Count*/;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //To remove the subviews for recycled cells
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    NSString *imgURL;
    
    if([items[indexPath.row] objectForKey:IMAGE_URL]!=nil)
    {
        imgURL = [items[indexPath.row] objectForKey:IMAGE_URL];
        if([imgURL isEqualToString:@""])
            imgURL = DEFAULT_IMAGE;
    }
    else
    {
        imgURL = DEFAULT_IMAGE;
    }
    
    //NSString *imgURL = [items[indexPath.row] objectForKey:IMAGE_URL];
    if([imgURL length] > 0) //not empty string
    {
        dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t q_main = dispatch_get_main_queue();
        cell.imageView.image = nil;
        dispatch_async(q_global, ^{
            NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
            if(urlData)
            {
                
                UIImage *tmpImg = [UIImage imageWithData:urlData];
                dispatch_async(q_main, ^{
                    cell.imageView.image = tmpImg;
#if 0
                    NSLog(@"image w:%f, h:%f", tmpImg.size.width, tmpImg.size.height);
                    
                    if(cell.imageView.image.size.width <= IMAGE_MAXWIDTH &&
                       cell.imageView.image.size.height <= IMAGE_MAXHEIGHT)
                    {
                        //cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
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
#else
                    float ratio = 1.0;
                    CGFloat maxHeight = _tableView.rowHeight - IMAGE_VERTICAL_MARGIN*2;
                    if(tmpImg.size.height > maxHeight/*_tableView.rowHeight*/)
                    {
                        ratio = maxHeight / tmpImg.size.height;
                        //cell.imageView.transform = CGAffineTransformMakeScale(ratio, ratio);
                    }
                    
                    if(tmpImg.size.width > IMAGE_MAXWIDTH)
                    {
                        if(ratio > IMAGE_MAXWIDTH/tmpImg.size.width) //height ratio is bigger
                        {
                            ratio = IMAGE_MAXWIDTH/tmpImg.size.width;
                            //cell.imageView.transform = CGAffineTransformMakeScale(ratio, ratio);
                        }
                    }
                    
                    
                    cell.imageView.transform = CGAffineTransformMakeScale(ratio/**0.5*/, ratio/**0.5*/);
                    [cell.imageView setContentMode: UIViewContentModeCenter ];
                    [cell layoutSubviews];
                });
#endif
            }
        });
    }
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    [self AddFormattedString:cell dict:items[indexPath.row]];
    
    return cell;
}

#if 1
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    isLoadingHotelInfo = YES;
    
    NSDictionary *inputDict = items[indexPath.row];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
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
#endif

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(Count > items.count) //not fully loaded
    {
        if((pageNum * 10 - 1) == indexPath.row) //last row to show
        {
            pageNum++;
            NSLog(@"to load next page");
            
            //To load the reservation list
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            if([ud stringForKey:PERSON_UID])
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                
                self.delegate = self;
                dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
                dict[PAGE_NUM] = [NSString stringWithFormat:@"%d", pageNum];
                
                [self addRequestFields:dict];
                [self setApiName:(NSString*)API_NAME/*@"search_booking_api"*/];
                [self setSecure:NO];
                
                [self sendRequest];
            }
        }
    }
}

-(void)AddFormattedString:(UITableViewCell*)cell dict:(NSDictionary*)dict
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1 //to add extra space on each line
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:HOTEL_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *linebreak=[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    
    //2nd line, today's date and nights
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyyMMdd"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    NSAttributedString *date=[[NSAttributedString alloc] initWithString:[Constant convertToLocalDate:date_String] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    NSAttributedString *wave=[[NSAttributedString alloc] initWithString:@"〜" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *nights=[[NSAttributedString alloc] initWithString:@"1泊" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:date];
    [s1 appendAttributedString:wave];
    [s1 appendAttributedString:nights];
    [s1 appendAttributedString:linebreak];
    
    //3nd line, member price, starts with red BG and white FG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSAttributedString *member=[[NSAttributedString alloc] initWithString:@" 会員 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppRedColor]}];
    
    //member lower price, gray FG and white BG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    NSAttributedString *space=[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    wave=[[NSAttributedString alloc] initWithString:@"〜" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *mem_low=[[NSAttributedString alloc] initWithString:[dict objectForKey:MEM_SINGLE_ROOM_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *mem_tax=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(税込%@)",[dict objectForKey:MEM_SINGLE_ROOM_PRICE_TAX]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];

    //add the 3nd line
    [s1 appendAttributedString:member];
    [s1 appendAttributedString:space];
    [s1 appendAttributedString:mem_low];
    [s1 appendAttributedString:mem_tax];
    [s1 appendAttributedString:wave];
    [s1 appendAttributedString:linebreak];
    
    //3rd line, normal price, starts with white FG and blue BG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSAttributedString *normal=[[NSAttributedString alloc] initWithString:@" 一般 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[Constant AppDarkBlueColor]}];
    
    //normal lower price, gray FG and white BG
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    NSAttributedString *norm_low=[[NSAttributedString alloc] initWithString:[dict objectForKey:SINGLE_ROOM_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *norm_tax=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(税込%@)",[dict objectForKey:SINGLE_ROOM_PRICE_TAX]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //normal higher price, red FG and white BG, bigger bold font
    
    //add the 3rd line
    [s1 appendAttributedString:normal];
    [s1 appendAttributedString:space];
    [s1 appendAttributedString:norm_low];
    [s1 appendAttributedString:norm_tax];
    [s1 appendAttributedString:wave];
    [s1 appendAttributedString:linebreak];

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
    
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        if(isLoadingHotelInfo == NO)
        {
            if(pageNum == 1)
            {
                Count = [data[@"nmbrMyFvrts"] integerValue];
                NSArray *tmpArr;
                if(Count > 0) //not zero item
                {
                    tmpArr = (NSArray*)data[@"myFvrtsInfrmtnList"];;
                    items = [tmpArr mutableCopy];
                    [_tableView reloadData];
                }
                else //To avoid null pointer
                    items = [@[]mutableCopy];
            }else
            {
                NSLog(@"current page: %d", pageNum);
                NSArray *tmpArr = (NSArray*)data[@"myFvrtsInfrmtnList"];
                
                [items addObjectsFromArray: tmpArr];
                [_tableView reloadData];
            }
        }
        else
        {
            isLoadingHotelInfo = NO; //reset the flag
            HotelInfoView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HotelInfoView"];
            next.inputDict = data;
            if(selectedHotelCode)
                next.hotelCode = selectedHotelCode;
            
            [self presentViewController:next animated:YES completion:^ {
            }];
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"BAPI1004"] ||
            [data[@"errrCode"] isEqualToString:@"BCMN1004"])
    {
        Count = 0;
        items = [@[] mutableCopy];
        [_tableView reloadData];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"お気に入りのホテルはありません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
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

- (void)setReload
{
    reloadFlag = YES;
}

@end
