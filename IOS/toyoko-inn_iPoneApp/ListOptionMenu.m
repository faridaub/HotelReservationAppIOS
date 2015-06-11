//
//  ListOptionMenu.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/18.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ListOptionMenu.h"
#import "ViewController.h"

#if 1
#import "ECSlidingViewController.h"
#endif

@interface ListOptionMenu ()

@end

@implementation ListOptionMenu

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
#if 1
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
#endif
    self.cellNames = [NSArray arrayWithObjects:@"c1", @"c2", @"c3", @"c4", @"c5", nil];
    
#if 0
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.cellNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = [self.cellNames objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    return cell;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"予約キャンセル確認";
            break;
        case 1:
            cell.textLabel.text = @"会員様ポイント確認";
            break;
        case 2:
            cell.textLabel.text = @"設定変更";
            break;
        case 3:
            cell.textLabel.text = @"ご利用案内";
            break;
        case 4:
            cell.textLabel.text = @"お問い合わせ";
            break;
        default:
            break;
    }
    return cell;
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

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
