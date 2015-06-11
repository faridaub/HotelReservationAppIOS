//
//  ReservList.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/02.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ReservList.h"
#import "Constant.h"
#import "reservOperation.h"

@interface ReservList ()

@end

@implementation ReservList

static NSMutableArray *items;
static NSInteger Count;

static int pageNum = 1;
static BOOL reloadFlag = NO;

#define IMAGE_MAXWIDTH 100.0
#define DEFAULT_IMAGE @"http://toyoko-inn.com/hotel/images/h263h1.jpg"
#define IMAGE_VERTICAL_MARGIN 10.0

static NSString const *API_NAME = @"search_booking_api";

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
             @"¥6,300",@"price",
             @"¥6,804",@"price_tax",
             @"2014年6月1日", @"date",
             @"1泊", @"nights",
             @"123456789", @"reserv_num",
             @"禁煙シングル", @"room_type",
             @"TOYOKO",@"fmly_name",
             @"TARO",@"given_name",
             @"http://toyoko-inn.com/hotel/images/h263h1.jpg",@"image",
             nil];
#endif
#if 1 //reset the list
    items = [@[] mutableCopy];
    [_tableView reloadData];
#endif
#if 1
    pageNum = 1;
    Count = 0;
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
#endif
    
}

#if 1
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //To reload the table
    if(!reloadFlag)
    {
        return;
    }
    else
    {
        reloadFlag = NO; //reset the reload flag
        Count = 0;
        pageNum = 1;
        if(items != nil) //scroll to top
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
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
#endif

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
    NSLog(@"current rows: %lu, total: %ld", (unsigned long)items.count, (long)Count);
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
#if 1
    NSString *url;
    
    if([items[indexPath.row] objectForKey:IMAGE_URL]!=nil)
    {
        url = [items[indexPath.row] objectForKey:IMAGE_URL];
        if([url isEqualToString:@""])
            url = DEFAULT_IMAGE;
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
        cell.imageView.image = tmpImg;
        
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
                cell.imageView.image = tmpImg;
                
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
            }
        });
#endif
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
#endif
    [self AddFormattedString:cell dict:items[indexPath.row]];
    
    return cell;
}

-(void)AddFormattedString:(UITableViewCell*)cell dict:(NSDictionary*)dict
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:[dict objectForKey:HOTEL_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *linebreak=[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:linebreak];
    
    //reservation number
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    NSAttributedString *reserv_num=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"予約番号：%@",[dict objectForKey:RESERV_NUM]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:reserv_num];
    [s1 appendAttributedString:linebreak];
    
    //name
    NSAttributedString *full_name=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@様",[dict objectForKey:FAMILY_NAME],[dict objectForKey:GIVEN_NAME]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:full_name];
    [s1 appendAttributedString:linebreak];
    
    //today's date and nights
    
    NSAttributedString *date=[[NSAttributedString alloc] initWithString:[Constant convertToLocalDate:dict[CHECKIN_DATE]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    NSAttributedString *wave=[[NSAttributedString alloc] initWithString:@"〜" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *nights=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@泊",[dict objectForKey:NUM_NIGHTS]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:date];
    [s1 appendAttributedString:wave];
    [s1 appendAttributedString:nights];
    [s1 appendAttributedString:linebreak];
    
    //room type and price
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    //NSAttributedString *space=[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString *roomName = dict[ROOM_NAME];
    if(roomName==nil)
        roomName = @"";
    
    NSAttributedString *room_type=[[NSAttributedString alloc] initWithString:roomName attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *price=[[NSAttributedString alloc] initWithString:[dict objectForKey:PAYMENT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *price_tax=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(税込%@)",[dict objectForKey:PAYMENT_PRICE_TAX]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //add the 3nd line
    [s1 appendAttributedString:room_type];
    //[s1 appendAttributedString:space];
    [s1 appendAttributedString:linebreak];
    [s1 appendAttributedString:price];
    [s1 appendAttributedString:price_tax];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    reservOperation *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservOperation"];
    next.inputDict = items[indexPath.row];
    
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

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

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        Count = [data[@"nmbrRsrvtns"] integerValue];
        
        if(pageNum == 1)
        {
            if(Count > 0) //not zero item
            {
                NSArray *tmpArr = (NSArray*)data[@"rsrvtnsInfrmtn"];
                if(tmpArr == nil) //keyword typo
                {
                    tmpArr = (NSArray*)data[@"rsrvtnInfrmtn"];
                }
                items = [tmpArr mutableCopy];
                
                [_tableView reloadData];
            }
            else //To avoid null pointer
                items = [@[] mutableCopy];
        }
        else //load more data
        {
            NSLog(@"current page: %d", pageNum);
            NSArray *tmpArr = (NSArray*)data[@"rsrvtnsInfrmtn"];
            if(tmpArr == nil) //keyword typo
            {
                tmpArr = (NSArray*)data[@"rsrvtnInfrmtn"];
            }
            
            [items addObjectsFromArray: tmpArr];
            [_tableView reloadData];
        }
        
    }
    else if([data[@"errrCode"] isEqualToString:@"BCMN1004"])
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"現在予約中のホテルはありません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
        
        //To show the empty table
        Count = 0;
        items = [@[]mutableCopy];
        [_tableView reloadData];
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
