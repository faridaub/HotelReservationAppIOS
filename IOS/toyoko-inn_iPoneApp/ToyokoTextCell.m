//
//  ToyokoTextCell.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/15.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoTextCell.h"

@implementation ToyokoTextCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
#if 0
        _textField.text = _value;
#endif
        _textField.inputAccessoryView = nil;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _value = textField.text;
    _dict[@"value"] = _value;
    [textField resignFirstResponder];
    NSLog(@"text edition end");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _value = textField.text;
    _dict[@"value"] = _value;
#if 1   //add code for input accessory view
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"確定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _textField.inputAccessoryView = numberToolbar;
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void) UITextFieldTextDidChange:(NSNotification*)notification
{
    UITextField * textfield = (UITextField*)notification.object;
    [self textChanged:textfield];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"tf.text = %@", textField.text);
    // enter closes the keyboard
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    else if ([string isEqualToString:@""]||[string isEqualToString:@"↨"]) //handle backspace, caps lock
    {
        return YES;
    }
    else if(_validSet != nil)
    {
        BOOL isOK = ([string rangeOfCharacterFromSet:_validSet].location != NSNotFound);
        if(isOK)
        {
            //check if the input character is full-width or not
            return [string canBeConvertedToEncoding:NSASCIIStringEncoding];
        }
        else
            return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)setValue:(NSString *)value
{
    _textField.text = value;
    _value = value;
    _dict[@"value"] = _value;
#if 0
    NSLog(@"value = %@", value);
#endif
#if 0
    //TODO: add warning mark
    if(self.requiredMark && _value.length == 0)
    {
        UIImage *warning = [UIImage imageNamed:@"警告"];
        UIImageView *warningMark = [[UIImageView alloc] initWithImage:warning];
        warningMark.transform = CGAffineTransformMakeScale(0.5, 0.5);
        warningMark.contentMode = UIViewContentModeCenter;
        warningMark.frame = CGRectMake(0, 0, warning.size.width+10.0f, warning.size.height);
        _textField.rightView = warningMark;
        _textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    else
    {
        _textField.rightView = nil;
    }
#endif
}

- (IBAction)textChanged:(id)sender {
    UITextField *tf = (UITextField*)sender;
#if 0
    NSLog(@"text changed: %@", tf.text);
#endif
    _value = tf.text;
    _dict[@"value"] = _value;
    
#if 0
    //TODO: add warning mark
    if(self.requiredMark && _value.length == 0)
    {
        UIImage *warning = [UIImage imageNamed:@"警告"];
        UIImageView *warningMark = [[UIImageView alloc] initWithImage:warning];
        warningMark.transform = CGAffineTransformMakeScale(0.5, 0.5);
        warningMark.contentMode = UIViewContentModeCenter;
        warningMark.frame = CGRectMake(0, 0, warning.size.width+10.0f, warning.size.height);
        _textField.rightView = warningMark;
        _textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    else
    {
        _textField.rightView = nil;
    }
#endif
}

-(id)getValue
{
    return (id)_value;
}

-(void)setSecure:(BOOL)secure
{
    _textField.secureTextEntry = secure;
}

#if 0
-(void)setRequired:(BOOL)required
{
    [super setRequired:required];
    
    //TODO: add warning mark
    if(required)
    {
        UIImage *warning = [UIImage imageNamed:@"警告"];
        UIImageView *warningMark = [[UIImageView alloc] initWithImage:warning];
        warningMark.frame = CGRectMake(0, 0, warning.size.width, warning.size.height);
        _textField.rightView = warningMark;
        _textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    }
    else
    {
        _textField.rightView = nil;
    }
}
#endif

-(void)setHint:(NSString*)hint
{
    _textField.placeholder = hint;
}

-(void)setClear:(BOOL)clear
{
    if(clear)
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    else
        _textField.clearButtonMode = UITextFieldViewModeNever;
}

-(void)setUpperCase:(BOOL)upper
{
    if(upper)
        _textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    else
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

-(void)cancelNumberPad{
    [_textField resignFirstResponder];
    _textField.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = numberTextField.text;
    [_textField resignFirstResponder];
}

-(void)setValid:(NSString*)type
{
    if([type isEqualToString:@"letter"])
    {
        _validSet = [NSCharacterSet letterCharacterSet];
        [_textField setKeyboardType:UIKeyboardTypeAlphabet];
        //_textField.inputAccessoryView = nil;
    }
    else if([type isEqualToString:@"decimal"])
    {
        _validSet = [NSCharacterSet decimalDigitCharacterSet];
        [_textField setKeyboardType:UIKeyboardTypeNumberPad];

#if 0   //add code for input accessory view
        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleDefault;
        numberToolbar.items = [NSArray arrayWithObjects:
                               [[UIBarButtonItem alloc]initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc]initWithTitle:@"確定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                               nil];
        [numberToolbar sizeToFit];
        _textField.inputAccessoryView = numberToolbar;
#endif
    }
    else if([type isEqualToString:@"email"])
    {
        _validSet = nil;
        [_textField setKeyboardType:UIKeyboardTypeEmailAddress];
        //_textField.inputAccessoryView = nil;
    }
    else //reset valid
    {
        _validSet = nil;
        [_textField setKeyboardType:UIKeyboardTypeDefault];
    }
    
    [_textField reloadInputViews];
}

-(void)adjustSubview
{
    //to handle to kinds of cell in one class, better to get the subview with tag
#if 1
    UIView *view =[self viewWithTag:1];
    if([view isKindOfClass:[UITextField class]])
    {
        _textField = (UITextField*)view;
        //NSLog(@"text field found");
    }
    _textField.delegate = self;
#endif
    //NSLog(@"contentView:%@",NSStringFromCGRect(self.contentView.frame));
    //NSLog(@"textfield:%@",NSStringFromCGRect(_textField.frame));
    CGRect r;
    if([_dict[@"cellName"] isEqualToString:@"Text1"])
    {
        //NSLog(@"text1 old: %@",NSStringFromCGRect(_textField.frame));
        UIView *contentView = _textField.superview;
        r.origin.y = (contentView.frame.size.height - _textField.frame.size.height)/2;
        r.origin.x = contentView.frame.size.width - _textField.frame.size.width - self.rightMargin;
        r.size = _textField.frame.size;
        //NSLog(@"text1: %@",NSStringFromCGRect(r));
        [_textField setFrame:r];
        
    }
    else //Text2, for telephone number
    {
        //NSLog(@"text2 old: %@",NSStringFromCGRect(_textField.frame));
        UIView *contentView = _textField.superview;
        r.origin.x =self.leftMargin;
        r.origin.y =_textField.frame.origin.y;
        r.size.width = contentView.frame.size.width/*self.frame.size.width*/ - self.leftMargin - self.rightMargin;
        r.size.height = _textField.frame.size.height;
        //NSLog(@"text2: %@", NSStringFromCGRect(r));
        [_textField setFrame:r];
    }
    
}

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //to limit the content of cell (textfield) not to overlap on other cells
    [self.contentView.superview setClipsToBounds:YES];
    //UIView *contentView = _textField.superview;
    
    //adjust the position of textlabel
    if([_dict[@"cellName"] isEqualToString:@"Text2"])
    {
        CGRect r = self.textLabel.frame;
        r.origin.y = (self.contentView.frame.size.height - self.textLabel.frame.size.height - _textField.frame.size.height)/2;
        [self.textLabel setFrame:r];
        
        //make the text label auto-shrink and vertically center aligned
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumScaleFactor = 0.5f;
        self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    else
    {
        CGRect r = self.textLabel.frame;
        r.size.width = self.contentView.frame.size.width - /*_textField.superview.frame.size.width*/_textField.frame.size.width- self.leftMargin - self.rightMargin - self.textLabel.frame.origin.x ;//_textField.frame.origin.x - self.textLabel.frame.origin.x - self.leftMargin;
        [self.textLabel setFrame: r];
        //NSLog(@"%@: title=%@, frame=%@, textfield=%@", _dict[@"cellName"], self.textLabel.text, NSStringFromCGRect(r), NSStringFromCGRect(_textField.frame));
        //NSLog(@"%@: title=%@, contentView=%@", _dict[@"cellName"], self.textLabel.text, NSStringFromCGRect(self.contentView.frame));
        
        //make the text label auto-shrink and vertically center aligned
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumScaleFactor = 0.5f;
        self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    //NSLog(@"touch.view: %@", touch.view);
    
    BOOL tfTouched = NO;
    
    
    if(_textField == touch.view)
    {
        tfTouched = YES;
    }
    
    
    if(!tfTouched)
    {
        [_textField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}
@end
