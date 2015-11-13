 //
//  AuthDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "AuthDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "AuthDetailViewCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
//#import "AFNetworking.h"


@interface AuthDetailViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
	//数据的缓冲区
	NSMutableData *downloadData;
}
@end

@implementation AuthDetailViewController
@synthesize authId;
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	downloadData = [NSMutableData data];
	
    self.title = @"实名认证";
    UIBarButtonItem *btn_cancel;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
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
	
	//下载数据
	 [self startDownload];
	//[self loadData];
	
	//[self sendRequestData];
	
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(0 == section||section ==2)
        return 1;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (dataDic == nil)
		
	{
			NSString *cell_id = @"empty_cell";
			
			UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
			if (nil == cell)
			{
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
			}
			
			UIFont *font = [UIFont systemFontOfSize:17.0f];
		//	cell.textLabel.text = @"无数据";
			cell.textLabel.font = font;
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = [UIColor clearColor];
			self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			return cell;
		}


	
	
	
	
	
	
	
    if (0 == indexPath.section) {
        NSString *CellIdentifier = @"AuthDetailViewCell";
        AuthDetailViewCell *cell = (AuthDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell)
        {
            UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
            
            cell = (AuthDetailViewCell *)uc.view;
            [cell setContent:dataDic];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    NSString *cell_id = @"empty_cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    if (1 == indexPath.section) {
		
		cell.backgroundColor = nil;
		cell.backgroundColor = [UIColor whiteColor];

		
        switch (indexPath.row) {
            case 0:
				
                cell.textLabel.text = @"身份证正面照片";
				cell.textLabel.textAlignment = NSTextAlignmentLeft;
				
				cell.selectionStyle = UITableViewCellSelectionStyleDefault;
				//cell.backgroundColor = [UIColor whiteColor];
				self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
				
                if(!idCardYImage){
                    idCardYImage = [[ClickImage alloc] initWithFrame:CGRectMake(212, 5, 100,50)];
                    idCardYImage.canClick = YES;
                    NSString *avatar_url = [BASE_URL stringByAppendingString:[dataDic objectForKey:@"idCardY"]];
                    UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
                    if (avatar_im)
                    {
                        [idCardYImage setImage:avatar_im];
                    }
                    else
                    {
                        RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                             parentView:idCardYImage
                                                                               delegate:self
                                                                       defaultImageName:@"default_pic_avatar"];
                        [idCardYImage setImage:r_img];
                    }
                    
                    [cell addSubview:idCardYImage];
                }
                break;
            case 1:
                cell.textLabel.text = @"身份证背面照片";
				cell.textLabel.textAlignment = NSTextAlignmentLeft;
				//cell.backgroundColor = [UIColor whiteColor];


                if(!idCardNImage){
                    idCardNImage = [[ClickImage alloc] initWithFrame:CGRectMake(212, 5, 100, 50)];
                    idCardNImage.canClick = YES;
                    NSString *avatar_url = [BASE_URL stringByAppendingString:[dataDic objectForKey:@"idCardN"]];
                    UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
                    if (avatar_im)
                    {
                        [idCardNImage setImage:avatar_im];
                    }
                    else
                    {
                        RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                             parentView:idCardNImage
                                                                               delegate:self
                                                                       defaultImageName:@"default_pic_avatar"];
                        [idCardNImage setImage:r_img];
                    }
                    
                    [cell addSubview:idCardNImage];
         }
                break;
            default:
                break;
        }
    }
    else if (2 == indexPath.section){
		if (indexPath.row == 0)
		{
			cell.backgroundColor = nil;
			
			cell.backgroundColor = [UIColor whiteColor];
			
			
        cell.textLabel.text = @"银行卡正面照片";
			cell.textLabel.textAlignment = NSTextAlignmentLeft;
			cell.backgroundColor = [UIColor whiteColor];

        if(!copyOfBankCardImage){
            copyOfBankCardImage = [[ClickImage alloc] initWithFrame:CGRectMake(212, 5, 100, 50)];
            copyOfBankCardImage.canClick = YES;
            NSString *avatar_url = [BASE_URL stringByAppendingString: [dataDic objectForKey:@"copyOfBankCard"]];
            UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
            if (avatar_im)
            {
                [copyOfBankCardImage setImage:avatar_im];
            }
            else
            {
                RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                     parentView:copyOfBankCardImage
                                                                       delegate:self
                                                               defaultImageName:@"default_pic_avatar"];
                [copyOfBankCardImage setImage:r_img];
            }
            
            [cell addSubview:copyOfBankCardImage];
            
        }
		
		}
    }
		
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 84;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (2 == section)
        return 127;
		
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (dataDic!= nil)
	{
    if (0 == section) {
        return head_view;
    }
	}
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (2 == section && self.chuckStatus.integerValue == 3&&dataDic!=nil) {
        return foot_view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 86;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_pass_click:(id)sender
{
    applyStatus = [NSString stringWithFormat:@"%ld",(long)[sender tag] ];
	
	NSLog(@"applyStatus=%@",applyStatus);
    [self updata];
}

- (void)setUpHeadView
{
    lb_name.text = [NSString stringWithFormat:@"申请人:%@",[dataDic objectForKey:@"userName"]];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDic objectForKey:@"createTime"] doubleValue]/1000]];
    lb_time.text = [@"申请时间:" stringByAppendingString:post_date];
    if(self.chuckStatus.integerValue == 1) {
        im_status.image = [UIImage imageNamed:@"img80.png"];
    }
    else if(self.chuckStatus.integerValue == 2) {
        im_status.image = [UIImage imageNamed:@"img81.png"];
    }
    else{
        im_status.alpha = 0.0f;
    }
    //[im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[@"Ecp.Picture.view.img?pictureId="stringByAppendingString: [dataDic objectForKey:@"avatarId"]]]];
	
	
//	NSLog(@"图片链接=%@",[BASE_URL stringByAppendingString: [dataDic objectForKey:@"avatarId"]]);
//	[im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dataDic objectForKey:@"avatarId"]]];

	
	
 NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dataDic objectForKey:@"avatarId"]];
	
	NSLog(@"avatar_url = %@",avatar_url);
	
	
	[im_avatar setImageFromUrl:YES withUrl:avatar_url];
	im_avatar.alpha = 1.0;
	
	
}

//发送请求
//- (void)sendRequestData
//{
//	
//	//请求提示
//	[SVProgressHUD showWithStatus:@"请求数据中"];
//		NSString *full_url = [NSString stringWithFormat:@"%@%@?%@", BASE_URL,AUTH_DETAIL_URL,self.authId];
//	
//	
//	//所有的请求对象都有AFHTTPRequestOperationManager对象发出
//	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	//设置响应类型(响应为二进制数据)
//	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//	
//	
//	
//	//发送请求
//	
//	[manager GET:full_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		
//		
//		
//				//解析
//		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//		
//		if (![[json objectForKey:@"success"] boolValue])
//		{
//			[SVProgressHUD dismiss];
//			[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
//			return;
//		}
//		if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
//			[SVProgressHUD dismiss];
//			[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
//			return;
//		}
//		[SVProgressHUD dismiss];
//		
//		dataDic = [[json objectForKey:@"data"] objectForKey:@"data"];
//		// [self.tableView reloadData];
//		
//		//隐藏
//		[SVProgressHUD dismiss];
//		
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		
//		
//		[SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
//		
//	}];
//	
//	
//	
//	
//	
//	
//}

#pragma mark - NSURLCon
- (void)startDownload
{
	
	[SVProgressHUD showWithStatus:@"请求数据中"];
	
	NSString *full_url = [NSString stringWithFormat:@"%@%@?authId=%@", BASE_URL,AUTH_DETAIL_URL,self.authId];
	//url对象
	NSURL *url = [NSURL URLWithString:full_url];
	
	//初始化请求对象
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	//发起一个异步请求
	[NSURLConnection connectionWithRequest:request delegate:self];
}
#pragma NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"已经接收到服务器响应");
	downloadData.length = 0;
	
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
	
	//追加数据
	[downloadData appendData:data];
	
	
}

//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//解析
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:downloadData options:NSJSONReadingMutableContainers error:nil];
	
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
		return;
	}
	[SVProgressHUD dismiss];
	
	dataDic = [json objectForKey:@"data"];
	
	 [self setUpHeadView];

	 [self.tableView reloadData];
	

	
}

#pragma NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"请求失败");
}








#pragma mark - loadData
- (void)loadData
{
    [SVProgressHUD showWithStatus:@"请求数据中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@?authId=%@", BASE_URL,AUTH_DETAIL_URL,self.authId];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:self.authId forKey:@"authId"];
    [req setHTTPMethod:@"GET"];
	
	NSLog(@"taken == %@ storeId == %@ authId == %@",[token getProperty:@"tokensn"],[token getProperty:@"storeId"],self.authId);
	
	
	
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadData:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoadData: (NSNotification *)notify
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
        return;
    }
    if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    [SVProgressHUD dismiss];

    dataDic = [[json objectForKey:@"data"] objectForKey:@"data"];
   // [self.tableView reloadData];
}

- (void)updata
{
    [SVProgressHUD showWithStatus:@"上传数据中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,AUDIT_AUTH_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
   // [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.authId forKey:@"authId"];
    [req setParam:applyStatus forKey:@"auditState"];
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
        return;
    }
    if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChannelManagerDidChange" object:nil];
    [SVProgressHUD dismissWithSuccess:@"操作成功!"];
    [self performSelector:@selector(popViewContgroller) withObject:nil afterDelay:1.0f];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)popViewContgroller
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    ClickImage *img = (ClickImage *)remoteImage.parent_view;
    [img setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
    ClickImage *img = (ClickImage *)remoteImage.parent_view;
    [img setImage:newImage];
    [RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

@end
