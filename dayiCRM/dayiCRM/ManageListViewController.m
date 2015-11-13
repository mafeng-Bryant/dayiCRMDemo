//
//  ManageListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-24.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ManageListViewController.h"
#import "OrderListViewController.h"
#import "GroupListViewController.h"
#import "ActivityListViewController.h"
#import "ProductListViewController.h"
#import "TakeOrderViewController.h"
#import "RevenueViewController.h"
#import "RRToken.h"
#import "StockCheckListViewController.h"
#import "ChannelManagerListViewController.h"
#import "ReserveListViewController.h"

@interface ManageListViewController ()

@end

@implementation ManageListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"管理";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_manager_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_manager_unselected"]];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
        return 2;
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (0 == section) {
        if([[[RRToken getInstance] getProperty:@"type"] isEqualToString:@"promotion"])
            return 3;
        return 4;
    }
    if (1 == section || 3 == section) {
        return 2;
    }
    return 3;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (0 == indexPath.section) {
        if(0 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img60.png"];
            cell.textLabel.text = @"线上订单";
        }
        else if(1 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img65.png"];
            cell.textLabel.text = @"门店订单";
        }
        else if(3 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img66.png"];
            cell.textLabel.text = @"快速下单";
        }
        else if(2 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img70.png"];
            cell.textLabel.text = @"收入";
        }

    }
    else if (1 == indexPath.section){
        if(0 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img63.png"];
            cell.textLabel.text = @"群发信息";
        }
        else if(1 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img64.png"];
            cell.textLabel.text = @"活动";
        }
    }
    else if (2 == indexPath.section){
        if(0 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img61.png"];
            cell.textLabel.text = @"库存";
        }
        else if(1 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img68.png"];
            cell.textLabel.text = @"零库存";
        }
        else if(2 == indexPath.row){
            cell.imageView.image = [UIImage imageNamed:@"img62.png"];
            cell.textLabel.text = @"库存盘点";
        }
    }
	else if (3 == indexPath.section){
		if(0 == indexPath.row){
			cell.imageView.image = [UIImage imageNamed:@"img77.png"];
			cell.textLabel.text = @"渠道管理";
		}
		else if(1 == indexPath.row){
			cell.imageView.image = [UIImage imageNamed:@"img82.png"];
			cell.textLabel.text = @"包间预订";
		}
	}
    cell.textLabel.font = fnt;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section) {
        if (0 == indexPath.row ||
            1 == indexPath.row) {
            OrderListViewController *ctrl = [[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
            if (0 == indexPath.row) {
                ctrl.type = 2;
            }
            else{
                ctrl.type = 1;
            }
            ctrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        else if (3 == indexPath.row){
            TakeOrderViewController *ctrl = [[TakeOrderViewController alloc] initWithStyle:UITableViewStyleGrouped];
            ctrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
         }
        else if (2 == indexPath.row){
			RevenueViewController *ctrl = [[RevenueViewController alloc] init];
            ctrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
        }

    }
    else if (0 == indexPath.row && 2 == indexPath.section){
        ProductListViewController *ctrl = [[ProductListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (0 == indexPath.row && 1 == indexPath.section){
        GroupListViewController *ctrl = [[GroupListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (1 == indexPath.row && 1 == indexPath.section){
        ActivityListViewController *ctrl = [[ActivityListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }

    else if (2 == indexPath.row && 2 == indexPath.section){
        StockCheckListViewController *ctrl = [[StockCheckListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if (1 == indexPath.row && 2 == indexPath.section){
        ProductListViewController *ctrl = [[ProductListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.zeroType = @"Y";
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
	else if (0 == indexPath.row && 3 == indexPath.section){
		ChannelManagerListViewController *ctrl = [[ChannelManagerListViewController alloc] initWithStyle:UITableViewStyleGrouped];
		ctrl.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:ctrl animated:YES];
	}
	else if (1 == indexPath.row && 3 == indexPath.section){
		ReserveListViewController *ctrl = [[ReserveListViewController alloc] initWithStyle:UITableViewStyleGrouped];
		ctrl.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:ctrl animated:YES];

	}
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
