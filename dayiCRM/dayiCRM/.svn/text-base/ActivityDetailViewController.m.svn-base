//
//  ActivityDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "ActivityDetailViewCell.h"
#import "JoinListViewController.h"
#import "EditActivityViewController.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController
@synthesize aid;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"活动详情";
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_del;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_del = [[UIBarButtonItem alloc] initWithTitle:@"删除"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_del_click:)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *del = [UIButton buttonWithType:UIButtonTypeCustom];
        [del setTitle:@"删除" forState:UIControlStateNormal];
        [del setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [del addTarget:self action:@selector(btn_del_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_del = [[UIBarButtonItem alloc] initWithCustomView:del];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_del;
    
    activityImages = [NSMutableArray array];
    activeRecords = [NSMutableArray array];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [edit removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    edit = [UIButton buttonWithType:UIButtonTypeCustom];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    [edit setFrame:CGRectMake(220.0f, 3.0f, 40,40)];
    [edit addTarget:self action:@selector(btn_edit_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:edit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([dataDict count] == 0) {
        return 0;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (3 == section) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"cell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:13.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (0 == indexPath.section) {
        NSString *CellIdentifier = @"ActivityDetailViewCell";
        
        ActivityDetailViewCell *cell = (ActivityDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell)
        {
            UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
            cell = (ActivityDetailViewCell *)uc.view;
            [cell setContent:dataDict];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    else if(1 == indexPath.section){
        if ([activeRecords count]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

    }
    else if(2 == indexPath.section){
        NSString *content = [dataDict  objectForKey:@"detailExplain"];
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
        CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(300, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;

        if (!lb_des) {
            lb_des = [[UILabel alloc] initWithFrame:CGRectMake(12,30, actualsize.width, actualsize.height)];
            lb_des.textAlignment = NSTextAlignmentLeft;
            lb_des.textColor = [UIColor darkGrayColor];
            lb_des.font = fnt;
            lb_des.backgroundColor = [UIColor clearColor];
            lb_des.text = content;
            lb_des.numberOfLines = 0;
            [cell.contentView addSubview:lb_des];
        }
    }
    else if (3 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                if (!lb_time) {
                    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                    [date_formatter setDateFormat:@"YYYY-MM-dd"];
                    NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"activityStartDate"] doubleValue]/1000]];
                    NSString *end_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"activityEndDate"] doubleValue]/1000]];
                    lb_time = [[UILabel alloc] initWithFrame:CGRectMake(12,30, 300, 40)];
                    lb_time.textAlignment = NSTextAlignmentLeft;
                    lb_time.textColor = [UIColor darkGrayColor];
                    lb_time.font = fnt;
                    lb_time.backgroundColor = [UIColor clearColor];
                    lb_time.text = [NSString stringWithFormat:@"%@至%@",start_date,end_date];
                    lb_time.numberOfLines = 0;
                    [cell.contentView addSubview:lb_time];
                }
                break;
            case 1:
                if (!lb_address) {
                    lb_address = [[UILabel alloc] initWithFrame:CGRectMake(12,30, 300, 40)];
                    lb_address.textAlignment = NSTextAlignmentLeft;
                    lb_address.textColor = [UIColor darkGrayColor];
                    lb_address.font = fnt;
                    lb_address.backgroundColor = [UIColor clearColor];
                    lb_address.text = [dataDict objectForKey:@"address"];
                    lb_address.numberOfLines = 2;
                    [cell.contentView addSubview:lb_address];
                }
                break;
            case 2:
                if (!lb_sponsor) {
                    lb_sponsor = [[UILabel alloc] initWithFrame:CGRectMake(12,30, 300, 40)];
                    lb_sponsor.textAlignment = NSTextAlignmentLeft;
                    lb_sponsor.textColor = [UIColor darkGrayColor];
                    lb_sponsor.font = fnt;
                    lb_sponsor.backgroundColor = [UIColor clearColor];
                    lb_sponsor.text = [dataDict objectForKey:@"activitySponsor"];
                    lb_sponsor.numberOfLines = 2;
                    [cell.contentView addSubview:lb_sponsor];
                }
                break;
            default:
                break;
        }
    }
    else if (4 == indexPath.section){
        NSString *content = [dataDict  objectForKey:@"activityParticipation"];
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
        CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(300, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        
        if (!lb_participation) {
            lb_participation = [[UILabel alloc] initWithFrame:CGRectMake(12,30, actualsize.width, actualsize.height)];
            lb_participation.textAlignment = NSTextAlignmentLeft;
            lb_participation.textColor = [UIColor darkGrayColor];
            lb_participation.font = fnt;
            lb_participation.backgroundColor = [UIColor clearColor];
            lb_participation.text = content;
            lb_participation.numberOfLines = 0;
            [cell.contentView addSubview:lb_participation];
        }

    }
    
    if ([cell.contentView viewWithTag:indexPath.section*10+indexPath.row+1]) {
        [[cell.contentView viewWithTag:indexPath.section*10+indexPath.row+1] removeFromSuperview];
    }
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 24, 24)];
    im.tag = indexPath.section*10+indexPath.row+1;
    switch (indexPath.section) {
        case 1:
            im.image = [UIImage imageNamed:@"img52"];
            break;
        case 2:
            im.image = [UIImage imageNamed:@"img53"];
            break;
        case 3:
            if (indexPath.row == 0) {
                im.image = [UIImage imageNamed:@"img39"];
            }
            else if (indexPath.row == 1) {
                im.image = [UIImage imageNamed:@"img45"];
            }
            else if (indexPath.row == 2) {
                im.image = [UIImage imageNamed:@"img46"];
            }
            break;
        case 4:
            im.image = [UIImage imageNamed:@"img42"];
            break;

        default:
            break;
    }
    if (0 != indexPath.section) {
        [cell.contentView addSubview:im];
    }
    
    if ([cell.contentView viewWithTag:indexPath.section*100+indexPath.row+1]) {
        [[cell.contentView viewWithTag:indexPath.section*100+indexPath.row+1] removeFromSuperview];
    }
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(44,3, 200, 30)];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    lb.tag = indexPath.section*100+indexPath.row+1;
    lb.backgroundColor = [UIColor clearColor];
    switch (indexPath.section) {
        case 1:
            lb.text = @"活动参与人";
            break;
        case 2:
            lb.text = @"活动说明";
            break;
        case 3:
            if (indexPath.row == 0) {
                lb.text = @"活动时间";
            }
            else if (indexPath.row == 1) {
                lb.text = @"活动地址";
            }
            else if (indexPath.row == 2) {
                lb.text = @"活动主办方";
            }
            break;
        case 4:
            lb.text = @"活动参与方式";
            break;
            
        default:
            break;
    }
    if (0 != indexPath.section) {
        [cell.contentView addSubview:lb];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 303.0f;
    }
    else if (2 == indexPath.section){
        UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:13.0f];
        NSString *content = [dataDict  objectForKey:@"detailExplain"];
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
        CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(300, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        return actualsize.height + 40;
    }
    else if (3 == indexPath.section){
        return 70.0f;
    }
    else if (4 == indexPath.section){
        UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:13.0f];
        NSString *content = [dataDict  objectForKey:@"activityParticipation"];
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName,nil];
        CGSize  actualsize =[content boundingRectWithSize:CGSizeMake(300, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        return actualsize.height + 40;
    }

    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.section) {
        if ([activeRecords count] == 0) {
            return;
        }
        JoinListViewController *ctrl = [[JoinListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [ctrl setUpBuffer:activeRecords];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - EventHandle

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_del_click:(id)sender
{
    LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
    [actionSheet showInView:self.tableView];
}

- (void)btn_edit_click:(id)sender
{
    EditActivityViewController  *ctrl = [[EditActivityViewController alloc] initWithNibName:@"EditActivityViewController" bundle:nil];
    ctrl.dataDict = dataDict;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
	
}

- (void)didClickOnDestructiveButton
{
    [self deleteActivity];
}

- (void)didClickOnCancelButton
{
    
}

#pragma mark loadData

- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, DETAIL_ACTIVITY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:aid forKey:@"entityId"];

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
    NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    dataDict = [[json objectForKey:@"data"] objectForKey:@"memberActivityDetails"];
    activeRecords = [dataDict objectForKey:@"activeRecords"];
    activityImages = [dataDict objectForKey:@"activityImages"];
    [self.tableView reloadData];
}

- (void)deleteActivity
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, DELETE_ACTIVITY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:aid forKey:@"entityId"];
    
    [req setHTTPMethod:@"POST"];
	
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onDeleteActivity:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onDeleteActivity: (NSNotification *)notify
{
    [self.view hideToastActivity];
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activityDidUpdate" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)filtDictionary:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
    activeRecords = [dict objectForKey:@"activeRecords"];
    activityImages = [dict objectForKey:@"activityImages"];

}
@end
