//
//  StockTreeViewController.m
//  dayiCRM
//
//  Created by Leo on 14-6-16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockTreeViewController.h"
#import "StockDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RWHomeCache.h"
#import "UrlImageView.h"
#import "TreeViewNode.h"
#import "StockTreeViewCell.h"

@interface StockTreeViewController ()
@property (nonatomic, retain) NSMutableArray *displayArray;

@end

@implementation StockTreeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"库存";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_stock_selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_stock_unselected"]];	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"storeDidChange" object:nil];

	buffer = [NSMutableArray array];
    subBuffer = [NSMutableArray array];
    yearBuffer = [NSMutableArray array];

    if (!IOS7) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    NSArray *arr = [RWHomeCache readFromFile:@"stockList"];
	
	if ([arr count])
	{
		[buffer addObjectsFromArray:arr];

        if ([[RWHomeCache readFromFile:@"subList"] count]) {
            [subBuffer addObjectsFromArray:[RWHomeCache readFromFile:@"subList"]];
        }
        [self fillNodesArray];
        [self fillDisplayArray];
		[self.tableView reloadData];
	}
    
    [self fetchProduct];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	NSLog(@"我来了");
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
        NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dic objectForKey:@"avatarId"]];
        [im setImageFromUrl:YES withUrl:avatar_url];
        im.tag = [indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1;
        [cell.contentView addSubview:im];
        
        if ([cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 10000]) {
            [[cell.contentView viewWithTag:[indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 10000] removeFromSuperview];
        }
        UILabel *lb_name = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 160, 34)];
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
        UILabel *lb_amount = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 34)];
        lb_amount.font = [UIFont systemFontOfSize:13];
        lb_amount.text = [NSString stringWithFormat:@"%d件 %d%@", [[dic objectForKey:@"picecInventory"] integerValue], [[dic objectForKey:@"unitInventory"] integerValue],[dic objectForKey:@"unitName"] ];
        lb_amount.backgroundColor = [UIColor clearColor];
        lb_amount.tag = [indexPath indexAtPosition:0] + [indexPath indexAtPosition:1] + [indexPath indexAtPosition:2] + 1000000;
        [cell.contentView addSubview:lb_amount];
        
        if (!IOS7)
        {
            UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
            UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
            UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
            
            UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
            UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
            
            UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
            messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 44.0f);
            [cell.contentView insertSubview:messageBackgroundView belowSubview:im];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@",[[buffer objectAtIndex:section] objectForKey:@"teaName"] ];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
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
		NSArray *yearArray = [dic objectForKey:@"yearArray"];
        NSMutableArray *nodeArray = [NSMutableArray array];
		for (NSDictionary *year in yearArray) {
			NSArray *arr = [NSArray array];
			for(NSDictionary *sub in subBuffer)
			{
				if ([[sub objectForKey:@"yearId"] isEqualToString:[year objectForKey:@"yearId"]])
				{
					arr = [sub objectForKey:@"data"];
					break;
				}
			}
			TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
			firstLevelNode1.nodeLevel = 0;
			firstLevelNode1.nodeObject = year;
			firstLevelNode1.isExpanded = NO;
			firstLevelNode1.nodeChildren = [[self fillChildrenForNode:arr] mutableCopy];
            [nodeArray addObject:firstLevelNode1];
		}
        
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

#pragma mark -
#pragma mark loadData

- (void)reloadData
{
    [buffer removeAllObjects];
    [self.displayArray removeAllObjects];
    [self.tableView reloadData];
    [self fetchProduct];
}
- (void)fetchProduct
{
    if ([buffer count] == 0)
        [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, INVENTORY_CATALOG_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setHTTPMethod:@"POST"];

	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFetchProduct:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onFetchProduct: (NSNotification *)notify
{
    [subBuffer removeAllObjects];
    [self.tableView reloadData];

	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];

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
    NSArray *arr = [data objectForKey:@"data"];
    if ([data count] == 0) {
        [self.view hideToastActivity];
        [buffer removeAllObjects];
        return;
    }
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    NSLog(@"%@",buffer);

    [RWHomeCache writeToFile:buffer withName:@"stockList"];
    for (NSDictionary *d in buffer) {
        [yearBuffer addObjectsFromArray:[d objectForKey:@"yearArray"]];
    }
    yearIndex = 0;
    yearId = [[yearBuffer objectAtIndex:yearIndex] objectForKey:@"yearId"];
    [subBuffer removeAllObjects];
    [self fetchProductByYear];
}

- (void)fetchProductByYear
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_PRODUCT_BYID_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:yearId forKey:@"yearId"];
	[req setHTTPMethod:@"POST"];

	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFetchProductByYear:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onFetchProductByYear: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
		//login fail
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    
    if ([arr count] != 0) {
        NSDictionary *dic = @{@"yearId": yearId,@"data":arr};
        [subBuffer addObject:dic];
    }
    else{
        NSDictionary *dic = @{@"yearId": yearId,@"data":@[]};
        [subBuffer addObject:dic];
    }

    if (yearIndex < [yearBuffer count]-1) {
        yearIndex += 1;
        yearId = [[yearBuffer objectAtIndex:yearIndex] objectForKey:@"yearId"];
        [self fetchProductByYear];
        return;
    }
    
    [self.view hideToastActivity];
    [RWHomeCache writeToFile:subBuffer withName:@"subList"];
    [self fillNodesArray];
    [self fillDisplayArray];
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
