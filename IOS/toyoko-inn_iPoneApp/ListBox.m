//
//  ListBox.m
//  toyoko-inn
//
//  Created by toyokoinn on 2015/04/06.
//  Copyright (c) 2015年 中崎拓真. All rights reserved.
//

#import "ListBox.h"

@implementation ListBox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //NSLog(@"frame: %@", NSStringFromCGRect(frame));
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0f;
    
    return self;
}

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
}

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

#if 0
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#endif

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
        [self removeFromSuperview];
    });
}

-(void)setData:(NSArray*)list index:(NSInteger)index
{
    _list = list;
    _selectedIndex = index;
    [_tableView reloadData];
}

@end
