//
//  ToyokoCustomTableVC.h
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "TLTableViewController.h"

@interface ToyokoCustomTableVC : TLTableViewController

@property NSArray *dialogScript;
@property BOOL removeSeparator;

-(void)reload:(NSArray*)input;
-(NSDictionary*)findRow:(NSString*)identifier;
-(NSInteger)findRowIndex:(NSString*)identifier;
-(void)HookObserver;
-(void)UnhookObserver;

@end
