//
//  passwordSetViewController.m
//  dayiCRM
//
//  Created by Fang on 14-10-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "passwordSetViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"

@interface passwordSetViewController ()

@end

@implementation passwordSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码修改";
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    CGRect rect = CGRectMake(110,7, 200, 30);
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:15.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"当前账号";
                if (lb_account) {
                    [lb_account removeFromSuperview];
                    lb_account = nil;
                }
                lb_account = [[UILabel alloc] initWithFrame:rect];
                lb_account.textAlignment = NSTextAlignmentLeft;
                lb_account.textColor = [UIColor blackColor];
                lb_account.font = fnt;
                lb_account.backgroundColor = [UIColor clearColor];
                lb_account.text = [[RRToken getInstance] getProperty:@"loginName"];
                [cell.contentView addSubview:lb_account];
                break;
            case 1:
                cell.textLabel.text = @"当前密码";
                if (tf_currentPassword) {
                    [tf_currentPassword removeFromSuperview];
                    tf_currentPassword = nil;
                }
                tf_currentPassword = [[UITextField alloc] initWithFrame:rect];
                tf_currentPassword.textAlignment = NSTextAlignmentLeft;
                tf_currentPassword.textColor = [UIColor blackColor];
                tf_currentPassword.font = fnt;
                tf_currentPassword.delegate = self;
                tf_currentPassword.secureTextEntry = YES;
                tf_currentPassword.returnKeyType = UIReturnKeyNext;
                tf_currentPassword.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:tf_currentPassword];
                break;
            default:
                break;
        }
    }
    else if (1 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"新密码";
                if (tf_newPassword) {
                    [tf_newPassword removeFromSuperview];
                    tf_newPassword = nil;
                }
                tf_newPassword = [[UITextField alloc] initWithFrame:rect];
                tf_newPassword.textAlignment = NSTextAlignmentLeft;
                tf_newPassword.textColor = [UIColor blackColor];
                tf_newPassword.font = fnt;
                tf_newPassword.delegate = self;
                tf_newPassword.secureTextEntry = YES;
                tf_newPassword.returnKeyType = UIReturnKeyNext;
                tf_newPassword.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:tf_newPassword];
                break;
            case 1:
                cell.textLabel.text = @"确认密码";
                if (tf_confirmPassword) {
                    [tf_confirmPassword removeFromSuperview];
                    tf_confirmPassword = nil;
                }
                tf_confirmPassword = [[UITextField alloc] initWithFrame:rect];
                tf_confirmPassword.textAlignment = NSTextAlignmentLeft;
                tf_confirmPassword.textColor = [UIColor blackColor];
                tf_confirmPassword.font = fnt;
                tf_confirmPassword.delegate = self;
                tf_confirmPassword.returnKeyType = UIReturnKeyDone;
                tf_confirmPassword.secureTextEntry = YES;
                tf_confirmPassword.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:tf_confirmPassword];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIImage *bg = [UIImage imageNamed:@"btn3"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认修改" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 300, 44);
    [btn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    btn.center = footView.center;
    [btn addTarget:self action:@selector(btn_modify_click:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section?100:0;
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
    if ([textField isEqual:tf_currentPassword]) {
        [tf_newPassword becomeFirstResponder];
    }
    else if ([textField isEqual:tf_newPassword]) {
        [tf_confirmPassword becomeFirstResponder];
    }
    return YES;
}

#pragma mark -
#pragma mark event handle

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_modify_click:(id)sender
{
    if([tf_currentPassword.text length] == 0){
        [self.view.window makeToast:@"还没有输入当前密码"];
        return;
    }
    if([tf_newPassword.text length] == 0){
        [self.view.window makeToast:@"还没有输入新密码"];
        return;
    }
    if(![tf_newPassword.text isEqualToString:tf_confirmPassword.text]){
        [self.view.window makeToast:@"两次输入的新密码不一致"];
        return;
    }

    [self uploadData];
}

#pragma mark -
#pragma mark uploadData
- (void)uploadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MODIFY_PASSWORD_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    
    [req setParam:lb_account.text forKey:@"loginName"];
    [req setParam:tf_currentPassword.text forKey:@"pastPassword"];
    [req setParam:tf_newPassword.text forKey:@"currentPassword"];

    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUploadData:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onUploadData: (NSNotification *)notify
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

	if([[[json objectForKey:@"data"] objectForKey:@"msg"] length]){
		[self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
	
    [self.view makeToast:@"修改成功!"];
    [self performSelector:@selector(showLoginView) withObject:nil afterDelay:1.0f];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"上传数据失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)showLoginView
{
    RRToken *token = [RRToken getInstance];
    [RRToken removeTokenForUID:[token getProperty:@"id"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[AppDelegate getInstance] performSelector:@selector(checkToken) withObject:nil afterDelay:1.0f];
}



@end
