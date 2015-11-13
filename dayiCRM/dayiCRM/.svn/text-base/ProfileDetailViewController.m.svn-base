//
//  ProfileDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-10-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "Toast+UIView.h"
#import "UrlImageView.h"
#import "EditProfileViewController.h"

@interface ProfileDetailViewController ()

@end

@implementation ProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
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
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([dict count] == 0) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 4;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = [NSString stringWithFormat:@"cell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    UIFont *fnt = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    UIFont *textFnt = [UIFont fontWithName:@"Helvetica" size:14.0f];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = fnt;
    
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"头像";
                if (im_avatar) {
                    [im_avatar removeFromSuperview];
                    im_avatar = nil;
                }
                im_avatar = [[UrlImageView alloc] initWithFrame:CGRectMake(245, 5, 65, 65)];
                [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dict objectForKey:@"avatarId"]]];
                [cell.contentView addSubview:im_avatar];
                break;
            case 1:
                cell.textLabel.text = @"名称";
                if (lb_name) {
                    [lb_name removeFromSuperview];
                    lb_name = nil;
                }
                lb_name = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                lb_name.textAlignment = NSTextAlignmentRight;
                lb_name.textColor = [UIColor lightGrayColor];
                lb_name.font = textFnt;
                lb_name.backgroundColor = [UIColor clearColor];
                lb_name.text = [dict objectForKey:@"userName"];
                [cell.contentView addSubview:lb_name];
                break;
            case 2:
                cell.textLabel.text = @"登录名";
                if (lb_loginName) {
                    [lb_loginName removeFromSuperview];
                    lb_loginName = nil;
                }
                lb_loginName = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                lb_loginName.textAlignment = NSTextAlignmentRight;
                lb_loginName.textColor = [UIColor lightGrayColor];
                lb_loginName.font = textFnt;
                lb_loginName.backgroundColor = [UIColor clearColor];
                lb_loginName.text = [dict objectForKey:@"loginName"];
                [cell.contentView addSubview:lb_loginName];
                break;
            case 3:
                cell.textLabel.text = @"手机号";
                if (lb_tel) {
                    [lb_tel removeFromSuperview];
                    lb_tel = nil;
                }
                lb_tel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                lb_tel.textAlignment = NSTextAlignmentRight;
                lb_tel.textColor = [UIColor lightGrayColor];
                lb_tel.font = textFnt;
                lb_tel.backgroundColor = [UIColor clearColor];
                lb_tel.text = [dict objectForKey:@"loginName"];
                [cell.contentView addSubview:lb_tel];
                break;
            default:
                break;
        }
    }
    
    else if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"性别";
                if (lb_gender) {
                    [lb_gender removeFromSuperview];
                    lb_gender = nil;
                }
                lb_gender = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                lb_gender.textAlignment = NSTextAlignmentRight;
                lb_gender.textColor = [UIColor lightGrayColor];
                lb_gender.font = textFnt;
                lb_gender.backgroundColor = [UIColor clearColor];
                if ([[dict objectForKey:@"gender"]integerValue] == 1) {
                    lb_gender.text = @"男";
                }
                else if([[dict objectForKey:@"gender"]integerValue] == 2){
                    lb_gender.text = @"女";
                }
                else{
                    lb_gender.text = @"未知";
                }
                [cell.contentView addSubview:lb_gender];
                break;
            case 1:
                cell.textLabel.text = @"地区";
                if (lb_region) {
                    [lb_region removeFromSuperview];
                    lb_region = nil;
                }
                lb_region = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                lb_region.textAlignment = NSTextAlignmentRight;
                lb_region.textColor = [UIColor lightGrayColor];
                lb_region.font = textFnt;
                lb_region.backgroundColor = [UIColor clearColor];
                lb_region.text = [dict objectForKey:@"region"];
                [cell.contentView addSubview:lb_region];
                break;
            default:
                break;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 0 == indexPath.row) {
        return 75;
    }
    return 44.0f;
}


#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_edit_click:(id)sender
{
    EditProfileViewController *ctrl = [[EditProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.dict = dict;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
    if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    dict = [NSDictionary dictionaryWithDictionary:data];
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
}

@end
