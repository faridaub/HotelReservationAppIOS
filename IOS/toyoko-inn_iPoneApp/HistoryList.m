//
//  HistoryList.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/02.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "HistoryList.h"
#import "Constant.h"
#import "HistoryView.h"

@interface HistoryList ()

@end

@implementation HistoryList

static NSMutableArray *items;
static NSInteger Count;
static int pageNum = 1;

#define DEFAULT_IMAGE @"http://toyoko-inn.com/hotel/images/h263h1.jpg"

static NSString const *API_NAME = @"search_stay_history_api";

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
    Count = 0;
    pageNum = 1;
    
    self.delegate = self; //To get calls to callback methods
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if([ud stringForKey:PERSON_UID])
    {
        NSDictionary *dict=@{PERSON_UID:[ud stringForKey:PERSON_UID], PAGE_NUM:[NSString stringWithFormat:@"%d", pageNum]};
        
        [self addRequestFields:dict];
        [self setApiName:(NSString*)API_NAME/*@"search_stay_history_api"*/];
        [self setSecure:NO];
        
        [self sendRequest];
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
    
    NSString *url;
    
    if([items[indexPath.row] objectForKey:IMAGE_URL]!=nil)
    {
        url = [items[indexPath.row] objectForKey:IMAGE_URL];
        if([url length] == 0)
            url = DEFAULT_IMAGE;
    }
    else
    {
        url = DEFAULT_IMAGE;
    }
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    cell.imageView.image = nil;
    
    dispatch_async(q_global, ^{
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if(urlData)
        {
            dispatch_async(q_main, ^{
                UIImage *tmpImg = [UIImage imageWithData:urlData];
                cell.imageView.image = tmpImg;
                cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                [cell.imageView setContentMode: UIViewContentModeCenter ];
                [cell layoutSubviews];
            });
        }
    });
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
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
    NSAttributedString *reserv_num=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:/*@"Reserv. No.:%@"*/@"予約番号：%@",[dict objectForKey:RESERV_NUM]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:reserv_num];
    [s1 appendAttributedString:linebreak];
    
    //name
    NSAttributedString *full_name=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:/*@"Mr./Ms. %@ %@"*/@"%@ %@様",[dict objectForKey:GIVEN_NAME],[dict objectForKey:FAMILY_NAME]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:full_name];
    [s1 appendAttributedString:linebreak];
    
    //today's date and nights
    
    NSAttributedString *date=[[NSAttributedString alloc] initWithString:[Constant convertToLocalDate:dict[CHECKIN_DATE]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    NSAttributedString *wave=[[NSAttributedString alloc] initWithString:@"〜" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *nights=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:/*@"%@ night(s)"*/@"%@泊",[dict objectForKey:NUM_NIGHTS]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph}];
    
    [s1 appendAttributedString:date];
    [s1 appendAttributedString:wave];
    [s1 appendAttributedString:nights];
    [s1 appendAttributedString:linebreak];
    
    //room type and price
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:10.0f];
    NSAttributedString *space=[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSString *roomName = dict[ROOM_NAME];
    if(roomName == nil)
        roomName = @"";
    
    NSAttributedString *room_type=[[NSAttributedString alloc] initWithString:roomName attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor grayColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *price=[[NSAttributedString alloc] initWithString:[dict objectForKey:PAYMENT_PRICE] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *price_tax=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:/*@"(%@ incl. tax)"*/@"(税込%@)",[dict objectForKey:PAYMENT_PRICE_TAX]] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor whiteColor]}];
    
    //add the 3nd line
    [s1 appendAttributedString:room_type];
    [s1 appendAttributedString:space];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HistoryView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryView"];
    next.inputDict = items[indexPath.row];
    
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)BackPressed:(id)sender {
    //stop query when back is pressed
    @synchronized(self) //avoid race condition
    {
        if(self.state >= Connecting && self.state < Done )
        {
            [self/*.connection*/ cancel];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
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
        if(pageNum == 1)
        {
            Count = [data[@"nmbrLdgng"] integerValue];
            if(Count > 0) //not zero item
            {
                NSArray *arr = (NSArray*)data[@"ldgngInfrmtn"];
                items = [arr mutableCopy];
                [_tableView reloadData];
            }
            else //To avoid null pointer
                items = [@[]mutableCopy];
        }
        else
        {
            NSLog(@"current page: %d", pageNum);
            NSArray *tmpArr = (NSArray*)data[@"ldgngInfrmtn"];
            
            [items addObjectsFromArray: tmpArr];
            [_tableView reloadData];
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"BCMN1004"])
    {
        Count = 0;
        items = [@[] mutableCopy];
        [_tableView reloadData];
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"宿泊履歴はありません。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
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

@end
