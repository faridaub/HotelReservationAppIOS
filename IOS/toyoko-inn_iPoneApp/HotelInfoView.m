//
//  HotelInfoView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "HotelInfoView.h"
#import "AppDelegate.h"
#import "RoomTypeList.h"
#import "ViewController.h"
#import "Constant.h"
#import "TextView.h"
#import "PictCell.h"
#import "MapView.h"
#import "UITableViewCell2.h"
#import "AddressCell.h"

#define DEFAULT_ZOOM 14.0

@interface HotelInfoView ()

@end

@implementation HotelInfoView

static NSArray *keys;
static NSDictionary *title;
//static NSMutableDictionary *contents;
static NSArray *details;

static NSArray *specialItems;
#if 0
static NSMutableArray *creditcards;
#else
static UIImage *cardImage;
#endif
static NSMutableArray *hotelimages;
static int MaxImageHeight;

static BOOL favoriteAdded = NO;
static BOOL isLoadingFavorite = NO;
static BOOL isDeletingFavorite = NO;
static BOOL initialLoading = NO;

static int cardSpace = 1;

#define PAGECONTROL_HEIGHT 37
#define IMAGE_MARGIN 10
#define NUM_LASTBUTTONS 3
#define BUTTON_HEIGHT 30.0
#define CELL_HEIGHT 50.0

#define IMAGE_CELL_HEIGHT 187.0

#define CARD_IMAGE_MARGIN 3.0

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
    UINib *nib = [UINib nibWithNibName:@"PictCell" bundle:nil];
    [self.InfoTable registerNib:nib forCellReuseIdentifier:@"Pict"];
    
    details = @[@"eqpmntInfrmtnList", @"accssInfmtnList", @"prkngInfmtn", @"pckpInfmtn", @"busInfmtn"];
    
    keys = [[NSArray alloc] initWithObjects:
#if 1
            IMAGE_URL/*@"image"*/,
#endif
            @"addrss"/*@"addr"*/,
#if 1
            @"accssInfmtnList"/*@"access"*/,
#endif
            @"prkngInfmtn"/*@"parking"*/,
            @"busInfmtn"/*@"bus_parking"*/,
            @"pckpInfmtn"/*@"pickup"*/,
            @"rntcrInfmtn"/*@"rentacar"*/,
            CHECKIN_TIME/*@"checkin"*/,
            @"chcktTime"/*@"checkout"*/,
            @"brkfstTime"/*@"breakfast"*/,
#if 1
            @"crdtInfrmtnList"/*@"credit"*/,
#endif
#if 1
            @"eqpmntInfrmtnList"/*@"equipment"*/,
#endif
            @"brrrfrInfmtn"/*@"barrier_free"*/,
            @"isoInfmtn"/*@"iso"*/,
            TEL_NUM/*@"telnum"*/,
            @"last", nil];
    title = [NSDictionary dictionaryWithObjectsAndKeys:
             @"ホテル名", @"htlName"/*@"hotel_name"*/,
             @"住所", @"addrss"/*@"addr"*/,
             @"アクセス", @"accssInfmtnList"/*@"access"*/,
             @"駐車場", @"prkngInfmtn"/*@"parking"*/,
             @"バス駐車場", @"busInfmtn"/*@"bus_parking"*/,
             @"送迎", @"pckpInfmtn"/*@"pickup"*/,
             @"東横INNレンタカーサービス", @"rntcrInfmtn"/*@"rentacar"*/,
             @"チェックイン", CHECKIN_TIME/*@"checkin"*/,
             @"チェックアウト", @"chcktTime"/*@"checkout"*/,
             @"朝食時間（無料）", @"brkfstTime"/*@"breakfast"*/,
             @"利用可能なクレジットカード", @"crdtInfrmtnList"/*@"credit"*/,
             @"館内設備・サービス", @"eqpmntInfrmtnList"/*@"equipment"*/,
             @"バリアフリー対応", @"brrrfrInfmtn"/*@"barrier_free"*/,
             @"ISO9001:2008認証取得", @"isoInfmtn"/*@"iso"*/,
             @"電話番号", TEL_NUM/*@"telnum"*/,
             @"画像", IMAGE_URL/*@"image"*/,
             nil];
#if 0
    contents = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @""/*@"東横INNアキバ浅草橋駅東口"*/,@"htlName"/*@"hotel_name"*/,
                @""/*@"東京都台東区柳橋2-14-4"*/, @"addrss"/*@"addr"*/,
                @""/*@"JR総武線「浅草橋駅」東口より徒歩3分、都営浅草線「浅草橋駅」A6出口より徒歩1分"*/, @"accssInfmtnList"/*@"access"*/,
                @""/*@"31台収容 先着順"*/, @"prkngInfmtn"/*@"parking"*/,
                @""/*@"なし"*/, @"busInfmtn"/*@"bus_parking"*/,
                @""/*@"≪JR秋葉原駅 ⇒ 東横INN神田秋葉原 ⇒ 東横INNアキバ浅草橋駅東口≫上記ルートを循環する、無料送迎バスを運行しております"*/, @"pckpInfmtn"/*@"pickup"*/,
                @""/*@"あり"*/, @"rntcrInfmtn"/*@"rentacar"*/,
                @""/*@"16：00"*/, CHECKIN_TIME/*@"checkin"*/,
                @""/*@"10：00"*/, @"chcktTime"/*@"checkout"*/,
                @""/*@"7：00〜9：30"*/, @"brkfstTime"/*@"breakfast"*/,
                @""/*@"jcb,visa,master,amex,diner"*/, @"crdtInfrmtnList"/*@"credit"*/,
                @""/*@"XXXX"*/, @"eqpmntInfrmtnList"/*@"equipment"*/,
                @""/*@"なし"*/, @"brrrfrInfmtn"/*@"barrier_free"*/,
                @""/*@"取得済み"*/, @"isoInfmtn"/*@"iso"*/,
                @""/*@"03-5822-1045"*/, TEL_NUM/*@"telnum"*/,
                @""/*@"http://www.toyoko-inn.com/sp/images/H243h1.jpeg,http://www.toyoko-inn.com/sp/images/H243r1.jpeg,http://toyoko-inn.com/sp/images/H243r6.jpeg"*/, IMAGE_URL/*@"image"*/,
                nil];
#endif
    specialItems = [[NSArray alloc]initWithObjects:IMAGE_URL/*@"image"*/,
                    @"addrss"/*@"addr"*/, @"accssInfmtnList",
                    @"crdtInfrmtnList"/*@"credit"*/, @"eqpmntInfrmtnList"/*@"rule"*/, @"last", nil];
    _InfoTable.delegate = self;
    _InfoTable.dataSource = self;
    
    [_RoomButton.imageView setContentMode: UIViewContentModeScaleAspectFit ];
#if 1
    _NaviBar.topItem.title = [_inputDict objectForKey:HOTEL_NAME];
#endif
#if 1
    NSMutableString *tempStr = [[NSMutableString alloc] initWithString:[_inputDict objectForKey:HOTEL_NAME]];
    [tempStr insertString:@"  " atIndex:0];
    [tempStr appendString:@" 詳細"];
    _titleLabel.text = tempStr;
#endif
    [_InfoTable.layer setBorderWidth:0.5];
#if 0
    creditcards = [[NSMutableArray alloc] init];
#endif
    hotelimages = [[NSMutableArray alloc] init];

    if([keys indexOfObject:@"crdtInfrmtnList"]!=NSNotFound)
    {
#if 0
        [creditcards removeAllObjects];
        [self MakeCreditCardImages:[_inputDict objectForKey:@"crdtInfrmtnList"]];
#else
        cardImage = [self MakeCardImage:[_inputDict objectForKey:@"crdtInfrmtnList"]];
#endif
    }
#if 1
    if([keys indexOfObject:IMAGE_URL]!=NSNotFound)
    {
        [hotelimages removeAllObjects];
        //To load all images from internet
        //TODO: make local image cache
        id obj = _inputDict[IMAGE_URL];
        NSString *imgURL;
        if([obj isKindOfClass:[NSArray class]])
        {
            NSArray *imgList = obj;
            imgURL = [imgList componentsJoinedByString:@","];
        }
        else if([obj isKindOfClass:[NSString class]])
        {
            imgURL = obj;
        }
        
        [self MakeHotelImages:[_inputDict objectForKey:IMAGE_URL]];
        //To get the max hotel image height
        [self checkMaxImageHeight:hotelimages];
    }
#endif
#if 0
    //To adjust the room type button position and the table size for longer screen sizes
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_RoomButton setFrame:CGRectMake(_RoomButton.frame.origin.x, r.size.height-_RoomButton.frame.size.height,_RoomButton.frame.size.width, _RoomButton.frame.size.height)];
    [_InfoTable setFrame:CGRectMake(_InfoTable.frame.origin.x, _InfoTable.frame.origin.y,
                                    _InfoTable.frame.size.width, r.size.height-_InfoTable.frame.origin.y-_RoomButton.frame.size.height)];
#endif
    _RoomButton.clipsToBounds = YES;
    _RoomButton.layer.cornerRadius = 10;
#if 0
    //To load the hotel information
    self.delegate = self;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    dict[HOTEL_CODE] = _inputDict[HOTEL_CODE];
    NSString *uid =[ud objectForKey:PERSON_UID];
    
    if(uid == nil)
        uid = @"";
    
    dict[PERSON_UID] = uid;
    
    [self addRequestFields:dict];
    [self setApiName:@"search_hotel_details_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#else
    self.delegate = self;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID]) //favorite confirmation if logged in
    {
        //To add this hotel into favorite list
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[PAGE_NUM] = @"1";
        dict[@"fvrtHtlCode"] = _hotelCode;
        
        [self addRequestFields:dict];
        [self setApiName:@"search_favorite_hotel_api"];
        [self setSecure:NO];
        
        initialLoading = YES;
        
        [self sendRequest];
    }
#endif
    
}

-(void)addFavorite
{
    self.delegate = self;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        //To add this hotel into favorite list
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[@"fvrtHtlCode"] = _hotelCode;
        
        [self addRequestFields:dict];
        [self setApiName:@"entry_favorite_hotel_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
}

-(void)deleteFavorite
{
    self.delegate = self;
    isDeletingFavorite = YES;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        //To add this hotel into favorite list
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[@"fvrtHtlCode"] = _hotelCode;
        dict[@"dltFlag"] = @"Y";
        
        [self addRequestFields:dict];
        [self setApiName:@"entry_favorite_hotel_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
}

-(void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *person_uid = [ud stringForKey:PERSON_UID];
    
    BOOL isInFavorite = NO;
    if([self.presentingViewController isKindOfClass:[FavoriteList class]])
    {
        isInFavorite = YES;
    }
    
    switch (buttonIndex)
    {
        case 0: //add or delete
            if(person_uid)
            {
                if(favoriteAdded)
                {
                    [self deleteFavorite];
                }
                else
                {
                    [self addFavorite];
                }
                if(isInFavorite)
                {
                    FavoriteList *fl = (FavoriteList*)self.presentingViewController;
                    [fl setReload];
                }
            }
            else //not logged in yet
            {
                [self showLoginView];
            }
            break;
    }
}

-(void)showFavoriteActionSheet:(BOOL)alreadyAdded
{
    Class class = NSClassFromString(@"UIAlertController");
    
    NSString *msg;
    
    if(alreadyAdded)
    {
        msg = @"お気に入りから削除しますか";
    }
    else
    {
        msg = @"お気に入りに追加しますか";
    }
    
    FavoriteList *fl = nil;
    
    if([self.presentingViewController isKindOfClass:[FavoriteList class]])
    {
        fl = (FavoriteList*)self.presentingViewController;
    }
    
    if(class){ //iOS8, use alert controller
        // UIAlertControllerを使ってアクションシートを表示
        UIAlertController *actionSheet = nil;
        
        actionSheet = [UIAlertController alertControllerWithTitle:@"確認"
                                                          message:msg
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
        if (alreadyAdded)
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"削除"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action){
                                                              [self deleteFavorite];
                                                              if(fl)
                                                              {
                                                                  [fl setReload];
                                                              }
                                                          }]];
        }
        else
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"追加"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action){
                                                              [self addFavorite];
                                                              if(fl)
                                                              {
                                                                  [fl setReload];
                                                              }
                                                          }]];
        }
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          
                                                      }]];
        
        // ユニバーサルアプリかiPadアプリの場合は、
        // UIPopoverPresentationControllerを使った以下のコードが無いと落ちてしまうので注意
        // （このコードがあっても、iPhoneでの実行時には何も変化なし）
        actionSheet.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *pop = actionSheet.popoverPresentationController;
        pop.sourceView = self.view;
        //TODO: set the correct rectangle
        pop.sourceRect = CGRectMake(100.0, 100.0, 20.0, 20.0);
        
        [self presentViewController:actionSheet
                           animated:YES
                         completion:nil];
    }else{ //iOS 7 or earlier, use action sheet
        // UIActionSheetを使ってアクションシートを表示
        UIActionSheet *as = [[UIActionSheet alloc] init];
        as.delegate = self;
        as.title = msg;
        if (alreadyAdded)
        {
            [as addButtonWithTitle:@"削除"];
        }
        else
        {
            [as addButtonWithTitle:@"追加"];
        }
        [as addButtonWithTitle:@"キャンセル"];
        as.destructiveButtonIndex = 0;
        as.cancelButtonIndex = 1;
        [as showInView:self.view];
    }
}

-(void)showLoginView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.lastVC = self;
    UIViewController *next=[self.storyboard instantiateViewControllerWithIdentifier:@"loginChoices2"/*@"loginView"*/];
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

-(void)showLoginActionSheet
{
    Class class = NSClassFromString(@"UIAlertController");
    
    NSString *msg;
    msg = @"お気に入りの追加にはログインが必要です。ログインしますか？";
    
    if(class){ //iOS8, use alert controller
        // UIAlertControllerを使ってアクションシートを表示
        UIAlertController *actionSheet = nil;
        
        actionSheet = [UIAlertController alertControllerWithTitle:@"確認"
                                                          message:msg
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"ログイン"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action){
                                                              //TODO: to jump to login view
                                                              [self showLoginView];
                                                          }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                          
                                                      }]];
        
        // ユニバーサルアプリかiPadアプリの場合は、
        // UIPopoverPresentationControllerを使った以下のコードが無いと落ちてしまうので注意
        // （このコードがあっても、iPhoneでの実行時には何も変化なし）
        actionSheet.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *pop = actionSheet.popoverPresentationController;
        pop.sourceView = self.view;
        //TODO: set the correct rectangle
        pop.sourceRect = CGRectMake(100.0, 100.0, 20.0, 20.0);
        
        [self presentViewController:actionSheet
                           animated:YES
                         completion:nil];
    }else{ //iOS 7 or earlier, use action sheet
        // UIActionSheetを使ってアクションシートを表示
        UIActionSheet *as = [[UIActionSheet alloc] init];
        as.delegate = self;
        as.title = msg;
        [as addButtonWithTitle:@"ログイン"];
        
        [as addButtonWithTitle:@"キャンセル"];
        as.destructiveButtonIndex = 0;
        as.cancelButtonIndex = 1;
        [as showInView:self.view];
    }
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    NSString *errCode = data[@"errrCode"];
    
    if(initialLoading) //initial favorite loading, 1st priority
    {
        initialLoading = NO;
        
        if([errCode isEqualToString:@"BCMN0000"])
        {
            favoriteAdded = YES;
        }
        else
        {
            favoriteAdded = NO;
        }
        return;
    }
    
    if([errCode isEqualToString:@"BCMN0000"])
    {
        if(isLoadingFavorite)
        {
            isLoadingFavorite = NO;
            NSInteger count = [data[@"nmbrMyFvrts"] integerValue];
            if(count == 0) //not added
            {
                favoriteAdded = NO;
                [self showFavoriteActionSheet:NO];
            }
            else //already added
            {
                favoriteAdded = YES;
                [self showFavoriteActionSheet:YES];
            }
        }
        else
        {
            if(!isDeletingFavorite) //favorite added
            {
                favoriteAdded = YES;
                _favoriteButton.selected = YES;
                _favoriteButton.backgroundColor = [UIColor whiteColor]/*[Constant AppLightBlueColor]*/;
                _favoriteButton.titleLabel.textColor = [Constant DescBlueColor];
#if 0
                [_favoriteButton setImage:[UIImage imageNamed:@"チェックマーク"] forState:UIControlStateNormal];
#endif
            }
            else //favorite deleted
            {
                isDeletingFavorite = NO;
                favoriteAdded = NO;
                _favoriteButton.selected = NO;
                _favoriteButton.backgroundColor = [Constant DescBlueColor];
                _favoriteButton.titleLabel.textColor = [UIColor whiteColor];
#if 0
                [_favoriteButton setImage:[UIImage imageNamed:@"白いお気に入りアイコン"] forState:UIControlStateNormal];
#endif
            }
        }

    }
    else //error handling
    {
        if([errCode isEqualToString:@"BCMN1002"]) //already added
        {
            favoriteAdded = YES;
            _favoriteButton.enabled = NO;
            
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"このホテルはすでにお気に入りに入ってます。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        if([errCode isEqualToString:@"BCMN1004"]) //no record
        {
            if(isLoadingFavorite)
            {
                isLoadingFavorite = NO;
                favoriteAdded = NO;
                [self showFavoriteActionSheet:NO];
            }
            else
            {
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
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
    //NSLog(@"numberOfRowsInSection called, ret=%i", self.cellNames.count);
    
    return keys.count;//self.cellNames.count;
}

-(void)MakeHotelImages:(NSString*)images
{
#if 1
    NSMutableArray *imagelist = [[images componentsSeparatedByString:@","]mutableCopy];
    
    NSArray *extraImgs = @[@"http://www.toyoko-inn.com/sp/images/H95r1.jpeg", @"http://www.toyoko-inn.com/sp/images/H156r6.jpeg", @"http://www.toyoko-inn.com/sp/images/H179r3.jpeg"];
    
    [imagelist addObjectsFromArray:extraImgs];
#else
    NSArray *imagelist = [images componentsSeparatedByString:@","];
#endif
    
    for(NSString *str in imagelist)
    {
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        if(urlData)
        {
            UIImage *tmpImg = [UIImage imageWithData:urlData];
            [hotelimages addObject:tmpImg];
        }
    }

}

-(void)checkMaxImageHeight:(NSArray*)images
{
    MaxImageHeight = 0;
    for(UIImage *img in images)
    {
        if(img.size.height > MaxImageHeight)
            MaxImageHeight = img.size.height;
    }
    //make the image size half
    MaxImageHeight/=2;
    NSLog(@"Max image height: %d", MaxImageHeight);
}

-(void)MakeLastCell:(UITableViewCell*)cell
{
    [cell.textLabel setText:@""];
    
    int buttonWidth;
    //calculate the width of each button, with left/right margin and 2 margins between buttons
    buttonWidth = (cell.contentView.frame.size.width - (NUM_LASTBUTTONS-1)*IMAGE_MARGIN)/NUM_LASTBUTTONS;
    
    CGRect r;
    
    //set the basic metrics
    r.origin.y = (CELL_HEIGHT - BUTTON_HEIGHT)/2;
    r.size.width = buttonWidth;
    r.size.height = BUTTON_HEIGHT;
    
    r.origin.x = 0/*IMAGE_MARGIN*/;
    
    //CGFloat inset = 0.0;
    
    if(!_aroundButton)
    {
#if 0
        _aroundButton = [[UIButton alloc] initWithFrame:r];
        [_aroundButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_aroundButton setTitle:@"周辺情報" forState:UIControlStateNormal];
        [_aroundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_aroundButton setBackgroundColor:[Constant DescBlueColor]];
        [_aroundButton setImage:[UIImage imageNamed:@"現在地周辺アイコン"] forState:UIControlStateNormal];
        _aroundButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        inset = (BUTTON_HEIGHT - ([UIImage imageNamed:@"現在地周辺アイコン"].size.height)/2.0)/2.0;
        
        [_aroundButton setImageEdgeInsets:UIEdgeInsetsMake(inset, 0.0, inset, 0.0)];
        [_aroundButton.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        _aroundButton.userInteractionEnabled = YES;
        _aroundButton.tag = 1; //use tag to find out the button
#else
        _aroundButton = (UIButton*)[cell viewWithTag:1];
        _aroundButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [_aroundButton.imageView setContentMode: UIViewContentModeCenter ];
#endif
    }
#if 0
    [cell.contentView addSubview:_aroundButton];
#endif
    [_aroundButton addTarget:self action:@selector(AroundPressed:) forControlEvents:UIControlEventTouchUpInside];
#if 0
    r.origin.x += buttonWidth + IMAGE_MARGIN;
#endif
    if(!_routeButton)
    {
#if 0
        _routeButton = [[UIButton alloc] initWithFrame:r];
        [_routeButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_routeButton setTitle:@"ルート検索" forState:UIControlStateNormal];
        [_routeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_routeButton setBackgroundColor:[Constant DescBlueColor]];
        [_routeButton setImage:[UIImage imageNamed:@"ルート検索アイコン"] forState:UIControlStateNormal];
        _routeButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        inset = (BUTTON_HEIGHT - ([UIImage imageNamed:@"ルート検索アイコン"].size.height)/2.0)/2.0;
        
        [_routeButton setImageEdgeInsets:UIEdgeInsetsMake(inset, 0.0, inset, 0.0)];
        [_routeButton.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        _routeButton.userInteractionEnabled = YES;
        _routeButton.tag = 2; //use tag to find out the button
#else
        _routeButton = (UIButton*)[cell viewWithTag:2];
        _routeButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [_routeButton.imageView setContentMode: UIViewContentModeCenter ];
#endif
    }
#if 0
    [cell.contentView addSubview:_routeButton];
#endif
    [_routeButton addTarget:self action:@selector(RoutePressed:) forControlEvents:UIControlEventTouchUpInside];
#if 0
    r.origin.x += buttonWidth + IMAGE_MARGIN;
#endif
    if(!_favoriteButton)
    {
#if 0
        _favoriteButton = [[UIButton alloc] initWithFrame:r];
        [_favoriteButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        
        //For changeable favorite button
        _favoriteButton.titleLabel.numberOfLines = 0; //make button title multiline
        
        [_favoriteButton setTitle:@"お気に入り"/*@"お気に入り\n解除"*/ forState:UIControlStateNormal];
        [_favoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_favoriteButton setTitleColor:[Constant DescBlueColor] forState:UIControlStateSelected];
        [_favoriteButton setBackgroundColor:[Constant DescBlueColor]];
        [_favoriteButton setImage:[UIImage imageNamed:@"白いお気に入りアイコン"] forState:UIControlStateNormal];
        //add new icon for selected state
        [_favoriteButton setImage:[UIImage imageNamed:@"チェックマーク"] forState:UIControlStateSelected];
        _favoriteButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        inset = (BUTTON_HEIGHT - ([UIImage imageNamed:@"白いお気に入りアイコン"].size.height)/2.0)/2.0;
        
        [_favoriteButton setImageEdgeInsets:UIEdgeInsetsMake(inset, 0.0, inset, 0.0)];
        [_favoriteButton.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        _favoriteButton.userInteractionEnabled = YES;
        _favoriteButton.tag = 3;
#else
        _favoriteButton = (UIButton*)[cell viewWithTag:3];
        _favoriteButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        _favoriteButton.imageView.contentMode = UIViewContentModeCenter;
        [_favoriteButton setImage:[UIImage imageNamed:@"チェックマーク"] forState:UIControlStateSelected];
        [_favoriteButton setTitleColor:[Constant DescBlueColor] forState:UIControlStateSelected];
#endif
    }
#if 0
    [cell.contentView addSubview:_favoriteButton];
#endif
    [_favoriteButton addTarget:self action:@selector(FavoritePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *buttons = @[_aroundButton, _routeButton, _favoriteButton];
    for(UIButton *btn in buttons)
    {
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1.5f;
        btn.layer.borderColor = [Constant DescBlueColor].CGColor;
    }
    
    //added for initial favorite button state
    _favoriteButton.selected = favoriteAdded;
    if(_favoriteButton.selected)
    {
        _favoriteButton.backgroundColor = [UIColor whiteColor]/*[Constant AppLightBlueColor]*/;
        //_favoriteButton.titleLabel.textColor = [Constant DescBlueColor];
    }
}

-(void)MakeImageCell:(UITableViewCell*)cell
{
#if 0
    [cell.textLabel setText:@""];
#if 1
    cell.contentView.frame = cell.bounds;
    cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
#endif
#endif
    //setup the page control
    if(!_pageControl)
    {
#if 0
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MaxImageHeight,
                                      cell.contentView.frame.size.width, PAGECONTROL_HEIGHT)];
#else
        if([[cell viewWithTag:2] isKindOfClass:[UIPageControl class]])
        {
            _pageControl = (UIPageControl*)[cell viewWithTag:2];
        }
#endif
        [_pageControl setNumberOfPages:hotelimages.count];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor yellowColor]];
    }
#if 0
    [cell.contentView addSubview:_pageControl];
#endif
    [_pageControl addTarget:self action:@selector(PageValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //setup the image view
    if(!_hotelImageView)
    {
#if 0
        _hotelImageView = [[UIImageView alloc] initWithImage:[hotelimages objectAtIndex:0]];
#else
        if([[cell viewWithTag:1] isKindOfClass:[UIImageView class]])
        {
            _hotelImageView = (UIImageView*)[cell viewWithTag:1];
            _hotelImageView.image = hotelimages[0];
        }
#endif
    }

    //CGRect r;
#if 0
    //setup the hotel image view
    r.origin.x = IMAGE_MARGIN;
    r.origin.y = 0;
    r.size.width = cell.contentView.frame.size.width - IMAGE_MARGIN*2;
    r.size.height = MaxImageHeight;
    [_hotelImageView setContentMode: UIViewContentModeScaleAspectFit ];
    [_hotelImageView setFrame:r];
    [cell.contentView addSubview:_hotelImageView];
#endif
    //setup the previous button
#if 0
    r.size.width = [UIImage imageNamed:@"前"].size.width/2;
    r.size.height = [UIImage imageNamed:@"前"].size.height/2;
    r.origin.x = IMAGE_MARGIN;
    r.origin.y = MaxImageHeight/2 - r.size.height/2;
#endif
    if(!_prevButton)
    {
#if 0
        _prevButton = [[UIButton alloc] initWithFrame:r];
#else
        if([[cell viewWithTag:3] isKindOfClass:[UIButton class]])
        {
            _prevButton = (UIButton*)[cell viewWithTag:3];
        }
#endif
    }
#if 0
    [_prevButton setImage:[UIImage imageNamed:@"前"] forState:UIControlStateNormal];
    [cell.contentView addSubview:_prevButton];
#endif
    [_prevButton addTarget:self action:@selector(PrevPressed:) forControlEvents:UIControlEventTouchUpInside];
    if(_pageControl.currentPage==0) //1st image
    {
        _prevButton.enabled = NO;
    }
    else
    {
        _prevButton.enabled = YES;
    }
    
    //setup the next button
#if 0
    r.size.width = [UIImage imageNamed:@"次"].size.width/2;
    r.size.height = [UIImage imageNamed:@"次"].size.height/2;
    r.origin.x = cell.contentView.frame.size.width - r.size.width-IMAGE_MARGIN;
    r.origin.y = r.origin.y = MaxImageHeight/2 - r.size.height/2;
#endif
    
    if(!_nextButton)
    {
#if 0
        _nextButton = [[UIButton alloc] initWithFrame:r];
#else
        if([[cell viewWithTag:4] isKindOfClass:[UIButton class]])
        {
            _nextButton = (UIButton*)[cell viewWithTag:4];
        }
#endif
    }
#if 0
    [_nextButton setImage:[UIImage imageNamed:@"次"] forState:UIControlStateNormal];
    [cell.contentView addSubview:_nextButton];
#endif
    [_nextButton addTarget:self action:@selector(NextPressed:) forControlEvents:UIControlEventTouchUpInside];
    if(_pageControl.currentPage==hotelimages.count-1) //last image
    {
        _nextButton.enabled = NO;
    }
    else
    {
        _nextButton.enabled = YES;
    }
}

- (void)PrevPressed:(id)sender
{
    _pageControl.currentPage--;
    [self PageValueChanged:_pageControl];
}

-(void)NextPressed:(id)sender
{
    _pageControl.currentPage++;
    [self PageValueChanged:_pageControl];
}

-(void)PageValueChanged:(id)sender
{
    NSLog(@"page: %ld", (long)_pageControl.currentPage);
    if (_pageControl.currentPage == 0) {
        _prevButton.enabled = NO;
    }
    else
        _prevButton.enabled = YES;
    
    if (_pageControl.currentPage == hotelimages.count-1) {
        _nextButton.enabled = NO;
    }
    else
        _nextButton.enabled = YES;
    
    [_hotelImageView setImage:[hotelimages objectAtIndex:_pageControl.currentPage]];
}

-(void)AddMapButton:(UITableViewCell*)cell
{
    //CGRect r;
#if 0
    if(!_mapButton)
    {
#endif
#if 0
        r.size.height = CELL_HEIGHT - IMAGE_MARGIN;
        r.size.width = r.size.height;
        r.origin.x = cell.contentView.frame.size.width - r.size.width /*-IMAGE_MARGIN/2*/;
        r.origin.y = IMAGE_MARGIN/2;
        
        _mapButton = [[UIButton alloc] initWithFrame:r];
        [_mapButton.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [_mapButton setTitle:@"MAP" forState:UIControlStateNormal];
        [_mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mapButton setBackgroundColor:[Constant DescBlueColor]];
        
        [_mapButton setImage:[UIImage imageNamed:@"地図アイコン"] forState:UIControlStateNormal];
        [_mapButton.imageView setContentMode: UIViewContentModeScaleAspectFit ];
        _mapButton.imageEdgeInsets = UIEdgeInsetsMake(5.0, 7.0, 15.0, 8.0);
        _mapButton.titleEdgeInsets = UIEdgeInsetsMake(20.0, -37.5, 0.0, 0.0);
        _mapButton.clipsToBounds = YES;
        _mapButton.layer.cornerRadius = 5;
#else
        _mapButton = (UIButton*)[cell viewWithTag:1];
        _mapButton.clipsToBounds = YES;
        _mapButton.layer.cornerRadius = 5;
#endif
#if 0
    }
#endif
#if 0
    [cell.contentView addSubview:_mapButton];
#endif
    [_mapButton addTarget:self action:@selector(MapPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)MapPressed:(id)sender
{
    double latt, lngtd;
    
    latt = [_inputDict[LATITUDE] doubleValue];
    lngtd = [_inputDict[LONGITUDE] doubleValue];
    //NSString *hotelName = _inputDict[HOTEL_NAME];
    
    //hotelName = [hotelName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if 1
    MapView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
    
    next.centerLatt = latt;
    next.centerLngtd = lngtd;
    
    next.searchDict = nil;
    
    NSMutableDictionary *tmpDict = [_inputDict mutableCopy];
    tmpDict[HOTEL_CODE] = _hotelCode;
    
    next.inputArray = @[tmpDict];
    next.title = _inputDict[HOTEL_NAME];
    next.isSingleHotelMode = YES; //added for one hotel only mode modification
    
    [self presentViewController:next animated:YES completion:^ {
        
    }];
#else
    NSString *url;
    
    if([[UIApplication sharedApplication] canOpenURL:
     [NSURL URLWithString:@"comgooglemaps://"]])
    {
        url = [NSString stringWithFormat:@"comgooglemaps://?q=%f,%f&zoom=%d&views=traffic", /*hotelName,*/ latt, lngtd, (int)DEFAULT_ZOOM];
    }
    else //google map not installed, use apple map instead
    {
        url = [NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f", latt, lngtd];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#endif
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
#if 0
    NSLog(@"bg color of cell: %@", cell.backgroundColor);
#endif
#if 0
    [cell setHighlighted:NO];
    [cell setSelected:NO];
#endif
#if 0
    for(UIView *view in cell.contentView.subviews)
    {
        NSLog(@"bg color:%@", view.backgroundColor);
    }
#endif
    if(cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {
        NSString *str = cell.textLabel.text;
        NSArray *arr = [str componentsSeparatedByString:@"\n"];
        NSString *title = arr[0];
        
        NSMutableArray *contentArray = [arr mutableCopy];
        [contentArray removeObjectAtIndex:0]; //remove the first obj
        NSString *content = [contentArray componentsJoinedByString:@"\n"];
        
        TextView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"TextView"];
        
        next.viewTitle = title;
        next.text = content;
        
        [self presentViewController:next animated:YES completion:^ {
        }];
    }
}

#define DESC_CELL_WIDTH 290.0f
#define TEXTLABEL_X 15.0f
#define MARGIN 5.0f

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath.row=%li", (long)indexPath.row);
#if 0
    NSString *cellIdentifier = @"Cell";
#else
    NSString *cellIdentifier;
    if([keys[indexPath.row] isEqualToString:IMAGE_URL])
    {
        cellIdentifier = @"Pict";
    }
    else if([keys[indexPath.row] isEqualToString:@"last"])
    {
        cellIdentifier = @"Last";
    }
    else if([keys[indexPath.row] isEqualToString:@"addrss"])
    {
        cellIdentifier = @"Address";
    }
    else if([keys[indexPath.row] isEqualToString:@"crdtInfrmtnList"])
    {
        cellIdentifier = @"CreditCard";
    }
    else
       cellIdentifier = @"Cell";
#endif
    UITableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
#if 0
    NSLog(@"bg color of cell: %@", cell.backgroundColor);
#endif
    //To set the separator inset
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
    
    //To remove the subviews for recycled cells
    if(![keys[indexPath.row] isEqualToString:IMAGE_URL] &&
       ![keys[indexPath.row] isEqualToString:@"last"] &&
       ![keys[indexPath.row] isEqualToString:@"addrss"] &&
       ![keys[indexPath.row] isEqualToString:@"crdtInfrmtnList"]) //do not handle image/last cell
    {
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    else if([keys[indexPath.row] isEqualToString:IMAGE_URL])//image cell
    {
        PictCell *pict = (PictCell*)cell;
        [pict setImages:hotelimages];
    }
#if 0
    NSLog(@"key=%@, value=%@", keys[indexPath.row], _inputDict[keys[indexPath.row]]);
#endif
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    //change the cell's property
    if([details containsObject:keys[indexPath.row]])
    {
        id value = _inputDict[keys[indexPath.row]];
        
        if([value isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray*)value;
            if(arr.count > 0)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if([value isKindOfClass:[NSString class]])
        {
            NSString *str = (NSString*)value;
            
            if(str.length > 0)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    
    //special item
    if ([specialItems indexOfObject:[keys objectAtIndex:indexPath.row]]!=NSNotFound)
    {
        if([[keys objectAtIndex:indexPath.row] isEqualToString:@"crdtInfrmtnList"])
        {
            NSMutableString *tempStr = [[NSMutableString alloc]initWithString:[title objectForKey:[keys objectAtIndex:indexPath.row]]];
            [tempStr appendString:@"\n"];
            [self AddFormattedStringToCell:cell str1:tempStr str2:@"　"];
//            [self MakeCreditCardImages:[contents objectForKey:[keys objectAtIndex:indexPath.row]]];
#if 0
            [self PlaceCreditCardImages:cell];
#else
            UIImageView *imgv = (UIImageView*)[cell viewWithTag:1];
            if(imgv)
            {
                imgv.image = cardImage;
            }
#endif
        }
        else if([[keys objectAtIndex:indexPath.row] isEqualToString:IMAGE_URL])
        {
#if 0
            [self MakeImageCell:cell];
#endif
        }
        else if([[keys objectAtIndex:indexPath.row] isEqualToString:@"last"])
        {
            [self MakeLastCell:cell];
        }
        else if([[keys objectAtIndex:indexPath.row] isEqualToString:@"addrss"])
        {
            NSMutableString *tempStr = [[NSMutableString alloc]initWithString:[title objectForKey:[keys objectAtIndex:indexPath.row]]];
            [tempStr appendString:@"\n"];
            [self AddFormattedStringToCell:cell str1:tempStr str2:[_inputDict objectForKey:[keys objectAtIndex:indexPath.row]]];
            [self AddMapButton:cell];
#if 0
            CGRect r = cell.textLabel.frame;
            r.size.width = _mapButton.frame.origin.x - r.origin.x - MARGIN;
            cell.textLabel.frame = r;
#endif
        }
        else if([[keys objectAtIndex:indexPath.row] isEqualToString:@"accssInfmtnList"])
        {
            NSArray *accesses = _inputDict[keys[indexPath.row]];
            
            NSMutableArray *accessList = [[NSMutableArray alloc] init];
            
            for(NSDictionary *dict in accesses)
            {
                [accessList addObject:dict[@"accssInfmtn"]];
            }
            NSString *access = [accessList componentsJoinedByString:@", "];
            
            NSMutableString *tempStr = [[NSMutableString alloc]initWithString:[title objectForKey:[keys objectAtIndex:indexPath.row]]];
            [tempStr appendString:@"\n"];
            [self AddFormattedStringToCell:cell str1:tempStr str2:access];
        }
        else if([[keys objectAtIndex:indexPath.row] isEqualToString:@"eqpmntInfrmtnList"])
        {
            NSArray *equips = _inputDict[keys[indexPath.row]];
            
            NSMutableArray *equipList = [[NSMutableArray alloc] init];
            
            for(NSDictionary *dict in equips)
            {
                [equipList addObject:dict[@"eqpmntName"]];
            }
            NSString *equip = [equipList componentsJoinedByString:@", "];
            
            NSMutableString *tempStr = [[NSMutableString alloc]initWithString:[title objectForKey:[keys objectAtIndex:indexPath.row]]];
            [tempStr appendString:@"\n"];
            [self AddFormattedStringToCell:cell str1:tempStr str2:equip];
        }
    }
    else
    {
        NSMutableString *tempStr = [[NSMutableString alloc]initWithString:[title objectForKey:[keys objectAtIndex:indexPath.row]]];
        [tempStr appendString:@"\n"];
        
        NSString *str = [_inputDict objectForKey:[keys objectAtIndex:indexPath.row]];
        //NSLog(@"key:%@, title:%@, str:%@", keys[indexPath.row], tempStr, str);
        
        //revmove the line break in the table
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        if([keys[indexPath.row] isEqualToString:CHECKIN_TIME] ||
           [keys[indexPath.row] isEqualToString:@"chcktTime"])
        {
            str = [str substringWithRange:NSMakeRange(0, 5)];
        }
        [self AddFormattedStringToCell:cell str1:tempStr str2:str];
    }
    
#if 0
    [cell setNeedsDisplay];
    [cell setNeedsLayout];
#endif
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[keys objectAtIndex:indexPath.row] isEqualToString:IMAGE_URL])
        cell.hidden = NO;
    else
    {
        if([specialItems containsObject:keys[indexPath.row]])
        {
            cell.hidden = NO;
        }
        else
        {
            NSString *str = _inputDict[keys[indexPath.row]];
            if(str == nil)
                cell.hidden = YES;
            
            //remove all spaces
            str = [ str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(str.length == 0)
                cell.hidden = YES;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[keys objectAtIndex:indexPath.row] isEqualToString:IMAGE_URL])
        return IMAGE_CELL_HEIGHT;
#if 1
    else if([keys[indexPath.row] isEqualToString:@"addrss"])
    {
        NSString *cellIdentifier = @"Address";
        AddressCell *cell = (AddressCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        CGFloat cellWidth = [cell getTextlabelWidth];
        
        NSMutableString *tempStr = [[NSMutableString alloc]initWithString:[title objectForKey:[keys objectAtIndex:indexPath.row]]];
        [tempStr appendString:@"\n"];
        [self AddFormattedStringToCell:cell str1:tempStr str2:[_inputDict objectForKey:[keys objectAtIndex:indexPath.row]]];
        
        NSAttributedString *attr = cell.textLabel.attributedText;
        
        CGRect rect = [attr boundingRectWithSize:(CGSize){cellWidth, CGFLOAT_MAX}
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                         context:nil];
        CGFloat separatorHeight = tableView.separatorStyle == UITableViewCellSeparatorStyleNone ? 0 : 1 / [UIScreen mainScreen].scale;
        CGFloat height = rect.size.height + separatorHeight + 1 + MARGIN;
        return fmax(height, CELL_HEIGHT);
    }
#endif
    else
    {
        if([specialItems containsObject:keys[indexPath.row]])
        {
            return CELL_HEIGHT;
        }
        else
        {
            NSString *str = _inputDict[keys[indexPath.row]];
            if(str == nil)
                return 0;
            
            //remove all spaces
            str = [ str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(str.length == 0)
                return 0;
        }
        
    }
    return CELL_HEIGHT;
}

- (IBAction)AroundPressed:(id)sender {
    NSString *baseURL = @"http://www.walking-map.com/osanpo/toyoko_inn/%@";
    NSString *url = [NSString stringWithFormat:baseURL, /*@"00001"*/_hotelCode];
    NSLog(@"walking-map url: %@", url);
    
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = url;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
}

- (IBAction)RoutePressed:(id)sender {
    NSString *destAddr;
    
    destAddr = _inputDict[@"addrss"];
    
    //latt = [_inputDict[LATITUDE] doubleValue];
    //lngtd = [_inputDict[LONGITUDE] doubleValue];
    //NSString *hotelName = _inputDict[HOTEL_NAME];
    
    //hotelName = [hotelName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url;
#if 1
    if([[UIApplication sharedApplication] canOpenURL:
        [NSURL URLWithString:@"comgooglemaps://"]])
    {
        url = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@", [destAddr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    else //google map not installed, use apple map instead
    {
        NSString *hotelName = _inputDict[HOTEL_NAME];
        url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@&daddr=%@", [@"現在地" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[/*destAddr*/hotelName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#else
    url = [NSString stringWithFormat:@"https://maps.google.com/maps?saddr=%@&daddr=%@",[@"現在地" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [destAddr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    NSLog(@"navi url: %@", url);
    
    ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    next.URL = url;
    [self presentViewController:next animated:YES completion:^ {
        
    }];
#endif
}

- (IBAction)FavoritePressed:(id)sender {
#if 0
    self.delegate = self;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        //To add this hotel into favorite list
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[@"fvrtHtlCode"] = _hotelCode;
        
        [self addRequestFields:dict];
        [self setApiName:@"entry_favorite_hotel_api"];
        [self setSecure:NO];
        
        [self sendRequest];
    }
#else
    self.delegate = self;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud stringForKey:PERSON_UID])
    {
        //To add this hotel into favorite list
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        self.delegate = self;
        dict[PERSON_UID] = [ud stringForKey:PERSON_UID];
        dict[PAGE_NUM] = @"1";
        dict[@"fvrtHtlCode"] = _hotelCode;
        
        [self addRequestFields:dict];
        [self setApiName:@"search_favorite_hotel_api"];
        [self setSecure:NO];
        
        isLoadingFavorite = YES;
        
        [self sendRequest];
    }
    else //if not logged in yet
    {
        [self showLoginActionSheet];
    }
#endif
}

- (IBAction)RoomTypePressed:(id)sender {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.reservData != nil)
    {
        [dict addEntriesFromDictionary:appDelegate.reservData];
        dict[HOTEL_CODE] = _hotelCode;
    }
    else
    {
        //no reservation data, fill the default items
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if([ud stringForKey:MEMBER_NUM])
            dict[MEMBER_FLAG] = @"Y";
        else
            dict[MEMBER_FLAG] = @"N";
        
        dict[HOTEL_CODE] = _hotelCode;
        
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"yyyyMMdd"];
        NSString *date_String=[dateformate stringFromDate:[NSDate date]];
        
        dict[CHECKIN_DATE] = date_String/*@"20140901"*/; //to be replaced by today's date
        dict[NUM_NIGHTS] = @"1"; //default value
        
        dict[NUM_PEOPLE] = @"1";
        dict[NUM_ROOMS] = @"1";
    }
    RoomTypeList *next = [self.storyboard instantiateViewControllerWithIdentifier:@"RoomTypeList"];
    next.searchDict = dict;
    
    next.title = [NSString stringWithFormat:@"%@\n%@~%@泊 %@名x%@室",
     _inputDict[HOTEL_NAME],[Constant convertToLocalDate:dict[CHECKIN_DATE]],
     dict[NUM_NIGHTS], dict[NUM_PEOPLE], dict[NUM_ROOMS]];
    
    next.htlName = _inputDict[HOTEL_NAME];
    
    [self presentViewController:next animated:YES completion:^ {
    }];
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)AddFormattedStringToCell:(UITableViewCell*)cell str1:(NSString*)str1 str2:(NSString*)str2
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 5.0f;
#if 0
    NSLog(@"paragraph.paragraphSpacingBefore = %f",paragraph.paragraphSpacingBefore);
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    paragraph.lineHeightMultiple = 1.2f;
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12.0f];
    NSAttributedString *s2=[[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:font, /*NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName:[UIColor grayColor],*/ NSParagraphStyleAttributeName: paragraph, NSBaselineOffsetAttributeName: [NSNumber numberWithFloat: 4.0]}];
    
    [s1 appendAttributedString: s2]; //combine the 2 strings
    
    font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
    NSMutableAttributedString *s0=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSBackgroundColorAttributeName:[Constant textHeaderColor], NSParagraphStyleAttributeName: paragraph}];
    
    NSAttributedString *s0_1=[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font}];
    [s0 appendAttributedString:s0_1];
    
    [s0 appendAttributedString:s1]; //add blue "I" in the beginning according to the design sample
    
#if 0
    NSLog(@"textLabel rect: %@", NSStringFromCGRect(cell.textLabel.frame));
#endif
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setAttributedText:s0];
#if 0
    [cell.textLabel sizeToFit];
#endif
}

#if 0
-(void)MakeCreditCardImages:(NSArray*)credit
{
    //get each card brand by parsing with ","
    //    [creditcards removeAllObjects];
    
    for(NSDictionary *dict in credit)
    {
        NSString *s = dict[@"creditName"];
        s = [s lowercaseString];
        //NSLog(@"card brand: %@",s);
        NSMutableString *tmpStr = [[NSMutableString alloc] initWithString:s];
        [tmpStr appendString:@".gif"];
        UIImage *tmpImg = [UIImage imageNamed:tmpStr];
        if(tmpImg == nil) //out of default card list
        {
            NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[IMAGE_URL]]];
            if(urlData)
            {
                tmpImg = [UIImage imageWithData:urlData];
                if(tmpImg == nil)
                    continue; //cannot load the card image, give up
            }
            else
            {
                continue; //cannot load the card image, give up
            }
        }
        //NSLog(@"img size: %f, %f", tmpImg.size.width, tmpImg.size.height);
        
        UIImageView *temp = [[UIImageView alloc] initWithImage:tmpImg];
#if 1
        temp.backgroundColor = [UIColor whiteColor];
        temp.opaque = NO;
#endif
        //temp.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [temp setFrame:CGRectMake(temp.frame.origin.x, temp.frame.origin.y, tmpImg.size.width/2, tmpImg.size.height/2)];
        
        [temp setContentMode: UIViewContentModeScaleAspectFit];
        [creditcards addObject:temp];
    }
}
#endif

#if 0
-(void)PlaceCreditCardImages:(UITableViewCell*)cell
{
    int height=0;
    
    NSLog(@"size of creditcards: %lu", (unsigned long)creditcards.count);
    
    for(UIImageView *view in creditcards)
    {
        //To get the max height value
        if(view.frame.size.height > height)
            height = view.frame.size.height;
    }
    
    height += CARD_IMAGE_MARGIN;
    
    int offset;
    int y,x= cell.indentationWidth/*0*/;
    int base_y = cell/*.contentView*/.frame.size.height - height;
    
    for(UIImageView *view in creditcards)
    {
        offset = (height - view.frame.size.height)/2;
        y = base_y + offset;
        [view setFrame:CGRectMake(x, y, view.frame.size.width, view.frame.size.height)];
        //NSLog(@"view frame: %f, %f, %f, %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        [cell.contentView addSubview:view];
        [cell.contentView bringSubviewToFront:view];
        x+= view.frame.size.width + cardSpace;
    }
}
#endif

-(UIImage*)MakeCardImage:(NSArray*)credit
{
    NSMutableArray *cardImages = [[NSMutableArray alloc]init];
    CGFloat maxHeight = 0;
    CGFloat totalWidth = 0;
    
    for(NSDictionary *dict in credit)
    {
        NSString *s = dict[@"creditName"];
        s = [s lowercaseString];
        //NSLog(@"card brand: %@",s);
        NSMutableString *tmpStr = [[NSMutableString alloc] initWithString:s];
        [tmpStr appendString:@".gif"];
        UIImage *tmpImg = [UIImage imageNamed:tmpStr];
        if(tmpImg == nil) //out of default card list
        {
            NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[IMAGE_URL]]];
            if(urlData)
            {
                tmpImg = [UIImage imageWithData:urlData];
                if(tmpImg == nil)
                    continue; //cannot load the card image, give up
            }
            else
            {
                continue; //cannot load the card image, give up
            }
        }
        [cardImages addObject:tmpImg];
        
        totalWidth += tmpImg.size.width;
        if(tmpImg.size.height > maxHeight)
            maxHeight = tmpImg.size.height;
    }
    totalWidth += cardImages.count*cardSpace - 1;
    
    CGSize size = CGSizeMake(totalWidth, maxHeight);
    
    UIGraphicsBeginImageContext(size);
    int x=0;
    for(UIImage *img in cardImages)
    {
        CGFloat Yoffset = (maxHeight - img.size.height)/2;
        CGRect rect;
        rect.size = img.size;
        rect.origin.x = x;
        rect.origin.y = Yoffset;
        
        [img drawInRect:rect];
        x += img.size.width + cardSpace;
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)connectionFailed:(NSError*)error
{
}
@end
