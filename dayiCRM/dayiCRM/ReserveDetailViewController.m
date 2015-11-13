//
//  ReserveDetailViewController.m
//  dayiCRM
//
//  Created by Leo on 14/11/5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ReserveDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface ReserveDetailViewController ()

@end

@implementation ReserveDetailViewController
@synthesize srcType, reserveId,dataDic;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =srcType?@"包间详情":@"包间预定";
	UIBarButtonItem *btn_cancel;
	UIBarButtonItem *back;
	if (IOS7) {
		btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
		back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backClick)];
	}
	else
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
		[btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
		[btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
		btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
		
		self.tableView.separatorColor = [UIColor clearColor];
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.navigationItem.hidesBackButton = YES;
		self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
	}
	self.navigationItem.leftBarButtonItem = btn_cancel;
	if (srcType)
		[self loadData];
    if (dataDic){
        [self initHeadView];
        btn_certain_tmp = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btn_certain_tmp_click:)];
        btn_cancel_tmp = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_tmp_click:)];
        btn_title = [[UIBarButtonItem alloc]initWithTitle:@"选择开始时间" style:UIBarButtonItemStylePlain target:self action:nil];
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *arr = @[back,flex,btn_title,flex,btn_certain_tmp];
        tool_bar_tmp = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        tool_bar_tmp.barStyle = UIBarStyleDefault;
        tool_bar_tmp.translucent = YES;
        [tool_bar_tmp setItems:arr animated:NO];
    }
}

- (void) backClick
{
	[actionSheet dismissWithClickedButtonIndex: 0 animated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (0 == section) {
		return 5;
	}
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cell_id = @"cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
	}
	
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
	
	CGRect textFrame = CGRectMake(200, 5, 100, 34);
	UIFont *textFont = [UIFont systemFontOfSize:13];

	if(0 == indexPath.section){
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"开始时间";
				if (!lb_startTime) {
					lb_startTime = [[UILabel alloc] initWithFrame:textFrame];
					lb_startTime.textAlignment = NSTextAlignmentRight;
					lb_startTime.font = textFont;
					lb_startTime.backgroundColor = [UIColor clearColor];
					[cell.contentView addSubview:lb_startTime];
				}
				if (dataDic && [dataDic objectForKey:@"startTime"]) {
					NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
					[date_formatter setDateFormat:@"MM-dd HH:mm"];
					NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"startTime"] doubleValue]/1000]];
					lb_startTime.text = start_date;
				}
				break;
			case 1:
				cell.textLabel.text = @"结束时间";
				if (!lb_endTime) {
					lb_endTime = [[UILabel alloc] initWithFrame:textFrame];
					lb_endTime.textAlignment = NSTextAlignmentRight;
					lb_endTime.font = textFont;
					lb_endTime.backgroundColor = [UIColor clearColor];
					[cell.contentView addSubview:lb_endTime];
				}
				if (dataDic && [dataDic objectForKey:@"endTime"]) {
					NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
					[date_formatter setDateFormat:@"MM-dd HH:mm"];
					NSString *end_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"endTime"] doubleValue]/1000]];
					lb_endTime.text = end_date;
				}
				break;
			case 2:
				cell.textLabel.text = @"联系人";
				if(!tf_contact){
					tf_contact = [[UITextField alloc] initWithFrame:textFrame];
					tf_contact.delegate = self;
					tf_contact.font = textFont;
					tf_contact.backgroundColor = [UIColor clearColor];
					tf_contact.textAlignment = NSTextAlignmentRight;
					tf_contact.returnKeyType = UIReturnKeyNext;
					[cell.contentView addSubview:tf_contact];
					if (srcType == 1) {
						tf_contact.enabled = NO;
					}
				}
				if (dataDic && [dataDic objectForKey:@"name"]) {
					tf_contact.text = [dataDic objectForKey:@"name"];
				}
				break;
			case 3:
				cell.textLabel.text = @"联系电话";
				if(!tf_mobile){
					tf_mobile = [[UITextField alloc] initWithFrame:textFrame];
					tf_mobile.delegate = self;
					tf_mobile.font = textFont;
					tf_mobile.backgroundColor = [UIColor clearColor];
					tf_mobile.textAlignment = NSTextAlignmentRight;
					tf_mobile.returnKeyType = UIReturnKeyNext;
					[cell.contentView addSubview:tf_mobile];
					if (srcType == 1) {
						tf_mobile.enabled = NO;
					}
				}
				if (dataDic && [dataDic objectForKey:@"mobile"]) {
					tf_mobile.text = [dataDic objectForKey:@"mobile"];
				}
				break;
			case 4:
				cell.textLabel.text = @"备注";
				if(!tf_remark){
					tf_remark = [[UITextField alloc] initWithFrame:textFrame];
					tf_remark.delegate = self;
					tf_remark.font = textFont;
					tf_remark.backgroundColor = [UIColor clearColor];
					tf_remark.textAlignment = NSTextAlignmentRight;
					tf_remark.returnKeyType = UIReturnKeyNext;
					[cell.contentView addSubview:tf_remark];
					if (srcType == 1) {
						tf_remark.enabled = NO;
					}
				}
				if (dataDic && [dataDic objectForKey:@"remark"]) {
					tf_remark.text = [dataDic objectForKey:@"remark"];
				}
				break;
			default:
				break;
		}
	}
	else if (1 == indexPath.section){
		cell.textLabel.text = @"执行人";
		if (!lb_reserveUser) {
			lb_reserveUser = [[UILabel alloc] initWithFrame:CGRectMake(180, 5, 100, 34)];
			lb_reserveUser.textAlignment = NSTextAlignmentRight;
			lb_reserveUser.font = textFont;
			lb_reserveUser.backgroundColor = [UIColor clearColor];
			[cell.contentView addSubview:lb_reserveUser];
			if (srcType == 0) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
			}
		}
		if (dataDic && [dataDic objectForKey:@"reserveUserName"]) {
			lb_reserveUser.text = [dataDic objectForKey:@"reserveUserName"];
		}
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (0 == section) {
		return 89.0f;
	}
	return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (0 == section) {
		return head_view;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (1 == section && srcType == 0) {
		return 89.0f;
	}
	return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if ( 1 == section && srcType == 0) {
		
		UIImage *bg = [UIImage imageNamed:@"btn3"];
		UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
		UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
		[btn_submit setBackgroundImage:stretchableImage forState:UIControlStateNormal];
		return footView;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(0 == srcType){
        if (0 == indexPath.section &&( 0 == indexPath.row || 1 == indexPath.row)) {
            type = indexPath.row;
            [self showDatePicker];
        }
        else if (0 == indexPath.row && 1 == indexPath.section){
            ExecutorListViewController *ctrl = [[ExecutorListViewController alloc] initWithStyle:UITableViewStylePlain];
            ctrl.delegate = self;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)executorListViewDidSelected:(NSDictionary *)dic
{
    lb_reserveUser.text = [dic objectForKey:@"name"];
    reserveUserId = [dic objectForKey:@"id"];
}

#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_submit_click:(id)sender
{
    if([startTime length] == 0){
        [self.view makeToast:@"还没选择开始时间"];
        return;
    }
    if([endTime length] == 0){
        [self.view makeToast:@"还没选择结束时间"];
        return;
    }
    if([startTime longLongValue] > [endTime longLongValue]){
        [self.view makeToast:@"开始时间不能大于结束时间"];
        return;
    }
    if ([tf_contact.text length] == 0) {
        [self.view makeToast:@"还没有填写联系人"];
        return;
    }
    if ([tf_mobile.text length] == 0) {
        [self.view makeToast:@"还没有电话"];
        return;
    }
	
	if (tf_mobile.text.length != 11 && tf_mobile.text.length != 7)
	{
		[self.view makeToast:@"电话号码格式不正确"];
	}
	
    if ([reserveUserId length] == 0) {
        [self.view makeToast:@"还没有选择执行人"];
        return;
    }

    [self updata];
}

- (void)initHeadView
{
	[im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dataDic objectForKey:@"avatarId"]]];
	lb_roomName.text = [dataDic objectForKey:@"roomName"];
	lb_roomPrice.text = [NSString stringWithFormat:@"包间价格:  %@元/小时",[dataDic objectForKey:@"perHourPrice"]];
}

#pragma mark - loadData
- (void)loadData
{
	[self.view makeToastActivity];
	RRToken *token = [RRToken getInstance];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,RESERVE_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:reserveId forKey:@"id"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
	[self.view hideToastActivity];
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	NSLog(@"%@",json);
	NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
	
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
		[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		[self.tableView reloadData];
		return;
	}
	
	if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
		[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
	
	dataDic = [json objectForKey:@"data"];
	[self initHeadView ];
	[self.tableView reloadData];
}


- (void)updata
{
    [SVProgressHUD showWithStatus:@"上传数据中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,ADD_ROOM_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:[dataDic objectForKey:@"roomId"] forKey:@"roomId"];
    [req setParam:startTime forKey:@"startTime"];
    [req setParam:endTime forKey:@"endTime"];
    if (tf_remark.text) {
        [req setParam:tf_remark.text forKey:@"remark"];
    }
    [req setParam:tf_mobile.text forKey:@"mobile"];
    [req setParam:tf_contact.text forKey:@"name"];
    [req setParam:reserveUserId forKey:@"reserveUserId"];

    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUpdata:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onUpdata: (NSNotification *)notify
{
    RRLoader *loader = (RRLoader *)[notify object];
    
    NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",json);
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        [self.tableView reloadData];
        return;
    }
    
    if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reserveDidAdd" object:nil];
    [SVProgressHUD showSuccessWithStatus:@"预订成功"];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0f];
}

- (void) onLoadFail: (NSNotification *)notify
{
	[SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_cancel_tmp_click:(id)sender
{
    [self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
}


- (void)btn_certain_tmp_click:(id)sender
{
    [self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc] init];
    [formatterDay setDateFormat:@"MM-dd HH:mm"];
    
    if (actionSheet.tag == 50)
    {
        lb_startTime.text = [formatterDay stringFromDate:datePicker.date];
        startTime = [NSString stringWithFormat:@"%ld", (long)[datePicker.date timeIntervalSince1970]];
    }
    
    if (actionSheet.tag == 51)
    {
        lb_endTime.text = [formatterDay stringFromDate:datePicker.date];
        endTime = [NSString stringWithFormat:@"%ld", (long)[datePicker.date timeIntervalSince1970]];
    }
    
}

- (void)showDatePicker
{
    if (IOS8){
        UIDatePicker *datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(-10.0f,0.0f, 320.0f, 216.0f)];
        NSLocale *curLocal = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"] ;
        datePicker.locale = curLocal;
        datePicker.tag = 101;
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.backgroundColor = [UIColor clearColor];
        
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        NSString *cancelButtonTitle = @"取消";
        NSString *destructiveButtonTitle = @"确定";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController.view addSubview:datePicker];
        alertController.view.tag = 50 + type;
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
        }];
        
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            UIDatePicker *datePicker = (UIDatePicker *)[alertController.view viewWithTag:101];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDateFormatter *formatterDay = [[NSDateFormatter alloc] init];
            [formatterDay setDateFormat:@"MM-dd HH:mm"];
            if (alertController.view.tag == 50)
            {
                lb_startTime.text = [formatterDay stringFromDate:datePicker.date];
                startTime = [NSString stringWithFormat:@"%ld000", (long)[datePicker.date timeIntervalSince1970]];
            }
            
            if (alertController.view.tag == 51)
            {
                lb_endTime.text = [formatterDay stringFromDate:datePicker.date];
                endTime = [NSString stringWithFormat:@"%ld000", (long)[datePicker.date timeIntervalSince1970]];
            }
        }];
        
        //        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:destructiveAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n\n" ;
    actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self  cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    actionSheet.tag = 50 + type;
    switch (type)
    {
        case 0:
            btn_title.title = @"选择开始时间";
            break;
        case 1:
            btn_title.title = @"选择结束时间";
            break;
        default:
            break;
    }
    [actionSheet showInView:self.view.window];
    UIDatePicker *datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f,40.0f, 320.0f, 216.0f)];
    NSLocale *curLocal = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"] ;
    datePicker.locale = curLocal;
    datePicker.tag = 101;
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.backgroundColor = [UIColor whiteColor];
    
    [actionSheet addSubview:datePicker];
    [actionSheet addSubview:tool_bar_tmp];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate

//判断手机号码

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
	if (textField == tf_mobile && range.length == 0 && string.length > 0 )
	{
		NSInteger num = [string integerValue];
		if (textField.text.length > 11)
		{
			return NO;
			
		}
		else{
					if (num >= 0 && num <= 9)
					{
						return YES;
					}
					else{
							return NO;
						}

		}
		
	}
		else{
			return YES;
		}
		

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:tf_contact]){
        [tf_mobile becomeFirstResponder];
    }
    else if([textField isEqual:tf_mobile]){
        [tf_remark becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
     return YES;
}

@end
