//
//  ToyokoNetBase.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEMS_PER_PAGE 10

extern NSString* MEMBER_NUM;
extern NSString* FAMILY_NAME;
extern NSString* GIVEN_NAME;
extern NSString* PERSON_UID;
extern NSString* BIRTHDATE;
extern NSString* PASSWORD;
extern NSString* TEL_NUM;
extern NSString* PC_EMAIL;
extern NSString* MB_EMAIL;
extern NSString* NEWSLETTER;
extern NSString* NATIONALITY;
extern NSString* GENDER;
extern NSString* RESERV_NUM;
extern NSString* RESERV_ID;

extern NSString* IMAGE_URL;

extern NSString* MEMBER_FLAG;
extern NSString* CHECKIN_DATE;
extern NSString* CHECKOUT_DATE;
extern NSString* HOTEL_CODE;
extern NSString* HOTEL_NAME;
extern NSString* NUM_NIGHTS;
extern NSString* NUM_PEOPLE;
extern NSString* NUM_ROOMS;
extern NSString* ROOM_TYPE;
extern NSString* ROOM_NAME;
extern NSString* SMOKING_FLAG;
extern NSString* SINGLE_ROOM_PRICE;
extern NSString* SINGLE_ROOM_PRICE_TAX;
extern NSString* MEM_SINGLE_ROOM_PRICE;
extern NSString* MEM_SINGLE_ROOM_PRICE_TAX;
extern NSString* PAYMENT_PRICE;
extern NSString* PAYMENT_PRICE_TAX;
extern NSString* CHECKIN_TIME;
extern NSString* OPTION_PRICE;
extern NSString* ECO_FLAG;
extern NSString* TARGET_DATE;
extern NSString* ECOPLAN_CHECKIN_SPECIFY;
extern NSString* BUSI_FLAG;
extern NSString* BUSI_TYPE;
extern NSString* SHARE_BED;
extern NSString* TOTAL_PRICE;
extern NSString* TOTAL_PRICE_TAX;
extern NSString* TOTAL_OPTION_PRICE;
extern NSString* VOD_FLAG;

extern NSString* MAX_PEOPLE;
extern NSString* KEYWORD;

extern NSString* PAGE_NUM;

extern NSString* LATITUDE;
extern NSString* LONGITUDE;
extern NSString* DISTANCE;

extern NSString* MEMBER_PRICE;
extern NSString* LISTED_PRICE;
extern NSString* MEM_PRICE_TAX;
extern NSString* LISTED_PRICE_TAX;
extern NSString* OFFICIAL_DISCOUNT_PRICE;
extern NSString* MEMBER_OFFICIAL_DISCOUNT_PRICE;
extern NSString* NUM_REMAINING_ROOMS;
extern NSString* DISTANCE_FROM_CURRENT_POSITION;

extern NSString* NOSHOW_CARD_FLAG;

extern NSString* LOGIN_ID;
extern NSString* LOGIN_PASSWD;
extern NSString* AUTH_KEY;

extern NSString* PROCESSING_TYPE;

extern NSString* AUTO_LOGIN;

extern NSString* VOD_AVAIL;
extern NSString* BEDSHARE_AVAIL;
extern NSString* ECO_AVAIL;
extern NSString* BP_AVAIL;
extern NSString* INITIALIZED;

extern NSString* COUNTRY_NAME;
extern NSString* COUNTRY_CODE;
extern NSString* AREA_NAME;
extern NSString* AREA_CODE;
extern NSString* STATE_NAME;
extern NSString* STATE_CODE;
extern NSString* NUM_HOTEL;

extern NSString* RECEIPT_NAME;
extern NSString* RECEIPT_TYPE;

extern NSString* PLAN_CODE;
extern NSString* PLAN_NAME;

@protocol ToyokoNetBaseDelegate<NSObject>
@required
-(void)ParsedDataReady:(NSDictionary*)data;
-(void)connectionFailed:(NSError*)error;
@end

enum ConnectionState
{
    Error = -1,
    Connecting =0,
    BodySent,
    HeaderGot,
    DataGetting,
    Done
};

//a base class for internet communication view controllers
@interface ToyokoNetBase : UIViewController<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (weak, nonatomic) id<ToyokoNetBaseDelegate>delegate;
@property (nonatomic) NSMutableDictionary *reqFields;
@property (nonatomic) NSDictionary *responseFields;

@property (nonatomic) NSMutableData *response;
@property (nonatomic) NSDictionary *parsedData;

@property (nonatomic) NSString *protocol;
@property (nonatomic) NSURLConnection *connection;
@property NSString *apiName;
@property BOOL isBeingUsed;
@property int state;
@property UIActivityIndicatorView *ai;
-(void)basicFieldsReset;
-(void)addRequestFields:(NSDictionary*)fields;
-(void)setApiName:(NSString*)api;
-(void)sendRequest;
-(void)setSecure:(BOOL)secure;
-(void)cancel;
@end

