//
//  LoginViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "LoginViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "NSString+MD5Addition.h"
#import "ForgetViewController.h"

@interface LoginViewController ()
@property(nonatomic,weak)IBOutlet UITextField *tf_account;
@property(nonatomic,weak)IBOutlet UITextField *tf_password;
@property(nonatomic,weak)IBOutlet UIButton *btn_login;
@property(nonatomic,weak)IBOutlet UIButton *btn_forget;
@property (weak, nonatomic) IBOutlet UIImageView *logImage;

@end

@implementation LoginViewController
@synthesize delegate;

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
    
    UIImage *bg = [UIImage imageNamed:@"btn1"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
    [self.btn_login setBackgroundImage:stretchableImage forState:UIControlStateNormal];
	
	//self.logImage.frame = CGRectMake(118, 32, 400, 400);
	if ([RRToken check]) {
        self.tf_account.text = [[RRToken getInstance] getProperty:@"loginName"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)dealloc
{
    self.view=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
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
    if ([textField isEqual:self.tf_account]) {
        [self.tf_password becomeFirstResponder];
    }
    return YES;
}


- (IBAction)btn_login_click:(id)sender
{
    if (![self.tf_account.text length]) {
        [self.view.window makeToast:@"用户名不能为空"];
        return;
    }
    
    if (![self.tf_password.text length]) {
        [self.view.window makeToast:@"密码不能为空"];
        return;
    }
    [self.tf_account resignFirstResponder];
    [self.tf_password resignFirstResponder];

    [self login];
}

- (IBAction)btn_forget_click:(id)sender
{
    ForgetViewController *ctrl = [[ForgetViewController alloc] initWithNibName:@"ForgetViewController" bundle:nil];
    ctrl.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)login
{
    NSString *deviceid;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"]) {
        deviceid = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    }
    else
    {
        CFUUIDRef deviceId = CFUUIDCreate (NULL);
        CFStringRef deviceIdStringRef = CFUUIDCreateString(NULL,deviceId);
        CFRelease(deviceId);
        NSString *deviceIdString = (__bridge NSString *)deviceIdStringRef;
        CFRelease(deviceIdStringRef);
        deviceid = [deviceIdString stringFromMD5];
        [[NSUserDefaults standardUserDefaults] setObject:deviceid forKey:@"deviceId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [SVProgressHUD showWithStatus:@"登录中"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:self.tf_account.text forKey:@"loginName"];
	[req setParam:self.tf_password.text forKey:@"password"];
    [req setParam:deviceid forKey:@"deviceId"];
	[req setParam:DEVICETYPE forKey:@"deviceType"];
	[req setParam:[[UIDevice currentDevice] model] forKey:@"deviceDetail"];
	[req setParam:[NSString stringWithFormat:@"%lu*%lu",(unsigned long)[[[UIScreen mainScreen] currentMode]size].width,(unsigned long)[[[UIScreen mainScreen] currentMode]size].height] forKey:@"resolution"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]) {
        [req setParam:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] forKey:@"deviceToken"];
    }
    
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
    NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismiss];
        
        if ([[json objectForKey:@"data"] objectForKey:@"msg"] )
            [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
	
    if([[json objectForKey:@"data"] objectForKey:@"msg"]){
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    
	NSDictionary *data = [json objectForKey:@"data"];
    NSDictionary *user = [data objectForKey:@"user"];

    RRToken *token = [[RRToken alloc] initWithUID:[data objectForKey:@"id"]];
    
    //set token
    [token setProperty:[data objectForKey:@"token"] forKey:@"tokensn"];
    [token setProperty:[data objectForKey:@"type"] forKey:@"type"];
    [token setProperty:[data objectForKey:@"id"] forKey:@"id"];
    [token setProperty:[user objectForKey:@"avatarId"] forKey:@"avatar"];
    [token setProperty:[user objectForKey:@"storeId"] forKey:@"storeId"];
    [token setProperty:[user objectForKey:@"storeName"] forKey:@"storeName"];
    [token setProperty:[user objectForKey:@"loginName"] forKey:@"loginName"];

    //write token to local file
    [token saveToFile];
    
	if ([delegate respondsToSelector:@selector(didLogin)])
	{
		[delegate performSelector:@selector(didLogin)];
	}
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reLogin" object:nil];

        [[AppDelegate getInstance] didLogin];
    }
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"登录失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}


@end
