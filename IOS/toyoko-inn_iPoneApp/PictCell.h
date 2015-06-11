//
//  PictCell.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/12/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)prevPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;
- (IBAction)pageChanged:(id)sender;
- (void)setImages:(NSArray*)images;
@property NSArray *imageList;
@end
