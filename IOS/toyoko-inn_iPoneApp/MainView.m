//
//  MainView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/04/03.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "MainView.h"
#import "ViewController.h"
//#import "OtherOptionMenu.h"
#import "ListOptionMenu.h"
#import "SlideMenu.h"
#import "MapView.h"
#import "DateSelectView.h"

@interface MainView ()

@end

@implementation MainView

static NSArray *AdList = nil;
static NSUInteger AdIter = 0;
static NSString *picURL = @"http://www.toyoko-inn.com/sp/images/";
static NSString *AdListUrl = @"http://www.walking-map.com/advertising";
static NSString *AdPicCache = @"/AdPicCache/";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
#if 1
    //Sliding menu initialize ---- Kaiyuan.Ho 20140422
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[SlideMenu class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"SlideMenu"/*@"ListOtherMenu"*/];
    }
#endif
#if 1
    //Added gesture for sliding menu feature  ---- Kaiyuan.Ho 20140422
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:265.0f];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    _HotelSearch.delegate = self;

    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iOSVersion >= 7.0) //change the UI of buttons to add the border
    {
        [_HotelListButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_HotelListButton setBackgroundColor:[UIColor blueColor]];
    }
    
    //added code for external XML file reading/parsing
    AdList= [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:AdListUrl]];
    [self LoadAdPics:AdList];

    AdIter = 0;
    
    //Added code for periodically ad button update -- Kaiyuan.Ho 2014/04/04
    if([AdList count]) //at least one Ad exists
    {
    _timer = [NSTimer
             scheduledTimerWithTimeInterval:4 //period: 4 secs
             target: self
             selector:@selector(adButtonUpdate:)
             userInfo:nil
             repeats:YES];
        
    //initialize the AdButton
    [_AdButton setTitle:@"" forState:UIControlStateNormal];
        
    //show the 1st button
    [self adButtonUpdate:_timer];
    }
    
    //Added code for page control ---- 20140421 Kaiyuan.Ho
    _AdPageControl.numberOfPages = [AdList count];
    _AdPageControl.currentPage = 0;
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

- (IBAction)TopPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)DestPressed:(id)sender {
#if 0
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/area/areal?stype=areal&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
#else
    UIViewController *next=[self.storyboard instantiateViewControllerWithIdentifier:@"SearchEntry"];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
#endif
}

- (IBAction)DatePressed:(id)sender {
#if 0
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/condition-select/index?bApp=1";
#else
    DateSelectView *next =  [self.storyboard instantiateViewControllerWithIdentifier:@"DateSelect"];
#endif
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)MapPressed:(id)sender {
#if 0
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/map/map?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
#else
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    //next.URL = @"http://www.toyoko-inn.com/sp/map/map?bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
#endif
}


- (IBAction)HotelPressed:(id)sender {
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = @"http://www.toyoko-inn.com/sp/area/areal?stype=areal&bApp=1";
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)AdPressed:(id)sender {
    //get the corresponding URL
    NSDictionary *dict =[AdList objectAtIndex:AdIter];
    NSString *url=[dict objectForKey:@"URL"];
    
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = url;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)PageValueChanged:(id)sender {
    //To handle the value of page control changed
    UIPageControl *pager=sender;
    NSInteger page = pager.currentPage;
    _AdPageControl.currentPage = page;
    //NSLog(@"current page=%d", page);
    AdIter = (page-1)%[AdList count];
    //use the existing method to save code size ---- Kaiyuan.Ho 20140421
    [self adButtonUpdate:_timer];
}

- (IBAction)MenuPressed:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}

- (void)handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    
    NSUInteger type = [_TypeSelect selectedSegmentIndex]+1;
    NSString *keyword = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(
                                                                            kCFAllocatorDefault,
                                                                           (CFStringRef)searchBar.text, // ←エンコード前の文字列(NSStringクラス)
                                                                           NULL,
                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                           kCFStringEncodingUTF8);
    NSString *url = [NSString stringWithFormat:@"http://www.toyoko-inn.com/sp/hotel/resultlist?method=%lu&key=%@", (unsigned long)type, keyword];

    
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = url;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

- (void)adButtonUpdate:(NSTimer*)timer {
    //To increase AdIter
    AdIter = (AdIter+1)%[AdList count];
    //NSLog(@"AdIter = %i", AdIter);
    
    //added code to implement ad button timer update
    NSDictionary *dict =[AdList objectAtIndex:AdIter];
#if 0
    UIImage *img = [UIImage imageNamed:[dict objectForKey:@"pic"]];
#else
    NSString *RootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *FullPath = [NSString stringWithFormat:@"%@%@%@", RootPath, AdPicCache, [dict objectForKey:@"pic"]];
    
    //NSLog(@"to load pic %@", FullPath);

    UIImage* img = [UIImage imageWithContentsOfFile:FullPath];
#endif
    [_AdButton setBackgroundImage:img forState:UIControlStateNormal];
    _AdPageControl.currentPage = AdIter;
}

- (void)LoadAdPics:(NSArray*)adlist {
    NSString *RootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *FullPath;
    NSError *error;
    
    //check if the cache folder exists
    NSString *dirPath = [NSString stringWithFormat:@"%@%@", RootPath, AdPicCache];
    if(![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    //check each ad pic
    for(NSDictionary *d in adlist)
    {
        //create the full cache path
        FullPath = [NSString stringWithFormat:@"%@%@%@", RootPath, AdPicCache, [d objectForKey:@"pic"]];
        
        //NSLog(@"to check file %@", FullPath);
        
        //file not cached yet -> download to local
        if(![[NSFileManager defaultManager] fileExistsAtPath:FullPath])
        {
            NSString *FullURL = [NSString stringWithFormat:@"%@%@", picURL, [d objectForKey:@"pic"]];
            //NSLog(@"to download file %@", FullURL);
            NSURL  *url = [NSURL URLWithString:FullURL];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            
            if(urlData)
            {
                [urlData writeToFile:FullPath atomically:YES];
                //NSLog(@"file %@ saved, %i bytes", FullPath, [urlData length]);
            }
        }
    }
}
@end
