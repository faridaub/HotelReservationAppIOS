//
//  UIImage+UISegmentIconAndText.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/01.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "UIImage+UISegmentIconAndText.h"

@implementation UIImage (UISegmentIconAndText)
+ (id) imageFromImage:(UIImage*)image string:(NSString*)string color:(UIColor*)color
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize expectedTextSize = [string sizeWithAttributes:@{NSFontAttributeName: font}];
    int width = expectedTextSize.width + image.size.width + 5;
    int height = MAX(expectedTextSize.height, image.size.width);
    CGSize size = CGSizeMake((float)width, (float)height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    int fontTopPosition = (height - expectedTextSize.height) / 2;
    CGPoint textPoint = CGPointMake(image.size.width + 5, fontTopPosition);
    
    [string drawAtPoint:textPoint withAttributes:@{NSFontAttributeName: font}];
    // Images upside down so flip them
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, (CGRect){ {0, (height - image.size.height) / 2}, {image.size.width, image.size.height} }, [image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)resize:(UIImage *)image rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end