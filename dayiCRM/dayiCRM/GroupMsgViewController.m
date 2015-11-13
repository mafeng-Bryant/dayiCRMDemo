//
//  GroupMsgViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-9.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "GroupMsgViewController.h"
#import "GroupDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "HistoryMsgListViewController.h"
#import "ActivityListViewController.h"

@interface GroupMsgViewController ()<ActivityListViewControllerDelegate>

@end

@implementation GroupMsgViewController
@synthesize gid;
@synthesize gName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"群发信息";
    UIBarButtonItem *btn_cancel;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
        
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    UIImage *bg = [UIImage imageNamed:@"btn3"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
    [btn_send setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    type = @"weixin";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    UIFont *font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = font;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"群名称";
            cell.detailTextLabel.text = gName;
            break;
        case 1:
            cell.textLabel.text = @"消息类型";
            if (!lb_type) {
                lb_type = [[UILabel alloc] initWithFrame:CGRectMake(IOS7?200:180,5, 90, 30)];
                lb_type.textAlignment = NSTextAlignmentRight;
                lb_type.textColor = [UIColor darkGrayColor];
                lb_type.font = [UIFont systemFontOfSize:13.0f];
                lb_type.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lb_type];
            }
            if ([type isEqualToString:@"weixin"]) {
                lb_type.text = @"微信";
            }
            else if ([type isEqualToString:@"sms"]){
                lb_type.text = @"短信";
            }
            break;
        case 2:
            cell.textLabel.text = @"查看历史记录";
            break;
        default:
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 262;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.row) {
        GroupDetailViewController *ctrl = [[GroupDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.gid = gid;
        ctrl.gName = gName;
        [self.navigationController pushViewController:ctrl animated:YES];
    
    }
    else if (1 == indexPath.row){
        SendTypeListViewController *ctrl = [[SendTypeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        [self.navigationController presentViewController:nav animated:YES completion:nil];

    }
    else if (2 == indexPath.row){
        HistoryMsgListViewController *ctrl = [[HistoryMsgListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.gid = gid;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btn_pic_click:(id)sender
{
    LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册中选取",@"从相机拍摄"]];
    [actionSheet showInView:self.tableView];
}

- (IBAction)btn_img_click:(id)sender
{
    if (image_data) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageWithData:image_data]];
        iv.frame = CGRectMake(0, 0, 250, 400);
        [self.view showToast:iv];
    }
    else{
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册中选取",@"从相机拍摄"]];
        [actionSheet showInView:self.tableView];
    }
}

- (IBAction)btn_activity_click:(id)sender
{
    ActivityListViewController *ctrl = [[ActivityListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (IBAction)btn_send_click:(id)sender
{
    if (([tx_content.text length] == 0 || [tx_content.text isEqualToString:@"请输入消息内容"])&&
        [image_data length] == 0 && [entityId length] == 0) {
        [self.view.window makeToast:@"还没有输入发送内容!"];
        return;
    }
    
    [SVProgressHUD show];

    if ([image_data length]) {
        [self uploadImage];
    }
    else{
        [self sendMsg];
    }
}

#pragma mark -
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    tx_content.text = nil;
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)sendTypeListViewController:(SendTypeListViewController *)ctrl didSelectedType:(NSString *)Type
{
    [ctrl dismissViewControllerAnimated:YES completion:nil];
    type = Type;
    tx_content.userInteractionEnabled = YES;
    if ([type isEqualToString:@"sms"]) {
        image_data = nil;
        [btn_img setImage:[UIImage imageNamed:@"img43"] forState:UIControlStateNormal];
        btn_img.enabled = NO;
        btn_pic.enabled = NO;
        btn_activity.enabled = NO;
    }
    else{
        btn_img.enabled = YES;
        btn_pic.enabled = YES;
        btn_activity.enabled = YES;

    }
    [self.tableView reloadData];
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *ctrl_img_picker = [[UIImagePickerController alloc] init];
	ctrl_img_picker.delegate = self;
	ctrl_img_picker.allowsEditing = NO;
    
	if (0 == buttonIndex)
	{
		ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		ctrl_img_picker.allowsEditing = NO;
        ctrl_img_picker.navigationController.delegate = self;
        [self presentViewController:ctrl_img_picker animated:YES completion:nil];
        
	}
	else if (1 == buttonIndex)
	{
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
		{
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
														 message:@"无法使用相机。可能此机器没有配备照相设备。"
														delegate:self
											   cancelButtonTitle:@"确定"
											   otherButtonTitles:nil];
			[av show];
			return;
		}
		
		ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
		ctrl_img_picker.allowsEditing = NO;
        [self presentViewController:ctrl_img_picker animated:YES completion:nil];
	}
	
}

- (void)didClickOnDestructiveButton
{
}

- (void)didClickOnCancelButton
{
}

#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *img = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	
	if (UIImagePickerControllerSourceTypeCamera == picker.sourceType)
	{
		UIImageWriteToSavedPhotosAlbum(img, nil, nil , nil);
	}
	
	CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
	CGFloat scale = 1.0f;
	
	if (rect.size.width > 1000.0f || rect.size.height > 1000.0f)
	{
		if (rect.size.width > rect.size.height)
		{
			scale = 1000.0f / rect.size.width;
		}
		else
		{
			scale = 1000.0f / rect.size.height;
		}
	}
	
	UIGraphicsBeginImageContext(rect.size);
	UIGraphicsBeginImageContextWithOptions(rect.size, YES, scale);
	[img drawInRect:rect];
	UIImage *new_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    [btn_img setImage:new_img forState:UIControlStateNormal];
	image_data = UIImageJPEGRepresentation(new_img, 0.2f);
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

#pragma mark loadData

- (void) uploadImage
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPLOAD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setData:image_data forKey:@"file"];
	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUploadImage:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onUploadImage: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    if ([json objectForKey:@"pictureId"]) {
        pictureId =[json objectForKey:@"pictureId"];
    }
    
    [self sendMsg];

}

- (void) sendMsg
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_GROUPMSG_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:[token getProperty:@"id"] forKey:@"userId"];
    [req setParam:gid forKey:@"groupId"];
    [req setParam:type forKey:@"sendType"];

    if ([tx_content.text length] && ![tx_content.text isEqualToString:@"请输入消息内容"]) {
        [req setParam:tx_content.text forKey:@"sendContent"];
    }
    else{
        [req setParam:@"" forKey:@"sendContent"];
    }
    
    if (pictureId) {
        [req setParam:pictureId forKey:@"pictureId"];
    }
    else{
        [req setParam:@"" forKey:@"pictureId"];
    }
    
    if (entityId) {
        [req setParam:entityId forKey:@"activityId"];
        [req setParam:@"" forKey:@"sendContent"];
    }

	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSendMsg:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onSendMsg: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    [SVProgressHUD showSuccessWithStatus:@"发送成功!" duration:1.0f];
}



- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络请求失败!" duration:1.0f];
    
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)activityListViewControllerDidSelected:(NSDictionary *)activity
{
    NSLog(@"%@",activity);
    image_data = nil;
    [btn_img setImage:[UIImage imageNamed:@"img43"] forState:UIControlStateNormal];
    btn_img.enabled = NO;
    btn_pic.enabled = NO;
    tx_content.userInteractionEnabled = NO;
    type = @"weixin";
    tx_content.text = nil;
    pictureId = nil;
    [self.tableView reloadData];
    entityId = [activity objectForKey:@"entityId"];
    tx_content.text = [NSString stringWithFormat:@"[活动]:%@",[activity objectForKey:@"name"]];
}


@end
