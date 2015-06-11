//
//  CellTestView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/22.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "CellTestView.h"
#import "ToyokoEcoplanCell.h"
#import "ToyokoBusiPak.h"

@interface CellTestView ()

@end

@implementation CellTestView

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
    
    UINib *nib = [UINib nibWithNibName:@"ToyokoEcoplanCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EcoplanCell"];
    
    nib = [UINib nibWithNibName:@"ToyokoBusiPak" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Busipak"];
    
    nib = [UINib nibWithNibName:@"ToyokoPickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Picker"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row==0)
    {
        NSString *cellIdentifier = @"EcoplanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSLog(@"1st time initialize ToyokoEcoplanCell");
            cell = [[ToyokoEcoplanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSArray *dates=@[@"1/1", @"1/2", @"1/3"];
        NSArray *selected=@[@"1/1"];
        
        ToyokoEcoplanCell *ecocell = (ToyokoEcoplanCell*)cell;
        
        [ecocell setDates:dates selectedDates:selected];
    }
    else{
        NSString *cellIdentifier = @"Busipak";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSLog(@"1st time initialize ToyokoBusiPak");
            cell = [[ToyokoBusiPak alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSArray *vals1=@[@(100), @(200), @(300)];
        NSArray *vals2=@[@(1000), @(2000), @(3000)];
        
        NSString *format1 = @"ビジネスパック%@";
        NSString *format2 = @"(%@円分のVISAギフトカード付き)";
        
        ToyokoBusiPak *busicell = (ToyokoBusiPak*)cell;
        [busicell setFormattedStrings:format1 str2:format2];
        [busicell setValues:vals1 values2:vals2];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;

    if(indexPath.row==0){
        NSString *CellIdentifier = @"EcoplanCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
    }
    else{
        NSString *CellIdentifier = @"Busipak";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
    }

    return cell.bounds.size.height;
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
