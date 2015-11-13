//
//  OrderDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "Toast+UIView.h"

@interface OrderDetailViewController ()
@property(nonatomic,strong)IBOutlet UIView *head_view;
@property(nonatomic,strong)IBOutlet UIImageView *im_avatar;
@property(nonatomic,strong)IBOutlet UIImageView *im_status;
@property(nonatomic,strong)IBOutlet UILabel *lb_name;
@property(nonatomic,strong)IBOutlet UILabel *lb_time;
@property(nonatomic,strong)IBOutlet UILabel *lb_orderName;
@property(nonatomic,strong)IBOutlet UIButton *btn_flag;

@end

@implementation OrderDetailViewController
@synthesize oid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单详情";
    UIBarButtonItem *btn_cancel;
    
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_certain = [[UIBarButtonItem alloc] initWithTitle:@"确认"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_certain_click:)];
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
        [tel setTitle:@"确认" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_certain_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_certain = [[UIBarButtonItem alloc] initWithCustomView:tel];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    [self initFootView];
    self.navigationItem.leftBarButtonItem = btn_cancel;
    [self loadData];
}

- (void)dealloc
{
    self.view=nil;
    self.head_view = nil;
    self.im_avatar = nil;
    self.lb_name = nil;
    self.lb_time = nil;
    self.btn_flag = nil;
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
    
    if ([[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])
        return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (2 == section) {
        return 4;
    }
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

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if ([[dict objectForKey:@"unitName"] length])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"数量(%@)",[dict objectForKey:@"unitName"] ];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"quantity"]];
                }
                else
                {
                    cell.textLabel.text = @"数量(件)";
                    if ([[dict objectForKey:@"offerPieceQty"] integerValue])
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"offerPieceQty"] ];
                }

                break;
            case 1:
                if ([[dict objectForKey:@"unitName"] length])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"价格(%@)",[dict objectForKey:@"unitName"] ];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"incomeAmount"]];
                }
                else
                {
                    cell.textLabel.text = @"价格(件)";
                    if ([[dict objectForKey:@"piecePrice"] integerValue])
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"piecePrice"]];
                }
                break;
            case 2:
                cell.textLabel.text = @"总价";
                if ([dict count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"receivableAmount"]];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"下单人";
                if ([dict count])
                    cell.detailTextLabel.text = [dict objectForKey:@"userId"];
                break;
            case 1:
                cell.textLabel.text = @"执行人";
                if (lb_executor) {
                    [lb_executor removeFromSuperview];
                    lb_executor = nil;
                }

                lb_executor = [[UILabel alloc] initWithFrame:CGRectMake(IOS7?200:180,5, 90, 30)];
                lb_executor.textAlignment = NSTextAlignmentRight;
                lb_executor.textColor = [UIColor colorWithRed:78.0f/255.0f green:201.0f/255.0f blue:0.0f alpha:1.0f];
                lb_executor.font = [UIFont systemFontOfSize:13.0f];
                lb_executor.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lb_executor];
                
                if (executorName)
                {
                    lb_executor.text = executorName;
                }
                else if ([[dict objectForKey:@"executeUserId"] length]) {
                    lb_executor.text = [dict objectForKey:@"executeUserId"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    lb_executor.frame = CGRectMake(IOS7?215:195,5, 90, 30);
                }
                else if([[dict objectForKey:@"status"] isEqualToString:@"Unconfirmed"])
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    lb_executor.text = @"选择执行人";
                }
                break;
            case 2:
                cell.textLabel.text = @"地址";
                if ([dict count])
                    cell.detailTextLabel.text = [dict objectForKey:@"obtainAddress"];
                cell.detailTextLabel.numberOfLines = 2;
                break;
            default:
                break;
        }
    }
    
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"转账开户行";
                if ([dict count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"bank"]];
                break;
            case 1:
                cell.textLabel.text = @"转账开户名";
                if ([dict count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"accountName"]];
                break;
            case 2:
                cell.textLabel.text = @"转账账户";
                if ([dict count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"account"]];
                break;
            case 3:
                cell.textLabel.text = @"转账备注";
                if ([dict count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"bankRemark"]];
                break;
            default:
                break;
        }
    }

    cell.textLabel.font = font;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    return cell;
}


#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return self.head_view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 110;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section && 1 == indexPath.row && [[dict objectForKey:@"status"] isEqualToString:@"Unconfirmed"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ExecutorListViewController *ctrl = [[ExecutorListViewController alloc] initWithStyle:UITableViewStylePlain];
        ctrl.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((1 == section && [[dict objectForKey:@"status"] isEqualToString:@"Unconfirmed"]) ||
        (2 == section && [[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])) {
        return 150;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((1 == section && [[dict objectForKey:@"status"] isEqualToString:@"Unconfirmed"])||
        (2 == section && [[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])) {
        return footView;
    }
    return nil;
}

#pragma mark -
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)btn_certain_click:(id)sender
{
    if([[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])
    {
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"确定转账信息无误?" delegate:self cancelButtonTitle:@"取消操作" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];

    }
    else
    {
        if ([eid length] == 0) {
            [self.view.window makeToast:@"还没有选择执行人!"];
            return;
        }
        [self firmOrder];
    }
    
}

- (void)initHeadView
{
    NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dict objectForKey:@"avatarId"]];
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
    
    self.lb_name.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"name"],[dict objectForKey:@"productPici"]];
    
    self.lb_orderName.text = [NSString stringWithFormat:@"订单编号:%@",[dict objectForKey:@"orderName"] ];
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"createTime"] doubleValue]/1000]];
    self.lb_time.text = post_date;

    if (![[dict objectForKey:@"status"] length] ) {
        self.btn_flag.hidden = YES;
    }
    else
    {
        if ([[dict objectForKey:@"status"] isEqualToString:@"New"]) {
            self.im_status.image = [UIImage imageNamed:@"order_New"];
        }
        else if ([[dict objectForKey:@"status"] isEqualToString:@"Unconfirmed"])
        {
            self.im_status.image = [UIImage imageNamed:@"order_uncomfired"];
        }
        else if ([[dict objectForKey:@"status"] isEqualToString:@"Confirmed"])
        {
            if ([[dict objectForKey:@"payStatus"] isEqualToString:@"UnPay"]) {
                self.im_status.image = [UIImage imageNamed:@"order_Confirmed"];
            }
            else if ([[dict objectForKey:@"payStatus"] isEqualToString:@"Paying"]){
                self.im_status.image = [UIImage imageNamed:@"fkz"];
            }
            else if ([[dict objectForKey:@"payStatus"] isEqualToString:@"Payed"]){
                self.im_status.image = [UIImage imageNamed:@"yfk"];
            }
            else if ([[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"]){
                self.im_status.image = [UIImage imageNamed:@"yzz"];
            }
        }
        else if ([[dict objectForKey:@"status"] isEqualToString:@"Finished"])
        {
            self.im_status.image = [UIImage imageNamed:@"order_Finished"];
        }
        else if ([[dict objectForKey:@"status"] isEqualToString:@"Canceled"])
        {
            self.im_status.image = [UIImage imageNamed:@"order_canceled"];
            
        }
    }
    

}

- (void)executorListViewDidSelected:(NSDictionary *)dic
{
    executorName = [dic objectForKey:@"name"];
    lb_executor.text = [dic objectForKey:@"name"];
    eid = [dic objectForKey:@"id"];
}

#pragma mark -
- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, ORDER_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    
	[req setParam:self.oid forKey:@"oid"];

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
    NSLog(@"---- %@",json);
    
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];

		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    if ([data count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    
    dict = [NSDictionary dictionaryWithDictionary:data];
    [self initHeadView];
    [self initFootView];

    [self.tableView reloadData];
}

- (void) firmOrder
{
    [SVProgressHUD showWithStatus:@"确认订单中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, FIREM_ORDER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.oid forKey:@"oid"];
    [req setParam:eid forKey:@"eid"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFirm:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];

}

- (void) cancelOrder
{
    [SVProgressHUD showWithStatus:@"确认取消中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, CANCEL_ORDER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.oid forKey:@"orderId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFirm:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
    
}

- (void) confirmTransfer
{
    [SVProgressHUD showWithStatus:@"确认订单中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, CONFIRM_TRANSFER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.oid forKey:@"orderId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFirm:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
    
}


- (void) onFirm: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",json);
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:@"操作失败!" afterDelay:1.5f];
		return;
	}
    
    if ([[json objectForKey:@"data"] objectForKey:@"msg"]) {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderDidChange" object:self];
    [SVProgressHUD dismissWithSuccess:@"操作成功!" afterDelay:1.5f];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.8];

}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

#pragma mark -

- (void)initFootView
{
    if (footView) {
        footView = nil;
    }
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled = YES;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage: [[UIImage imageNamed:@"btn3"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4, 4, 4)] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(16.0f, 30, 288, 44);
    [btn1 addTarget:self action:@selector(btn_certain_click:) forControlEvents:UIControlEventTouchUpInside];
    if([[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])
    {
        [btn1 setTitle:@"确认转账" forState:UIControlStateNormal];
    }
    else
    {
        [btn1 setTitle:@"确认订单" forState:UIControlStateNormal];
    }
    [footView addSubview:btn1];
    
    if(![[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage: [[UIImage imageNamed:@"btn4"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4, 4, 4)] forState:UIControlStateNormal];
        btn.frame = CGRectMake(16.0f, 88, 288, 44);
        [btn addTarget:self action:@selector(btn_del_click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"取消订单" forState:UIControlStateNormal];
        [footView addSubview:btn];
    }
}

- (void)btn_del_click:(id)sender
{
    LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"确定取消订单?" delegate:self cancelButtonTitle:@"取消操作" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    [actionSheet showInView:self.view];

}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        if([[dict objectForKey:@"payStatus"] isEqualToString:@"Transfer"])
        {
            [self confirmTransfer];
        }
        else
        {
            [self cancelOrder];
        }
    }
}

- (void)didClickOnDestructiveButton
{
    
}

- (void)didClickOnCancelButton
{
    
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

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
