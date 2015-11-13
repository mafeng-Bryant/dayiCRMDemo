//
//  ForgetViewController.m
//  dayiCRM
//
//  Created by Fang on 14-5-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ForgetViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "CompareViewController.h"

@interface ForgetViewController ()

@property(nonatomic,weak)IBOutlet UITextField *tf_tel;
@end

@implementation ForgetViewController

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
        
        UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
        [tel setTitle:@"下一步" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_next_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_next = [[UIBarButtonItem alloc] initWithCustomView:tel];

        
    }
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_next;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [self post];
    return YES;
}

- (void)btn_next_click:(id)sender
{
    [self post];
}

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (void)post
{
    [self.tf_tel resignFirstResponder];
    if ([self.tf_tel.text length] == 0) {
        [self.view.window makeToast:@"电话还没有填写哦!"];
        return;
    }
    
    if (![self isValidateMobile:self.tf_tel.text]) {
        [self.view.window makeToast:@"电话格式不正确!"];
        return;
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"将发送验证码至:%@",self.tf_tel.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil];
    [av show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [self sendAccount];
    }
}

- (void) sendAccount
{
    [SVProgressHUD showWithStatus:@"请求数据中"];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, FORGET_PASSWORD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:self.tf_tel.text forKey:@"account"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSend:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
    
}

- (void) onSend: (NSNotification *)notify
{
    [SVProgressHUD dismiss];

	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
        
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
		return;
	}
    
    if ([[json objectForKey:@"data"] objectForKey:@"msg"]) {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
        return;
    }
    
    CompareViewController *ctrl = [[CompareViewController alloc] initWithNibName:@"CompareViewController" bundle:nil];
    ctrl.tel = self.tf_tel.text;
    ctrl.randNumber = [[json objectForKey:@"data"] objectForKey:@"randNumber"];
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

@end
