//
//  StoreListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-5-27.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StoreListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "RWHomeCache.h"

@interface StoreListViewController ()

@end

@implementation StoreListViewController
@synthesize delegate,buffer;

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
    self.title = @"门店列表";

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"storeName"];
    cell.textLabel.textColor = [UIColor whiteColor];
    if ([[[RRToken getInstance] getProperty:@"storeName"] isEqualToString:[dic objectForKey:@"storeName"]]){
        cell.textLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:226.0f/255.0f blue:29.0f/255.0f alpha:1.0f];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RRToken *token = [RRToken getInstance];
    [token setProperty:[[buffer objectAtIndex:indexPath.row] objectForKey:@"storeName"] forKey:@"storeName"];
    [token setProperty:[[buffer objectAtIndex:indexPath.row] objectForKey:@"storeId"] forKey:@"storeId"];
    [token saveToFile];
    if (delegate)
        [delegate didSelectedStoreName:[[buffer objectAtIndex:indexPath.row] objectForKey:@"storeName"]];
}

- (void)loadStoreList
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_STORELIST_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"id"] forKey:@"userId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadedStoreList:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoadedStoreList: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"storeList"];
    if ([arr count] == 0) {
        NSLog(@"%@",[data objectForKey:@"msg"]);
        return;
    }
    
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    [RWHomeCache writeToFile:buffer withName:@"storeList"];
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

@end
