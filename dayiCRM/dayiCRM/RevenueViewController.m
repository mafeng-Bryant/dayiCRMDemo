//
//  RevenueViewController.m
//  dayiCRM
//
//  Created by Fang on 14-7-5.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "RevenueViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RevenueCell.h"

@interface RevenueViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)IBOutlet UILabel *lb1_title;
@property(nonatomic,strong)IBOutlet UILabel *lb1_content;
@property(nonatomic,strong)IBOutlet UILabel *lb2_title;
@property(nonatomic,strong)IBOutlet UILabel *lb2_content;
@property(nonatomic,strong)IBOutlet UILabel *lb3_title;
@property(nonatomic,strong)IBOutlet UILabel *lb3_content;
@property(nonatomic,strong)IBOutlet UILabel *lb4_title;
@property(nonatomic,strong)IBOutlet UILabel *lb4_content;
@property(nonatomic,strong)IBOutlet UILabel *lb5_title;
@property(nonatomic,strong)IBOutlet UILabel *lb5_content;
@property(nonatomic,strong)IBOutlet UILabel *lb6_title;
@property(nonatomic,strong)IBOutlet UILabel *lb6_content;
@property(nonatomic,strong)IBOutlet UILabel *lb7_title;
@property(nonatomic,strong)IBOutlet UILabel *lb7_content;
@property(nonatomic,strong)IBOutlet UILabel *lb8_title;
@property(nonatomic,strong)IBOutlet UILabel *lb8_content;

@end

@implementation RevenueViewController
{
 UITableView *inComeTableView;
}

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"storeDidChange" object:nil];
    
    self.title = @"收入概况";
    UIBarButtonItem *btn_cancel;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
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
    }
    self.navigationItem.leftBarButtonItem = btn_cancel;

	[self initTableView];
	
    [self loadData];
}


//初始化tabeleView
- (void) initTableView
{
	inComeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-10, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
	inComeTableView.delegate = self;
	inComeTableView.dataSource = self;
	
	[inComeTableView registerNib:[UINib nibWithNibName:@"RevenueCell" bundle:nil]   forCellReuseIdentifier:@"RevenueCell"];
	
 	[self.view addSubview:inComeTableView];
	
	
}

#pragma - mark UITableViewDelegate


//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 10;//section头部高度
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([[dict objectForKey:@"type"] integerValue] == 2)
	{
		return 4;
	}
	else if ([[dict objectForKey:@"type"] integerValue] == 1)
	{
		if (section == 0||section == 1)
		{
			return 3;
		}else
		{
			return 1;
			
		}
		
		
	}
	return 0;
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *idenfic = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfic];
	
	NSLog(@"dict== %@",dict);
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:idenfic];
	}
	if ([[dict objectForKey:@"type"] integerValue] == 2)
	{
		if (indexPath.section == 0)
		{
			if (indexPath.row == 0)
			{
				RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
				
				cell.priceLable.text = [dict objectForKey:@"monthlyProfit"];
				cell.winLabel.text = @"月利润";
				
				return cell;
				
				//  cell.detailTextLabel.font = [UIFont systemFontOfSize:32];
				
			}else if (indexPath.row == 1)
			{
				cell.textLabel.text = @"月固定成本";
				
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"fixedCost"]];
				
			}else if (indexPath.row == 2)
			{
				cell.textLabel.text = @"月变动成本";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"variableCost"]];
				
			}else if (indexPath.row == 3)
			{
				cell.textLabel.text = @"月收入";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"monthlyIncome"]];
			
			}
			
		}
		else if (indexPath.section == 1)
		{
			if (indexPath.row == 0)
			{
				RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
				
				cell.priceLable.text = [dict objectForKey:@"profitForTheYear"];
				cell.winLabel.text = @"年利润";
				
				return cell;

				

				
			}else if (indexPath.row == 1)
			{
				cell.textLabel.text = @"年固定成本";
				
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"yearFixedCost"]];
			}else if (indexPath.row == 2)
			{
				cell.textLabel.text = @"年变动成本";
				
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"FYearVariableCost"]];
			}else if (indexPath.row == 3)
			{
				cell.textLabel.text = @"年收入";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"annualIncome"]];
			}
		}
	
	}
	
	else if ([[dict objectForKey:@"type"] integerValue] == 1)
	{
		
		if (indexPath.section == 0)
		{
			if (indexPath.row == 0)
			{
				RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
				
				cell.priceLable.text = [dict objectForKey:@"totalAmount"];
				cell.winLabel.text = @"当月提成总额";
				
				return cell;
				
				//  cell.detailTextLabel.font = [UIFont systemFontOfSize:32];
				
			}else if (indexPath.row == 1)
			{
				cell.textLabel.text = @"当月个人提成总额";
				
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"personalAmount"]];
				
			}else if (indexPath.row == 2)
			{
				cell.textLabel.text = @"当月团队提成";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"teamAmount"]];
				
			}
			
			
		}
		else if (indexPath.section == 1)
		{
			
			if (indexPath.row == 0)
			{
				RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
				
				cell.priceLable.text = [dict objectForKey:@"yearTotalAmount"];
				cell.winLabel.text = @"年累计提成";
				
				return cell;
				
				//  cell.detailTextLabel.font = [UIFont systemFontOfSize:32];
				
			}else if (indexPath.row == 1)
			{
				cell.textLabel.text = @"年个人提成";
				
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"yearPersonalAmount"]];
				
			}else if (indexPath.row == 2)
			{
				cell.textLabel.text = @"年团队提成";
				cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"yearTeamAmount"]];
				
			}
		}else if (indexPath.section == 2)
		{
			if (indexPath.row == 0)
			{
				RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
				
				cell.priceLable.text = [dict objectForKey:@"lastMonthHasReturn"];
				cell.winLabel.text = @"上月已返还金额";
				
				return cell;
				
			}
			
		}
		else if (indexPath.section == 3)
		{
			if (indexPath.row == 0)
			{
				
				RevenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RevenueCell"];
				
				cell.priceLable.text = [dict objectForKey:@"lastMonthNotReturn"];
				cell.winLabel.text = @"上月未返还金额";
				
				return cell;
				
			}
			
		}

		
		
		
	}
	return cell;
	
	
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([[dict objectForKey:@"type"] integerValue] == 2)
	{
		return 2;
	}else if ([[dict objectForKey:@"type"] integerValue] ==1)
	{
		return 4;
	}
	
	return 0;
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
	{
		return 85;
		
	}
	return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,INCOME_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    NSLog(@"%@",[token getProperty:@"storeId"]);
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
    NSLog(@"=======%@",[[json objectForKey:@"data"] objectForKey:@"msg"] );
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    //login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    dict = [json objectForKey:@"data"];
	
	
   // [self setDisplayData];
	[inComeTableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)setDisplayData
{
    if ([[dict objectForKey:@"type"] integerValue] == 2) {
        self.lb1_title.text = @"月收入";
        self.lb1_content.text = [dict objectForKey:@"monthlyIncome"];
        
        self.lb2_title.text = @"月固定成本";
        self.lb2_content.text = [dict objectForKey:@"fixedCost"];

        self.lb3_title.text = @"月变动成本";
        self.lb3_content.text = [dict objectForKey:@"variableCost"];

		
        self.lb5_title.text = @"月利润";
        self.lb5_content.text = [dict objectForKey:@"monthlyProfit"];

		
		self.lb4_title.text = @"年收入";
		self.lb4_content.text = [dict objectForKey:@"annualIncome"];

        self.lb6_title.text = @"年利润";
        self.lb6_content.text = [dict objectForKey:@"profitForTheYear"];

        self.lb7_title.text = @"年固定成本";
        self.lb7_content.text = [dict objectForKey:@"yearFixedCost"];

        self.lb8_title.text = @"年变动成本";
        self.lb8_content.text = [dict objectForKey:@"FYearVariableCost"];
    }
    else if ([[dict objectForKey:@"type"] integerValue] == 1) {
        self.lb1_title.text = @"当月提成总额(元)";
        self.lb1_content.text = [dict objectForKey:@"totalAmount"];
        
        self.lb2_title.text = @"当月个人提成总额(元)";
        self.lb2_content.text = [dict objectForKey:@"personalAmount"];
        
        self.lb3_title.text = @"当月团队提成(元)";
        self.lb3_content.text = [dict objectForKey:@"teamAmount"];
        
        self.lb4_title.text = @"上月已返还金额(元)";
        self.lb4_content.text = [dict objectForKey:@"lastMonthHasReturn"];
        
        self.lb5_title.text = @"上月未返还金额(元)";
        self.lb5_content.text = [dict objectForKey:@"lastMonthNotReturn"];
        
        self.lb6_title.text = @"年累计提成(元)";
        self.lb6_content.text = [dict objectForKey:@"yearTotalAmount"];
        
        self.lb7_title.text = @"年个人提成(元)";
        self.lb7_content.text = [dict objectForKey:@"yearPersonalAmount"];
        
        self.lb8_title.text = @"年团队提成(元)";
        self.lb8_content.text = [dict objectForKey:@"yearTeamAmount"];
    }

}

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
