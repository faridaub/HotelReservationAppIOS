//
//  Constant.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/20.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

//person information constants

NSString* const MEMBER_NUM = @"mmbrshpNmbr";
NSString* const FAMILY_NAME = @"fmlyName";
NSString* const GIVEN_NAME = @"frstName";
NSString* const PERSON_UID = @"rsrvsPrsnUid";
NSString* const BIRTHDATE = @"dateBirth";
NSString* const PASSWORD = @"psswrd";
NSString* const TEL_NUM = @"phnNmbr";
NSString* const PC_EMAIL = @"pcEmlAddrss";
NSString* const MB_EMAIL = @"mblEmlAddrss";
NSString* const NEWSLETTER = @"nwslttr";
NSString* const NATIONALITY = @"ntnltyCode";
NSString* const GENDER = @"sex";
NSString* const RESERV_NUM = @"rsrvtnNmbr";
NSString* const RESERV_ID = @"rsrvId";

//hotel information constants
NSString* const IMAGE_URL = @"imgURL";

//vacancy search constants
NSString* const MEMBER_FLAG = @"mmbrshpFlag";
NSString* const CHECKIN_DATE = @"chcknDate";
NSString* const CHECKOUT_DATE = @"chcktDate";
NSString* const HOTEL_CODE = @"htlCode";
NSString* const HOTEL_NAME = @"htlName";
NSString* const NUM_NIGHTS = @"nmbrNghts";
NSString* const NUM_PEOPLE = @"nmbrPpl";
NSString* const NUM_ROOMS = @"nmbrRms";
NSString* const ROOM_TYPE = @"roomType";
NSString* const ROOM_NAME = @"roomName";
NSString* const SMOKING_FLAG = @"smkngFlag";
NSString* const SINGLE_ROOM_PRICE = @"snglrmPrc";
NSString* const SINGLE_ROOM_PRICE_TAX = @"snglrmPrcIncldngTax";
NSString* const MEM_SINGLE_ROOM_PRICE = @"mmbrsnglrmPrc";
NSString* const MEM_SINGLE_ROOM_PRICE_TAX = @"mmbrSnglrmPrcIncldngTax";
NSString* const PAYMENT_PRICE = @"pymntPrc";
NSString* const PAYMENT_PRICE_TAX = @"pymntPrcIncldngTax";
NSString* const CHECKIN_TIME = @"chcknTime";
NSString* const OPTION_PRICE = @"optnPrc";
NSString* const ECO_FLAG = @"ecoFlag";
NSString* const TARGET_DATE = @"trgtDate";
NSString* const ECOPLAN_CHECKIN_SPECIFY = @"ecoChckn";
NSString* const BUSI_FLAG = @"bsnssPackFlag";
NSString* const BUSI_TYPE = @"bsnssPackType";
NSString* const SHARE_BED = @"chldrnShrngBed";
NSString* const TOTAL_PRICE = @"ttlPrc";
NSString* const TOTAL_PRICE_TAX = @"ttlPrcIncldngTax";
NSString* const TOTAL_OPTION_PRICE = @"ttlOptnPrc";
NSString* const VOD_FLAG = @"vodFlag";

NSString* const MAX_PEOPLE = @"maxPpl";
NSString* const KEYWORD = @"kywrd";

//query constants
NSString* const PAGE_NUM = @"pageNmbr";

NSString* const LATITUDE = @"lttd";
NSString* const LONGITUDE = @"lngtd";
NSString* const DISTANCE = @"dstnc";

NSString* const MEMBER_PRICE = @"mmbrPrc";
NSString* const LISTED_PRICE = @"listPrc";
NSString* const MEM_PRICE_TAX = @"mmbrPrcIncldngTax";
NSString* const LISTED_PRICE_TAX = @"listPrcIncldngTax";
NSString* const OFFICIAL_DISCOUNT_PRICE = @"offclWebDscntPrc";
NSString* const MEMBER_OFFICIAL_DISCOUNT_PRICE = @"mmbrOffclWebDscntPrc";
NSString* const NUM_REMAINING_ROOMS = @"nmbrRrms";
NSString* const DISTANCE_FROM_CURRENT_POSITION = @"dstncCrrntPstn";

NSString* const NOSHOW_CARD_FLAG = @"nshwCrdtSttmntFlag";

NSString* const LOGIN_ID = @"lgnId";
NSString* const LOGIN_PASSWD = @"lgnPsswrd";
NSString* const AUTH_KEY = @"athntctnKey";

NSString* const PROCESSING_TYPE= @"prcssngType";

NSString* const AUTO_LOGIN = @"autoLogin";

NSString* const VOD_AVAIL = @"vodAvlblFlag";
NSString* const BEDSHARE_AVAIL = @"lyngOfChldrnAvlblFlag";
NSString* const ECO_AVAIL = @"ecoAvlblFlag";
NSString* const BP_AVAIL = @"bsnssPackAvlblFlag";

NSString* const INITIALIZED = @"initialized";

NSString* const COUNTRY_NAME = @"cntryName";
NSString* const COUNTRY_CODE = @"cntryCode";
NSString* const AREA_NAME = @"areaName";
NSString* const AREA_CODE = @"areaCode";
NSString* const STATE_NAME = @"sttName";
NSString* const STATE_CODE = @"sttCode";
NSString* const NUM_HOTEL = @"nmbrHtl";

NSString* const RECEIPT_NAME = @"receiptName";
NSString* const RECEIPT_TYPE = @"receiptType";

NSString* const PLAN_CODE = @"planCode";
NSString* const PLAN_NAME = @"planName";

//Yes/No mapping, temporary
NSArray *YesNo; // = @[@"Y", @"N"];
NSArray *cht_yesno; // = @[@"是", @"否"];
NSArray *eng_yesno; // = @[@"Yes", @"No"];
NSArray *jpn_yesno; // =@[@"", @""];


#import "Constant.h"

@implementation Constant

NSArray *nationCodes;
NSDictionary *nationDatas;
NSArray *genderCodes;
NSDictionary *genderDatas;

#if 0
NSMutableArray *checkinTimes;
#endif
+(NSArray*)getCheckinTimeList:(BOOL)isMember
{
#if 0
    if(checkinTimes)
        return checkinTimes;
#else
    NSMutableArray *checkinTimes;
#endif
    //not initialized
    checkinTimes = [[NSMutableArray alloc] init];
    
    int startTime;
    if(isMember)
        startTime = 15;
    else
        startTime = 16;
    
    for(int i = startTime; i<=23; i++)
    {
        NSString *tmp = [NSString stringWithFormat:@"%d:00", i];
        [checkinTimes addObject:tmp];
        tmp = [NSString stringWithFormat:@"%d:30", i];
        [checkinTimes addObject:tmp];
    }
    [checkinTimes addObject:@"24:00"];
    
    return checkinTimes;
}

+(NSArray*)getNationalityList
{
    if(nationCodes != nil)
    {
        if([nationCodes count]!=0)
        {
            return nationCodes;
        }
    }
    
    [self ParseData];
    
    if(nationDatas)
    {
        nationCodes = nationDatas[@"nations"];
    }
    
    if(nationCodes == nil) //no data
        return @[];
    
    return nationCodes;
}

+(NSString*)getNationalityCode:(NSInteger)index
{
    if(nationCodes == nil)
        [self ParseData];
    
    if(index > [nationCodes count]-1)
        return @"";
    
    return nationCodes[index];
} //get nationality code from index

+(NSArray*)getNationalityNames:(NSString*)lang
{
    if(nationDatas == nil)
        [self ParseData];
    
    if(nationDatas == nil)
        return @[];
    
    NSArray *nations;
    
    if([lang isEqualToString:@"ja"])
    {
        nations = nationDatas[@"jpn_nations"];
    }
    
    else if([lang isEqualToString:@"en"])
    {
        nations = nationDatas[@"eng_nations"];
    }
    //TODO: add code for other languages
    
    if(nations == nil) //no data
        return @[];
    
    return nations;
}

+(NSString*)getNationalityName:(NSInteger)index lang:(NSString*)lang
{
    if(nationDatas == nil)
        [self ParseData];
    
    if(nationDatas == nil)
        return @"";
    
    NSArray *nations;
    
    if([lang isEqualToString:@"ja"])
    {
        nations = nationDatas[@"jpn_nations"];
    }
    else if([lang isEqualToString:@"en"])
    {
        nations = nationDatas[@"eng_nations"];
    }
    //TODO: add code for other languages
    
    if(index <= [nations count])
        return nations[index];
    
    return @"";
} //get nationality name from index

+(NSString*)NationalityNameFromCode:(NSString*)code lang:(NSString*)lang
{
    if(nationDatas == nil)
        [self ParseData];
    
    if(nationDatas == nil)
        return @"";
    
    if(nationCodes == nil)
        return @"";
    
    NSUInteger index = 0;
    
    if([nationCodes containsObject:code])
    {
        index = [nationCodes indexOfObject:code];
    }
    else
    {
        return @"";
    }
    
    NSArray *nations;
    
    if([lang isEqualToString:@"ja"])
    {
        nations = nationDatas[@"jpn_nations"];
    }
    else if([lang isEqualToString:@"en"])
    {
        nations = nationDatas[@"eng_nations"];
    }
    //TODO: add code for other languages
    
    return nations[index];
}

+(NSNumber*)NationalityIndexFromCode:(NSString*)code
{
    if(nationDatas == nil)
        [self ParseData];
    
    //return 0 as defaul value
    if(nationDatas == nil)
        return @(0);
    
    if(nationCodes == nil)
        return @(0);
    
    NSInteger index = 0;
    
    if([nationCodes containsObject:code])
    {
        index = [nationCodes indexOfObject:code];
    }
    else
    {
        return @(0);
    }
    
    return [NSNumber numberWithInteger:index];
}

+(NSArray*)getGenderList
{
    if(genderCodes != nil)
    {
        if([genderCodes count]!=0)
        {
            return genderCodes;
        }
    }
    
    [self ParseData];
    
    if(genderDatas)
    {
        genderCodes = genderDatas[@"gender"];
    }
    
    if(genderCodes == nil) //no data
        return @[];
    
    return genderCodes;
}

+(NSArray*)getGenderNames:(NSString*)lang
{
    if(genderDatas == nil)
        [self ParseData];
    
    if(genderDatas == nil)
        return @[];
    
    NSArray *genders;
    
    if([lang isEqualToString:@"ja"])
    {
        genders = genderDatas[@"jpn_gender"];
    }
    
    else if([lang isEqualToString:@"en"])
    {
        genders = genderDatas[@"eng_gender"];
    }
    //TODO: add code for other languages
    
    if(genders == nil) //no data
        return @[];
    
    return genders;
}

+(NSString*)getGenderCode:(NSInteger)index
{
    if(genderCodes == nil)
        [self ParseData];
    
    if(index > [genderCodes count]-1)
        return @"";
    
    return genderCodes[index];
}

+(NSString*)getGenderName:(NSInteger)index lang:(NSString*)lang
{
    if(genderDatas == nil)
        [self ParseData];
    
    if(genderDatas == nil)
        return @"";
    
    NSArray *genders;
    
    if([lang isEqualToString:@"ja"])
    {
        genders = genderDatas[@"jpn_gender"];
    }
    else if([lang isEqualToString:@"en"])
    {
        genders = genderDatas[@"eng_gender"];
    }
    //TODO: add code for other languages
    
    if(index <= [genders count])
        return genders[index];
    
    return @"";
}

+(NSString*)GenderNameFromCode:(NSString*)code lang:(NSString*)lang
{
    if(genderDatas == nil)
        [self ParseData];
    
    if(genderDatas == nil)
        return @"";
    
    if(genderCodes == nil)
        return @"";
    
    NSUInteger index = 0;
    
    if([genderCodes containsObject:code])
    {
        index = [genderCodes indexOfObject:code];
    }
    else
    {
        return @"";
    }
    
    NSArray *genders;
    
    if([lang isEqualToString:@"ja"])
    {
        genders = genderDatas[@"jpn_gender"];
        NSLog(@"jpn gender: %@", genders);
    }
    else if([lang isEqualToString:@"en"])
    {
        genders = genderDatas[@"eng_gender"];
        NSLog(@"eng gender: %@", genders);
    }
    //TODO: add code for other languages
    
    //NSLog(@"geders[%li]:%@", index, genders[index]);
    return genders[index];
}

+(NSNumber*)GenderIndexFromCode:(NSString*)code
{
    if(genderDatas == nil)
        [self ParseData];
    
    //return 0 as defaul value
    if(genderDatas == nil)
        return @(0);
    
    if(genderCodes == nil)
        return @(0);
    
    NSInteger index = 0;
    
    if([genderCodes containsObject:code])
    {
        index = [genderCodes indexOfObject:code];
    }
    else
    {
        return @(0);
    }
    
    return [NSNumber numberWithInteger:index];
}

+(NSString*)convertToLocalDate:(NSString*)strDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [dateFormat setDateFormat:@"yyyyMMdd"];
#if 1
    [dateFormat setCalendar:gregorianCalendar];
#endif
    NSDate *convertedDate = [dateFormat dateFromString:strDate];
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:convertedDate dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
    
    return dateStr;
}

+(NSString*)calCheckoutDate:(NSString*)checkinDate nights:(int)nights
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *convertedDate = [dateFormat dateFromString:checkinDate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.day = nights;
    
    NSDate *endDate = [cal dateByAddingComponents:comp toDate:convertedDate options:0];
    
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:endDate dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
    
    NSLog(@"checkout date:%@", dateStr);
    return dateStr;
}

+(NSString*)calCheckoutDate2:(NSString*)checkinDate nights:(int)nights
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *convertedDate = [dateFormat dateFromString:checkinDate];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.day = nights;
    
    NSDate *endDate = [cal dateByAddingComponents:comp toDate:convertedDate options:0];
    
    NSString *dateStr = [dateFormat stringFromDate:endDate];
    
    NSLog(@"checkout date:%@", dateStr);
    return dateStr;
}

+(NSArray*)genEcoDates:(NSString*)checkinDate nights:(int)nights
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *convertedDate = [dateFormat dateFromString:checkinDate];
    
    NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"MM/dd"];
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    
    for(int i=1; i<nights; i++)
    {
        comp.day = i;
        NSDate *endDate = [cal dateByAddingComponents:comp toDate:convertedDate options:0];
        NSString *date = [format2 stringFromDate:endDate];
        [dates addObject:date];
    }
    
    return dates;
}

+(NSString*)genEcoDateStr:(NSArray*)ecoDates
{
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"MM/dd"];
    
    NSDate *convertedDate;
    NSString *newDate;
    
    for(NSString *str in ecoDates)
    {
        convertedDate = [dateFormat dateFromString:str];
        newDate = [format2 stringFromDate:convertedDate];
        [dates addObject:newDate];
    }
    
    return [dates componentsJoinedByString:@", "];
}

+(NSString*)YesNoNameFromCode:(NSString*)code lang:(NSString*)lang
{
    NSString *ret = @"";
    
    if(YesNo == nil)
        YesNo = @[@"Y", @"N"];
    if(cht_yesno == nil)
        cht_yesno = @[@"是", @"否"];
    if(eng_yesno == nil)
        eng_yesno = @[@"Yes", @"No"];
    if(jpn_yesno == nil)
        jpn_yesno = @[@"はい", @"いいえ"];
    
    NSUInteger index = 1; //default is N
    
    if([YesNo containsObject:code])
    {
        index = [YesNo indexOfObject:code];
        if([lang isEqualToString:@"ja"])
            ret = jpn_yesno[index];
        else if([lang isEqualToString:@"en"])
            ret = eng_yesno[index];
        //TODO: handle other languages
        
    }
    
    return ret;
}

+(void)ParseData
{
    //parse the json file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"nations" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    nationDatas=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if(!nationDatas)
        NSLog(@"nation data error: %@", error);
    
    nationCodes = nationDatas[@"nations"];
    
    //Parse the gender data
    filePath = [[NSBundle mainBundle] pathForResource:@"gender" ofType:@"json"];
    jsonData = [NSData dataWithContentsOfFile:filePath];
    error = nil;
    
    genderDatas = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(!genderDatas)
        NSLog(@"gender data error: %@", error);
    
    genderCodes = genderDatas[@"gender"];
}

+(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:checkString];
    return (result && [checkString canBeConvertedToEncoding:NSASCIIStringEncoding]);
}

+(BOOL)IsValidTelnum:(NSString*)checkString
{
    const int minDigits = 6;
    
    if(checkString.length < minDigits)
        return NO;
    
    NSCharacterSet *cs = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filtered = [[checkString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [filtered isEqualToString:checkString];
}

+(BOOL)IsValidPasswd:(NSString*)passwd
{
    if(passwd.length < 6) //too short
    {
        return NO;
    }
    
    BOOL containsDigit = NO, containsAlpha = NO;
    
    for(int i=0;i < passwd.length; i++)
    {
        unichar c = [passwd characterAtIndex:i];
        
        containsDigit |= [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
        containsAlpha |= [[NSCharacterSet letterCharacterSet] characterIsMember:c];
    }
    
    if(!(containsDigit && containsAlpha)) //at least one restrict is not satisfied
    {
        return NO;
    }
    
    //check if any non-letter or non-decimal character exists
    for(int i=0;i < passwd.length; i++)
    {
        unichar c = [passwd characterAtIndex:i];
        
        containsDigit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
        containsAlpha = [[NSCharacterSet letterCharacterSet] characterIsMember:c];
        
        if(containsAlpha || containsDigit) //letter or decimal
            continue;
        else
        {
            NSLog(@"character %c is invalid", c);
            return NO;
        }
    }
    
    return [passwd canBeConvertedToEncoding:NSASCIIStringEncoding];/*YES*/;
}

+(BOOL)IsValidDate:(NSString *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *validateDate = [format dateFromString:date];
    if (validateDate != nil)
        return YES;
    else
        return NO;
}

+(UIColor*)textHeaderColor
{
    return [UIColor colorWithRed:53.0/255.0 green:116.0/255.0 blue:196.0/255.0 alpha:1.0];
}

+(UIColor*)DescBlueColor
{
    return [UIColor colorWithRed:36.0/255.0 green:90.0/255.0 blue:196.0/255.0 alpha:1.0];
}

+(UIColor*)AppRedColor
{
    return [UIColor colorWithRed:164.0/255.0 green:5.0/255.0 blue:1.0/255.0 alpha:1.0];
}

+(UIColor*)AppDarkBlueColor
{
    return [UIColor colorWithRed:58.0/255.0 green:72.0/255.0 blue:177.0/255.0 alpha:1.0];
}

+(UIColor*)AppLightGrayColor
{
    return [UIColor colorWithRed:227.0/255.0 green:227/255.0 blue:227.0/255.0 alpha:1.0];
}

+(UIColor*)AppLightBlueColor
{
    return [UIColor colorWithRed:229.0/255.0 green:246.0/255.0 blue:254.0/255.0 alpha:1.0];
}

//utility method to get the top most view controller
+(UIViewController*)getTopVC
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
@end