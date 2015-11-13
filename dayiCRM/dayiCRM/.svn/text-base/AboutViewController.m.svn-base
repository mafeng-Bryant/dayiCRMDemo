//
//  AboutViewController.m
//  dayiCRM
//
//  Created by Fang on 14-10-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "AboutViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "AppIntroductionViewController.h"
#import "SystemMsgViewController.h"
#import "FeedBackViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于大益";
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_id = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"版本更新";
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (!lb_version) {
                lb_version = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 160, 34)];
                lb_version.textAlignment = NSTextAlignmentRight;
                lb_version.textColor = [UIColor lightGrayColor];
                lb_version.font = [UIFont systemFontOfSize:13.0f];
                lb_version.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:lb_version];
            }

            break;
        case 1:
            cell.textLabel.text = @"功能介绍";
            break;
        case 2:
            cell.textLabel.text = @"系统通知";
            break;
        case 3:
            cell.textLabel.text = @"帮助与反馈";
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img74"]];
    iv.frame = CGRectMake(0.0f, 0.0f, 70.0f, 70.0f);
    iv.center = headView.center;
    [headView addSubview:iv];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( 0 == indexPath.row && hasNew) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://www.meetrend.com/app/index.html"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.meetrend.com/app/index.html"]];
        }
    }
    else if (1 == indexPath.row){
        AppIntroductionViewController *ctrl = [[AppIntroductionViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (2 == indexPath.row){
        SystemMsgViewController *ctrl = [[SystemMsgViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (3 == indexPath.row){
        FeedBackViewController *ctrl = [[FeedBackViewController alloc] initWithNibName:@"FeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}


#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark loadData

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"获取版本信息"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, FIND_MODEL_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:@"dayiCrm"forKey:@"name"];
    [req setParam:@"4" forKey:@"deviceType"];

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
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"%@",json);
#endif
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
        return;
    }
    
    NSString *bundleVersion = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    if ([bundleVersion isEqualToString:[[json objectForKey:@"data"] objectForKey:@"version"]]) {
        lb_version.text = [[json objectForKey:@"data"] objectForKey:@"version"];
    }
    else{
        lb_version.text = @"有新版本,点击下载更新!";
        hasNew = YES;
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
