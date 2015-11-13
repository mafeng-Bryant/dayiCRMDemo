//
//  CompareViewController.m
//  dayiCRM
//
//  Created by Fang on 14-5-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "CompareViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "resetViewController.h"

@interface CompareViewController ()
@property(nonatomic,weak)IBOutlet UITextField *tf_tel;
@property(nonatomic,weak)IBOutlet UIButton *btn;
@property(nonatomic,weak)IBOutlet UILabel *lb_count;
@end

@implementation CompareViewController
@synthesize tel,randNumber;

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
        btn_next = [[UIBarButtonItem alloc] initWithTitle:@"下一步"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_next_click:)];
        
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
        [next setTitle:@"下一步" forState:UIControlStateNormal];
        [next setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [next addTarget:self action:@selector(btn_next_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_next = [[UIBarButtonItem alloc] initWithCustomView:next];
        
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_next;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    
    self.btn.enabled = NO;
    self.lb_count.text = @"60";
    count = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(dida) userInfo:nil
                                            repeats:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([timer isValid]) {
        [timer invalidate];
    }
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
    if ([self.tf_tel.text isEqualToString:self.randNumber]) {
        resetViewController *ctrl = [[resetViewController alloc] initWithNibName:@"resetViewController" bundle:nil];
        ctrl.account = self.tel;
        [self.navigationController pushViewController:ctrl animated:YES];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    else
    {
        [self.view.window makeToast:@"验证码输入错误!"];
    }
}

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_send_click:(id)sender
{
    [self sendAccounts];
}

- (void)dida
{
    count--;
    self.lb_count.text = [NSString stringWithFormat:@"%d",count];
    if (count == 0) {
        [timer invalidate];
        self.btn.enabled = YES;
    }
}

- (void) sendAccounts
{
    [SVProgressHUD showWithStatus:@"请求数据中"];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, FORGET_PASSWORD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:self.tel forKey:@"account"];
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
    
    [SVProgressHUD dismissWithSuccess:@"请求成功!"];
    self.randNumber = [[json objectForKey:@"data"] objectForKey:@"randNumber"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderDidChange" object:self];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

@end
