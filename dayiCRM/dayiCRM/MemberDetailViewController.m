//
//  MemberDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "OrderListCell.h"
#import "CompileMemberMsgViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "Toast+UIView.h"
#import "ClickImage.h"

@interface MemberDetailViewController ()

@property(nonatomic,strong)IBOutlet UIView *head_view;
@property(nonatomic,strong)IBOutlet UILabel *lb_nickname;
@property(nonatomic,strong)IBOutlet UILabel *lb_weichatNo;
@property(nonatomic,strong)IBOutlet UIView *foot_view;
@property(nonatomic,strong)IBOutlet UIButton *btn_sender;
@property(nonatomic,strong)IBOutlet ClickImage *im_avatar;
@property(nonatomic,strong)IBOutlet UIImageView *im_gender;

@end

@implementation MemberDetailViewController
@synthesize uid,type;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详细资料";
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_edit;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_edit = [[UIBarButtonItem alloc] initWithTitle:@"编辑"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_edit_click:)];
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
        
        UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
        [tel setTitle:@"编辑" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_edit_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_edit = [[UIBarButtonItem alloc] initWithCustomView:tel];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_edit;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)dealloc
{
    self.view=nil;
    buffer = nil;
    dict = nil;
    history = nil;
    self.head_view = nil;
    self.lb_nickname = nil;
    self.lb_weichatNo = nil;
    self.foot_view = nil;
    self.btn_sender = nil;
    self.im_avatar = nil;

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
    return 1 + [history count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"empty_cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cell_id];
    }
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];

    if (indexPath.section == 0) {
        if (!IOS7){
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

        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = [dict objectForKey:@"mobile"];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            case 1:
                cell.textLabel.text = @"备注";
                cell.detailTextLabel.text = [dict objectForKey:@"description"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                cell.textLabel.text = @"邮箱";
                cell.detailTextLabel.text = [dict objectForKey:@"email"];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            case 3:
                cell.textLabel.text = @"新浪微博";
                cell.detailTextLabel.text = [dict objectForKey:@"sinaWeibo"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 4:
                cell.textLabel.text = @"腾讯微博";
                cell.detailTextLabel.text = [dict objectForKey:@"tencentWeibo"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            default:
                break;
        }
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = font;
        cell.textLabel.textColor = [UIColor blackColor];
        return cell;
    }
    else {
        NSString *CellIdentifier = @"OrderListCell";
        NSDictionary *dic = [history objectAtIndex:indexPath.section - 1];
        
        OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell)
        {
            UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
            
            cell = (OrderListCell *)uc.view;
            [cell setContent:dic];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 80;
    }
    else if (1 == section){
        return 60;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return self.head_view;
    }
    else if (1 == section){
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 60)];
        lb.text = @"    历史订单记录";
        lb.textColor = [UIColor blackColor];
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont systemFontOfSize:17.0f];
        return lb;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (0 == section && ([[dict objectForKey:@"status"] intValue] == 0 || [[dict objectForKey:@"status"] intValue] == 1)) {
        return self.foot_view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section && ([[dict objectForKey:@"status"] intValue] == 0 || [[dict objectForKey:@"status"] intValue] == 1)) {
        return 88;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >=1) {
        return 142;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndex = indexPath.row;
    if (0 == indexPath.section && 0 == indexPath.row) {
        if (![[dict objectForKey:@"mobile"] length]) {
            return;
        }
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"拨打电话?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[[dict objectForKey:@"mobile"]]];
        [actionSheet showInView:self.view];

    }
    if (0 == indexPath.section && 2 == indexPath.row) {
        if (![[dict objectForKey:@"email"] length]) {
            return;
        }
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"发送邮件?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[[dict objectForKey:@"email"]]];
        [actionSheet showInView:self.view];
    }
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_edit_click:(id)sender
{
    CompileMemberMsgViewController *ctrl = [[CompileMemberMsgViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.dict = dict;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)initHeadView
{
    if ([[dict objectForKey:@"name"] length]) {
        self.lb_nickname.text = [dict objectForKey:@"name"];
    }
    else if ([[dict objectForKey:@"nickName"] length])
    {
        self.lb_nickname.text = [dict objectForKey:@"nickName"];
    }
    
    if ([[dict objectForKey:@"gender"] integerValue] == 1) {
        
        self.im_gender.image = [UIImage imageNamed:@"Contact_Male"];
    }
    else if ([[dict objectForKey:@"gender"] integerValue] == 2){
        self.im_gender.image = [UIImage imageNamed:@"Contact_Female"];
    }
    
    NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dict objectForKey:@"pictureId"]];
	UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
	if (avatar_im)
	{
		[self.im_avatar setImage:avatar_im];
	}
	else
	{
		RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
															 parentView:self.im_avatar
															   delegate:self
													   defaultImageName:@"default_pic_avatar"];
		
		[self.im_avatar setImage:r_img];
	}
    
    self.im_avatar.canClick = YES;

}

- (void)initFooterView
{
    UIImage *bg = [UIImage imageNamed:@"btn3"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
    [self.btn_sender setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    [self.btn_sender setTitle:[[dict objectForKey:@"status"] intValue]?@"再次发送邀请":@"发送邀请" forState:UIControlStateNormal];
    [self.btn_sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)btn_sender_click:(id)sender
{
    [self inviteMember];
}

#pragma mark -
#pragma mark loadDate

- (void)loadData
{
    if ([dict count] == 0)
        [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MEMBER_INFO_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.uid forKey:@"id"];
    if ([type length]) {
        [req setParam:type forKey:@"type"];
    }
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
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
    NSLog(@"%@",json);
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);

	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    if ([data count] == 0) {
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    
    
    dict = [NSDictionary dictionaryWithDictionary:data];
    if ([[dict objectForKey:@"history"] isKindOfClass:[NSArray class]])
        history = [dict objectForKey:@"history"];
    [self initHeadView];
    [self initFooterView];
    [self.tableView reloadData];
}
- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)inviteMember
{
    [SVProgressHUD showWithStatus:@"邀请中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, INVITE_MEMBER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:[dict objectForKey:@"mobile"] forKey:@"mobile"];
    [req setParam:[dict objectForKey:@"name"] forKey:@"name"];
    [req setParam:self.uid forKey:@"id"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onInvited:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onInvited: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismiss];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    if ([[data objectForKey:@"operationState"] isEqualToString:@"success"]) {
        [SVProgressHUD dismissWithSuccess:@"邀请成功" afterDelay:1.0f];
    }
    else
    {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[data objectForKey:@"msg"]];
    }
}


#pragma mark -
#pragma mark RRRemoteImageDelegate

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
	static UIImage *empty_image = nil;
	
	if (nil == empty_image)
	{
		empty_image = [UIImage imageNamed:@"default_pic_avatar"];
	}
	
	[self.im_avatar setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	[self.im_avatar setImage:newImage];
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}


#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        if (0 == selectedIndex) {
            if ([dict objectForKey:@"mobile"]) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@",[dict objectForKey:@"mobile"]]]];
            }
        }
        else if (2 == selectedIndex){
            if ([dict objectForKey:@"email"]) {
                [self sendmail];
            }

        }
    }
}

- (void)didClickOnDestructiveButton
{
    
}

- (void)didClickOnCancelButton
{
}

- (void)sendmail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if ([mailClass canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        picker.navigationBar.tintColor = [UIColor whiteColor];
        [picker.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        [picker setToRecipients:@[[dict objectForKey:@"email"]]];
        NSString *emailBody = @"";
        [picker setMessageBody:emailBody isHTML:NO];
        
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate
- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *msg;
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            msg = @"发送取消";
            break;
        case MessageComposeResultSent:
            msg = @"发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MessageComposeResultFailed:
            msg = @"发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
