//
//  CustomTableVC.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/09.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "CustomTableVC.h"

@interface CustomTableVC ()
@property (strong, nonatomic) NSArray *treeItems;
@end

@implementation CustomTableVC

static BOOL isDuringReload;

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
    
    //set data model with top-level items collapsed
    if(_defaultKeyword)
        self.treeItems = _keywordList;
    else
        self.treeItems = _areaList;
    
    NSArray *topLevelIdentifiers = [TLIndexPathItem identifiersForIndexPathItems:self.treeItems];
    self.dataModel = [[TLTreeDataModel alloc] initWithTreeItems:self.treeItems collapsedNodeIdentifiers:/*@[]*/topLevelIdentifiers];
    
    self.delegate = self;
    
    [self.tableView.layer setBorderWidth:0.5];
    [self.tableView.layer setBorderColor:[UIColor blackColor].CGColor];
    
    isDuringReload = NO;
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

- (TLIndexPathTreeItem *)itemWithId:(id)identifier type:(NSString*)type children:(NSArray *)children
{
    return [[TLIndexPathTreeItem alloc] initWithIdentifier:identifier
                                               sectionName:nil
                                            cellIdentifier:type
                                                      data:nil andChildItems:children];
}

- (TLIndexPathTreeItem *)itemWithId:(id)identifier type:(NSString*)type children:(NSArray *)children data:(id)data
{
    return [[TLIndexPathTreeItem alloc] initWithIdentifier:identifier
                                               sectionName:nil
                                            cellIdentifier:type
                                                      data:data andChildItems:children];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    id identifier = [self.dataModel identifierAtIndexPath:indexPath];
    if([identifier isKindOfClass:[NSString class]])
        cell.textLabel.text = identifier;
    else if([identifier isKindOfClass:[NSAttributedString class]])
        cell.textLabel.attributedText = identifier;
    
    cell.imageView.image = nil;
    
    //special row for current place
    if(identifier == self.currPlace.identifier)
    {
        cell.imageView.image = [UIImage imageNamed:@"現在地アイコン"];
        cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [cell.imageView setContentMode: UIViewContentModeCenter];
    }
    
    //add the arrow for Lv0 nodes
    if([cell.reuseIdentifier isEqualToString:@"Lv0"])
    {
        TLIndexPathTreeItem *item = [self.dataModel itemAtIndexPath:indexPath];
        if(!item.collapsed)
        {
            NSAttributedString *attrStr = (NSAttributedString*)identifier;
            NSLog(@"%@ collapsed", attrStr.string);
            [cell.imageView setImage: [UIImage imageNamed:@"▼"]];
        }
        else
        {
            [cell.imageView setImage: [UIImage imageNamed:@"▶"]];
        }
        
        if(isDuringReload)
        {
            [cell.imageView setImage: [UIImage imageNamed:@"▶"]]; //initial state
        }
        cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [cell.imageView setContentMode: UIViewContentModeCenter];
        
        [cell setNeedsDisplay];
        [cell setNeedsLayout];
    }
    
    //to set the inset to zero
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell touched: %ld", (long)indexPath.row);
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO: go to hotel list if in keyword mode, search with chosen keyword
    
    TLIndexPathTreeItem *item = [self.dataModel itemAtIndexPath:indexPath];
    if(_defaultKeyword) //keyword mode
    {
        NSDictionary *dataDict = item.data;
        NSString *keyword = dataDict[KEYWORD];
        NSString *cellIdentifier = item.cellIdentifier;
        
        if([cellIdentifier isEqualToString:@"NotFound"]) //error message cell
            return;
        
        if([_embeddingView respondsToSelector:@selector(SearchKeyword:)])
        {
            [_embeddingView SearchKeyword:keyword];
        }
    }
    else
    {
#if 1
        NSDictionary *dict = item.data;
        if([item.cellIdentifier isEqualToString:@"Lv1"])
        {
            if([_embeddingView respondsToSelector:@selector(SearchArea:)])
            {
                [_embeddingView SearchArea:dict];
            }
        }
        else if([item.cellIdentifier isEqualToString:@"Lv0"])
        {
            //handle the special case Hokkaido
            if([dict[AREA_CODE] isEqualToString:@"1"])
            {
                NSArray *children = item.childItems;
                if(children) //children exists
                {
                    if(children.count > 0)
                    {
                        if([_embeddingView respondsToSelector:@selector(SearchArea:)])
                        {
                            TLIndexPathTreeItem *child = children[0];
                            dict = child.data;
                            [_embeddingView SearchArea:dict];
                        }
                    }
                }
            }
        }
#endif
    }
}

- (void)controller:(TLTreeTableViewController *)controller willChangeNode:(TLIndexPathTreeItem *)treeItem collapsed:(BOOL)collapsed
{
    NSString *str;
    
    //20150330: added code to keep if this node is collapsed or not
    treeItem.collapsed = collapsed;
#if 0
    //Do not scroll when expanding
    self.tableView.scrollEnabled = NO;
#endif
    
    if([treeItem.identifier isKindOfClass:[NSString class]])
        str = treeItem.identifier;
    else if([treeItem.identifier isKindOfClass:[NSAttributedString class]])
        str = [treeItem.identifier string];
    
    NSLog(@"%@ collapsed: %d", str, collapsed);
#if 0
    NSLog(@"item data: %@", treeItem.data);
#endif
    //check if it is the one which collapses
    if([treeItem.cellIdentifier isEqualToString:@"Lv0"] && treeItem.childItems.count > 0)
    {
#if 0
        UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:[self.dataModel indexPathForItem:treeItem]];

        if(!collapsed)
            [cell.imageView setImage: [UIImage imageNamed:@"▼"]];
        else
            [cell.imageView setImage: [UIImage imageNamed:@"▶"]];
#endif
#if 0
        //To fix: the arrow does not change in simulator
        [cell setNeedsDisplay];
        [cell setNeedsLayout];
        //[cell.imageView drawRect:cell.imageView.bounds];
#else
        NSIndexPath *index = [self.dataModel indexPathForItem:treeItem];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        //[self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
#endif
    }
}

- (void)controller:(TLTreeTableViewController *)controller didChangeNode:(TLIndexPathTreeItem *)treeItem collapsed:(BOOL)collapsed
{
#if 0
    //unlock scroll
    self.tableView.scrollEnabled = YES;
#endif
}

-(void)reloadData
{
    if(_defaultKeyword)
        self.treeItems = _keywordList;
    else
        self.treeItems = _areaList;
    
    NSArray *topLevelIdentifiers = [TLIndexPathItem identifiersForIndexPathItems:self.treeItems];
    self.dataModel = [[TLTreeDataModel alloc] initWithTreeItems:self.treeItems collapsedNodeIdentifiers:/*@[]*/topLevelIdentifiers];
    
    NSLog(@"started reload");
    isDuringReload = YES;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    isDuringReload = NO;
    NSLog(@"reload ended");
}
@end
