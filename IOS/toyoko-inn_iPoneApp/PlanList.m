//
//  PlanList.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/06/02.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "PlanList.h"
#import "Constant.h"
#import "RoomInfoView.h"

@interface PlanList ()

@end

@implementation PlanList

- (void)viewDidLoad {
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
    
    _roomLabel.text = [NSString stringWithFormat:@"%@ プラン一覧",_planlist[0][ROOM_NAME]];
    _roomLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _roomLabel.layer.borderWidth = 0.5f;
    
    NSSortDescriptor *sortDist = [[NSSortDescriptor alloc] initWithKey:LISTED_PRICE ascending:YES];
    //sort by capacity
    _planlist = [_planlist sortedArrayUsingDescriptors:@[sortDist]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(_planlist == nil)
        return 0;
    else
        return [_planlist count];
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

-(void)AddFormattedString:(NSDictionary*)dict label:(UILabel*)label
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
    
    //1st line, hotel name, bold font with bigger size
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:dict[PLAN_NAME] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
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
    
    [s1 appendAttributedString:linebreak];
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [label setAttributedText:s1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *items = _planlist[indexPath.row];
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [self AddFormattedString:items label:cell.textLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict addEntriesFromDictionary:_searchDict];
    dict[PLAN_CODE] = _planlist[indexPath.row][PLAN_CODE];
    
    RoomInfoView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomInfoView"];
    
    next.searchDict = [dict mutableCopy];
    next.inputDict = _planlist[indexPath.row];
    next.htlName = _htlName;
    [self presentViewController:next animated:YES completion:^ {
    }];
    
    NSLog(@"plan: %@", _planlist[indexPath.row]);
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
