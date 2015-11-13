//
//  ProductListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-3.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ProductListViewController.h"
#import "StockDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RWHomeCache.h"
#import "UrlImageView.h"
#import "TreeViewNode.h"
#import "StockTreeViewCell.h"
#import "StockCheckViewController.h"

@interface ProductListViewController ()
@property (nonatomic, retain) NSMutableArray *displayArray;
@property (nonatomic,retain)UIView *head_view;
@property (nonatomic,retain)UIImageView *im_point;

@end

@implementation ProductListViewController
@synthesize delegate,isStockCheck,zeroType,reportId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@"我来也");
	//[super viewWillAppear:YES];
	
	

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
        
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    self.navigationItem.leftBarButtonItem = btn_cancel;
    if(delegate)
        self.title = @"选择茶品";
    else if (isStockCheck){
        self.title = @"库存盘点";
        [self initHeadView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"stockCheckDidChange" object:nil];
    }
    else{
        self.title = @"库存";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"activityDidUpdate" object:nil];
    }
    
	buffer = [NSMutableArray array];
    subBuffer = [NSMutableArray array];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
    
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
    return [buffer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([self.displayArray count] == 0)
        return 0;
    return [[self.displayArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0) {
        NSString *cell_id = @"empty_cell";
        
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
    TreeViewNode *node = [[self.displayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (node.nodeLevel == 1) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"UITableViewCell_%lu_%lu",(unsigned long)[indexPath indexAtPosition:0],(unsigned long)[indexPath indexAtPosition:1]];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSDictionary *dic = node.nodeObject;
        
        if ([cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1]) {
            [[cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1] removeFromSuperview];
        }
        
        UrlImageView *im = [[UrlImageView alloc] initWithFrame:CGRectMake(12, 5, 34, 34)];
        NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dic objectForKey:@"productImage"]];
        [im setImageFromUrl:YES withUrl:avatar_url];
        im.tag = [indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1;
        [cell.contentView addSubview:im];
        
        if ([cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 10000]) {
            [[cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 10000] removeFromSuperview];
        }
        UILabel *lb_name = [[UILabel alloc] initWithFrame:CGRectMake(60, 5,isStockCheck?200:160, 34)];
        lb_name.font = [UIFont systemFontOfSize:15];
        if ([[dic objectForKey:@"productPici"] length])
            lb_name.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"productName"],[dic objectForKey:@"productPici"] ];
        else
            lb_name.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productName"]];
        lb_name.backgroundColor = [UIColor clearColor];
        lb_name.tag = [indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 10000;
        [cell.contentView addSubview:lb_name];
        
        if ([cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1000000]) {
            [[cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1000000] removeFromSuperview];
        }

        if (isStockCheck){
            if ([[dic objectForKey:@"result"] isEqualToString:@"N"]){
                UILabel *lb_amount = [[UILabel alloc] initWithFrame:CGRectMake(260, 5, 70, 34)];
                lb_amount.font = [UIFont systemFontOfSize:13];
                lb_amount.text = @"不正常";
                lb_amount.backgroundColor = [UIColor clearColor];
                lb_amount.textColor = dayiColor;
                lb_amount.tag = [indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1000000;
                [cell.contentView addSubview:lb_amount];
            }
        }
        else{
            UILabel *lb_amount = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 34)];
            lb_amount.font = [UIFont systemFontOfSize:13];
            lb_amount.text = [NSString stringWithFormat:@"%d%@ %d%@", [[dic objectForKey:@"productBigNumber"] integerValue], [dic objectForKey:@"productBigUnitName"] ,[[dic objectForKey:@"productSmallNumber"] integerValue],[dic objectForKey:@"productSmallUnitName"] ];
            lb_amount.backgroundColor = [UIColor clearColor];
            lb_amount.tag = [indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1000000;
            [cell.contentView addSubview:lb_amount];
        }
        return cell;
    }
    
    
    NSString *CellIdentifier = @"StockTreeViewCell";
    StockTreeViewCell *cell = (StockTreeViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (StockTreeViewCell *)uc.view;
        cell.treeNode = node;
        [cell setUpTitleLableAndImg];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        if(isStockCheck)
            return 58;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        if(isStockCheck)
        {
            return  self.head_view;
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TreeViewNode *node = [[self.displayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (node.nodeLevel == 0) {
        StockTreeViewCell *cell = (StockTreeViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.treeNode.isExpanded = !cell.treeNode.isExpanded;
        [cell setSelected:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectTreeNodeButtonClicked" object:self];
    }
    else if (node.nodeLevel == 1){
        NSDictionary *dic = node.nodeObject;
        if (delegate && [delegate respondsToSelector:@selector(productListViewController:didSelectedProduct:)]) {
            if ([[dic objectForKey:@"productBigNumber"] integerValue] == 0 &&
                [[dic objectForKey:@"productSmallNumber"] integerValue] == 0 ) {
                [self.view.window makeToast:@"暂无库存,请选择其他茶品!" duration:1.0f position:@"bottom"];
                return;
            }
            [delegate productListViewController:self didSelectedProduct:dic];
        }
        else if (isStockCheck){
            
            StockCheckViewController *ctrl = [[StockCheckViewController alloc]initWithStyle:UITableViewStyleGrouped];
            ctrl.dataDict = dic;
            ctrl.productName = [dic objectForKey:@"productName"];
            if(reportId){
                ctrl.reportId = reportId;
            }
            else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"reportId"]){
                ctrl.reportId = [[NSUserDefaults standardUserDefaults] objectForKey:@"reportId"];
            }
            ctrl.isUnCheck = !is_confirmed;
            ctrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
        else{
			
			
            StockDetailViewController *ctrl = [[StockDetailViewController alloc] initWithNibName:@"StockDetailViewController" bundle:nil];
            ctrl.title_name = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"productName"],[dic objectForKey:@"productPici"] ];
            ctrl.sid = [dic objectForKey:@"productId"];
            ctrl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            }
        }
    }
}


#pragma mark - EventHandle
- (void)btn_cancel_click:(id)sender
{
    if (delegate) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reportId"];
}

- (void)initHeadView
{
    self.head_view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 54.0f)];
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    im.image = [UIImage imageNamed:@"order_select_bg"];
    
    im.userInteractionEnabled = YES;
    
    self.im_point = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f, 7.0f, 30.0f, 30.0f)];
    self.im_point.image = [UIImage imageNamed:@"point_green"];
    [im addSubview:self.im_point];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"未盘点" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn_order_select_click:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(0.0f, 0.0f, 160.0f, 44.0f);
    btn1.tag = 1;
    [im addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"已盘点" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn_order_select_click:) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(160.0f, 0.0f, 160.0f, 44.0f);
    btn2.tag = 2;
    [im addSubview:btn2];
    
    [self.head_view addSubview:im];
}

- (void)btn_order_select_click:(id)sender
{
    if ([sender tag] == 1) {
        is_confirmed = NO;
        self.im_point.frame = CGRectMake(30.0f, 7.0f, 30.0f, 30.0f);
    }
    else if ([sender tag] == 2){
        is_confirmed = YES;
        self.im_point.frame = CGRectMake(190.0f, 7.0f, 30.0f, 30.0f);
    }
    [buffer removeAllObjects];
    [self loadData];
}


#pragma mark - loadData
- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url;
    if(isStockCheck){
        full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, INVENTORY_REPORT_DETAIL];
    }
    else{
         full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, PRODUCT_LIST_URL];
    }
	
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    if(isStockCheck){
        [req setParam:is_confirmed?@"Y":@"N" forKey:@"isCount"];
        if(reportId){
            [req setParam:reportId forKey:@"reportId"];
        }
        else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"reportId"]){
            [req setParam:[[NSUserDefaults standardUserDefaults] objectForKey:@"reportId"] forKey:@"reportId"];
        }
        else{
            [req setParam:@" " forKey:@"reportId"];
        }
    }
    else if(zeroType){
        [req setParam:zeroType forKey:@"zeroType"];
    }
	[req setHTTPMethod:@"POST"];
    
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFetchProduct:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onFetchProduct: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
    
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    //login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view hideToastActivity];
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [[data objectForKey:@"data"] objectForKey:@"productCatalogs"];
    if ([data count] == 0) {
        [self.view hideToastActivity];
        [buffer removeAllObjects];
        return;
    }
    
    [self.view hideToastActivity];

    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    [self fillNodesArray];
    [self fillDisplayArray];
    [self.tableView reloadData];
    
}

- (void) onLoadFail: (NSNotification *)notify
{
    [self.view.window makeToast:@"获取数据失败!"];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
}

#pragma mark -

- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (NSArray *nodeArray in nodes) {
        nodesTmpArray = [[NSMutableArray alloc]init];
        for (TreeViewNode *node in nodeArray) {
            [nodesTmpArray addObject:node];
            if (node.isExpanded) {
                [self fillNodeWithChildrenArray:node.nodeChildren];
            }
        }
        [self.displayArray addObject:nodesTmpArray];
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [nodesTmpArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

- (void)fillNodesArray
{
    nodes = [NSMutableArray array];
	for (NSDictionary *dic in buffer) {
		NSArray *productArray = [dic objectForKey:@"products"];
        
        NSMutableArray *nodeArray = [NSMutableArray array];

        TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
        firstLevelNode1.nodeLevel = 0;
        firstLevelNode1.nodeObject = [dic objectForKey:@"productCatalogName"];
        firstLevelNode1.isExpanded = NO;
        firstLevelNode1.nodeChildren = [[self fillChildrenForNode:productArray] mutableCopy];
        [nodeArray addObject:firstLevelNode1];
        
        [nodes addObject:nodeArray] ;
	}
}

- (NSArray *)fillChildrenForNode:(NSArray *)arr
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *dic in arr) {
		TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
		secondLevelNode1.nodeLevel = 1;
		secondLevelNode1.nodeObject = dic;
		[array addObject:secondLevelNode1];
	}
	return array;
}



@end
