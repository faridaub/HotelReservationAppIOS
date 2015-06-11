//
//  SlideMenu.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/21.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "SlideMenu.h"
#import "ViewController.h"

@interface SlideMenu ()

@end

@implementation SlideMenu

- (void)awakeFromNib
{
    NSLog(@"awakeFromNib called");
    //self.cellNames = [NSArray arrayWithObjects:@"m1", @"m2", @"m3", @"m4", nil];
}
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
    NSLog(@"viewDidLoad called");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if 0
    self.itemtable.delegate = self;
    self.itemtable.dataSource = self;
#endif
    self.cellNames = [NSArray arrayWithObjects:@"予約キャンセル確認", @"会員様ポイント確認", @"設定変更", @"ご利用案内", @"お問い合わせ", nil];
    
    //To remove the extra empty table cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.picNames = [NSArray arrayWithObjects:@"icon_check.png", @"icon_point.png", @"bt_blue_a.png", @"bt_blue_b.png", @"bt_blue_c.png",nil];
    self.hlpics = [NSArray arrayWithObjects:@"icon_check.png", @"icon_point.png", @"bt_gray_a.png", @"bt_gray_b.png", @"bt_gray_c.png",nil];
    
#if 1
    // Sliding menu initialize ---- Kaiyuan.Ho 20140422
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
#endif
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
    NSLog(@"numberOfRowsInSection called, ret=%lu", (unsigned long)self.cellNames.count);
    
    return self.cellNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath called");
#if 0
    NSString *cellName = [self.cellNames objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    return cell;
#else
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.cellNames objectAtIndex:indexPath.row];

    //Add pictures
    if(self.picNames.count  > indexPath.row)
    {
        cell.imageView.image = [UIImage imageNamed:[self.picNames objectAtIndex:indexPath.row]];
        cell.imageView.highlightedImage = [UIImage imageNamed:[self.hlpics objectAtIndex:indexPath.row]];
    }
    return cell;
#endif
}

#if 0
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath 2 called");
    UITableViewCell *cell = [self.itemtable dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"行き先から探す";
            break;
        case 1:
            cell.textLabel.text = @"日付から探す";
            break;
        case 2:
            cell.textLabel.text = @"地図から探す";
            break;
        case 3:
            cell.textLabel.text = @"ホテルの一覧を見る";
            break;
        default:
            break;
    }
    return cell;
}
#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除をします。
    switch (indexPath.row) {
        case 0:
            [self ReservePressed:self];
            break;
        case 1:
            [self PointPessed:self];
            break;
        case 2:
            [self SettingPressed:self];
            break;
        case 3:
            [self GuidePressed:self];
            break;
        case 4:
            [self InquiryPressed:self];
            break;
        default:
            break;
    }
}

- (IBAction)ReservePressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://yoyaku.4and5.com/mb/html/rvmb_entryMmbrshpTypeRsrvCntnt.html?guid=ON&f=4&rf=1&toyokoTop=true&ma=&sid=&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)PointPessed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://yoyaku.4and5.com/mb/html/rvmb_athntctMmbrshp45CnfrmPnt.html?guid=ON&f=4&rf=1&toyokoTop=true&topPage=1&ma=&sid=&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)SettingPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://yoyaku.4and5.com/mb/html/rvmb_settingChgNameBrth.html?guid=ON&f=4&rf=1&toyokoTop=true&ma=&sid=&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)GuidePressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/i/etc/guidance.html?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)InquiryPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/i/etc/reference.html?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)DestPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/area/areal?stype=areal&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)DatePressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/condition-select/index?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)MapPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/map/map?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)HotelPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/area/areal?stype=areal&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}
@end
