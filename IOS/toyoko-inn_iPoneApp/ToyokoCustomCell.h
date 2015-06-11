//
//  ToyokoCustomCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToyokoCustomCell : UITableViewCell
@property (nonatomic) NSString *identifier; //the string to identify each item
@property (nonatomic) NSAttributedString *AttrTitle; //the title of each item
@property (nonatomic) NSString *title; //the title of each item
//@property NSAttributedString *description; //the description in each item(optional)
@property (nonatomic) NSUInteger topMargin, bottomMargin, leftMargin, rightMargin;
//@property (nonatomic) CALayer *topBorder, *bottomBorder, *leftBorder, *rightBorder;
@property (nonatomic) BOOL requiredMark;
//@property (nonatomic) id value; //the initial/saved value of each item

#if 1
@property (nonatomic) UILabel *bgLabel;
#endif

-(void)setAttrTitle:(NSAttributedString*)title;
-(void)setTitle:(NSString*)title;
-(NSString*)getTitle;
-(NSAttributedString*)getAttrTitle;
-(void)setValue:(id)value;
-(id)getValue;
-(void)setDetail:(NSString*)str;
-(void)setAttrDetail:(NSAttributedString*)attr;
-(void)setDict:(NSMutableDictionary*)dict;
-(void)adjustSubview;
-(void)setRequired:(BOOL)required;
-(void)setBorder:(BOOL)border;
#if 1
-(void)setLabel:(BOOL)label color:(UIColor*)color border:(NSArray*)border;
#endif
-(void)autoAttrTitle;
@end
