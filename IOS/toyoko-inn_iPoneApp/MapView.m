//
//  MapView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/05/28.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "MapView.h"
#import "landmark.h"
#import "UIImage+UISegmentIconAndText.h"
#import "HotelListView.h"

@interface MapView ()

@end

@implementation MapView
GMSMapView *mapView_;
BOOL firstLocationUpdate_;

static NSMutableArray* markers;
//static NSMutableDictionary* hotelData;
static UIImage* hotel_icon;
#define DEFAULT_ZOOM 14.0
//default distance to center point is 5000m
#define DEFAULT_DISTANCE 5000

//Default central position is Kamata station
#define DEFAULT_LAT 35.698679
#define DEFAULT_LNG 139.774176
#define MARGIN 5.0

static float currZoom = DEFAULT_ZOOM;
//static BOOL isGettingNewZoom = NO;

NSString const *hotelIconName = @"marker_htl"/*@"icon_map_hotel2"*/;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5f;
    [label setText:self.title];
    _NaviBar.topItem.titleView = label;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_centerLatt
                                                            longitude:_centerLngtd
                                                                 zoom:currZoom];

    [_ResetButton.imageView setContentMode: UIViewContentModeCenter];
    [_ConstraintButton.imageView setContentMode: UIViewContentModeCenter];
    
    //To calculate the correct position of Google Map
    CGRect r = [[UIScreen mainScreen] bounds];
    r.origin.y = _NaviBar.frame.size.height + _NaviBar.frame.origin.y;
    r.size.height -= _NaviBar.frame.size.height + _NaviBar.frame.origin.y;

    //To move the reset button to the buttom
    if(!_isSingleHotelMode)
    {
        r.size.height = _ResetButton.frame.origin.y - r.origin.y - MARGIN;
    }
#if 0
    [_ResetButton setFrame:CGRectMake(_ResetButton.frame.origin.x, [[UIScreen mainScreen] bounds].size.height-_ResetButton.frame.size.height, _ResetButton.frame.size.width, _ResetButton.frame.size.height)];
    [_ConstraintButton setFrame:CGRectMake(_ConstraintButton.frame.origin.x, [[UIScreen mainScreen] bounds].size.height-_ConstraintButton.frame.size.height, _ConstraintButton.frame.size.width, _ConstraintButton.frame.size.height)];
#endif
    mapView_ = [GMSMapView mapWithFrame:r camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.delegate = self;
#if 0
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
#endif
    [self.view addSubview:mapView_];
    
    //To reuse the markers array
    if(markers ==nil)
        markers = [[NSMutableArray alloc] init];
    else
    {
        for(GMSMarker *mk in markers)
        {
            mk.map = nil;
        }
        [markers removeAllObjects];
    }
#if 0
    //To convert the htlList to NSDict, with key hotel code
    if(hotelData == nil)
        hotelData = [[NSMutableDictionary alloc] init];
    else
        [hotelData removeAllObjects];
    
    for(NSDictionary *dict in _inputArray)
    {
        NSString *htlCode = dict[HOTEL_CODE];
        hotelData[htlCode] = dict;
    }
#endif
    //Load the hotel icon
    //CGRect r;
#if 0
    r.origin.x = 0;
    r.origin.y = 0;
    r.size = [UIImage imageNamed:(NSString*)hotelIconName].size;
    r.size.width /= 2;
    r.size.height /= 2;
    hotel_icon = [UIImage resize:[UIImage imageNamed:(NSString*)hotelIconName] rect:r];
#else
    hotel_icon = [UIImage imageNamed:(NSString*)hotelIconName];
#endif
#if 0
    //To load the address list
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* path = [bundle pathForResource:@"addr" ofType:@"plist"];
    NSArray *addrlist = [NSArray arrayWithContentsOfFile:path];
       
    
    for(NSDictionary* addr in addrlist){
        //Add markers one by one
        GMSMarker *tmpMarker = [[GMSMarker alloc] init];
        //NSLog(@"addr=%@", [addr objectForKey:@"hoteladdr"]);
        tmpMarker.title = [addr objectForKey:@"hotel_name"];
        tmpMarker.snippet = [addr objectForKey:@"addr"];

        //Convert lat/lng to double and fit into coordinate
        tmpMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[[addr valueForKey:@"lat"] doubleValue], (CLLocationDegrees)[[addr valueForKey:@"lng"] doubleValue]);
        
        tmpMarker.flat = NO;
        tmpMarker.icon = hotel_icon;
        tmpMarker.map = mapView_;
        tmpMarker.userData = addr;
        [markers addObject:tmpMarker];
    }
#endif
    //Change the zoom to 5000m scope
    CGFloat dist = [mapView_.projection pointsForMeters:DEFAULT_DISTANCE atCoordinate:CLLocationCoordinate2DMake(_centerLatt, _centerLngtd)];
    NSLog(@"%f points for %d meters in current zoom", dist, DEFAULT_DISTANCE);
  
    //Adjust the image of reset button
    [_ResetButton.imageView setContentMode: UIViewContentModeCenter ];
    _ResetButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _ResetButton.clipsToBounds = YES;
    _ResetButton.layer.cornerRadius = 10;
    
    [_ConstraintButton.imageView setContentMode: UIViewContentModeCenter];
    _ConstraintButton.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    _ConstraintButton.clipsToBounds = YES;
    _ConstraintButton.layer.cornerRadius = 10;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    //prepare data for query
    self.delegate = self;
    
    //end of single hotel mode
    if(_isSingleHotelMode)
    {
        GMSMarker *tmpMarker = [[GMSMarker alloc] init];
        //NSLog(@"addr=%@", [addr objectForKey:@"hoteladdr"]);
        NSDictionary *dict = _inputArray[0];
        tmpMarker.title = dict[HOTEL_NAME];
        tmpMarker.snippet = dict[HOTEL_NAME];
        
        //Convert lat/lng to double and fit into coordinate
        tmpMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)_centerLatt, (CLLocationDegrees)_centerLngtd);
        
        tmpMarker.flat = NO;
        tmpMarker.icon = hotel_icon;
        tmpMarker.map = mapView_;
        tmpMarker.userData = dict;
        [markers addObject:tmpMarker];
        
        [mapView_ animateToLocation:CLLocationCoordinate2DMake(_centerLatt,_centerLngtd)];
        [mapView_ animateToZoom:currZoom]; //zoom to default value
        
        //_ConstraintButton.enabled = NO;
        _ConstraintButton.hidden = YES;
        _ResetButton.hidden = YES;
        _BackButton.title = @"戻る";
        _ListButton.title = @"";
        _ListButton.enabled = NO;
        [mapView_ animateToZoom:DEFAULT_ZOOM];
        return;
    }
    else
    {
        _ConstraintButton.hidden = NO;
        _ResetButton.hidden = NO;
        //_ConstraintButton.enabled = YES;
        _BackButton.title = @"ホーム";
        _ListButton.title = @"リスト";
        _ListButton.enabled = YES;
    }
#if 0
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    dict[MEMBER_FLAG] = @"Y"; //dummy
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyyMMdd"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    dict[CHECKIN_DATE] = date_String/*@"20140901"*/;
    dict[NUM_NIGHTS] = @"1"; //dummy
    dict[NUM_PEOPLE] = @"1"; //dummy
    dict[NUM_ROOMS] = @"1"; //dummy
#endif
#if 0
    [self addRequestFields:_searchDict];
    [self setApiName:@"search_hotel_coordinate_api"];
    [self setSecure:NO];
    
    [self sendRequest];
#else
    GMSCoordinateBounds *bounds= [[GMSCoordinateBounds alloc] init];
    for(NSDictionary *dict in _inputArray)
    {
        if([dict[LATITUDE] doubleValue] == 0.0f &&
           [dict[LONGITUDE] doubleValue] == 0.0f)
        {
            continue;
        }
        
        GMSMarker *tmpMarker = [[GMSMarker alloc] init];
        tmpMarker.title = dict[HOTEL_NAME];
        tmpMarker.snippet = dict[HOTEL_NAME];
        
        //Convert lat/lng to double and fit into coordinate
        tmpMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[dict [LATITUDE] doubleValue], (CLLocationDegrees)[dict[LONGITUDE] doubleValue]);
        
        bounds = [bounds includingCoordinate: tmpMarker.position];
        
        tmpMarker.flat = NO;
        tmpMarker.icon = hotel_icon;
        tmpMarker.map = mapView_;
        tmpMarker.userData = dict;
        [markers addObject:tmpMarker];
    }
    
    if(_inputArray.count >= 1)
    {
        //isGettingNewZoom = YES;
        double delayInSeconds = 0.5; //delay 0.5 sec
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
            //isGettingNewZoom = YES;
            [mapView_ /*animateWithCameraUpdate*/moveCamera:update];
            currZoom = mapView_.camera.zoom;
            _centerLngtd = mapView_.camera.target.longitude;
            _centerLatt = mapView_.camera.target.latitude;
            NSLog(@"currZoom=%f", currZoom);
            if(_inputArray.count > 1)
                [mapView_ animateToZoom:currZoom];
            else
                [mapView_ animateToZoom:DEFAULT_ZOOM];
        });
    }
#endif
}

- (void)dealloc {
#if 0
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    //if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        //firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:currZoom];
    //}
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker
{
    //dummy data for display
#if 0
    NSMutableDictionary *items = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"東横INNアキバ浅草橋駅東口",@"hotel_name",
                                 @"¥6,300",@"mem_low",
                                 @"¥7,300",@"mem_high",
                                 @"¥6,800",@"norm_low",
                                 @"¥7,800",@"norm_high",
                                 @"JR総武線「浅草橋駅」東口より徒歩3分",@"access",
                                 @"現在地から1km",@"distance",
                                 @"http://toyoko-inn.com/hotel/images/h263h1.jpg",@"image",
                                 @"残り5室", @"roomsleft",
                                 nil];
#endif
    NSDictionary* dict = (NSDictionary*)marker.userData;
#if 0
    items[@"hotel_name"] = dict[@"hotel_name"];
#endif
    NSLog(@"%@ touched", dict[HOTEL_NAME]);
    landmark *view = (landmark*)[[[NSBundle mainBundle] loadNibNamed:@"landmark"
                                                      owner:self
                                                    options:nil] lastObject];
    view.isSingleHotelMode = _isSingleHotelMode;
    view.mapView = mapView;
    [view setDict:dict];
    
    return view;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)  	marker
{
    NSDictionary *dict = (NSDictionary*)marker.userData;
    NSLog(@"window tapped: %@",dict);
#if 1
    if(_isSingleHotelMode) //single mode, previous view is the hotel info
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else
    {
        HotelListView *vc =  (HotelListView*)self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            [vc MoveToHotel:dict[HOTEL_CODE]];
        }
        ];
    }
#endif
}

#if 0
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    NSLog(@"new zoom = %f, curr zoom=%f", position.zoom, mapView_.camera.zoom);
    if(isGettingNewZoom)
    {
        isGettingNewZoom = NO;
        currZoom = position.zoom;
    }
}
#endif

- (IBAction)BackPressed:(id)sender{
    //jump to the home screen
    if(!_isSingleHotelMode)
    {
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (IBAction)ListPressed:(id)sender {
    //Previous view is the hotel list view
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)ResetPressed:(id)sender {
    //go back to the current location and reset the zoom
    [mapView_ animateToLocation:CLLocationCoordinate2DMake(_centerLatt,_centerLngtd)];
    [mapView_ animateToZoom:currZoom];
}

- (IBAction)ConstraintPressed:(id)sender {
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@",data);
#if 0
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"])
    {
        //parse the data and create the landmarks
        NSArray *htlList = data[@"hotel_info"];
        
        //double aveLttd = 0.0f;
        //double aveLngtd = 0.0f;
        
        GMSCoordinateBounds *bounds= [[GMSCoordinateBounds alloc] init];
        
        for(NSDictionary *dict in htlList)
        {
            NSString *htlCode = dict[HOTEL_CODE];
#if 0
            NSLog(@"data type = %@", NSStringFromClass([hotelData[htlCode] class]));
#endif
            if(hotelData[htlCode] == nil) //data exists only in one side
                continue;
            
            //skip test hotel
            if([dict[LATITUDE] doubleValue] == 0.0f &&
               [dict[LONGITUDE] doubleValue] == 0.0f)
            {
                continue;
            }
            
            [hotelData[htlCode] addEntriesFromDictionary:dict];
            
            //add markers
            GMSMarker *tmpMarker = [[GMSMarker alloc] init];
            //NSLog(@"addr=%@", [addr objectForKey:@"hoteladdr"]);
            tmpMarker.title = dict[HOTEL_NAME];
            tmpMarker.snippet = dict[HOTEL_NAME];
            
            //Convert lat/lng to double and fit into coordinate
            tmpMarker.position = CLLocationCoordinate2DMake((CLLocationDegrees)[[dict valueForKey:LATITUDE] doubleValue], (CLLocationDegrees)[[dict valueForKey:LONGITUDE] doubleValue]);
            
            bounds = [bounds includingCoordinate: tmpMarker.position];
            
            tmpMarker.flat = NO;
            tmpMarker.icon = hotel_icon;
            tmpMarker.map = mapView_;
            tmpMarker.userData = hotelData[htlCode];
            [markers addObject:tmpMarker];
            
            //aveLttd += [dict[LATITUDE] doubleValue];
            //aveLngtd += [dict[LONGITUDE] doubleValue];
        }
#if 0
        if(_centerLatt == 0.0f && _centerLngtd == 0.0f)
        {
            aveLttd /= (double)htlList.count;
            aveLngtd /= (double)htlList.count;
            
            _centerLatt = aveLttd;
            _centerLngtd = aveLngtd;
            
            NSLog(@"ave lttd=%f, lngtd=%f",aveLttd, aveLngtd);

            mapView_.camera = [GMSCameraPosition cameraWithLatitude:aveLttd
                                                          longitude:aveLngtd
                                                               zoom:currZoom];

        }
#endif
        if(hotelData.count >= 1)
        {
            GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
            //isGettingNewZoom = YES;
            [mapView_ /*animateWithCameraUpdate*/moveCamera:update];
            //isGettingNewZoom = YES;
            
            double delayInSeconds = 0.5; //delay 0.5 sec
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                currZoom = mapView_.camera.zoom;
                _centerLngtd = mapView_.camera.target.longitude;
                _centerLatt = mapView_.camera.target.latitude;
                NSLog(@"currZoom=%f", currZoom);
            });
            
            if(hotelData.count == 1)
            {
                [mapView_ animateToZoom:currZoom];
            }
        }
        
        //currZoom = mapView_.camera.zoom;
        //NSLog(@"current zoom = %f", currZoom);
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
#endif
}

-(void)connectionFailed:(NSError*)error
{
    
}
@end
