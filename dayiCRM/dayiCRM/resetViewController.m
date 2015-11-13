//
//  resetViewController.m
//  dayiCRM
//
//  Created by Fang on 14-5-16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "resetViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
@interface resetViewController ()
@property(nonatomic,weak)IBOutlet UITextField *tf_password;

@end

@implementation resetViewController
@synthesize account;

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
    self.title = @"重置密码";
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_next;
    
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        btn_next = [[UIBarButtonItem alloc] initWithTitle:@"完成"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_next_click:)];
        
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
        [next setTitle:@"完成" forState:UIControlStateNormal];
        [next setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [next addTarget:self action:@selector(btn_next_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_next = [[UIBarButtonItem alloc] initWithCustomView:next];
        
        
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_next;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma UITextFieldDelegate

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
    return YES;
}

- (void)btn_next_click:(id)sender
{
    [self.tf_password resignFirstResponder];
    [self sendAccount];
}

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) sendAccount
{
    [SVProgressHUD showWithStatus:@"重设中"];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, RESET_PASSWORD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:self.account forKey:@"account"];
    [req setParam:self.tf_password.text forKey:@"resetPassword"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFirm:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
    
}

- (void) onFirm: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
    
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
		return;
	}
    
    if ([[json objectForKey:@"data"] objectForKey:@"msg"]) {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
        return;
    }
    
    [SVProgressHUD dismissWithSuccess:@"设置成功!"];
    [self performSelector:@selector(popView) withObject:nil afterDelay:1.0f];
}


- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void) popView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
