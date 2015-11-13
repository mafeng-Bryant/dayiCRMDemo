//
//  StockDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockDetailViewController.h"
#import "OrderListCell.h"
#import "StockEditViewController.h"
#import "SplitStockViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
@interface StockDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)IBOutlet UIView *head_view;
@property(nonatomic,weak)IBOutlet UIView *bg_view;
@property(nonatomic,weak)IBOutlet UIImageView *im_brand;
@property(nonatomic,weak)IBOutlet UIImageView *im_triangle;
@property(nonatomic,weak)IBOutlet UITableView *table_view;

@end

@implementation StockDetailViewController
@synthesize sid,title_name;

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
    self.title = title_name;
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_edit;
	UIBarButtonItem *btn_sure;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_edit = [[UIBarButtonItem alloc] initWithTitle:@"拆分"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_edit_click:)];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
		
		//编辑按钮
		btn_sure = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_sure_click:)];
	
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
        [tel setTitle:@"拆分" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_edit_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_edit = [[UIBarButtonItem alloc] initWithCustomView:tel];
		
		
		UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
		[sure setTitle:@"修改" forState:UIControlStateNormal];
		[sure addTarget:self action:@selector(btn_sure_click:) forControlEvents:UIControlEventTouchUpInside];
		btn_sure = [[UIBarButtonItem alloc] initWithCustomView:sure];
		
		
        self.navigationItem.hidesBackButton = YES;
        self.table_view.separatorColor = [UIColor clearColor];
        self.table_view.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.table_view.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
	
    //self.navigationItem.rightBarButtonItem = btn_edit;
	//self.navigationItem.rightBarButtonItem = btn_sure;
	self.navigationItem.rightBarButtonItems = @[btn_edit,btn_sure];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    is_history = NO;
    [self initHeadView];
    buffer = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"stockCheckDidChange" object:nil];
}


#pragma - mark 修改库存信息按钮

- (void)btn_sure_click:(UIButton *)btn
{

	
	StockEditViewController *stock = [[StockEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	
	UINavigationController *stockNa = [[UINavigationController alloc] initWithRootViewController:stock];
	
	stock.dict = detailDic;
	stock.title_name = title_name;
	stock.productId = detailDic[@"productId"];

	
	[stockNa.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
	[self.navigationController presentViewController:stockNa animated:YES completion:nil];

	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDetail];
}

- (void)dealloc
{
    self.view=nil;
    buffer = nil;
    detailDic = nil;
    historyDic = nil;
    self.head_view = nil;
    self.bg_view = nil;
    self.im_brand = nil;
    self.im_triangle = nil;
    self.table_view = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!is_history) {
        return 2;
    }
    if (0 == [buffer count]) {
        return 1;
    }
    return [buffer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!is_history) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!is_history) {
        static NSString *cell_id = @"stock_cell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
        }
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
    
        if (!IOS7)
        {
            UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
            UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
            UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
            
            UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
            UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
            
            UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
            messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 44.0f);
            [cell.contentView insertSubview:messageBackgroundView belowSubview:cell.textLabel];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
        }

        if (0 == indexPath.section) {
            if (0 == indexPath.row) {
                cell.textLabel.text = @"库存量(件)";
                if ([detailDic count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"picecInventory"] ];
            }
            else if (1 == indexPath.row){
                cell.textLabel.text = @"单次最大购买量(件)";
                if ([detailDic count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"pieceDispInventory"] ];
                
            }
            else if (2 == indexPath.row){
                cell.textLabel.text = @"平均报价(件)";
                if ([detailDic count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"piecePrice"] ];
                
            }
            else if (3 == indexPath.row){
                cell.textLabel.text = @"报价(件)";
                if ([detailDic count])
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"offerPiecePrice"] ];
                
            }

        }
        else if (1 == indexPath.section){
            if (0 == indexPath.row) {
                if ([detailDic count])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"库存量(%@)",[detailDic objectForKey:@"unitName"]];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"unitInventory"] ];
                }
            }
            else if (1 == indexPath.row){
                if ([detailDic count])
                {
                    cell.textLabel.text = @"最小单位/件";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"unitCount"] ];
                }
                
            }
            else if (2 == indexPath.row){
                if ([detailDic count])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"平均报价(%@)",[detailDic objectForKey:@"unitName"] ];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"unitPrice"] ];
                }
            }
            else if (3 == indexPath.row){
                if ([detailDic count])
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"报价(%@)",[detailDic objectForKey:@"unitName"] ];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[detailDic objectForKey:@"offerUnitPrice"] ];
                }
            }
        }
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        return cell;
    }
    if ([buffer count] == 0) {
        static NSString *cell_id = @"empty_cell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = @"无数据";
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NSString *CellIdentifier = @"OrderListCell";
    NSDictionary *dic = [buffer objectAtIndex:indexPath.section];
    
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (OrderListCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!is_history) {
        return 44;
    }
    if ([buffer count]) {
        return 142;
    }
    return 44;
}


#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_edit_click:(id)sender
{
    SplitStockViewController *ctrl = [[SplitStockViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.productName = title_name;
    ctrl.dataDict = detailDic;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)btn_select_click:(id)sender
{
	
    if ([sender tag] == 1 && is_history) {
        is_history = NO;
        [self scrollTriangleView];
        if([detailDic count] == 0)
        [self loadDetail ];

    }
    else if ([sender tag] == 2 && !is_history){
        is_history = YES;
        [self scrollTriangleView];
        if([historyDic count] == 0)
            [self loadData];
    }
    [self.table_view reloadData];
}

- (void)scrollTriangleView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (!is_history) {
        self.im_triangle.frame = CGRectMake(54, 43, 18, 7);
    }
    else{
        self.im_triangle.frame = CGRectMake(245, 43, 18, 7);
     }
    [UIView commitAnimations];

}
- (void)initHeadView
{
    self.head_view.frame = CGRectMake(0, 0, 320, 154);
    [self.view addSubview:self.head_view];
    self.table_view.frame = CGRectMake(0, 154, 320, self.view.frame.size.height - self.head_view.frame.size.height);
    NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[historyDic objectForKey:@"img"]];
	UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
	if (avatar_im)
	{
		[self.im_brand setImage:avatar_im];
	}
	else
	{
		RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
															 parentView:self.im_brand
															   delegate:self
													   defaultImageName:@"home_special_default"];
		
		[self.im_brand setImage:r_img];
	}
}

#pragma mark -
#pragma mark RRRemoteImageDelegate

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
	static UIImage *empty_image = nil;
	
	if (nil == empty_image)
	{
		empty_image = [UIImage imageNamed:@"home_special_default"];
	}
	
	[self.im_brand setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	[self.im_brand setImage:newImage];
	
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

#pragma mark -
- (void)loadData
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, ORDER_HISTORY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.sid forKey:@"id"];
	[req setParam:@"1" forKey:@"pageIndex"];
	[req setParam:@"1000" forKey:@"pageSize"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];

		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    historyDic = data;
    [self initHeadView];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        return;
    }
    
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    [self.table_view reloadData];
}

- (void)loadDetail
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_INVENTORYBYID_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.sid forKey:@"id"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadDetail:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoadDetail: (NSNotification *)notify
{
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
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    detailDic = [json objectForKey:@"data"];
    [self.table_view reloadData];
    [self loadData];
}


- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}
@end
