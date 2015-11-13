//
//  SendTypeListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "SendTypeListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface SendTypeListViewController ()

@end

@implementation SendTypeListViewController
@synthesize delegate;

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
    self.title = @"选择消息类型";
    buffer = [NSMutableArray array];
    [self loadData];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [buffer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"empty_cell";
    
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
        [cell.contentView insertSubview:messageBackgroundView belowSubview:cell.textLabel];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"value"] isEqualToString:@"email"] ||
        [[dic objectForKey:@"value"] isEqualToString:@"microblog"]){
        [self.view.window makeToast:@"暂不支持该类型"];
        return;
    }
    if (delegate && [delegate respondsToSelector:@selector(sendTypeListViewController:didSelectedType:)]){
        [delegate sendTypeListViewController:self didSelectedType:[dic objectForKey:@"value"]];
    }
}

#pragma mark loadData

- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_TYPE_URL];
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
    NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    NSArray *arr = [[json objectForKey:@"data"] objectForKey:@"types"];
    if ([arr count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
