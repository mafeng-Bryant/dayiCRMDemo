//
//  ProfileViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-25.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ProfileViewController.h"
#import "RRToken.h"
#import "UrlImageView.h"
#import "MemberDetailViewController.h"
#import "AppDelegate.h"
#import "ProfileDetailViewController.h"
#import "QRCodeViewController.h"
#import "passwordSetViewController.h"
#import "AboutViewController.h"
#import "AddAuthViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"我";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_member_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_member_unselected"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBtn;
    if (IOS7)
    {
        backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self.tableView selector:@selector(reloadData) name:@"reLogin" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(1 == section)
    {
        if([[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
            return 3;
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = [NSString stringWithFormat:@"cell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    if (!IOS7)
    {
        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 44);
        [cell.contentView insertSubview:messageBackgroundView atIndex:0];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }
    
    UIFont *fnt = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if (0 == indexPath.section) {
        if (im_avatar) {
            [im_avatar removeFromSuperview];
            im_avatar = nil;
        }
        im_avatar = [[UrlImageView alloc] initWithFrame:CGRectMake(10, 5, 65, 65)];
        [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[[RRToken getInstance] getProperty:@"avatar"]]];
        [cell.contentView addSubview:im_avatar];
        
        if (lb_name) {
            [lb_name removeFromSuperview];
            lb_name = nil;
        }
        lb_name = [[UILabel alloc] initWithFrame:CGRectMake(90,20, 200, 30)];
        lb_name.textAlignment = NSTextAlignmentLeft;
        lb_name.textColor = [UIColor blackColor];
        lb_name.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.text = [[RRToken getInstance] getProperty:@"loginName"];
        [cell.contentView addSubview:lb_name];
    }
    else if (1 == indexPath.section){
        if(0 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img71.png"];
            cell.textLabel.text = @"密码修改";
        }
        else if(1 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img73.png"];
            cell.textLabel.text = @"我的二维码";
        }
        else if(2 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img85.png"];
            cell.textLabel.text = @"实名认证";
        }

    }
    else if (2 == indexPath.section){
        if(0 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img72.png"];
            cell.textLabel.text = @"关于大益";
        }
    }
    
    else if (3 == indexPath.section){
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.font = fnt;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 0 == indexPath.row) {
        return 75;
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (3 == indexPath.section && 0 == indexPath.row) {
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"确定退出当前账号?" delegate:self cancelButtonTitle:@"取消操作" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
        return;
    }
    else if (0 == indexPath.section && 0 == indexPath.row) {
        ProfileDetailViewController *ctrl = [[ProfileDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (1 == indexPath.section && 1 == indexPath.row) {
        QRCodeViewController *ctrl = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (1 == indexPath.section && 0 == indexPath.row) {
        passwordSetViewController *ctrl = [[passwordSetViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (1 == indexPath.section && 2 == indexPath.row){
        AddAuthViewController *ctrl = [[AddAuthViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];

    }
    
    else if (2 == indexPath.section && 0 == indexPath.row) {
        AboutViewController *ctrl = [[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    
}

- (void)didClickOnDestructiveButton
{
    RRToken *token = [RRToken getInstance];
    [RRToken removeTokenForUID:[token getProperty:@"id"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[AppDelegate getInstance] performSelector:@selector(checkToken) withObject:nil afterDelay:1.0f];
    
}

- (void)didClickOnCancelButton
{
    
}



@end
