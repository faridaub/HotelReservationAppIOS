//
//  ToyokoCustomTableVC.m
//  toyoko-inn
//
//  Created by toyokoinn on 2014/07/14.
//  Copyright (c) 2014年 中崎拓真. All rights reserved.
//

#import "ToyokoCustomTableVC.h"
#import "ToyokoCustomCell.h"
#import "ToyokoBusiPak.h"
#import "ToyokoButtonCell.h"
#import "ToyokoEcoplanCell.h"
#import "ToyokoPickerCell.h"
#import "ToyokoPriceCell.h"
#import "ToyokoRuleCell.h"
#import "ToyokoSegmentCell.h"
#import "ToyokoStepperCell.h"
#import "ToyokoTextCell.h"

#import "TLIndexPathDataModel.h"
#import "TLIndexPathItem.h"

#import "Constant.h"

@interface ToyokoCustomTableVC ()

@end

@implementation ToyokoCustomTableVC

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
    
    UINib *nib = [UINib nibWithNibName:@"ToyokoEcoplanCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EcoplanCell"];
    
    nib = [UINib nibWithNibName:@"ToyokoBusiPak" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Busipak"];
    
    nib = [UINib nibWithNibName:@"ToyokoPickerCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Picker"];
    
    self.tableView.delaysContentTouches = NO;
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
- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ToyokoCustomCell *cell = (ToyokoCustomCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
   
    NSString *cellClass = NSStringFromClass([cell class]);
    
    //20141202 Kaiyuan.ho: close the keypad when non-textfield cell is tapped
    //                     to fix the numeric keypad close issue
    if(![cellClass isEqualToString:@"ToyokoTextCell"])
    {
        [self.view endEditing:YES];
    }    
}


//To convert the new specified script and show on the screen, run as interpreter
- (TLIndexPathDataModel*)PerformDialogScript
{
    NSMutableArray *items = [[NSMutableArray alloc]init];

    //NSLog(@"PerformDialogScript enter");
    for(NSDictionary *dict in _dialogScript)
    {
        NSString *cellName = dict[@"cellName"];
        NSString *identifier = dict[@"identifier"];
        TLIndexPathItem *item = [[TLIndexPathItem alloc] initWithIdentifier:identifier
                                                                 sectionName:nil
                                                              cellIdentifier:cellName
                                                                        data:dict];
        [items addObject:item];
        //NSLog(@"script:%@", dict);
    }
    return [[TLIndexPathDataModel alloc] initWithItems:items];
}

-(void)MakeCell:(ToyokoCustomCell*)cell dict:(NSDictionary*)dict index:(NSIndexPath*)index
{
    NSString *classname = NSStringFromClass([cell class]);
    NSString *cellName = dict[@"cellName"];
    
    //add the required mark if set
    BOOL required = NO;
    if(dict[@"required"])
        required = [dict[@"required"] boolValue];
    
    [cell setRequired:required];
    
#if 1
    NSArray *border = @[];
    if(dict[@"border"])
        border = dict[@"border"];
    
    //[cell setBorder:border];
//#endif

    BOOL label = NO;
    UIColor *bgColor = [UIColor whiteColor];
    if(dict[@"bgColor"])
    {
        label = YES;
        bgColor = dict[@"bgColor"];
    }
    
    //NSLog(@"title:%@ label:%d border:%@",dict[@"title"],label, border);
    [cell setLabel:label color:bgColor border:border];
#endif

    if([classname isEqualToString:@"ToyokoCustomCell"])
    {
        if (![cellName isEqualToString:@"2Cols"])
        {
            [cell setTitle:dict[@"title"]];
            if([cellName isEqualToString:@"Cell"])
            {
                [cell autoAttrTitle];
            }
        }
        else //cell with title and detail text
        {
#if 0
            //bg color is set
            if (dict[@"bgcolor"])
            {
                cell.backgroundColor = dict[@"bgcolor"];
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
#endif
#if 1
            NSString *title = dict[@"title"];
            NSRange range = [title rangeOfString:@"\n"];
            if(range.location != NSNotFound) //line break in the title string
                cell.textLabel.numberOfLines = 0;
            else
                cell.textLabel.numberOfLines = 1;
#endif
            [cell setTitle:dict[@"title"]];
            if(!dict[@"link"]) //not a link
            {
                [cell setDetail:dict[@"title2"]];
            }
            else
            {
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:dict[@"title2"] attributes:@{NSLinkAttributeName:dict[@"link"]}];
                [cell setAttrDetail:attrStr];
            }
            [cell autoAttrTitle];
        }
        
        if([cellName isEqualToString:@"Description"])
        {
            //color is set
            if (dict[@"color"])
            {
                cell.textLabel.textColor = dict[@"color"];
            }
            else
            {
                cell.textLabel.textColor = [Constant DescBlueColor];
            }
            
            if(dict[@"font"])
            {
                cell.textLabel.font = [UIFont systemFontOfSize:[dict[@"font"]integerValue]];
            }
            else
            {
                cell.textLabel.font = [UIFont systemFontOfSize:12.0];
            }
            
        }
    }
    else if([classname isEqualToString:@"ToyokoButtonCell"])
    {
        ToyokoButtonCell *buttonCell = (ToyokoButtonCell*)cell;
        [buttonCell setTitle:dict[@"title"]];
        [buttonCell setButtonTitle:dict[@"buttonTitle"]];
        if(dict[@"hidden"])
            [buttonCell setButtonHidden:[dict[@"hidden"]boolValue]];
        
        if(dict[@"icon"])
            [buttonCell setIcon:[UIImage imageNamed:dict[@"icon"]]];
        
        [buttonCell adjustSubview];

        //add code for action and delegate
        if(dict[@"action"])
        {
            [buttonCell setAction:NSSelectorFromString(dict[@"action"])];
        }
        
        if(dict[@"delegate"])
        {
            [buttonCell setDelegate:dict[@"delegate"]];
        }
    }
    else if([classname isEqualToString:@"ToyokoEcoplanCell"])
    {
        ToyokoEcoplanCell *ecoplan = (ToyokoEcoplanCell*)cell;
        ecoplan.clipsToBounds = YES;
        [ecoplan adjustSubview];
        
        [ecoplan setDict:(NSMutableDictionary*)dict];
        [ecoplan setDates:dict[@"dates"] selectedDates:dict[@"value"]];
#if 0
        //handle the "specify when check-in" button
        if(dict[@"ecoChckn"])
        {

            if([dict[@"ecoChckn"] isEqualToString:@"Y"])
                [ecoplan setNoSpecifySelected:YES];
            else
                [ecoplan setNoSpecifySelected:NO];

        }
#endif
    }
    else if([classname isEqualToString:@"ToyokoBusiPak"])
    {
        ToyokoBusiPak *busiCell = (ToyokoBusiPak*)cell;
        busiCell.clipsToBounds = YES;
        [busiCell adjustSubview];
        
        [busiCell setDict:(NSMutableDictionary*)dict];
        [busiCell setFormattedStrings:dict[@"format1"] str2:dict[@"format2"]];
        [busiCell setValues:dict[@"values1"] values2:dict[@"values2"]];
        if(dict[@"value"] != nil)
            [busiCell setValue:[dict[@"value"] integerValue]];
    }
    else if([classname isEqualToString:@"ToyokoStepperCell"])
    {
        ToyokoStepperCell *stepperCell = (ToyokoStepperCell*)cell;
        [stepperCell adjustSubview];
        
        [stepperCell setTitle:dict[@"title"]];
        [stepperCell setFormatString:dict[@"format"]];
        [stepperCell setDict:(NSMutableDictionary*)dict];
        
        double min, max, value;
        min = [dict[@"min"] doubleValue];
        max = [dict[@"max"] doubleValue];
        value = [dict[@"value"] doubleValue];
        [stepperCell setValue:[NSNumber numberWithDouble:value]];
        [stepperCell setupStepper:1.0 min:min max:max];
        
        [stepperCell autoAttrTitle];
    }
    else if([classname isEqualToString:@"ToyokoSegmentCell"])
    {
        ToyokoSegmentCell *segmentCell = (ToyokoSegmentCell*)cell;
        
        [segmentCell setTitle:dict[@"title"]];
#if 0
        [segmentCell autoAttrTitle];
#else
        if(!dict[@"plain"])
        {
            [segmentCell autoAttrTitle];
        }
        else //plain is set
        {
            if(![dict[@"plain"] boolValue])
                [segmentCell autoAttrTitle];
        }
#endif
        [segmentCell setDict:(NSMutableDictionary*)dict];
        [segmentCell setValue:[dict[@"value"] integerValue]];
        [segmentCell setSegmentTitles:dict[@"choices"]];
        [segmentCell adjustSubview];
    }
    else if([classname isEqualToString:@"ToyokoPickerCell"])
    {
        ToyokoPickerCell *pickerCell = (ToyokoPickerCell*)cell;        
        
        [pickerCell setTitle:dict[@"title"]];
        
        [pickerCell setDict:(NSMutableDictionary*)dict];
        [pickerCell setExpanded:[dict[@"expanded"] boolValue] initial:YES];
        [pickerCell setValue:[dict[@"value"]integerValue]];
        [pickerCell setChoices:dict[@"choices"]];
#if 0
        [pickerCell autoAttrTitle];
#else
        if(!dict[@"plain"])
        {
            [pickerCell autoAttrTitle];
        }
        else //plain is set
        {
            if(![dict[@"plain"] boolValue])
                [pickerCell autoAttrTitle];
        }
#endif
        [pickerCell setTable:self.tableView index:index];
        [pickerCell setHeight:[dict[@"minHeight"] floatValue] max:[dict[@"maxHeight"]floatValue]];
        
        [pickerCell reload]; //To reload all data because the data is set after picker initialization
    }
    else if([classname isEqualToString:@"ToyokoTextCell"])
    {
        ToyokoTextCell *textCell = (ToyokoTextCell*)cell;
        [textCell setDict:(NSMutableDictionary*)dict];
        [textCell adjustSubview];
        
        [textCell setTitle:dict[@"title"]];        
        [textCell setValue:dict[@"value"]];
        
        //set if the input should be hidden
        if(dict[@"secure"])
        {
            if([dict[@"secure"] boolValue])
                [textCell setSecure:YES];
            else
                [textCell setSecure:NO];
        }
        else
            [textCell setSecure:NO];
        
        //set the input hint
        if(dict[@"hint"])
        {
            [textCell setHint:dict[@"hint"]];
        }
        else
        {
            [textCell setHint:@""];
        }
        
        //set the clear button mode
        if(dict[@"clear"])
        {
            if([dict[@"clear"] boolValue])
                [textCell setClear:YES];
            else
                [textCell setClear:NO];
        }
        else
            [textCell setClear:NO]; //default is NO
        
        //set validation type
        if(dict[@"valid"])
        {
            [textCell setValid:dict[@"valid"]];
        }
        else
            [textCell setValid:@""];
        
        //set upper case
        if(dict[@"upper"])
        {
            [textCell setUpperCase:[dict[@"upper"] boolValue]];
        }
        else
        {
            [textCell setUpperCase:NO];
        }
        
        if([cellName isEqualToString:@"Text2"])
            [cell.textLabel sizeToFit];
        
        if(!dict[@"plain"])
        {
            [cell autoAttrTitle];
        }
        else //plain is set
        {
            if(![dict[@"plain"] boolValue])
                [cell autoAttrTitle];
            else
            {
                NSLog(@"plain mode font size: %f", cell.textLabel.font.pointSize);
                if(dict[@"font"])
                {
                    cell.textLabel.font = [UIFont systemFontOfSize:[dict[@"font"]integerValue]];
                }
            }
        }
    }
    else if([classname isEqualToString:@"ToyokoPriceCell"])
    {
        ToyokoPriceCell *priceCell = (ToyokoPriceCell*)cell;
        [priceCell setStrings:dict[@"str1"] str2:dict[@"str2"]];
        [priceCell adjustSubview];        
    }
    else if([classname isEqualToString:@"ToyokoRuleCell"])
    {
        ToyokoRuleCell *ruleCell = (ToyokoRuleCell*)cell;
        [ruleCell setStrings:dict[@"str1"] str2:dict[@"str2"]];
        [ruleCell adjustSubview];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToyokoCustomCell *cell = (ToyokoCustomCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    TLIndexPathItem *item = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    
#if 0 //added for separator customization
    if(_removeSeparator)
    {
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, tableView.bounds.size.width)];
        }
    }
    else
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
#endif
    
    NSDictionary *dict;
    NSMutableDictionary *mutableDict;
    
    //To get the binding data
    if([item.data isKindOfClass:[NSDictionary class]])
        dict = (NSDictionary*)item.data;
    
    //For some cells which have an input, the data should be mutable
    if ([item.data isKindOfClass:[NSMutableDictionary class]])
        mutableDict = (NSMutableDictionary*)item.data;
    
    [self MakeCell:cell dict:dict index:indexPath];
#if 1
    [cell setNeedsDisplay];
    [cell setNeedsLayout];
#endif
    
    return cell;
}

#define DESC_CELL_WIDTH 290.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    TLIndexPathItem *item = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    
    if([item.data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict =(NSDictionary*)item.data;
        if([dict[@"type"] isEqualToString:@"ToyokoPickerCell"])
        {
            BOOL expanded = [dict[@"expanded"] boolValue];
            CGFloat minHeight = [dict[@"minHeight"] floatValue];
            CGFloat maxHeight = [dict[@"maxHeight"] floatValue];
            
            if(expanded)
                height = maxHeight; //max height should be 220
            else
                height = minHeight; //min height should be 44
            
            NSLog(@"picker's height:%f", height);
        }
        
        //description cell, dynamic height depends on the text
        if([dict[@"cellName"] isEqualToString:@"Description"])
        {
            ToyokoCustomCell *cell = (ToyokoCustomCell*)[tableView dequeueReusableCellWithIdentifier:dict[@"cellName"]];
            if (cell == nil)
            {
                cell = (ToyokoCustomCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dict[@"cellName"]];
            }
            UIFont *font = cell.textLabel.font;
            if(dict[@"font"]) //added for variable font size
            {
                font = [UIFont systemFontOfSize:[dict[@"font"]integerValue]];
            }
            CGFloat cellWidth = DESC_CELL_WIDTH;/*cell.contentView.frame.size.width;*///cell.textLabel.frame.size.width;
            //NSLog(@"desc cell width: %f", cellWidth);
            //NSLog(@"textlabel width: %f", cell.textLabel.frame.size.width);
            
            NSString *str = dict[@"title"];
#if 1
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font}];
            CGRect rect = [attr boundingRectWithSize:(CGSize){cellWidth, CGFLOAT_MAX}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
#endif
            CGFloat separatorHeight = tableView.separatorStyle == UITableViewCellSeparatorStyleNone ? 0 : 1 / [UIScreen mainScreen].scale;
            height = rect.size.height + separatorHeight + 1;
#if 0
            NSLog(@"desc cell height: %f", height);
#endif
            if(dict[@"space"])
            {
                height += [dict[@"space"] integerValue]*2;
            }
#if 0
            CGRect borderRect;
            if(cell.leftBorder)
            {
                borderRect = cell.leftBorder.frame;
                borderRect.size.height = height;
                cell.leftBorder.frame = borderRect;
            }
            if(cell.rightBorder)
            {
                borderRect = cell.rightBorder.frame;
                borderRect.size.height = height;
                cell.rightBorder.frame = borderRect;
            }
            
#endif
            //NSLog(@"cellwidth:%f, height:%f",cellWidth, height);
        }
        
        if([dict[@"cellName"] isEqualToString:@"Rule"])
        {
            ToyokoRuleCell *cell = (ToyokoRuleCell*)[tableView dequeueReusableCellWithIdentifier:dict[@"cellName"]];
            if (cell == nil)
            {
                cell = (ToyokoRuleCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dict[@"cellName"]];
            }
            CGFloat cellWidth = cell.textLabel.frame.size.width;
            
            NSString *str1 = dict[@"str1"];
            NSString *str2 = dict[@"str2"];
           
#if 1
            NSAttributedString *attr = [cell MakeFormattedString:str1 str2:str2];
            CGRect rect = [attr boundingRectWithSize:(CGSize){cellWidth, CGFLOAT_MAX}
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
#endif
            CGFloat separatorHeight = tableView.separatorStyle == UITableViewCellSeparatorStyleNone ? 0 : 1 / [UIScreen mainScreen].scale;
            height = rect.size.height + separatorHeight + cell.topMargin + cell.bottomMargin;
            //NSLog(@"cellwidth:%f, height:%f",cellWidth, height);
        }
        
        if([dict[@"cellName"] isEqualToString:@"Busipak"] ||
           [dict[@"cellName"] isEqualToString:@"EcoplanCell"] ||
           [dict[@"cellName"] isEqualToString:@"Segment"] ||
           [dict[@"cellName"] isEqualToString:@"Description"])
        {
            if(dict[@"hidden"])
            {
                if([dict[@"hidden"] boolValue])
                    height = 0; //to hide the cell
            }
        }
        
    }
    
    //20150327: round the floating point number to remove the annoying separator
    return round(height);
}

#define CELL_WIDTH 320.0f

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLIndexPathItem *item = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    
    BOOL separatorSpecified = NO;
    BOOL separator = NO;
    
    if([item.data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict =(NSDictionary*)item.data;
        
        if([dict[@"cellName"] isEqualToString:@"Busipak"] ||
           [dict[@"cellName"] isEqualToString:@"EcoplanCell"] ||
           [dict[@"cellName"] isEqualToString:@"Segment"] ||
           [dict[@"cellName"] isEqualToString:@"Description"])
        {
            if(dict[@"hidden"]) //hidden property exists
            {
                if([dict[@"hidden"] boolValue])
                    cell.hidden = YES; //to hide the cell
            }
        }
        
        if(dict[@"separator"])
        {
            separatorSpecified = YES;
            separator = [dict[@"separator"] boolValue];
        }
    }
    
    if(separatorSpecified)
    {
        if(separator) //to show separator
        {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
        else //to hide separator
        {
            //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f,CELL_WIDTH)];
            }
            //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            //tableView.separatorColor = [UIColor clearColor];
        }
        
        return; //skip default setting
    }
    
#if 1 //added for separator customization
    if(_removeSeparator)
    {
        //For iOS 6/7 compatiblilty, because setSeparatorInset is available from iOS 7
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, CGRectGetWidth(cell.bounds))];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorColor = [UIColor clearColor];
    }
    else
    {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
#endif
    
}

- (void)reload:(NSArray*)input
{
    //NSLog(@"reload called");
    _dialogScript = input;
    self.indexPathController.dataModel = [self PerformDialogScript];
}

-(NSDictionary*)findRow:(NSString*)identifier
{
    for(NSDictionary *dict in _dialogScript)
    {
        //check if the identifier is identical or not
        if([dict[@"identifier"] isEqualToString:identifier])
            return dict;
    }
    return nil;
}

-(NSInteger)findRowIndex:(NSString*)identifier
{
    for(int i=0; i<_dialogScript.count; i++)
    {
        NSDictionary *dict = _dialogScript[i];
        //check if the identifier is identical or not
        if([dict[@"identifier"] isEqualToString:identifier])
            return i;
    }
    return -1;
}


-(void)HookObserver
{
    for(NSDictionary *dict in _dialogScript)
    {
        if(!dict[@"observer"]) //observer setting not exist
        {
            continue;
        }
        else //observer set
        {
            [dict addObserver:dict[@"observer"] forKeyPath:@"value" options:0/*NSKeyValueObservingOptionNew*/ context:nil];
        }
    }

}

-(void)UnhookObserver
{
    for(NSDictionary *dict in _dialogScript)
    {
        if(!dict[@"observer"]) //observer setting not exist
        {
            continue;
        }
        else
        {
            @try{
                [dict removeObserver:dict[@"observer"] forKeyPath:@"value"];
            }@catch(id anException){
                //do nothing, just avoid crash
            }
        }
    }
}

@end
