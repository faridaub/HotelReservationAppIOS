//
//  DestSearch.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/01.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "DestSearch.h"
#import "UIImage+UISegmentIconAndText.h"
#import "TLIndexPathTreeItem.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface DestSearch ()
//@property (strong, nonatomic) NSArray *treeItems;
@end

@implementation DestSearch

static NSDictionary *itemsHistory;
static NSArray *historyKeys;
static NSArray *historyValues;
static NSDictionary *cancelButtonTitle;

static NSMutableArray *keywordList;
static NSMutableArray *arealist;

static UITableView *targetTable;
static CustomTableVC *targetTableVC;

NSString const *KeywordHistory = @"KeywordHistory";

static NSString *currKeyword;
static NSMutableArray *keywordHistory;
static int searchKeywordIndex = 0;
static BOOL isLoadingHotelInfo = NO;
static BOOL isInsertingKeyword = NO;
static BOOL isRelatedMode = NO;
static BOOL isAreaLoaded = NO;
static NSMutableArray *relatedResult;

static NSUInteger relatedKeywordCount = 0;

//added for size variable search result list
CGRect oriTable, expTable;

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
    //_searchBar.text = _searchKeyword;
    isRelatedMode = NO;
#if 0
    itemsHistory = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"1", @"東横INN蒲田1",
                    @"2", @"東横INN蒲田2",
                    @"1", @"蒲田駅", nil];
    historyKeys = [itemsHistory allKeys];
    historyValues = [itemsHistory allValues];
#endif
    cancelButtonTitle = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"Cancel", @"en",
                         @"キャンセル", @"jp",
                         @"取消", @"zh", nil];
    //To fix the search icon to left side
#if 1
    //UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    //[_searchBar setPositionAdjustment: UIOffsetMake ( -100, 0.0 ) forSearchBarIcon:UISearchBarIconSearch];
#else
    UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeAlways];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    //[txfSearchField setBackground:[UIImage imageNamed:@"searchbar_bgImg.png"]];
    //[txfSearchField setBorderStyle:UITextBorderStyleNone];
    //txfSearchField.layer.borderWidth = 8.0f;
    //txfSearchField.layer.cornerRadius = 10.0f;
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    //txfSearchField.clearButtonMode=UITextFieldViewModeNever;
#endif
    //localize the cancel button of search bar
    UIView* view=_searchBar.subviews[0];
    for (UIView *subView in view.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton *)subView;
            //TODO: set title for each language
            [cancelButton setTitle:[cancelButtonTitle objectForKey:@"jp"] forState:UIControlStateNormal];
            [cancelButton setBackgroundColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0]/*[UIColor grayColor]*/];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
#if 1
            [cancelButton addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
#endif
        }
    }

    //1st segment
    NSMutableString *tmp = [[NSMutableString alloc] initWithString:@" "];
    [tmp appendString:[_typeSegment titleForSegmentAtIndex:0]];
    
    //resize the icon image before combining the image and text
    CGRect r;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size = [UIImage imageNamed:@"検索履歴"].size;
    r.size.width /= 2;
    r.size.height /= 2;
    UIImage *resizedImg = [UIImage resize:[UIImage imageNamed:@"検索履歴"] rect:r];
    UIImage *imageWithText = [UIImage imageFromImage:resizedImg string:tmp color:[UIColor whiteColor]];
    [_typeSegment setImage:imageWithText forSegmentAtIndex:0];
    
    //2nd segment
    [tmp setString:@" "];
    [tmp appendString:[_typeSegment titleForSegmentAtIndex:1]];
    
    //resize the image
    r.origin.x = 0;
    r.origin.y = 0;
    r.size = [UIImage imageNamed:@"検索エリア"].size;
    r.size.width /= 2;
    r.size.height /= 2;
    resizedImg = [UIImage resize:[UIImage imageNamed:@"検索エリア"] rect:r];
    imageWithText = [UIImage imageFromImage:resizedImg string:tmp color:[UIColor whiteColor]];
    [_typeSegment setImage:imageWithText forSegmentAtIndex:1];

    //[_resultTable.layer setBorderWidth:0.5];
    //[_resultTable.layer setBorderColor:[UIColor blackColor].CGColor];
    
    //To make the search bar focused for fixing the cancel button does not work issue
    [_searchBar becomeFirstResponder];

#if 0
    //set the dummy search result of keywords
    keywordList = [NSMutableArray array];
    [keywordList removeAllObjects];
    for(NSString *key in [itemsHistory allKeys])
    {
        NSAttributedString *tmp = [self FormattedString:key num:[[itemsHistory objectForKey:key]intValue]];
        [keywordList addObject:[targetTableVC itemWithId:tmp type:@"Cell" children:nil]];
    }
#else
    
#if 0
    keywordList = [NSMutableArray array];
    [keywordList removeAllObjects];
    for(NSDictionary *dict in _DestResult)
    {
        NSAttributedString *tmp = [self FormattedString:dict[KEYWORD] num:[dict[@"num_hotel"]intValue]];
        [keywordList addObject:[targetTableVC itemWithId:tmp type:@"Cell" children:nil data:dict]];
    }
#else
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if([ud arrayForKey:(NSString*)KeywordHistory] != nil)
    {
        NSArray *array = [ud arrayForKey:(NSString*)KeywordHistory];
        keywordHistory = [array mutableCopy];
    }
    else
    {
        keywordHistory = [[NSMutableArray alloc] init];
    }
    //get the number of hotel for each keyword
    
    //keyword list: save kw/num of hotel pair
    
    if(keywordList) //initialized
    {
        [keywordList removeAllObjects];
    }
    else
    {
        keywordList = [[NSMutableArray alloc] init];
    }
    
    _DestResult = [NSMutableArray array];
#if 0
    if([ud stringForKey:MEMBER_NUM])
        dict[MEMBER_FLAG] = @"Y";
    else
        dict[MEMBER_FLAG] = @"N";
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyyMMdd"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    dict[CHECKIN_DATE] = date_String/*@"20140901"*/; //to be replaced by today's date
    dict[NUM_NIGHTS] = @"1"; //default value
    
    dict[NUM_PEOPLE] = @"1";
    dict[NUM_ROOMS] = @"1";
#endif
    
    if(keywordHistory.count > 0)
    {
        searchKeywordIndex = 0;
        currKeyword = keywordHistory[searchKeywordIndex];
        
        self.delegate = self;
        _searchDict[KEYWORD] = currKeyword;
        _searchDict[@"mode"] = @"1";
        
        isLoadingHotelInfo = YES;
        _searchBar.userInteractionEnabled = NO; //disable input while loading search result
        
        [self addRequestFields:_searchDict];
        [self setApiName:@"search_hotel_vacant_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
    
#endif
#endif

#if 0
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *data=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

    //convert the parsed json data to tree format
    if(data)
    {
        arealist = [NSMutableArray array];
        [arealist removeAllObjects];

        TLIndexPathTreeItem *place=[targetTableVC itemWithId:[self FormattedString:@"現在地周辺" num:[[[data objectForKey:@"place"]objectForKey:@"num_hotels"]intValue]] type:@"place" children:nil];
        [arealist addObject:place];
        NSArray *area = [data objectForKey:@"area"];
        NSString *area_name;
        for(NSDictionary *dict in area)
        {
            NSLog(@"area=%@",[dict objectForKey:@"area_name"]);
            area_name = [dict objectForKey:@"area_name"];
            
            [arealist addObject:[targetTableVC itemWithId:area_name type:@"section" children:nil]];
            
            NSMutableArray *prefArr = [[NSMutableArray alloc]init];
            [prefArr removeAllObjects];
            for(NSDictionary *pref in [dict objectForKey:@"prefs"])
            {
                NSLog(@"area=%@, pref=%@", area_name, [pref objectForKey:@"pref_name"]);
                [prefArr addObject:[targetTableVC itemWithId:[self FormattedString:[pref objectForKey:@"pref_name"] num:[[pref objectForKey:@"num_hotels"]intValue]] type:@"Lv1" children:@[]]];
            }
            
            NSAttributedString *tmp=[self FormattedString:area_name num:[[dict objectForKey:@"num_hotels"]intValue]];
            
            [arealist addObject:[targetTableVC itemWithId:tmp type:@"Lv0" children:prefArr]];
        }
#endif
        //set data model with top-level items collapsed
        if(targetTableVC)
        {
            targetTableVC.keywordList = keywordList;
            //targetTableVC.areaList = arealist;
            targetTableVC.defaultKeyword = YES;
            //targetTableVC.currPlace = place;
            [targetTableVC reloadData];
        }
#if 0
    }
    else
        NSLog(@"error=%@", error.description);
#endif
#if 0
    self.delegate = self;
    [self addRequestFields:_searchDict];
    [self setApiName:@"search_hotel_area_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#endif
    
    oriTable = _containerView.frame;
    
    CGFloat diff = _containerView.frame.origin.y - _typeSegment.frame.origin.y;
    expTable = CGRectMake(_containerView.frame.origin.x , _typeSegment.frame.origin.y, _containerView.frame.size.width, _containerView.frame.size.height + diff);
    isAreaLoaded = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //stop all network communication
    @synchronized(self)
    {
        isLoadingHotelInfo = NO;
        isRelatedMode = NO;
        [self cancel];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"table_embed"]) {
        CustomTableVC * childViewController = (CustomTableVC *) [segue destinationViewController];
        targetTable = childViewController.tableView;
        targetTableVC = childViewController;
        childViewController.embeddingView = self;
    }
}

#if 1
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    NSLog(@"search text = %@", searchText);
    
    if(searchText.length > 0)
    {
        //hide typeSegment and expand the table
        _typeSegment.hidden = YES;
        _containerView.frame = expTable;
        
        @synchronized(self)
        {
            //terminate hotel info loading mode
            if(isLoadingHotelInfo)
            {
                isLoadingHotelInfo = NO;
                [self cancel];
            }
        }
        
        isRelatedMode = YES;
        
        @synchronized(self) //avoid race condition
        {
            if(self.state >= Connecting && self.state < Done )
            {
                [self/*.connection*/ cancel];
            }
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if(appDelegate.reservData != nil)
        {
            [dict addEntriesFromDictionary:appDelegate.reservData];
        }
        else
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            if([ud stringForKey:MEMBER_NUM])
                dict[MEMBER_FLAG] = @"Y";
            else
                dict[MEMBER_FLAG] = @"N";
#if 0
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyyMMdd"];
            NSString *date_String=[dateformate stringFromDate:[NSDate date]];

            dict[CHECKIN_DATE] = date_String;
            dict[NUM_NIGHTS] = @"1"; //default value
            
            dict[NUM_PEOPLE] = @"1";
            dict[NUM_ROOMS] = @"1";
#else

#endif
        }
        
        [dict addEntriesFromDictionary:_searchDict];
        dict[KEYWORD] = searchText;
        [dict removeObjectForKey:@"mode"];
        
        self.delegate = self;
        
        [self addRequestFields:dict];
        [self setApiName:@"search_hotel_keyword_api"];
        [self setSecure:NO];
        
        isRelatedMode = YES;
        [self sendRequest];
    }
    else
    {
        _typeSegment.hidden = NO;
        _containerView.frame = oriTable;
        
        if(targetTableVC)
        {
            targetTableVC.keywordList = keywordList;
            targetTableVC.defaultKeyword = YES;
            [targetTableVC reloadData];
        }
    }
}
#endif

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
        return NO;
    }
    else if ([text isEqualToString:@""]) //handle backspace
    {
        return YES;
    }
    return YES;
}

#if 0
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keyword = searchBar.text;
    
    //handle the keyword if it does not exist
    if([keywordHistory containsObject:keyword] == NO)
    {
        //insert the keyword to the head of array
        [keywordHistory insertObject:keyword atIndex:0];
        
        currKeyword = searchBar.text;
        _searchDict[KEYWORD] = currKeyword;
        _searchDict[@"mode"] = @"1";
        
        isInsertingKeyword = YES;
        
        self.delegate = self;
        [self addRequestFields:_searchDict];
        [self setApiName:@"search_hotel_vacant_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
}
#endif

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancel pressed");
    
    @synchronized(self)
    {
        //terminate hotel info loading mode
        if(isLoadingHotelInfo)
        {
            isLoadingHotelInfo = NO;
            [self cancel];
        }
    }
    
    //close the view if cancel pressed
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(NSAttributedString*)FormattedString:(NSString*)name num:(int)num
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
    
    //keyword name, bold font
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:[UIColor clearColor]}];
    
    NSAttributedString *space=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph/*, NSBackgroundColorAttributeName:[UIColor whiteColor]*/}];
    
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13.0f];
    
    UIColor *bgColor;
    if(num > 0)
        bgColor = [UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:10.0/255.0 alpha:1.0];
    else
        bgColor = [UIColor darkGrayColor];
    
    if(!_hideNumber)
    {
        NSMutableAttributedString *number=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %d軒   ", num] attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph, NSBackgroundColorAttributeName:bgColor/*[UIColor blackColor]*//*[UIColor colorWithRed:244.0/255.0 green:170.0/255.0 blue:10.0/255.0 alpha:1.0]*/}];
        
        [s1 appendAttributedString:space];
        [s1 appendAttributedString:number];
    }
    //[cell.textLabel setAttributedText:s1];
    return s1;
}


- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)typeChanged:(id)sender {
    UISegmentedControl *seg=sender;
    
    switch(seg.selectedSegmentIndex)
    {
        case 0: //switch to keyword list
            targetTableVC.defaultKeyword = YES;
            [targetTableVC reloadData];
            break;
            
        case 1://switch to area list
            //close keyboard
            [_searchBar resignFirstResponder];
            targetTableVC.defaultKeyword = NO;
            isLoadingHotelInfo = NO; //20150428: to stop loading keyword info
            [targetTableVC reloadData];
            if(!isAreaLoaded)
            {
                self.delegate = self;
                [self addRequestFields:_searchDict];
                [self setApiName:@"search_hotel_area_api"];
                [self setSecure:NO];
                
                [self sendRequest];
            }
            break;
    }
}

-(void)SearchKeyword:(NSString*)keyword
{
#if 0
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    dict[KEYWORD] = keyword;
    dict[@"mode"] = @"1";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.reservData != nil)
    {
        [dict addEntriesFromDictionary:appDelegate.reservData];
    }
    else
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if([ud stringForKey:MEMBER_NUM])
            dict[MEMBER_FLAG] = @"Y";
        else
            dict[MEMBER_FLAG] = @"N";
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"yyyyMMdd"];
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        dict[CHECKIN_DATE] = date_String; 
        dict[NUM_NIGHTS] = @"1"; //default value
        
        dict[NUM_PEOPLE] = @"1";
        dict[NUM_ROOMS] = @"1";
    }
    
    self.delegate = self;
    
    [self addRequestFields:dict];
    [self setApiName:@"search_hotel_vacant_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#else
    //check if there is related keyword
    if(isRelatedMode && relatedKeywordCount==0)
        return;
    
    //add keyword and save
    if(![keywordHistory containsObject:keyword])
    {
        [keywordHistory insertObject:[keyword copy] atIndex:0];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:keywordHistory forKey:(NSString*)KeywordHistory];
    [ud synchronize];
    
    if([_searchDelegate respondsToSelector:@selector(SetKeyword:)])
    {
        [_searchDelegate SetKeyword:keyword];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
#endif
}

-(void)SearchArea:(NSDictionary*)area
{
    NSLog(@"area: %@", area);
    if([_searchDelegate respondsToSelector:@selector(SetArea:)])
    {
        [_searchDelegate SetArea:area];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#if 1
NSString const *CHILDREN = @"children";

-(void)ConvertAreaToTree:(NSDictionary*)areas
{
    NSArray *keys = [areas allKeys];
    //sort the keys to iterate from area 1
    keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    arealist = [NSMutableArray array];
    [arealist removeAllObjects];
    
    for(NSString *key in keys)
    {
        //NSLog(@"area key: %@", key);
        NSDictionary *area = areas[key];
        
        [arealist addObject:[targetTableVC itemWithId:area[AREA_NAME] type:@"section" children:nil]];
        
        NSArray *children = area[CHILDREN];
        
        if(children == nil) //not set
        {
            NSAttributedString *tmp=[self FormattedString:area[AREA_NAME] num:0];
            [arealist addObject:[targetTableVC itemWithId:tmp type:@"Lv0" children:@[]]];
            continue;
        }
        
        NSMutableArray *prefArr = [[NSMutableArray alloc]init];
        [prefArr removeAllObjects];
        
        for(NSDictionary *child in children)
        {
            //NSLog(@"child: %@", child);
            [prefArr addObject:[targetTableVC itemWithId:[self FormattedString:child[STATE_NAME] num:[child[NUM_HOTEL]intValue]] type:@"Lv1" children:@[] data:child]];
        }
        NSAttributedString *tmp=[self FormattedString:area[AREA_NAME] num:[area [NUM_HOTEL]intValue]];
        
        [arealist addObject:[targetTableVC itemWithId:tmp type:@"Lv0" children:prefArr data:area]];
    }
    
    if(targetTableVC)
    {
        //targetTableVC.keywordList = keywordList;
        targetTableVC.areaList = arealist;
        //targetTableVC.defaultKeyword = YES;
        targetTableVC.currPlace = nil;
        [targetTableVC reloadData];
    }
}

-(NSDictionary*)ParseAreaData:(NSDictionary*)data
{
    //NSMutableDictionary *tree = [[NSMutableDictionary alloc]init];
    
    NSArray *areaList = data[@"areaInfrmtn"];
    
    NSMutableDictionary *areaSet = [[NSMutableDictionary alloc]init]; //unique area set
    
    for(NSDictionary *dict in areaList) //1st: get all unique areas
    {
        NSString *areaCode = dict[@"areaCode"];
        NSString *areaName = dict[AREA_NAME];
        
        if(areaSet[areaCode] == nil) //not exist
        {
            NSDictionary *tmpDict = @{@"areaCode":areaCode, AREA_NAME:areaName};
            areaSet[areaCode] = [tmpDict mutableCopy];
        }
    }
    
    //2nd: get all states and count the total num of hotels for each area
    for(NSDictionary *dict in areaList)
    {
        NSString *areaCode = dict[@"areaCode"];
        NSMutableDictionary *areaEntry = areaSet[areaCode];
        
        //TODO: check child array
        if(areaEntry[CHILDREN] == nil) //children not created yet
        {
            NSMutableArray *children = [[NSMutableArray alloc]init];
            areaEntry[CHILDREN] = children;
        }
        
        NSMutableArray *children = areaEntry[CHILDREN];
        [children addObject:dict];
    }
    
    NSComparator comp = ^(id obj1, id obj2) {
        NSInteger rank1 = [obj1 integerValue];
        NSInteger rank2 = [obj2 integerValue];
        NSComparisonResult result = [@(rank1) compare:@(rank2)];
        //NSLog(@"obj1 2 result: %d:%d:%d", rank1, rank2, result);
        return (NSComparisonResult)result;
    };
    //3rd: recalculate the total number of hotels in each area
    NSSortDescriptor *sortDist = [[NSSortDescriptor alloc] initWithKey:STATE_CODE ascending:YES comparator:comp];
    
    for(NSMutableDictionary *areaEntry in [areaSet allValues])
    {
        //NSLog(@"areaEntry: %@",areaEntry);

        NSUInteger totalNum = 0;
        
        //sort the children by state code
        NSMutableArray *children = areaEntry[CHILDREN];
        [children sortUsingDescriptors:@[sortDist]];
        
        for(NSDictionary *dict in children)
        {
            totalNum += [dict[NUM_HOTEL] integerValue];
        }
        areaEntry[NUM_HOTEL] = @(totalNum);
    }

    //NSLog(@"tree: %@", areaSet);
    
    return areaSet;
}
#endif

-(void)ParsedDataReady:(NSDictionary*)data
{
    //NSLog(@"data: %@", data);
    
    if(data[@"nmbrArs"])
    {
        if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
        {
            NSDictionary* dict = [self ParseAreaData:data];
            [self ConvertAreaToTree:dict];
            isAreaLoaded = YES;
        }
        else
        {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        return;
    }
    
    if(isRelatedMode)
    {
        //BAPI1007: the targeted hotels are all full occupied
        if([data[@"errrCode"] isEqualToString:@"BCMN0000"] || [data[@"errrCode"] isEqualToString:@"BAPI1007"]) //success, at least 1 keyword
        {
            NSArray *kwlist = data[@"keyword_info"];
            relatedKeywordCount = kwlist.count;
            
            relatedResult = [[NSMutableArray alloc]init];
            
            for(NSDictionary *dict in kwlist)
            {
                NSAttributedString *tmp = [self FormattedString:dict[KEYWORD] num:(int)[dict[@"num_hotel"]integerValue]];
                [relatedResult addObject:[targetTableVC itemWithId:tmp type:@"Cell" children:nil data:dict]];
            }
            
            targetTableVC.keywordList = relatedResult;
            if(_typeSegment.selectedSegmentIndex == 0)
            {
                targetTableVC.defaultKeyword = YES;
                [targetTableVC reloadData];
            }
        }
        else if([data[@"errrCode"] isEqualToString:@"BAPI1004"])
        {
            relatedKeywordCount = 0;
#if 0
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"該当するキーワードがありません。キーワードを変更して再度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
            [alert show];
#else
            relatedResult = [[NSMutableArray alloc]init];
            UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
            NSString *message= @"該当するキーワードがありません。キーワードを変更して再度お試しください。";
            NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant AppDarkBlueColor], NSBackgroundColorAttributeName:[UIColor whiteColor]}];
            [relatedResult addObject:[targetTableVC itemWithId:s1 type:@"NotFound" children:nil data:nil]];
            targetTableVC.keywordList = relatedResult;
            targetTableVC.defaultKeyword = YES;
            [targetTableVC reloadData];
#endif
        }
        else
        {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        return;
    }
    
    if(isLoadingHotelInfo)
    {
        int hotelCount;
        if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success, at least 1 hotel
        {
            NSArray *hotelList = data[@"htlList"];
            hotelCount = (int)hotelList.count;
        }
        else
        {
            hotelCount = 0;
        }
        NSDictionary *dict=@{KEYWORD:[currKeyword copy], @"num_hotel":@(hotelCount)};
        [_DestResult addObject:dict];
        NSAttributedString *tmp = [self FormattedString:currKeyword num:(int)hotelCount];
        [keywordList addObject:[targetTableVC itemWithId:tmp type:@"Cell" children:nil data:dict]];
        
        if(searchKeywordIndex == keywordHistory.count - 1) //last keyword
        {
            isLoadingHotelInfo = NO;
            _searchBar.userInteractionEnabled = YES;
            if(targetTableVC)
            {
                targetTableVC.keywordList = keywordList;
                //targetTableVC.areaList = arealist;
                targetTableVC.defaultKeyword = YES;
                //targetTableVC.currPlace = place;
                [targetTableVC reloadData];
            }
        }
        else //handle the next keyword
        {
            double delayInSeconds = 0.1f; //delay 0.1 sec
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //code to be executed on the main queue after a delay
                searchKeywordIndex++; //go to next keyword
                currKeyword = keywordHistory[searchKeywordIndex];
                
                _searchDict[KEYWORD] = currKeyword;
                _searchDict[@"mode"] = @"1";
                
                self.delegate = self;
                [self addRequestFields:_searchDict];
                [self setApiName:@"search_hotel_vacant_api"];
                [self setSecure:NO];
                
                [self sendRequest];
            });
        }
    }
    else if(isInsertingKeyword) //check the new keyword
    {
        isInsertingKeyword = NO;
        
        //check if this keyword is already saved or not
        if(![keywordHistory containsObject:currKeyword])
        {
            [keywordHistory insertObject:[currKeyword copy] atIndex:0];
        }
        
        int hotelCount;
        if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success, at least 1 hotel
        {
            NSArray *hotelList = data[@"htlList"];
            hotelCount = (int)hotelList.count;
        }
        else //hotel not found
        {
            hotelCount = 0;
        }
        
        NSDictionary *dict=@{KEYWORD:[currKeyword copy], @"num_hotel":@(hotelCount)};
        [_DestResult insertObject:dict atIndex:0];
        NSAttributedString *tmp = [self FormattedString:currKeyword num:(int)hotelCount];
        [keywordList insertObject:[targetTableVC itemWithId:tmp type:@"Cell" children:nil data:dict] atIndex:0];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:keywordHistory forKey:(NSString*)KeywordHistory];
        [ud synchronize];
        
        //reload the table
        if(targetTableVC)
        {
            targetTableVC.keywordList = keywordList;
            //targetTableVC.areaList = arealist;
            if(_typeSegment.selectedSegmentIndex == 0)
            {
                targetTableVC.defaultKeyword = YES;
                //targetTableVC.currPlace = place;
                [targetTableVC reloadData];
            }
        }
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
