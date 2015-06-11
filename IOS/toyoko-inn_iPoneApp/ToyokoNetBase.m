//
//  ToyokoNetBase.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoNetBase.h"

@interface ToyokoNetBase ()

@end

@implementation ToyokoNetBase
#if 1
static NSString *HTTP = @"https://";
static NSString *HTTPS = @"https://";
static NSString *baseURL= @"webapi.toyoko-inn.com/smart_phone/"/*@"testwebapi1.cloudapp.net/smart_phone/"*/;
static NSString *appVersion = @"1"/*@"1.01"*/; //To change when the app is updated
static NSString *apiKey = @"webapi.toyoko-inn.com"/*@"funtion_test1.01"*/; //To change when the official API key is decided
#else
static NSString *HTTP = @"http://";
static NSString *HTTPS = @"https://";
static NSString *baseURL= @"testwebapi1.cloudapp.net/smart_phone/";
static NSString *appVersion = @"1"; //To change when the app is updated
static NSString *apiKey = @"webapi.toyoko-inn.com"; //To change when the official API key is decided
#endif

//NSDictionary *nationMapping;

#define INDICATOR_SIZE 50


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
    
    self.reqFields = [[NSMutableDictionary alloc]init];
    [self basicFieldsReset];
    self.protocol = HTTP;
    @synchronized(self)
    {
        _isBeingUsed = NO;
    }
    
    //Add indicator
    //CGRect r = [[UIScreen mainScreen] bounds];
    _ai = [[UIActivityIndicatorView alloc] init];
    _ai.frame = CGRectMake(0, 0, INDICATOR_SIZE, INDICATOR_SIZE);
    _ai.center = self.view.center;
    _ai.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _ai.color = [UIColor darkGrayColor];
    _ai.backgroundColor = [UIColor clearColor/*blackColor*/];
    _ai.hidesWhenStopped = YES;
    [self.view addSubview:_ai];
}

//reset the fields for some views that sends data several times in one lifecyle
-(void)basicFieldsReset
{
    [self.reqFields removeAllObjects];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *dvcTkn = [ud stringForKey:@"deviceToken"];
    
    if(dvcTkn == nil) //not set, avoid null pointer
    {
        dvcTkn = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
    
    [self.reqFields setObject:apiKey forKey:@"key"];
    [self.reqFields setObject:appVersion forKey:@"applctnVrsnNmbr"];
    [self.reqFields setObject:@"I" forKey:@"osType"]; //Fixed to I in iOS implementation
    //device dependent fields, get from system call
    [self.reqFields setObject:[UIDevice currentDevice].systemVersion forKey:@"osVrsn"];
    [self.reqFields setObject:[UIDevice currentDevice].model forKey:@"mdl"];
    [self.reqFields setObject:dvcTkn forKey:@"dvcTkn"];
    [self.reqFields setObject:[[NSLocale preferredLanguages]objectAtIndex:0]/*@"ja"*/ forKey:@"lngg"];
    //NSLog(@"langs: %@", [NSLocale preferredLanguages]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addRequestFields:(NSDictionary*)fields
{
    [self basicFieldsReset];
    [self.reqFields addEntriesFromDictionary:fields];
}

#if 0
-(void)setApiName:(NSString*)api
{
    self.apiName = api;
}
#endif

-(void)sendRequest
{
    @synchronized(self)
    {
        //To prevent double touch
        if(_isBeingUsed)
        {
            return;
        }
        _isBeingUsed = YES;
#if 0
        [self.view bringSubviewToFront:ai];
        [ai startAnimating];
#endif
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",self.protocol, baseURL, self.apiName]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        
        //reset the receiver buffer
        self.response = nil;
        
        int count = 0;
        NSMutableString *tmpStr = [[NSMutableString alloc]init];
        //NSLog(@"req fields: %lu", (unsigned long)[self.reqFields count]);
        
        for(NSString *key in [self.reqFields allKeys])
        {
            //escape the original string
#if 0
            NSString *tmp = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(                                                                                                        kCFAllocatorDefault,                                                                                                        (CFStringRef)[self.reqFields objectForKey:key], // ←エンコード前の文字列(NSStringクラス)
                                                                                        NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
#else
            id t = self.reqFields[key];
            NSString *tmp;
            if([t isKindOfClass:[NSString class]])
            {
                tmp = (NSString*)t;
                tmp = [tmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else
            {
                NSLog(@"key %@: class %@", key, NSStringFromClass([t class]));
                continue;
            }
#endif
            [tmpStr appendString:[NSString stringWithFormat:@"%@=%@", key, tmp]];
            if(count < self.reqFields.count-1) //not the last one
                [tmpStr appendString:@"&"];
            
            count++;
        }
        NSLog(@"req str = %@",tmpStr);
        
        request.HTTPBody = [tmpStr dataUsingEncoding:NSUTF8StringEncoding];
#if 0
        request.timeoutInterval = 60.0;
#endif
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        _state = Connecting;
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
{
    @synchronized(self)
    {
        _state = BodySent;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @synchronized(self)
    {
        _state = DataGetting;
    }
    if(self.response == nil) //not created yet
    {
        self.response = [[NSMutableData alloc]init];
    }
    
    [self.response appendData:data];
}

#pragma mark - ToyokoNetBaseDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"reponse header=%@", response);
    @synchronized(self)
    {
        _state = HeaderGot;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    @synchronized(self)
    {
        _state = Error;
    }
    
    NSLog(@"error=%@", error);
    if([self.delegate respondsToSelector:@selector(connectionFailed:)])
    {
        [self.delegate connectionFailed:error];
    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:[error localizedDescription]
                              delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
    [alert show];

    @synchronized(self)
    {
        _isBeingUsed = NO;
#if 1
        [_ai stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#else
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#endif
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    //NSLog(@"willSendRequest called");
    @synchronized(self)
    {
        _state = Connecting;
    }
#if 1
    [self.view bringSubviewToFront:_ai];
    [_ai startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#else
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#endif
    return request;
}

-(void)cancel
{
    NSLog(@"cancel is called");
    [_connection cancel];
    _state = Done;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _isBeingUsed = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @synchronized(self)
    {
        _state = Done;
    }
    @synchronized(self)
    {
        NSString *str =[[NSString alloc] initWithData:self.response encoding:NSUTF8StringEncoding];
#if 1
        //convert "\r\n" to json "\n"
        str = [ str stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\\\\n"];
        NSLog(@"response=%@", str);
#endif
#if 1
        //added for removing html tags
        NSRange r;
        NSString *s = [str copy];
        while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        {
            s = [s stringByReplacingCharactersInRange:r withString:@""];
        }
        str = s;
#endif
        NSString *convertedStr = [NSString stringWithCString:[str cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
        
        NSLog(@"converted=%@", convertedStr);
        
        if(convertedStr == nil) //bad response, not JSON format
        {
            _isBeingUsed = NO;
#if 0
            const unsigned char *ptr = [self.response bytes];
            
            for(int i=0; i<[self.response length]; ++i) {
                unsigned char c = *ptr++;
                if(c >= 0x80)
                    NSLog(@"char=%c hex=%x", c, c);
            }
#endif
#if 0
            [ai stopAnimating];
#else
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#endif
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"エラーが発生しました。しばらく経ってから再度お試しください。"
                                      delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
            [alert show];
            return;
        }
        NSError *error = nil;
        NSDictionary *data=[NSJSONSerialization JSONObjectWithData:[convertedStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
        if(data)
        {
            self.parsedData = data;
            //the parsed data must be copied in the callback
            if([self.delegate respondsToSelector:@selector(ParsedDataReady:)])
            {
                [self.delegate ParsedDataReady:self.parsedData];
            }
        }
        else
        {
            NSLog(@"error=%@",error);
#if 0
            const unsigned char *ptr = [self.response bytes];
            
            for(int i=0; i<[self.response length]; ++i) {
                unsigned char c = *ptr++;
                NSLog(@"char=%c hex=%x", c, c);
            }
#endif
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"エラーが発生しました。しばらく経ってから再度お試しください。"
                                      delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
            [alert show];
        }
        
        //Unlock after all data is passed to caller
        _isBeingUsed = NO;
#if 1
        [_ai stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#else
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#endif
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

-(void)setSecure:(BOOL)secure
{
    if(secure)
        self.protocol = HTTPS;
    else
        self.protocol = HTTP;
}

@end
