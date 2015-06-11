//
//  InitialSlidingViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/25/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "InitialSlidingViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.shouldAdjustChildViewHeightForStatusBar = YES;
        self.statusBarBackgroundView.backgroundColor = [UIColor blackColor];
    }

#if 0
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
#else
#if 1
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
#endif
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    //self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    self.shouldAddPanGestureRecognizerToTopViewSnapshot = YES;
#endif
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
