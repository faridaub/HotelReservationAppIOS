//
//  MessageList.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/07.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "MessageList.h"
#import "Constant.h"

@interface MessageList ()

@end

@implementation MessageList

static NSArray *messages;
static NSArray *titles;

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
    
    NSDictionary *msg1 = @{@"category": @(1), @"msg_id":@(1), @"date":@"2014年8月20日", @"title":@"「ホテル東横INN品川旗の台駅南口」オープン！", @"read":@(YES)};
    NSDictionary *msg2 = @{@"category": @(2), @"msg_id":@(2), @"date":@"2014年8月1日", @"title":@"ホテル店舗名称変更のお知らせ", @"read":@(NO)};
    NSDictionary *msg3 = @{@"category": @(3), @"msg_id":@(3), @"date":@"2014年8月27日", @"title":@"東横INN蒲田東口リニューアルオープン", @"read":@(NO)};
    messages = @[msg1,msg2,msg3];
    
    titles = @[@"東横INNからのお知らせ", @"お気に入りのホテルからのお知らせ", @"最寄りホテルからのお知らせ"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [titles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier ;
    UITableViewCell *cell;
    NSLog(@"indexPath.row=%ld", (long)indexPath.row);
  
    
    cellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
        
    NSDictionary *msg = messages[(NSUInteger)(indexPath.section)];
    if([msg[@"read"] boolValue]) //message read
    {
        cell.textLabel.text = [[messages objectAtIndex:(NSUInteger)(indexPath.section)] objectForKey:@"date"];
    }
    else
    {
        [self AddUnreadMark:cell.textLabel text:msg[@"date"]];
    }
    cell.detailTextLabel.text = [[messages objectAtIndex:(NSUInteger)(indexPath.section)] objectForKey:@"title"];
    
    //To remove the subviews for recycled cells
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//Add the "unread" mark after the title
- (void)AddUnreadMark:(UILabel*)label text:(NSString*)str
{
    UIFont *font = label.font;
//    CGFloat fontSize = font.pointSize;
    
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor]}];
#if 0
    font = [UIFont systemFontOfSize:fontSize-4];
    NSAttributedString *s2=[[NSAttributedString alloc] initWithString:@" 未読 " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName:[Constant AppRedColor]/*[UIColor redColor]*/}];
#else
    UIImage *required = [UIImage imageNamed:@"未読"];
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
    [s1 appendAttributedString: s2];
    label.attributedText = s1;
}
@end
