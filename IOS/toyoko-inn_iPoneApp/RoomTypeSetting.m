//
//  RoomTypeSetting.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/04.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "RoomTypeSetting.h"

@interface RoomTypeSetting ()

@end

@implementation RoomTypeSetting

NSArray *buttons;
NSArray *radioGroup;
UIButton *selectedButton;

NSString *singleName;
NSString *doubleName;
NSString *twinName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ConfirmButton.clipsToBounds = YES;
    _ConfirmButton.layer.cornerRadius = 10;
    
    singleName = _SingleButton.titleLabel.text;
    doubleName = _DoubleButton.titleLabel.text;
    twinName = _TwinButton.titleLabel.text;
    
    //To handle the buttons with one array,fill the buttons into array
    buttons = [[NSArray alloc]initWithObjects:_SingleButton, _DoubleButton, _TwinButton, _ConfirmButton,nil];
    radioGroup = [[NSArray alloc]initWithObjects:_SingleButton, _DoubleButton, _TwinButton, nil];
    
    selectedButton = _SingleButton;
 
    for(UIButton *b in buttons)
    {
        b.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [b.imageView setContentMode: UIViewContentModeCenter ];
    }
    
    for(UIButton *b in radioGroup)
    {
        [b.layer setBorderWidth:0.5];
        [b.layer setBorderColor:[[UIColor blackColor]CGColor]];
    }

    [self AddImageToButton:_SingleButton image:[UIImage imageNamed:@"シングルベッド"]];
    [self AddImageToButton:_DoubleButton image:[UIImage imageNamed:@"ダブルベッド"]];
    [self AddImageToButton:_TwinButton image:[UIImage imageNamed:@"ツインベッド"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)SinglePressed:(id)sender {
    [self HandleRadioGroup:sender];
}

- (IBAction)DoublePressed:(id)sender {
    [self HandleRadioGroup:sender];
}

- (IBAction)TwinPressed:(id)sender {
    [self HandleRadioGroup:sender];
}

- (IBAction)ConfirmPressed:(id)sender {
    //save the selected room type
    NSString *roomName;
    NSString *roomCode;
    
    if(selectedButton == _SingleButton)
    {
        roomCode = @"S";
        roomName = singleName;
    }
    else if(selectedButton == _DoubleButton)
    {
        roomCode = @"D";
        roomName = doubleName;
    }
    else if(selectedButton == _TwinButton)
    {
        roomCode = @"T";
        roomName = twinName;
    }
    
    if([self.RoomDelegate respondsToSelector:@selector(SetRoomType:roomTypeName:)])
    {
        [self.RoomDelegate SetRoomType:roomCode roomTypeName:roomName];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)HandleRadioGroup:(UIButton*)selected
{
    selectedButton = selected;
    for(UIButton *b in radioGroup)
    {
        if(b == selectedButton)
        {
            [b setImage: [UIImage imageNamed:@"ラジオオン"] forState:UIControlStateNormal ];
            [b setBackgroundColor:[UIColor lightGrayColor]];
        }
        else
        {
            [b setImage: [UIImage imageNamed:@"ラジオオフ"] forState:UIControlStateNormal ];
            [b setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

- (void)AddImageToButton:(UIButton*)button image:(UIImage*)img
{
    UIImageView *imgv = [[UIImageView alloc]initWithImage:img];
    int offset = (button.frame.size.height - img.size.height/2)/2;
    
    [imgv setContentMode: UIViewContentModeScaleAspectFit ];
    [imgv setFrame:CGRectMake(button.frame.size.width-offset-(img.size.width/2),
                              offset,
                               img.size.width/2,
                               img.size.height/2)];

    [button addSubview:imgv];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
}

-(void)connectionFailed:(NSError*)error
{
}
@end
