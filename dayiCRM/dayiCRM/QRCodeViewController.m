//
//  QRCodeViewController.m
//  dayiCRM
//
//  Created by Fang on 14-10-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "QRCodeViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "Toast+UIView.h"
#import "UrlImageView.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二维码";
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
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpQRView
{
    if ([[dict objectForKey:@"avatarId"] length]) {
        [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dict objectForKey:@"avatarId"]]];
    }
    
    lb_name.text = [dict objectForKey:@"userName"];
    if ([[dict objectForKey:@"gender"] integerValue] == 1) {
        im_gender.image = [UIImage imageNamed:@"Contact_Male"];
    }
    else if ([[dict objectForKey:@"gender"] integerValue] == 2){
        im_gender.image = [UIImage imageNamed:@"Contact_Female"];
    }
    else{
        im_gender.alpha = 0;
    }
    lb_region.text = [dict objectForKey:@"region"];
    
    if ([qrCodeString length]) {
        [im_qrcode setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:qrCodeString]];
    }
}

#pragma mark -
#pragma mark loadDate

- (void)loadData
{
    if ([dict count] == 0)
        [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MY_INFORMATION_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    [self loadQrCode];
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
    [self setUpQRView];
}

- (void)loadQrCode
{
    RRToken *token = [RRToken getInstance];
    
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MY_QRCODE_URL];

    if(![[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
    {
        full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, STORE_QRCODE_URL];
    }
    
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadedQrCode:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoadedQrCode: (NSNotification *)notify
{
    [self.view hideToastActivity];
    RRLoader *loader = (RRLoader *)[notify object];
    NSDictionary *json = [loader getJSONData];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",json);
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
    //login fail
    if (![[json objectForKey:@"success"] boolValue] || [[json objectForKey:@"data"] objectForKey:@"msg"])
    {
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    qrCodeString = [[json objectForKey:@"data"] objectForKey:@"qrCode"];
    [self setUpQRView];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}

@end
