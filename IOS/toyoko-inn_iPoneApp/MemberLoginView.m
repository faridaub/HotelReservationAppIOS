//
//  MemberLoginView.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/06/12.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "MemberLoginView.h"
#import "infoRegAdd.h"
#import "infoRegAdd2.h"
#import "initialAlready.h"

@interface MemberLoginView ()



@end

@implementation MemberLoginView
static NSArray *prefixes;
static NSInteger selectedIndex;

static NSArray *textfields;
static UIScrollView *scrollView;

static UITextField *activeField = nil;

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
    _OKButton.clipsToBounds = YES;
    _OKButton.layer.cornerRadius = 10;
    
    prefixes = [[NSArray alloc]initWithObjects:@"I", @"G", @"GV", @"L", @"LV", @"T", nil];
    
    //set I as the default value
    selectedIndex = 0;
    
    //To hide the picker as default
    _PrefixPicker.hidden = YES;
    
    //set the current index as selected in picker
    [_PrefixPicker selectRow:0 inComponent:selectedIndex animated:YES];
    
    [_PrefixButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_PrefixButton.layer setBorderWidth:1.0];
    
    [_PrefixPicker.layer setBorderColor:[[UIColor grayColor]CGColor]];
    [_PrefixPicker.layer setBorderWidth:1.0];
    
    textfields = @[_memberNum1, _memberNum2, _FamilyName, _GivenName];
#if 0
    _memberNum1.delegate = self;
    _memberNum2.delegate = self;
    _FamilyName.delegate = self;
    _GivenName.delegate = self;
#endif
    for(UITextField *tf in textfields)
    {
        tf.delegate = self;
    }
    activeField = nil;
    
    //20150423: added for scrollbar
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = self.view.bounds.size;
    scrollView.bounces = NO;
    [scrollView addSubview:self.view];
#if 1
    self.view = scrollView;
#endif

    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(20.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
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

- (IBAction)PrefixButtonPressed:(id)sender {
    //To toggle shown/hidden status of prefix picker
    if(_PrefixPicker.hidden == YES)
    {
        _PrefixPicker.hidden = NO;
    }
    else
    {
        _PrefixPicker.hidden = YES;
    }
}

-(NSInteger)numberOfComponentsInPickerView:
(UIPickerView*)pickerView
{
    return 1;
}

-(NSInteger)pickerView:
(UIPickerView*)pickerView numberOfRowsInComponent:
(NSInteger)component
{
    //There is always only one line in each component
    return [prefixes count];
}

-(NSString*)pickerView:
(UIPickerView*)pickerView
           titleForRow:(NSInteger)row
          forComponent:(NSInteger)component
{
    return [prefixes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //To change the display value of prefix button and hide the picker again
    selectedIndex = row;
    pickerView.hidden = YES;
    [_PrefixButton setTitle:[NSString stringWithFormat:@"%@ ▼", [prefixes objectAtIndex:row]] forState:UIControlStateNormal];
    NSLog(@"didSelectRow called, row=%li, component=%li", (long)row, (long)component);
}

- (IBAction)BackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)OKPressed:(id)sender {
    //add code to check if any item is empty
    NSArray *Strs = @[_memberNum1.text, _memberNum2.text, _FamilyName.text, _GivenName.text];
    for(NSString *str in Strs)
    {
        if(str.length == 0) //empty string
        {
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle:@"確認" message:@"未入力の必須項目があります。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    }
    
    //check the number length
    if(_memberNum1.text.length != 4 || _memberNum2.text.length != 6)
    {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"会員番号の形式が不正です。ご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    //construct the member number string from text fields
    NSString *member_num = [NSString stringWithFormat:@"%@%@-%@",prefixes[selectedIndex], _memberNum1.text, _memberNum2.text];
    
    self.delegate = self;
    
    dict[MEMBER_NUM] = member_num;
    dict[FAMILY_NAME] = _FamilyName.text;
    dict[GIVEN_NAME] = _GivenName.text;
    
    [self addRequestFields:dict];
    [self setApiName:@"attests_member_api"];
    [self setSecure:NO];
    
    [self sendRequest];
}

-(void)ParsedDataReady:(NSDictionary*)data
{
    NSLog(@"data: %@", data);
    
    if([data[@"errrCode"] isEqualToString:@"BCMN0000"]) //success
    {
        //TODO: move to login ID/pass registration view
        //NSString *uid = data[PERSON_UID];
#if 0
        NSString *fmlyName = data[FAMILY_NAME];
        NSString *frstName = data[GIVEN_NAME];
        NSString *sex = data[GENDER];
        NSString *nationCode = data[NATIONALITY];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //[defaults setObject:uid forKey:PERSON_UID];
        [defaults setObject:fmlyName forKey:FAMILY_NAME];
        [defaults setObject:frstName forKey:GIVEN_NAME];
        [defaults setObject:sex forKey:GENDER];
        [defaults setObject:nationCode forKey:NATIONALITY];
        [defaults setObject:data[MEMBER_NUM] forKey:MEMBER_NUM]; //save the member card number
        [defaults synchronize];
#endif
        //jump to info reg add view
        if([data[LOGIN_ID] isEqualToString:@""])
        {
            infoRegAdd2 *next = (infoRegAdd2*)[self.storyboard instantiateViewControllerWithIdentifier:@"infoRegAdd2"];
            next.inputDict = [data mutableCopy];
            
            //avoid nil item
            if(!next.inputDict[BIRTHDATE])
                next.inputDict[BIRTHDATE] = @"";
            
            if(!next.inputDict[MB_EMAIL])
                next.inputDict[MB_EMAIL] = @"";
            
            if(!next.inputDict[MEMBER_FLAG])
                next.inputDict[MEMBER_FLAG] = @"Y";
            
            [self presentViewController:next animated:YES completion:^ {
                
            }];
        }
        else //login ID already set
        {
            initialAlready *next = (initialAlready*)[self.storyboard instantiateViewControllerWithIdentifier:@"initialAlready"];
            next.inputDict = [data mutableCopy];
            [self presentViewController:next animated:YES completion:^ {
                
            }];
        }
    }
    else if([data[@"errrCode"] isEqualToString:@"BGNL0001"] || [data[@"errrCode"] isEqualToString:@"BRSV0003"] || [data[@"errrCode"] isEqualToString:@"BCMN1004"]) //authentication failed or other error
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:@"お客様の情報を確認できませんでした。会員番号･氏名をご確認の上、再度お試しください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"確認" message:data[@"errrMssg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"はい", nil];
        [alert show];
    }
}

-(void)connectionFailed:(NSError*)error
{
    
}

-(void)cancelNumberPad
{
    [self.view endEditing:YES];
    //textfield.text = @"";
}

-(void)doneWithNumberPad
{
    //NSString *numberFromTheKeyboard = numberTextField.text;
    //[textfield resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
#if 1   //add code for input accessory view
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"確定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    textField.inputAccessoryView = numberToolbar;
#endif
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // enter closes the keyboard
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    else if ([string isEqualToString:@""]||[string isEqualToString:@"↨"]) //handle backspace and caps lock
    {
        return YES;
    }
    
    NSCharacterSet *validSet;
    //check which validation to use
    if(textField == _memberNum1 || textField == _memberNum2) //decimal
    {
        validSet = [NSCharacterSet decimalDigitCharacterSet];
    }
    else //letter
    {
        validSet = [NSCharacterSet letterCharacterSet];
    }
    
    if([string rangeOfCharacterFromSet:validSet].location != NSNotFound)
    {
        return [string canBeConvertedToEncoding:NSASCIIStringEncoding];
    }
    else
        return  NO;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    //NSLog(@"touch.view: %@", touch.view);
    
    BOOL tfTouched = NO;
    
    for(UITextField *tf in textfields)
    {
        if(tf == touch.view)
        {
            tfTouched = YES;
            break;
        }
    }
    
    if(!tfTouched)
    {
        [self.view endEditing:YES];
    }
    
    [super touchesBegan:touches withEvent:event];
}
@end
