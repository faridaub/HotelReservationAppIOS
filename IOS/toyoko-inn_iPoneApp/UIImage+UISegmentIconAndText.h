//
//  UIImage+UISegmentIconAndText.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/01.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UISegmentIconAndText)

+ (id) imageFromImage:(UIImage*)image string:(NSString*)string color:(UIColor*)color;
//+ (id) imageFromImage:(UIImage*)image string:(NSString*)string color:(UIColor*)color position:(NSString*)position;
+ (UIImage *)resize:(UIImage *)image rect:(CGRect)rect;

@end
