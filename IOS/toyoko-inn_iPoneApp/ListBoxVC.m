//
//  ListBoxVC.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/04/15.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ListBoxVC.h"

@interface ListBoxVC ()

@end

@implementation ListBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.layer.borderColor = [UIColor blackColor].CGColor;
    //self.view.layer.borderWidth = 2.0f;
    //self.view.layer.cornerRadius = 5.0f;
    //self.view.clipsToBounds = YES;
    
    //self.modalPresentationStyle = UIModalPresentationCurrentContext;
    _titleLabel.text = self.title;
#if 1
    _bgView.layer.cornerRadius = 5.0f;
    _bgView.clipsToBounds = YES;
#endif

#if 0 //setup the round corner of title label
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_titleLabel.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _titleLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    _titleLabel.layer.mask = maskLayer;
    _titleLabel.clipsToBounds = YES;
#endif

#if 0 //setup the round corner of table
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _tableView.bounds;
    maskLayer.path = maskPath.CGPath;
    _tableView.layer.mask = maskLayer;
    _tableView.clipsToBounds = YES;
#endif
    
#if 0
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat x = (r.size.width - self.view.frame.size.width)/2.0f;
    CGFloat y = (r.size.height - self.view.frame.size.height)/2.0f;
    r = self.view.frame;
    r.origin.x = x;
    r.origin.y = y;
    self.view.frame = r;
#endif
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier ;
    UITableViewCell *cell;
    //NSLog(@"indexPath.row=%ld", (long)indexPath.row);
    
    cellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(_list)
    {
        cell.textLabel.text = _list[indexPath.row];
        if(_selectedIndex == indexPath.row) //select row
        {
            cell.imageView.image = [UIImage imageNamed:@"ラジオオン"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"ラジオオフ"];
        }
        cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //adjust the separator
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(_list)
    {
        return _list.count;
    }
    else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate)
    {
        if([_delegate respondsToSelector:@selector(SetIndex:)])
        {
            [_delegate SetIndex:indexPath.row];
        }
    }
    
    //close this view
    double delayInSeconds = 0.25f; //delay 0.25 sec
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)setData:(NSArray*)list index:(NSInteger)index
{
    _list = list;
    _selectedIndex = index;
    [_tableView reloadData];
}

@end
