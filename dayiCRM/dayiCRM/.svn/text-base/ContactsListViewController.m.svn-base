//
//  ContactsListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "ContactsListViewController.h"
#import "pinyin.h"
#import "MemberListCell.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "BATableView.h"
#import "ContactsListViewCell.h"

@interface ContactsListViewController ()<BATableViewDelegate>
@property(nonatomic,strong)IBOutlet UIView *list_view;
@property(nonatomic,strong)IBOutlet BATableView *table_view;

@end

@implementation ContactsListViewController
@synthesize delegate,selectedArray;

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
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_done;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_done = [[UIBarButtonItem alloc] initWithTitle:@"确定"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_done_click:)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done setTitle:@"确定" forState:UIControlStateNormal];
        [done setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [done addTarget:self action:@selector(btn_done_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_done = [[UIBarButtonItem alloc] initWithCustomView:done];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.title = @"选择联系人";
    self.navigationItem.rightBarButtonItem = btn_done;
    buffer = [NSMutableArray array];
    bufferTmp = [NSMutableArray array];
    usrArray = [NSMutableArray array];
    [self createTableView];
    [self loadData];

}

- (void)setupSelectedArray:(NSArray *)array
{
    selectedArray = [NSMutableArray arrayWithArray:array];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark EventHandle

- (void) createTableView {
    self.table_view = [[BATableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-64)];
    self.table_view.delegate = self;
    [self.view addSubview:self.table_view];
}

- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btn_done_click:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(contactsListViewController:didSelectedUsrArrary:)]) {
        [delegate contactsListViewController:self didSelectedUsrArrary:usrArray];
    }
}


#pragma mark loadData

- (void)loadData
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MEMBERUSER_LIST_URL];
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
    
    NSDictionary *data = [[json objectForKey:@"data"] objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"customers"];
    if ([arr count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        return;
    }
    [bufferTmp removeAllObjects];
    [bufferTmp addObjectsFromArray:arr];
    
    [buffer removeAllObjects];
    [self filtBuffer];
    [self.table_view reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)filtBuffer
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in bufferTmp) {
        [dic setObject:@"0" forKey:@"selected"];
        if ([selectedArray count]) {
            for (NSDictionary *dict in selectedArray) {
                if ([[dict objectForKey:@"userId"] isEqualToString:[dic objectForKey:@"userId"]]) {
                    [dic setObject:@"1" forKey:@"selected"];
                    [usrArray addObject:dic];
                }
            }
        }
        NSString *nickname = [dic objectForKey:@"customerName"];
        if ([nickname length] == 0) {
            continue;
        }
        
        NSRange range = NSMakeRange(0, 1);
        NSString *subString = [nickname substringWithRange:range];
        
        NSString *firstLetter ;
        if (![self isHanZi:subString] && ![self isPureInt:subString])
        {
            firstLetter = [subString lowercaseString];
        }
        else
        {
            firstLetter = [NSString stringWithFormat:@"%c", pinyinFirstLetter([nickname characterAtIndex:0])];
        }
        
        BOOL is_contain = NO;
        
        for (NSDictionary *dict in array) {
            if ([[dict objectForKey:@"letter"] isEqualToString:[firstLetter capitalizedString]]) {
                is_contain = YES;
                NSMutableArray *a = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];
                [a addObject:dic];
                NSDictionary *d = @{@"letter": [firstLetter capitalizedString],@"data":a};
                [array replaceObjectAtIndex:[array indexOfObject:dict] withObject:d];
                break;
            }
        }
        
        if (!is_contain) {
            NSArray *a = @[dic];
            NSDictionary *d = @{@"letter": [firstLetter capitalizedString],@"data":a};
            [array addObject:d];
        }
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"letter" ascending:YES];
    NSArray *tempArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    [buffer removeAllObjects];
    [buffer addObjectsFromArray:tempArray];
    
    NSDictionary *dic = [buffer objectAtIndex:0];
    if ([[dic objectForKey:@"letter"] isEqualToString:@"#"]) {
        [buffer insertObject:dic atIndex:[buffer count]];
        [buffer removeObjectAtIndex:0];
    }
}

- (BOOL) isHanZi:(NSString *)str
{
//    const char *cString = [str UTF8String];
//    if (strlen(cString) == 3)
//    {
//        return YES;
//    }
//    return NO;
	return YES;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark UITableViewDelagate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([buffer count] == 0) {
        return 1;
    }
    return [buffer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([buffer count] == 0) {
        return 1;
    }
    return [[[buffer objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    NSString *CellIdentifier = @"ContactsListViewCell";
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    ContactsListViewCell *cell = (ContactsListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (ContactsListViewCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    NSMutableArray *key = [NSMutableArray array];
    for (NSDictionary *dic in buffer) {
        [key addObject:[dic objectForKey:@"letter"]];
    }
    return key;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([buffer count] == 0) {
        return nil;
    }
    return [[buffer objectAtIndex:section] objectForKey:@"letter"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([[dic objectForKey:@"selected"] integerValue]) {
        [d setObject:@"0" forKey:@"selected"];
        for (NSDictionary *usr in usrArray) {
            if ([[usr objectForKey:@"userId"] isEqualToString:[dic objectForKey:@"userId"]]) {
                [usrArray removeObject:usr];
                break;
            }
        }
    }
    else{
        [d setObject:@"1" forKey:@"selected"];
        [usrArray addObject:dic];
    }
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:[[buffer objectAtIndex:indexPath.section] objectForKey:@"data"]];
    [tmp replaceObjectAtIndex:indexPath.row withObject:d];
    NSDictionary *dict = @{@"data": tmp,@"letter":[[buffer objectAtIndex:indexPath.section] objectForKey:@"letter"]};
    [buffer replaceObjectAtIndex:indexPath.section withObject:dict];
    [self.table_view reloadData];
    
}


@end
