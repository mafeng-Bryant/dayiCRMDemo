//
//  CheckoutListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-7-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "CheckoutListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "OrderStoreDetailViewController.h"

@interface CheckoutListViewController ()

@end

@implementation CheckoutListViewController
@synthesize oid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"结账";
    UIBarButtonItem *btn_back;
    
    if (IOS7) {
        btn_back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_back = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    
    btn_certain = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btn_certain_tmp_click:)];
    btn_cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_tmp_click:)];
    btn_title = [[UIBarButtonItem alloc]initWithTitle:@"选择包间" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *arr = @[btn_cancel,flex,btn_title,flex,btn_certain];
    tool_bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    tool_bar.barStyle = UIBarStyleDefault;
    tool_bar.translucent = YES;
    [tool_bar setItems:arr animated:NO];

    [self initFootView];
    self.navigationItem.leftBarButtonItem = btn_back;
    [self loadData];
    [self loadRoomList];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (dict) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 == section) {
        return 1;
    }
    else if (1 == section){
        return 4;
    }
    else if (2 == section){
        return 3;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (0 == indexPath.section) {
        cell.textLabel.text = @"明细总金额";
        if (!lb_detailAmount) {
            lb_detailAmount = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
            lb_detailAmount.textColor = [UIColor darkGrayColor];
            lb_detailAmount.font = font;
            lb_detailAmount.backgroundColor = [UIColor clearColor];
            lb_detailAmount.textAlignment = NSTextAlignmentRight;
            lb_detailAmount.text = [dict objectForKey:@"detailAmount"];
            [cell.contentView addSubview:lb_detailAmount];
        }
    }
    else if (1 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"包间";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (!lb_roomName) {
                    lb_roomName = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 40)];
                    lb_roomName.textColor = [UIColor darkGrayColor];
                    lb_roomName.font = font;
                    lb_roomName.backgroundColor = [UIColor clearColor];
                    lb_roomName.textAlignment = NSTextAlignmentRight;
                    lb_roomName.text = [dict objectForKey:@"roomName"];
                    [cell.contentView addSubview:lb_roomName];
                    roomId = [dict objectForKey:@"roomId"];
                }
                break;
            case 1:
                cell.textLabel.text = @"包间单价";
              if (!lb_roomPrice) {
                    lb_roomPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
                    lb_roomPrice.textColor = [UIColor darkGrayColor];
                    lb_roomPrice.font = font;
                    lb_roomPrice.backgroundColor = [UIColor clearColor];
                    lb_roomPrice.textAlignment = NSTextAlignmentRight;
                    lb_roomPrice.text = [dict objectForKey:@"roomPrice"];
                    [cell.contentView addSubview:lb_roomPrice];
                }
                break;
            case 2:
                cell.textLabel.text = @"包间用时";
                if (!lb_roomHour) {
                    lb_roomHour = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 40)];
                    lb_roomHour.textColor = [UIColor darkGrayColor];
                    lb_roomHour.font = font;
                    lb_roomHour.backgroundColor = [UIColor clearColor];
                    lb_roomHour.textAlignment = NSTextAlignmentRight;
                    lb_roomHour.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"roomHour"] ];
                    [cell.contentView addSubview:lb_roomHour];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text = @"包间费用";
                if (!lb_perHourPrice) {
                    lb_perHourPrice = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 40)];
                    lb_perHourPrice.textColor = [UIColor darkGrayColor];
                    lb_perHourPrice.font = font;
                    lb_perHourPrice.backgroundColor = [UIColor clearColor];
                    lb_perHourPrice.textAlignment = NSTextAlignmentRight;
                    lb_perHourPrice.text = [dict objectForKey:@"perHourPrice"];
                    [cell.contentView addSubview:lb_perHourPrice];
                }
                break;
            default:
                break;
        }
    }
    else if (2 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"折扣";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (!tf_discount) {
                    tf_discount = [[UITextField alloc] initWithFrame:CGRectMake(190, 2, 100, 40)];
                    tf_discount.textColor = [UIColor darkGrayColor];
                    tf_discount.font = font;
                    tf_discount.backgroundColor = [UIColor clearColor];
                    tf_discount.textAlignment = NSTextAlignmentRight;
                    tf_discount.delegate = self;
                    tf_discount.returnKeyType = UIReturnKeyDone;
                    tf_discount.text = [dict objectForKey:@"discount"];
                    [cell.contentView addSubview:tf_discount];

                }
                break;
            case 1:
                cell.textLabel.text = @"总金额";
                cell.textLabel.textColor = dayiColor;
                if (!lb_totalAmount) {
                    lb_totalAmount = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 40)];
                    lb_totalAmount.textColor = dayiColor;
                    lb_totalAmount.font = font;
                    lb_totalAmount.backgroundColor = [UIColor clearColor];
                    lb_totalAmount.textAlignment = NSTextAlignmentRight;
                    lb_totalAmount.text = [dict objectForKey:@"totalAmount"];
                    [cell.contentView addSubview:lb_totalAmount];
                }
                break;
            case 2:
                cell.textLabel.text = @"支付方式";
                if (!lb_paymentType) {
                    lb_paymentType = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 40)];
                    lb_paymentType.textColor = [UIColor darkGrayColor];
                    lb_paymentType.font = font;
                    lb_paymentType.backgroundColor = [UIColor clearColor];
                    lb_paymentType.textAlignment = NSTextAlignmentRight;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    [cell.contentView addSubview:lb_paymentType];
                }
                break;
            default:
                break;
        }
    }

    cell.textLabel.font = font;
    if (![cell.textLabel.text isEqualToString:@"总金额"]) {
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return head_view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 100;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        return footView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            srcType = 1;
        }
        else if (2 == indexPath.row){
            srcType = 2;
        }
        [self action];
    }
    else if (2 == indexPath.section){
        if (2 == indexPath.row) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            PaymentTypeListViewController *ctrl = [[PaymentTypeListViewController alloc] initWithStyle:UITableViewStylePlain];
            ctrl.srcDelegate = self;
            [ctrl setUpBuffer:payArray];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
}
#pragma mark -
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)btn_certain_click:(id)sender
{
    LXActionSheet *as = [[LXActionSheet alloc]initWithTitle:@"确定信息无误?" delegate:self cancelButtonTitle:@"取消操作" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [as showInView:self.view];

}

- (void)initFootView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled = YES;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage: [[UIImage imageNamed:@"btn4"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4, 4, 4)] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(16.0f, 30, 288, 44);
    [btn1 addTarget:self action:@selector(btn_certain_click:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"确定" forState:UIControlStateNormal];
    [footView addSubview:btn1];
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,CHECKOUT_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:self.oid forKey:@"orderId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",json);
    
    //login fail
	if (![[json objectForKey:@"success"] boolValue])
    {
        NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"] );
        
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        [self.tableView reloadData];
        return;
    }
    
    dict = [json objectForKey:@"data"];
    payArray = [dict objectForKey:@"payArray"];
    [self initHeadView];
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)loadRoomList
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, ROOM_LIST_URL];
    
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadRoomList:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
    
}

- (void) onLoadRoomList: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"获取数据失败!"];
		return;
	}
    [SVProgressHUD dismiss];
    roomArray = [[[json objectForKey:@"data"] objectForKey:@"data"] objectForKey:@"records"];
}

- (void) confirmCheckout
{
    [SVProgressHUD showWithStatus:@"确认订单中"];
    
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,CONFIRM_CHECKOUT_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:self.oid forKey:@"orderId"];
    
    [req setParam:lb_detailAmount.text forKey:@"detailAmount"];
	[req setParam:roomId forKey:@"roomId"];
	[req setParam:lb_roomPrice.text forKey:@"roomPrice"];
	[req setParam:lb_roomHour.text forKey:@"roomHour"];
	[req setParam:lb_perHourPrice.text forKey:@"perHourPrice"];
	[req setParam:tf_discount.text forKey:@"discount"];
	[req setParam:lb_totalAmount.text forKey:@"totalAmount"];
	[req setParam:paymentType forKey:@"paymentType"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onConfirmCheckout:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onConfirmCheckout: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    
    NSLog(@"%@",json);
    
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
    }
    else{
        [SVProgressHUD dismissWithSuccess:@"结账成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderDidChange" object:self];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5f];
    }
}

- (void) initHeadView
{
    lb_orderName.text = [dict objectForKey:@"orderName"];
    lb_userName.text = [dict objectForKey:@"userName"];
    [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dict objectForKey:@"avatarId"]]];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *post_date;
    if ([dict objectForKey:@"orderDate"]) {
        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"orderDate"] doubleValue]/1000]];
        lb_time.text = post_date;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([textField.text floatValue] > 1.0) {
        [self.view.window makeToast:@"折扣格式不正确!"];
    }
    else{
        
        [self calculateTotal];
    }
    
    return YES;
}

#pragma mark -

- (void)btn_certain_tmp_click:(id)sender
{
    UIPickerView *pickerView = (UIPickerView *)[actionSheet viewWithTag:102];
	[self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
    NSUInteger row = [pickerView selectedRowInComponent:0];
    if (srcType == 1) {
        NSDictionary *dic = [roomArray objectAtIndex:row];
        lb_roomName.text = [dic objectForKey:@"roomName"];
        roomId = [dic objectForKey:@"roomId"];
        lb_roomPrice.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"perHourPrice"] ];
    }
    else {
        lb_roomHour.text = [NSString stringWithFormat:@"%d",row+1];
    }
    
    lb_perHourPrice.text = [NSString stringWithFormat:@"%.2f",[lb_roomHour.text floatValue]*[lb_roomPrice.text floatValue]];
    [self calculateTotal];
 
}

- (void)btn_cancel_tmp_click:(id)sender
{
    [self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
}

- (void) action
{
	NSString *title =  @"\n\n\n\n\n\n\n\n\n\n\n\n\n";
	actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	actionSheet.tag = 103;
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    
    if (srcType == 1) {
        btn_title.title = @"选择包间";
    }
    else {
        btn_title.title = @"选择包间用时";
    }
	UIPickerView *pickerView = [[UIPickerView alloc] init];
	pickerView.frame = CGRectMake(0.0f,40.0f, 320.0f, 216.0f);
	pickerView.tag = 102;
	pickerView.delegate = self;
	pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
	pickerView.showsSelectionIndicator = YES;
	[actionSheet addSubview:pickerView];
	[actionSheet addSubview:tool_bar];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (srcType == 1) {
        return [roomArray count];
    }
    return 12;
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (srcType == 1) {
        NSDictionary *dic = [roomArray objectAtIndex:row];
        NSString *name = [dic objectForKey:@"roomName"];
        return name;
    }
    else {
        
        return [NSString stringWithFormat:@"%d",row+1];
    }

    return nil;
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)calculateTotal
{
    lb_totalAmount.text = [NSString stringWithFormat:@"%.2f",([lb_detailAmount.text floatValue]+[lb_perHourPrice.text floatValue])*[tf_discount.text floatValue]];

}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        if ([paymentType length] == 0) {
            [self.view.window makeToast:@"请先选择支付方式!"];
            return;
        }
        [self confirmCheckout];
    }
}

- (void)didClickOnDestructiveButton
{
    
}

- (void)didClickOnCancelButton
{
    
}

- (void)popViewController
{
    OrderStoreDetailViewController *ctrl = [[OrderStoreDetailViewController alloc] initWithNibName:@"OrderStoreDetailViewController" bundle:nil];
    ctrl.oid = self.oid;
    ctrl.type = 1;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    return;
}

- (void)PaymentTypeListViewController:(PaymentTypeListViewController *)ctrl didSelectedIndex:(NSUInteger)index
{
    NSDictionary *dic = [payArray objectAtIndex:index];
    lb_paymentType.text = [dic objectForKey:@"text"];
    paymentType = [dic objectForKey:@"value"];
}

@end
