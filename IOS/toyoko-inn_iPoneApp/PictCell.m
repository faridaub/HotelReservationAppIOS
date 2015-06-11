//
//  PictCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/12/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "PictCell.h"

@implementation PictCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)prevPressed:(id)sender
{
    _pageControl.currentPage--;
    [self pageChanged:_pageControl];
}

- (IBAction)nextPressed:(id)sender
{
    _pageControl.currentPage++;
    [self pageChanged:_pageControl];
}

- (IBAction)pageChanged:(id)sender {
    if(_imageList.count > 0) //check if the array is empty
        _imgv.image = _imageList[_pageControl.currentPage];
    
    if(_pageControl.currentPage == 0)
    {
        _prevButton.enabled = NO;
    }
    else
        _prevButton.enabled = YES;
    
    if(_pageControl.currentPage == _pageControl.numberOfPages-1)
    {
        _nextButton.enabled = NO;
    }
    else
        _nextButton.enabled = YES;
    
}

- (void)setImages:(NSArray*)images
{
    _imageList = images;
    
    if(_imageList.count > 0) //check if the array is empty
    {
        [_pageControl setNumberOfPages:_imageList.count];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor yellowColor]];
        _pageControl.currentPage = 0;
        
        //default is the 0th image
        _imgv.image = _imageList[0];
    }
   
}
@end
