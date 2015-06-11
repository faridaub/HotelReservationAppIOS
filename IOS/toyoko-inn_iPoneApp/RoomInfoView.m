//
//  RoomInfoView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/16.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "RoomInfoView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "reservInput.h"
#import "TextView.h"
#import "PictCell.h"
#import "ViewController.h"

@interface RoomInfoView ()

@end

@implementation RoomInfoView

static NSArray *items;
static NSMutableArray *roomimages;
static int MaxImageHeight;
static int PriceCellHeight;
static int PriceDetailHeight;

static NSMutableDictionary *loadedData;

static UIImageView *imgv;

#define PAGECONTROL_HEIGHT 37
#define IMAGE_MARGIN 5.0

#define PRICE_HEIGHT 110
#define PRICE_DETAIL_HEIGHT 40

#define IMAGE_CELL_HEIGHT 187.0

#define BGLABEL_TAG 10
#define CELL_WIDTH 320
#define DEFAULT_MARGIN 5
#define BORDER_WIDTH 1.0f

#define DEFAULT_IMAGE @"http://www.toyoko-inn.com/images/app/deluxe_twin.jpg"/*@"http://www.toyoko-inn.com/sp/images/H243r1.jpeg"*/

static NSString *cancelPolicy;

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
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Pict"];
    
    NSString *txtFilePath = [[NSBundle mainBundle] pathForResource: @"cancelPolicy" ofType: @"txt"];
    cancelPolicy = [NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:NULL];
    
    items =@[
#if 0
             @{@"cellName":@"smallCell",@"type":@"title1",@"title":@"喫煙ダブル",@"icon":@"白い喫煙マーク"},
             @{@"cellName":@"Custom",@"type":@"image",@"images":@"http://www.toyoko-inn.com/sp/images/H243r5.jpeg"},
             //only check-in cell is NSMutableDictionary, others are NSDictionary
             [@{@"cellName":@"Checkin",@"type":@"checkin",@"date":@"2014年7月20日",@"nights":@(2)} mutableCopy],
             @{@"cellName":@"Checkout",@"type":@"checkout",@"date":@"2014年7月21日"},
             @{@"cellName":@"smallCell",@"type":@"title2",@"title":@"喫煙ダブル",@"icon":@"喫煙マーク",@"num_people":@(2)},
             @{@"cellName":@"priceCell",@"type":@"price_mem",@"total":@"28,000円",@"total_tax":@"税込30,240",@"prices":@[@"14,000円",@"14,000円"],@"prices_tax":@[@"税込15,120円",@"税込15,120円"]},
             @{@"cellName":@"priceCell",@"type":@"price_norm",@"total":@"35,200円",@"total_tax":@"税込38,016",@"prices":@[@"17,000円",@"18,200円"],@"prices_tax":@[@"税込18,360円",@"税込19,656円"]},
             @{@"cellName":@"regularCell",@"type":@"equip",@"title1":@"客室設備・アメニティ",@"title2":@"Wifi, LAN, ..."},
             @{@"cellName":@"smallCell2",@"type":@"rule",@"title1":@"宿泊約款・利用規約"},
             @{@"cellName":@"bigCell",@"type":@"policy",@"title1":@"キャンセルポリシー",@"title2":@"当日16時〜22時：宿泊代金の50％\n当日22以降／不泊：宿泊代金の100％"},
#endif
            ];
#if 1
    _OKButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [_OKButton.imageView setContentMode: UIViewContentModeCenter ];
    _OKButton.clipsToBounds = YES;
    _OKButton.layer.cornerRadius = 10;
#endif
    
    roomimages = [[NSMutableArray alloc] init];
    
    //setup the room images
    [roomimages removeAllObjects];
    //To load all images from internet
    //TODO: make local image cache

    for(id item in items)
    {
        NSDictionary *dict = (NSDictionary*)item;
        if([dict[@"type"] isEqualToString:@"image"])
        {
            [self MakeRoomImages:dict[@"images"]];
            break;
        }
    }
    //To get the max hotel image height
    [self checkMaxImageHeight:roomimages];
#if 0
    //To adjust the room type button position and the table size for longer screen sizes
    CGRect r = [[UIScreen mainScreen] bounds];
    
    [_OKButton setFrame:CGRectMake(_OKButton.frame.origin.x, r.size.height-_OKButton.frame.size.height,_OKButton.frame.size.width, _OKButton.frame.size.height)];
    [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y,
                                    _tableView.frame.size.width, r.size.height-_tableView.frame.origin.y-_OKButton.frame.size.height)];
#endif
    [_tableView.layer setBorderWidth:0.5f];
    [_tableView.layer setBorderColor:[UIColor blackColor].CGColor];
#if 1
    self.delegate = self;
    [self addRequestFields:_searchDict];
    [self setApiName:@"search_room_type_details_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PrepareTableData:(NSDictionary*)data
{
    NSString *smokingIcon;
    NSString *smokingIcon2;
    if([_inputDict[SMOKING_FLAG] isEqualToString:@"Y"])
    {
        smokingIcon = @"白い喫煙マーク";
        smokingIcon2 = @"喫煙マーク";
    }
    else
    {
        smokingIcon = @"白い禁煙マーク";
        smokingIcon2 = @"禁煙マーク";
    }
    loadedData[SMOKING_FLAG] = _inputDict[SMOKING_FLAG];
    
    NSArray *equips = data[@"eqpmntInfrmtnList"];
    
    NSMutableArray *equipList = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dict in equips)
    {
        [equipList addObject:dict[@"eqpmntName"]];
    }
    NSString *equipStr = [equipList componentsJoinedByString:@", "];
    
    NSMutableArray *mem_price = [[NSMutableArray alloc] init];
    NSMutableArray *mem_price_tax = [[NSMutableArray alloc] init];
    NSMutableArray *norm_price = [[NSMutableArray alloc] init];
    NSMutableArray *norm_price_tax = [[NSMutableArray alloc] init];
    
    NSArray *priceList = data[@"brkdwn"];
    
    for(NSDictionary *priceDict in priceList)
    {
        [mem_price addObject:priceDict[MEMBER_PRICE]];
        [mem_price_tax addObject:[NSString stringWithFormat:@"税込%@", priceDict[MEM_PRICE_TAX]]];
        [norm_price addObject:priceDict[LISTED_PRICE]];
        [norm_price_tax addObject:[NSString stringWithFormat:@"税込%@", priceDict[LISTED_PRICE_TAX]]];
    }
#if 1
    PriceCellHeight = PRICE_HEIGHT;
    PriceDetailHeight = PRICE_DETAIL_HEIGHT;
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"priceCell"];
    
    if(priceList.count <= 2) //normal size, reset the height of detail label
    {
        if([[cell viewWithTag:3] isKindOfClass:[UILabel class]]) //avoid error
        {
            UILabel *label = (UILabel*)[cell viewWithTag:3];
            CGRect rect = label.frame;
            rect.size.height = PRICE_DETAIL_HEIGHT;
        }
    }
    else //more than 2 nights
    {
        NSString *str = [self MakePriceDetail:mem_price price_tax:mem_price_tax];

        if([[cell viewWithTag:3] isKindOfClass:[UILabel class]]) //avoid error
        {
            UILabel *label = (UILabel*)[cell viewWithTag:3];
            UIFont *font = label.font;
            CGFloat cellWidth = label.frame.size.width;
            
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font}];
            CGRect rect = [attr boundingRectWithSize:(CGSize){cellWidth, CGFLOAT_MAX}                                             options:NSStringDrawingUsesLineFragmentOrigin                                            context:nil];
            if(rect.size.height > PRICE_DETAIL_HEIGHT)
            {
                //change the size of price cell
                PriceDetailHeight = rect.size.height+1;
                PriceCellHeight = PRICE_HEIGHT + rect.size.height - PRICE_DETAIL_HEIGHT;
#if 0
                CGRect frame = label.frame;
                frame.size.height = rect.size.height+1;
                label.frame = frame;
#endif
            }
            else //fittable in original size
            {
                PriceCellHeight = PRICE_HEIGHT;
                PriceDetailHeight = PRICE_DETAIL_HEIGHT;
#if 0
                CGRect frame = label.frame;
                frame.size.height = PRICE_DETAIL_HEIGHT+1;
                label.frame = frame;
#endif
            }
        }
        
        
    }
#endif
    
    loadedData[ROOM_NAME] = _inputDict[ROOM_NAME];
    loadedData[NUM_PEOPLE] = _searchDict[NUM_PEOPLE];
    
    //added to show the default image if there is no image URL
    NSString* url = data[IMAGE_URL];
    if([url isEqualToString:@""]) //empty URL
    {
        url = DEFAULT_IMAGE;
    }
    url = [ url stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([url isEqualToString:@""]) //empty URL
    {
        url = DEFAULT_IMAGE;
    }
    
    items =@[
             @{@"cellName":@"smallCell",@"type":@"title1",@"title":_inputDict[ROOM_NAME],@"icon":smokingIcon},
             @{@"cellName":@"Pict"/*@"Custom"*/,@"type":@"image",@"images":url/*data[IMAGE_URL]*/},
             //only check-in cell is NSMutableDictionary, others are NSDictionary
             [@{@"cellName":@"Checkin",@"type":@"checkin",@"date":[Constant convertToLocalDate: _searchDict[CHECKIN_DATE]],@"nights":[NSNumber numberWithInt:[_searchDict[NUM_NIGHTS]intValue]], @"maxstay":[NSNumber numberWithInt:[data[@"maxStay"]intValue]], @"border":@[@"top", @"left", @"right"]} mutableCopy],
             @{@"cellName":@"Checkout",@"type":@"checkout",@"date":[Constant calCheckoutDate:_searchDict[CHECKIN_DATE] nights:[_searchDict[NUM_NIGHTS]intValue]], @"border":@[@"bottom", @"left", @"right"]},
#if 1
             @{@"cellName":@"space",@"type":@"space"},
#endif
             @{@"cellName":@"bigCell"/*@"smallCell"*/,@"type":@"title2",@"title":_inputDict[/*ROOM_NAME*/PLAN_NAME],@"icon":smokingIcon2,@"num_people":[NSNumber numberWithInt:[_inputDict[MAX_PEOPLE]intValue]], @"border":@[@"top", @"left", @"right"]},
          @{@"cellName":@"priceCell",@"type":@"price_mem",@"total":data[@"ttlMmbrPrc"],@"total_tax":[NSString stringWithFormat:@"税込%@", data[@"ttlMmbrPrcIncldngTax"]],@"prices":mem_price,@"prices_tax":mem_price_tax, @"border":@[@"left", @"right"]},
         @{@"cellName":@"priceCell",@"type":@"price_norm",@"total":data[@"ttlListPrc"],@"total_tax":[NSString stringWithFormat:@"税込%@", data[@"ttlListPrcIncldngTax"]],@"prices":norm_price,@"prices_tax":norm_price_tax, @"border":@[@"bottom", @"left", @"right"]},
#if 1
             @{@"cellName":@"space",@"type":@"space"},
#endif
             @{@"cellName":@"regularCell",@"type":@"equip",@"title1":@"設備・アメニティ",@"title2":equipStr},
             @{@"cellName":@"smallCell2",@"type":@"rule",@"title1":@"宿泊約款・利用規約", /*@"title2":data[@"trmsCndtns"]*/},
             @{@"cellName":@"smallCell2",@"type":@"policy",@"title1":@"キャンセルポリシー",/*@"title2":cancelPolicy*/},
             ];
    
    //initialize the image data
    [self MakeRoomImages:url/*data[IMAGE_URL]*/];
    //To get the max hotel image height
    [self checkMaxImageHeight:roomimages];
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

- (IBAction)OKButtonPressed:(id)sender {
#if 1
    //Merge the option available flags into roomDict
    NSArray *options = @[VOD_AVAIL, ECO_AVAIL, BP_AVAIL, BEDSHARE_AVAIL];
    
    for(NSString *str in options)
    {
        loadedData[str] = _inputDict[str]; //copy the data from room list into room detail
    }
#endif
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.reservData != nil)
    {
        appDelegate.reservData[HOTEL_CODE] = _searchDict[HOTEL_CODE];
        appDelegate.reservData[ROOM_TYPE] = _searchDict[ROOM_TYPE];
        appDelegate.reservData[NUM_NIGHTS] = _searchDict[NUM_NIGHTS]; //bug fix
        appDelegate.reservData[PLAN_CODE] = _inputDict[PLAN_CODE];
        appDelegate.reservData[PLAN_NAME] = _inputDict[PLAN_NAME];
        appDelegate.htlName = _htlName;
        appDelegate.roomDict = loadedData;
    }
    else
    {
        //NSLog(@"searchDict: %@",_searchDict);
        //NSLog(@"no reservation data, error");
        appDelegate.reservData = [_searchDict mutableCopy];
        appDelegate.reservData[PLAN_CODE] = _inputDict[PLAN_CODE];
        appDelegate.reservData[PLAN_NAME] = _inputDict[PLAN_NAME];
        appDelegate.htlName = _htlName;
        appDelegate.roomDict = loadedData;
    }
    
    if([ud stringForKey:PERSON_UID]) //already logged in
    {
        reservInput *next = [self.storyboard instantiateViewControllerWithIdentifier:@"reservInput"];
        next.inputDict = appDelegate.reservData;
        next.roomDict = loadedData;
        next.htlName = _htlName;
        [self presentViewController:next animated:YES completion:^ {
        }];
    }
    else //jump to login view
    {
        UIViewController *next=[self.storyboard instantiateViewControllerWithIdentifier:@"loginChoices2"/*@"loginView"*/];
        [self presentViewController:next animated:YES completion:^ {
            
        }];
    }
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)MakeRoomImages:(NSString*)images
{
    [roomimages removeAllObjects];
    NSArray *imagelist = [images componentsSeparatedByString:@","];
    
    for(NSString *str in imagelist)
    {
        NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
        if(urlData)
        {
            UIImage *tmpImg = [UIImage imageWithData:urlData];
            [roomimages addObject:tmpImg];
        }
    }
}

- (IBAction)NightsChanged:(id)sender {
    UIStepper *stepper = (UIStepper*)sender;
    
    for(id item in items)
    {
        NSDictionary *dict = (NSDictionary*)item;
        //only Checkin cell has stepper
        if([dict[@"cellName"] isEqualToString:@"Checkin"])
        {
            NSMutableDictionary *tmpdict = (NSMutableDictionary*)item;
            tmpdict[@"nights"] = [NSNumber numberWithInt:(int)stepper.value];
            break;
        }
    }
    
    _searchDict[NUM_NIGHTS] = [NSString stringWithFormat:@"%d",(int)stepper.value];
    
    UIView *view = [stepper.superview viewWithTag:3]; //get the the label from superview
    if([view isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel*)view;
        label.text = [NSString stringWithFormat:@"%d泊",(int)stepper.value];
    }
    
    //change the checkout date and search the prices once again
    self.delegate = self;
    [self addRequestFields:_searchDict];
    [self setApiName:@"search_room_type_details_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = items[indexPath.row];
    NSString *CellIdentifier = dict[@"cellName"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    [self MakeCell:cell dict:dict];
#if 1
    [cell setNeedsDisplay];
    [cell setNeedsLayout];
    [cell layoutSubviews];
#endif
    return cell;
}

//make each cells
-(void)MakeCell:(UITableViewCell*)cell dict:(NSDictionary*)dict
{
    NSArray *detailCells = @[@"equip", @"rule", @"policy"];
#if 0
    NSArray *borders = dict[@"border"];
    NSArray *borderKey = @[@"top", @"bottom", @"left", @"right"];
    UILabel *bgLabel = (UILabel*)[cell.contentView viewWithTag:BGLABEL_TAG];
    if(borders) //borders are set
    {
        //UILabel *bgLabel = (UILabel*)[cell.contentView viewWithTag:BGLABEL_TAG];
        if(bgLabel == nil)
        {
            CGRect r = cell.contentView.frame;
            r.origin.x = DEFAULT_MARGIN;
            r.size.width = CELL_WIDTH-DEFAULT_MARGIN*2;
            bgLabel = [[UILabel alloc] initWithFrame:r];
            bgLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            bgLabel.tag = BGLABEL_TAG; //temporary number
            [cell.contentView addSubview:bgLabel];
            [cell.contentView sendSubviewToBack:bgLabel];
        }
        
        for(NSString *str in borderKey)
        {
            if([borders containsObject:str]) //border to create
            {
                NSLog(@"to add border %@", str);
                CALayer *layer = [CALayer layer];
                if([str isEqualToString:@"top"])
                {
                    layer.frame = CGRectMake(0, 0, bgLabel.frame.size.width, BORDER_WIDTH);
                }
                else if([str isEqualToString:@"bottom"])
                {
                    layer.frame = CGRectMake(0, bgLabel.frame.size.height - BORDER_WIDTH, bgLabel.frame.size.width, BORDER_WIDTH);
                }
                else if([str isEqualToString:@"left"])
                {
                    layer.frame = CGRectMake(0, 0, BORDER_WIDTH, bgLabel.frame.size.height);
                }
                else if([str isEqualToString:@"right"])
                {
                    layer.frame = CGRectMake(bgLabel.frame.size.width - BORDER_WIDTH, 0, BORDER_WIDTH, bgLabel.frame.size.height);
                }
                layer.backgroundColor = [UIColor darkGrayColor].CGColor;
                [bgLabel.layer addSublayer:layer];
            }
            else //border to remove
            {
                NSLog(@"to remove border %@", str);
                for (CALayer *layer in bgLabel.layer.sublayers)
                {
                    if([layer.name isEqualToString:str])
                    {
                        [layer removeFromSuperlayer];
                    }
                }
            }
        }
    }
    else //not set -- to reset
    {
        //UILabel *bgLabel = (UILabel*)[cell.contentView viewWithTag:BGLABEL_TAG];
        if(bgLabel != nil)
        {
            for(CALayer *layer in bgLabel.layer.sublayers)
            {
                if([borderKey containsObject:layer.name]) //extra custom layer
                {
                    [layer removeFromSuperlayer];
                }
            }
        }
        //else -- do nothing
    }
#endif
    
    NSString *type = dict[@"type"];
    
    if([detailCells containsObject:type])
    {
        if(dict[@"title2"])
        {
            NSString *title2 = dict[@"title2"];
            if(title2.length > 0)
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            if([type isEqualToString:@"rule"] ||
               [type isEqualToString:@"policy"])
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if([type isEqualToString:@"checkin"])
    {
        //NSLog(@"dict: %@", dict);
        UIView *view = [cell viewWithTag:1];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            label.text = @"チェックイン";
        }
        view = [cell viewWithTag:2];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            label.text = dict[@"date"];
        }
        view = [cell viewWithTag:3];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            label.text = [NSString stringWithFormat:@"%d泊",[dict[@"nights"]intValue]];
        }
        view = [cell viewWithTag:4];
        if([view isKindOfClass:[UIStepper class]])
        {
            UIStepper *stepper = (UIStepper*)view;
            stepper.value = (double)[dict[@"nights"]intValue];
            stepper.maximumValue = (double)[dict[@"maxstay"]intValue];
            NSLog(@"stepper: value=%f, max=%f", stepper.value, stepper.maximumValue);
        }
    }
    else if([type isEqualToString:@"checkout"])
    {
        UIView *view = [cell viewWithTag:1];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            label.text = @"チェックアウト";
        }
        view = [cell viewWithTag:2];
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            label.text = dict[@"date"];
        }
    }
    else if([type isEqualToString:@"image"])
    {
        [self MakeImageCell:cell];
    }
    else if([type isEqualToString:@"title1"])
    {
        [self MakeTitle1Cell:cell title:dict[@"title"] icon:[UIImage imageNamed:dict[@"icon"]]];
    }
    else if([type isEqualToString:@"title2"])
    {
        [self MakeTitle2Cell:cell title:dict[@"title"] icon:[UIImage imageNamed:dict[@"icon"]] people:[dict[@"num_people"]intValue]];
    }
    else if([type isEqualToString:@"price_mem"])
    {
        [self MakePriceCell:cell member:YES dict:dict];
    }
    else if([type isEqualToString:@"price_norm"])
    {
        [self MakePriceCell:cell member:NO dict:dict];
    }
    else if([type isEqualToString:@"equip"])
    {
        [self AddFormattedStringToCell:cell str1:dict[@"title1"] str2:dict[@"title2"]];
    }
    else if([type isEqualToString:@"rule"])
    {
        [self AddFormattedStringToCell:cell str1:dict[@"title1"] str2:nil];
    }
    else if([type isEqualToString:@"policy"])
    {
        [self AddFormattedStringToCell:cell str1:dict[@"title1"] str2:dict[@"title2"]];
    }
#if 1
    NSArray *borders = dict[@"border"];
    NSArray *borderKey = @[@"top", @"bottom", @"left", @"right"];
    UILabel *bgLabel = (UILabel*)[cell.contentView viewWithTag:BGLABEL_TAG];
    if(borders) //borders are set
    {
        //UILabel *bgLabel = (UILabel*)[cell.contentView viewWithTag:BGLABEL_TAG];
        if(bgLabel == nil)
        {
            CGRect r = cell.contentView.frame;
            r.origin.x = DEFAULT_MARGIN;
            r.size.width = CELL_WIDTH-DEFAULT_MARGIN*2;
            
            if([type isEqualToString:@"price_mem"] ||
               [type isEqualToString:@"price_norm"])
            {
                r.size.height = PriceCellHeight;
            }
            
            bgLabel = [[UILabel alloc] initWithFrame:r];
            bgLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            bgLabel.tag = BGLABEL_TAG; //temporary number
            [cell.contentView addSubview:bgLabel];
            [cell.contentView sendSubviewToBack:bgLabel];
        }
        
        for(NSString *str in borderKey)
        {
            if([borders containsObject:str]) //border to create
            {
                NSLog(@"to add border %@", str);
                CALayer *layer = [CALayer layer];
                
                if([str isEqualToString:@"top"])
                {
                    layer.frame = CGRectMake(0, 0, bgLabel.frame.size.width, BORDER_WIDTH);
                }
                else if([str isEqualToString:@"bottom"])
                {
                    layer.frame = CGRectMake(0, bgLabel.frame.size.height - BORDER_WIDTH, bgLabel.frame.size.width, BORDER_WIDTH);
                }
                else if([str isEqualToString:@"left"])
                {
                    layer.frame = CGRectMake(0, 0, BORDER_WIDTH, bgLabel.frame.size.height);
                }
                else if([str isEqualToString:@"right"])
                {
                    layer.frame = CGRectMake(bgLabel.frame.size.width - BORDER_WIDTH, 0, BORDER_WIDTH, bgLabel.frame.size.height);
                }
                layer.name = str;
                layer.backgroundColor = [UIColor darkGrayColor].CGColor;
                [bgLabel.layer addSublayer:layer];
            }
            else //border to remove
            {
                NSLog(@"to remove border %@", str);
                NSMutableArray *tmpArray = [NSMutableArray array];
                for (CALayer *layer in bgLabel.layer.sublayers)
                {
                    if([layer.name isEqualToString:str])
                    {
                        //[layer removeFromSuperlayer];
                        [tmpArray addObject:layer];
                    }
                }
                for(CALayer *layer in tmpArray)
                {
                    [layer removeFromSuperlayer];
                }
                [tmpArray removeAllObjects];
            }
        }
    }
    else //not set -- to reset
    {
        //UILabel *bgLabel = (UILabel*)[cell.contentView viewWithTag:BGLABEL_TAG];
        if(bgLabel != nil)
        {
            NSMutableArray *tmpArray = [NSMutableArray array];
            for(CALayer *layer in bgLabel.layer.sublayers)
            {
                if([borderKey containsObject:layer.name]) //extra custom layer
                {
                    //[layer removeFromSuperlayer];
                    [tmpArray addObject:layer];
                }
            }
            for(CALayer *layer in tmpArray)
            {
                [layer removeFromSuperlayer];
            }
            [tmpArray removeAllObjects];
        }
        //else -- do nothing
    }
#endif
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = items[indexPath.row];
    NSArray *borders = dict[@"border"];
    
    if(borders == nil)
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
    
    if([borders containsObject:@"left"])
    {
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            UIEdgeInsets inset = cell.separatorInset;
            inset.left = DEFAULT_MARGIN + BORDER_WIDTH;
            [cell setSeparatorInset:inset];
        }
    }
    
    if([borders containsObject:@"right"])
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            UIEdgeInsets inset = cell.separatorInset;
            inset.right = DEFAULT_MARGIN + BORDER_WIDTH;
            [cell setSeparatorInset:inset];
        }
    }
    
    //for bottom border, to hide the separator
    if([borders containsObject:@"bottom"])
    {
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            //NSLog(@"cell width: %f", cell.bounds.size.width);
            [cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0)];
        }
    }
    
    //check the next cell for "top" border
    if(indexPath.row + 1 < items.count) //not the last cell
    {
        dict = items[indexPath.row+1];
        NSArray *borders = dict[@"border"];
        if (borders)
        {   //if next cell has at least one border
            if([borders containsObject:@"top"])
            {
                //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
                if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                    //NSLog(@"cell width: %f", cell.bounds.size.width);
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, CGRectGetWidth(cell.bounds)/2.0, 0, CGRectGetWidth(cell.bounds)/2.0)];
                }
            }
        }
    }
}

//#define IMGV_TAG 10

-(void)MakeTitle1Cell:(UITableViewCell*)cell title:(NSString*)title icon:(UIImage*)icon
{
#if 0
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
#endif
#if 0
    cell.imageView.image = nil;
#else
    cell.imageView.image = icon;
    cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [cell.imageView setContentMode: UIViewContentModeCenter ];
#endif
    cell.backgroundColor = [Constant AppDarkBlueColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18.0f];
    CGRect r = [title boundingRectWithSize:cell.contentView.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.textLabel.font} context:nil];
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y,
                                      r.size.width, r.size.height);
#if 0
    //UIImageView *imgv;
    if(imgv)
    {
        //imgv = (UIImageView*)[cell viewWithTag:IMGV_TAG];
        imgv.image = icon;
    }
    else
    {
        imgv = [[UIImageView alloc] initWithImage:icon];
    }
    
    imgv.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [imgv setContentMode: UIViewContentModeCenter ];
#if 0
    [cell.textLabel sizeToFit];
#endif
    
    imgv.frame = CGRectMake(cell/*.contentView*/.frame.size.width - icon.size.width/2 - IMAGE_MARGIN,
                            (cell/*.contentView*/.frame.size.height - icon.size.height/2)/2,
                            icon.size.width/2, icon.size.height/2);
#if 1
    [cell addSubview:imgv];
#else
    [cell.contentView addSubview:imgv];
#endif
#endif
}

#define LABEL_HEIGHT 18.0

-(void)MakeTitle2Cell:(UITableViewCell*)cell title:(NSString*)title icon:(UIImage*)icon people:(NSInteger)people
{
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
#if 1
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.5;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
#endif
    
    cell.imageView.image = icon;
    cell.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [cell.imageView setContentMode: UIViewContentModeCenter];
    
    //Add the capacity icons
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    //paragraph.lineHeightMultiple = 1.2f;
#endif
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12.0f];
    NSDictionary *dict = @{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph/*, NSBackgroundColorAttributeName:[UIColor lightGrayColor]*/};
    
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:@" 定員 " attributes:dict];
    
    CGSize textSize = [s1 size];
    
    UIImage *person = [UIImage imageNamed:@"定員アイコン"];
    CGSize peopleSize = CGSizeMake((person.size.width/2)*people+2*IMAGE_MARGIN, fmax(person.size.height/2, LABEL_HEIGHT/*textSize.height*/));
    
    CGFloat x, y;
    x = CELL_WIDTH/*cell.contentView.frame.size.width*/ - textSize.width - peopleSize.width - DEFAULT_MARGIN*2 - BORDER_WIDTH;
    y = (cell.contentView.frame.size.height - LABEL_HEIGHT/*textSize.height*/)/2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, textSize.width, LABEL_HEIGHT/*textSize.height*/)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.attributedText = s1;
    label.tag = 1;
    [cell.contentView addSubview:label];
    
    x += textSize.width;
    y = (cell.contentView.frame.size.height - peopleSize.height)/2;
    
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, peopleSize.width, peopleSize.height)];
    bgLabel.backgroundColor=[UIColor grayColor];
    bgLabel.tag = 2;
    [cell.contentView addSubview:bgLabel];
    
    //add code to adjust y position
    y = (cell.contentView.frame.size.height - person.size.height/2)/2;
    
    for(int i=0;i < people; i++)
    {
        UIImageView *imgv;
#if 0
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGE_MARGIN+i*(person.size.width/2+1), 0, person.size.width/2, person.size.height/2)];
#else
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(x+IMAGE_MARGIN+i*(person.size.width/2/*+1*/), y, person.size.width/2, person.size.height/2)];
#endif
        [imgv setContentMode: UIViewContentModeScaleAspectFit ];
        
        imgv.image = person;
        imgv.backgroundColor = [UIColor grayColor];
#if 0
        [bgLabel addSubview:imgv];
#else
        [cell.contentView addSubview:imgv];
#endif
        //bring the person icon to fron
        [bgLabel bringSubviewToFront:imgv];
    }
}

-(NSString*)MakePriceDetail:(NSArray*)prices price_tax:(NSArray*)prices_tax
{
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    
    for(int i=0;i<prices.count;i++)
    {
        NSString *tmp = [NSString stringWithFormat:@" %d泊目　%@　(%@)", i+1, prices[i], prices_tax[i]];
        [str appendString:tmp];
        
        if(i!=prices.count-1) //not the last item
        {
            [str appendString:@"\n"];
        }
    }
    return str;
}

-(void)MakePriceCell:(UITableViewCell*)cell member:(BOOL)member dict:(NSDictionary*)dict
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 1
    paragraph.lineHeightMultiple = 1.1f;
    //paragraph.headIndent = 10.0f;
    //paragraph.firstLineHeadIndent = 10.0f;
#endif
    
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13.0f];
    NSMutableDictionary *attr =[@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: paragraph} mutableCopy];
    
    NSMutableAttributedString *s1;
    
    NSString *tmp;
    if(member)
    {
        attr[NSBackgroundColorAttributeName] = [Constant AppRedColor];
        tmp = @" 会員 ";
    }
    else
    {
        attr[NSBackgroundColorAttributeName] = [Constant AppDarkBlueColor]/*[UIColor grayColor]*/;
        tmp = @" 一般 ";
    }
    
    s1=[[NSMutableAttributedString alloc] initWithString:tmp attributes:attr];
    attr[NSFontAttributeName] = [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0f];
    attr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [attr removeObjectForKey:NSBackgroundColorAttributeName] ;

    NSAttributedString *s2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",dict[@"total"], dict[@"total_tax"]] attributes:attr];
    
    [s1 appendAttributedString:s2];
    
    if([[cell viewWithTag:1] isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        label.attributedText = s1;
    }
    
    NSArray *prices = dict[@"prices"];
    NSArray *prices_tax = dict[@"prices_tax"];
#if 0
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    
    for(int i=0;i<prices.count;i++)
    {
        NSString *tmp = [NSString stringWithFormat:@"%d泊目　%@　(%@)", i+1, prices[i], prices_tax[i]];
        [str appendString:tmp];
        
        if(i!=prices.count-1) //not the last item
        {
            [str appendString:@"\n"];
        }
    }
#else
    NSString *str = [self MakePriceDetail:prices price_tax:prices_tax];
#endif
    
    if([[cell viewWithTag:3] isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel*)[cell viewWithTag:3];
        label.text = str;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        //to adjust the height of label
        if(PriceDetailHeight > PRICE_DETAIL_HEIGHT)
        {
            CGRect frame = label.frame;
            frame.size.height = PriceDetailHeight;
            label.frame = frame;
        }
    }
}

-(void)AddFormattedStringToCell:(UITableViewCell*)cell str1:(NSString*)str1 str2:(NSString*)str2
{
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing += 7.0f;
#if 0
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0f];
#else
    UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14.0f];
#endif

#if 0
    UIColor *fgColor = [UIColor grayColor];
#else
    UIColor *fgColor = [UIColor blackColor];
#endif
    NSMutableAttributedString *s1=[[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName:font,
        NSForegroundColorAttributeName:fgColor,
        NSParagraphStyleAttributeName: paragraph}];
    
    //NSAttributedString *linebreak=[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName: paragraph}];
    
    //[s1 appendAttributedString:linebreak];
#if 0
    //one-line only cell
    if(str2 != nil)
    {
        //paragraph.lineHeightMultiple = 1.2f;
#if 0
        fgColor = [UIColor blackColor];
#else
        fgColor = [UIColor grayColor];
#endif
        font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
        NSAttributedString *s2=[[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:fgColor, /*NSBackgroundColorAttributeName:[UIColor grayColor],*/ NSParagraphStyleAttributeName: paragraph,/* NSBaselineOffsetAttributeName: [NSNumber numberWithFloat: 4.0]*/}];
    
        [s1 appendAttributedString: s2]; //combine the 2 strings
    }
#endif
#if 0
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:12.0f];
    NSMutableAttributedString *s0=[[NSMutableAttributedString alloc] initWithString:@"I " attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[Constant textHeaderColor], NSParagraphStyleAttributeName: paragraph}];
#else
    font = [UIFont fontWithName:@"HiraKakuProN-W6" size:14.0f];
    NSMutableAttributedString *s0=[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font, NSBackgroundColorAttributeName:[Constant textHeaderColor], NSParagraphStyleAttributeName: paragraph}];
    NSAttributedString *s0_1 = [[NSAttributedString alloc] initWithString:@" "  attributes:@{NSFontAttributeName:font}];
    [s0 appendAttributedString:s0_1];
#endif
#if 0
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setAttributedText:s0];
#else
    [s0 appendAttributedString:s1]; //add blue "I" in the beginning according to the design sample
    cell.textLabel.attributedText = s0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 1;
    [cell.textLabel sizeToFit];
#if 0
    if(str2!=nil)
    {
        font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
        UIColor *color = cell.detailTextLabel.textColor;
        NSAttributedString *s2=[[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color, NSBackgroundColorAttributeName:[UIColor clearColor], NSParagraphStyleAttributeName: paragraph,/* NSBaselineOffsetAttributeName: [NSNumber numberWithFloat: 4.0]*/}];
        cell.detailTextLabel.attributedText = s2;
        //[cell.detailTextLabel sizeToFit];
    }
#else
    if(str2!=nil)
        cell.detailTextLabel.text = str2;
#endif
    else
        cell.detailTextLabel.text = @"";
    
    //cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.numberOfLines = 1;
    
#endif
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = items[indexPath.row];
    NSString *CellIdentifier = dict[@"cellName"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    CGFloat height = cell.bounds.size.height;
    
    if([dict[@"type"] isEqualToString:@"image"])
    {
        return IMAGE_CELL_HEIGHT/*MaxImageHeight + PAGECONTROL_HEIGHT*/;
    }
    else if(([dict[@"type"] isEqualToString:@"price_mem"]) || ([dict[@"type"] isEqualToString:@"price_norm"])) //price cell's height
    {
        return PriceCellHeight;
    }
    else if([CellIdentifier isEqualToString:@"space"])
    {
        return 12.0f;
    }
    //get the height of each customized cell
    return round(height);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //show the detail in another view
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
    {

        NSDictionary *dict = items[indexPath.row];
        NSString *type = dict[@"type"];
        //NSString *cellName = dict[@"cellName"];
        
        if([type isEqualToString:@"rule"]) //special item, use web view to open
        {
            //NSString *url = dict[@"title2"];
            
            ViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
            next.URL = @"http://webapi.toyoko-inn.com/smart_phone/disp_agreement";/*url*/;
            [self presentViewController:next animated:YES completion:^ {
                
            }];
        }
        else
        {
            //NSString *str;
            //NSArray *arr;
            NSString *title;
            NSString *content;

            title = cell.textLabel.attributedText.string;
            if(![type isEqualToString:@"policy"])
            {
                content = cell.detailTextLabel.attributedText.string;
            }else
            {
                content = cancelPolicy;
            }
#if 0
            NSMutableArray *contentArray = [arr mutableCopy];
            [contentArray removeObjectAtIndex:0]; //remove the first obj
            content = [contentArray componentsJoinedByString:@"\n"];
#endif
            TextView *next = [self.storyboard instantiateViewControllerWithIdentifier:@"TextView"];
            
            next.viewTitle = title;
            next.text = content;
            
            [self presentViewController:next animated:YES completion:^ {
            }];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

-(void)MakeImageCell:(UITableViewCell*)cell
{
#if 1
    PictCell *pict = (PictCell*)cell;
    [pict setImages:roomimages];
#else
    [cell.textLabel setText:@""];
    //setup the page control
    if(!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MaxImageHeight,
                                                                       cell.contentView.frame.size.width, PAGECONTROL_HEIGHT)];
        
        [_pageControl setNumberOfPages:roomimages.count];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor yellowColor]];
    }
    
    [cell.contentView addSubview:_pageControl];
    [_pageControl addTarget:self action:@selector(PageValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //setup the image view
    if(!_roomImageView)
    {
        if(roomimages.count > 0)
            _roomImageView = [[UIImageView alloc] initWithImage:[roomimages objectAtIndex:0]];
        else
            _roomImageView = [[UIImageView alloc] init];
    }
    
    CGRect r;
    
    //setup the hotel image view
    r.origin.x = IMAGE_MARGIN;
    r.origin.y = 0;
    r.size.width = cell.contentView.frame.size.width - IMAGE_MARGIN*2;
    r.size.height = MaxImageHeight;
    [_roomImageView setContentMode: UIViewContentModeScaleAspectFit ];
    [_roomImageView setFrame:r];
    [cell.contentView addSubview:_roomImageView];
    
    //setup the previous button
    r.size.width = [UIImage imageNamed:@"前"].size.width/2;
    r.size.height = [UIImage imageNamed:@"前"].size.height/2;
    r.origin.x = IMAGE_MARGIN;
    r.origin.y = MaxImageHeight/2 - r.size.height/2;
    
    if(!_prevButton)
        _prevButton = [[UIButton alloc] initWithFrame:r];
    
    [_prevButton setImage:[UIImage imageNamed:@"前"] forState:UIControlStateNormal];
    [cell.contentView addSubview:_prevButton];
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
    r.size.width = [UIImage imageNamed:@"次"].size.width/2;
    r.size.height = [UIImage imageNamed:@"次"].size.height/2;
    r.origin.x = cell.contentView.frame.size.width - r.size.width-IMAGE_MARGIN;
    r.origin.y = r.origin.y = MaxImageHeight/2 - r.size.height/2;
    
    if(!_nextButton)
        _nextButton = [[UIButton alloc] initWithFrame:r];
    
    [_nextButton setImage:[UIImage imageNamed:@"次"] forState:UIControlStateNormal];
    [cell.contentView addSubview:_nextButton];
    [_nextButton addTarget:self action:@selector(NextPressed:) forControlEvents:UIControlEventTouchUpInside];
    if(_pageControl.currentPage==roomimages.count-1) //last image
    {
        _nextButton.enabled = NO;
    }
    else
    {
        _nextButton.enabled = YES;
    }
#endif
}

-(void)PageValueChanged:(id)sender
{
    NSLog(@"page: %ld", (long)_pageControl.currentPage);
    if (_pageControl.currentPage == 0) {
        _prevButton.enabled = NO;
    }
    else
        _prevButton.enabled = YES;
    
    if (_pageControl.currentPage == roomimages.count-1) {
        _nextButton.enabled = NO;
    }
    else
        _nextButton.enabled = YES;
    
    [_roomImageView setImage:[roomimages objectAtIndex:_pageControl.currentPage]];
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

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        loadedData = [data mutableCopy];
        //add max people
        loadedData[MAX_PEOPLE] = _inputDict[MAX_PEOPLE];
        [self PrepareTableData:data];
        [_tableView reloadData];
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
}
@end
