//
//  Constant.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/08/20.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Constant : NSObject

+(NSArray*)getCheckinTimeList:(BOOL)isMember;

+(NSArray*)getNationalityList; //return all selectable nationality names
+(NSArray*)getNationalityNames:(NSString*)lang;
+(NSString*)getNationalityCode:(NSInteger)index; //get nationality code from index
+(NSString*)getNationalityName:(NSInteger)index lang:(NSString*)lang; //get nationality name from index
+(NSString*)NationalityNameFromCode:(NSString*)code lang:(NSString*)lang; //translate code to name with language setting
+(NSNumber*)NationalityIndexFromCode:(NSString*)code;

+(NSArray*)getGenderList;
+(NSArray*)getGenderNames:(NSString*)lang;
+(NSString*)getGenderCode:(NSInteger)index;
+(NSString*)getGenderName:(NSInteger)index lang:(NSString*)lang;
+(NSString*)GenderNameFromCode:(NSString*)code lang:(NSString*)lang;
+(NSNumber*)GenderIndexFromCode:(NSString*)code;

+(NSString*)convertToLocalDate:(NSString*)strDate;
+(NSString*)calCheckoutDate:(NSString*)checkinDate nights:(int)nights;
+(NSString*)calCheckoutDate2:(NSString*)checkinDate nights:(int)nights;
+(NSArray*)genEcoDates:(NSString*)checkinDate nights:(int)nights;
+(NSString*)genEcoDateStr:(NSArray*)ecoDates;

+(BOOL)IsValidEmail:(NSString *)checkString;
+(BOOL)IsValidTelnum:(NSString*)checkString;
+(BOOL)IsValidPasswd:(NSString*)passwd;
+(BOOL)IsValidDate:(NSString *)date;

+(NSString*)YesNoNameFromCode:(NSString*)code lang:(NSString*)lang;
+(UIColor*)textHeaderColor;
+(UIColor*)DescBlueColor;
+(UIColor*)AppRedColor;
+(UIColor*)AppDarkBlueColor;
+(UIColor*)AppLightGrayColor;
+(UIColor*)AppLightBlueColor;
+(UIViewController*)getTopVC;
@end
