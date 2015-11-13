//
//  StockEditViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockEditViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface StockEditViewController ()

@end

@implementation StockEditViewController
@synthesize title_name,dict,productId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_save;
    self.title = title_name;
    
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_save = [[UIBarButtonItem alloc] initWithTitle:@"保存"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_save_click:)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
        [tel setTitle:@"保存" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_save_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_save = [[UIBarButtonItem alloc] initWithCustomView:tel];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_save;
}

- (void)dealloc
{
    self.view=nil;
    tf_rate = nil;
    tf_reveal = nil;
    tf_bid = nil;
    tf_quote = nil;
    tf_abid = nil;
    tf_rate_b = nil;
    tf_reveal_b = nil;
    tf_bid_b = nil;
    tf_quote_b = nil;
    tf_abid_b = nil;
    dict = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"empty_cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cell_id];
    }
    
    UIFont *font = [UIFont systemFontOfSize:16.0f];
    if (!IOS7)
    {
        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 44.0f);
        [cell.contentView insertSubview:messageBackgroundView belowSubview:cell.textLabel];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }

    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"库存量(件)";
                if (tf_rate) {
                    [tf_rate removeFromSuperview];
                    tf_rate = nil;
                }
                tf_rate = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_rate.borderStyle = UITextBorderStyleNone;
                tf_rate.backgroundColor = [UIColor clearColor];
                tf_rate.textAlignment = NSTextAlignmentRight;
                tf_rate.font = font;
                tf_rate.delegate = self;
                tf_rate.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"picecInventory"] ];
                tf_rate.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tf_rate];
                break;
            case 1:
                cell.textLabel.text = @"展示量(件)";
                if (tf_reveal) {
                    [tf_reveal removeFromSuperview];
                    tf_reveal = nil;
                }
                tf_reveal = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_reveal.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pieceDispInventory"] ];
                tf_reveal.borderStyle = UITextBorderStyleNone;
                tf_reveal.backgroundColor = [UIColor clearColor];
                tf_reveal.textAlignment = NSTextAlignmentRight;
                tf_reveal.font = font;
                tf_reveal.delegate = self;
                tf_reveal.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tf_reveal];
                break;
            case 2:
                cell.textLabel.text = @"平均进价(件)";
                if (tf_bid) {
                    [tf_bid removeFromSuperview];
                    tf_bid = nil;
                }
                tf_bid = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_bid.text= [NSString stringWithFormat:@"%@",[dict objectForKey:@"piecePrice"] ];
                tf_bid.borderStyle = UITextBorderStyleNone;
                tf_bid.backgroundColor = [UIColor clearColor];
                tf_bid.textAlignment = NSTextAlignmentRight;
                tf_bid.font = font;
                tf_bid.delegate = self;
                tf_bid.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tf_bid];
                
                break;
            case 3:
                cell.textLabel.text = @"报价(件)";
                if (tf_abid) {
                    [tf_abid removeFromSuperview];
                    tf_abid = nil;
                }
                tf_abid = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_abid.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerPiecePrice"] ];
                tf_abid.borderStyle = UITextBorderStyleNone;
                tf_abid.backgroundColor = [UIColor clearColor];
                tf_abid.textAlignment = NSTextAlignmentRight;
                tf_abid.font = font;
                tf_abid.delegate = self;
                tf_abid.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:tf_abid];
                break;
            default:
                break;
        }
    }
  
    else if (1 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"库存量(%@)",[dict objectForKey:@"unitName"] ];
                if (tf_rate_b) {
                    [tf_rate_b removeFromSuperview];
                    tf_rate_b = nil;
                }
                tf_rate_b = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_rate_b.borderStyle = UITextBorderStyleNone;
                tf_rate_b.backgroundColor = [UIColor clearColor];
                tf_rate_b.textAlignment = NSTextAlignmentRight;
                tf_rate_b.font = font;
                tf_rate_b.delegate = self;
                tf_rate_b.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unitInventory"] ];
                tf_rate_b.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tf_rate_b];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"展示量(%@)",[dict objectForKey:@"unitName"] ];
                if (tf_reveal_b) {
                    [tf_reveal_b removeFromSuperview];
                    tf_reveal_b = nil;
                }
                tf_reveal_b = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_reveal_b.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unitDispInventory"] ];
                tf_reveal_b.borderStyle = UITextBorderStyleNone;
                tf_reveal_b.backgroundColor = [UIColor clearColor];
                tf_reveal_b.textAlignment = NSTextAlignmentRight;
                tf_reveal_b.font = font;
                tf_reveal_b.delegate = self;
                tf_reveal_b.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tf_reveal_b];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"平均报价(%@)",[dict objectForKey:@"unitName"] ];
                if (tf_abid_b) {
                    [tf_abid_b removeFromSuperview];
                    tf_abid_b = nil;
                }
                tf_abid_b = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_abid_b.text= [NSString stringWithFormat:@"%@",[dict objectForKey:@"unitPrice"] ];
                tf_abid_b.borderStyle = UITextBorderStyleNone;
                tf_abid_b.backgroundColor = [UIColor clearColor];
                tf_abid_b.textAlignment = NSTextAlignmentRight;
                tf_abid_b.font = font;
                tf_abid_b.delegate = self;
                tf_abid_b.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tf_abid_b];
                
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"报价(%@)",[dict objectForKey:@"unitName"] ];
                if (tf_bid_b) {
                    [tf_bid_b removeFromSuperview];
                    tf_bid_b = nil;
                }
                tf_bid_b = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_bid_b.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerUnitPrice"] ];
                tf_bid_b.borderStyle = UITextBorderStyleNone;
                tf_bid_b.backgroundColor = [UIColor clearColor];
                tf_bid_b.textAlignment = NSTextAlignmentRight;
                tf_bid_b.font = font;
                tf_bid_b.delegate = self;
                tf_bid_b.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:tf_bid_b];
                break;
            default:
                break;
        }
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = font;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];

    return cell;
}


- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btn_save_click:(id)sender
{
    if([tf_bid.text length] == 0 || [tf_bid_b.text length] == 0 ||
       [tf_rate.text length] == 0 || [tf_rate_b.text length] == 0 ||
       [tf_reveal.text length] == 0  ||
       [tf_abid.text length] == 0 || [tf_abid_b.text length] == 0)
    {
        [self.view.window makeToast:@"数据不能为空,没有请输入0!"];
        return;
    }
    [self saveData];
}

#pragma mark -
#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if(textField == tf_abid ||textField == tf_bid_b)
	{
		return YES;
	
	}
	return NO;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

//文字是否可以改变


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:tf_rate]) {
        [tf_reveal becomeFirstResponder];
        [dict setObject:textField.text forKey:@"picecInventory"];
    }
    else if ([textField isEqual:tf_reveal]) {
        [tf_bid becomeFirstResponder];
        [dict setObject:textField.text forKey:@"pieceDispInventory"];

    }
    else if ([textField isEqual:tf_bid]) {
        [tf_abid becomeFirstResponder];
        [dict setObject:textField.text forKey:@"piecePrice"];

    }
    else if ([textField isEqual:tf_abid]) {
        [tf_rate_b becomeFirstResponder];
        [dict setObject:textField.text forKey:@"offerPiecePrice"];

    }
    else if ([textField isEqual:tf_rate_b]) {
        [tf_reveal_b becomeFirstResponder];
        [dict setObject:textField.text forKey:@"unitInventory"];

    }
    else if ([textField isEqual:tf_reveal_b]) {
        [tf_abid_b becomeFirstResponder];
        [dict setObject:textField.text forKey:@"unitDispInventory"];

    }
    else if ([textField isEqual:tf_abid_b]) {
        [tf_bid_b becomeFirstResponder];
        [dict setObject:textField.text forKey:@"unitPrice"];
    }
    else
    {
        [dict setObject:textField.text forKey:@"offerUnitPrice"];
    }
    return YES;
}

#pragma mark -
- (void)saveData
{
    [SVProgressHUD showWithStatus:@"保存数据中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,UPDATA_INVENTORY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    
    [req setParam:productId forKey:@"productId"];
    [req setParam:tf_rate.text forKey:@"picecInventory"];
    [req setParam:tf_reveal.text forKey:@"pieceDispInventory"];
    [req setParam:tf_bid.text forKey:@"piecePrice"];
    [req setParam:tf_abid.text forKey:@"offerPiecePrice"];
    [req setParam:tf_rate_b.text forKey:@"unitInventory"];
    [req setParam:tf_reveal_b.text forKey:@"unitDispInventory"];
    [req setParam:tf_abid_b.text forKey:@"unitPrice"];
    [req setParam:tf_bid_b.text forKey:@"offerUnitPrice"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSaveData:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onSaveData: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
    NSLog(@"%@",json );
    
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"保存失败!" afterDelay:1.5f];
		return;
	}
    
    [SVProgressHUD dismissWithSuccess:@"保存成功!" afterDelay:1.5f];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0f];

}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"保存失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
