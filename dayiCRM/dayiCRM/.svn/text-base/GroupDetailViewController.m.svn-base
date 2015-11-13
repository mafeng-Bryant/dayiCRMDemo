//
//  GroupDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-9.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "MemberDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "UrlImageButton.h"
#import "SBJson.h"
#import "GroupMsgViewController.h"

@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController
@synthesize gid,gName;

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
    UIBarButtonItem *btn_done;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_done = [[UIBarButtonItem alloc] initWithTitle:@"完成"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_done_click:)];
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
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done setTitle:@"完成" forState:UIControlStateNormal];
        [done setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [done addTarget:self action:@selector(btn_done_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_done = [[UIBarButtonItem alloc] initWithCustomView:done];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    if (gid) {
        self.title = @"群组信息";
        [self loadGroupDetail];
    }
    else{
        self.title = @"创建群组";
        self.navigationItem.rightBarButtonItem = btn_done;
        [self loadGroupView];
    }
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
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

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (0 == indexPath.section && 0 == indexPath.row) {
        if (!tf_name) {
            tf_name = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 240, 30)];
            tf_name.placeholder = @"请输入群名称";
            tf_name.borderStyle = UITextBorderStyleNone;
            tf_name.backgroundColor = [UIColor clearColor];
            tf_name.textAlignment = NSTextAlignmentLeft;
            tf_name.font = [UIFont systemFontOfSize:15];
            tf_name.textColor = [UIColor darkGrayColor];
            tf_name.delegate = self;
            tf_name.returnKeyType = UIReturnKeyDone;
            tf_name.text = gName;
            if (gid) {
                tf_name.userInteractionEnabled = NO;
            }
            [cell.contentView addSubview:tf_name];
        }
     }
    else if (1 == indexPath.section && 0 == indexPath.row)
    {
        [cell.contentView addSubview:groupView];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return @"群组成员";
    }
    return @"群名称";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section) {
        return([groupsArray count]/6 +1)*50;
    }
    return 44.0f;
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_done_click:(id)sender
{
    if ([tf_name.text length] == 0) {
        [self.view.window makeToast:@"还没有填写群名称!"];
        return;
    }
    else if ([groupsArray count] == 0){
        [self.view.window makeToast:@"还没有选择群成员!"];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in groupsArray) {
        NSDictionary *d = @{@"userName": [dic objectForKey:@"customerName"],@"userId": [dic objectForKey:@"userId"]};
        [array addObject:d];
    }
    groupUsers = [array JSONRepresentation];
    [self createGroup];
}

- (void)btn_pic_click:(id)sender
{
    NSString *uid = [[groupsArray objectAtIndex:[sender tag]-1] objectForKey:@"memberId"] ;
    MemberDetailViewController *ctrl = [[MemberDetailViewController alloc] initWithNibName:@"MemberDetailViewController" bundle:nil];
    ctrl.uid = uid;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)btn_add_click:(id)sender
{
    ContactsListViewController *ctrl = [[ContactsListViewController alloc] initWithNibName:nil bundle:nil];
    ctrl.delegate = self;
    if ([groupsArray count]) {
        [ctrl setupSelectedArray:groupsArray];
    }
    if (gid) {
        originalArray = [NSMutableArray arrayWithArray:groupsArray];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
    [self.navigationController presentViewController:nav animated:YES completion:nil ];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)contactsListViewController:(ContactsListViewController *)ctrl didSelectedUsrArrary:(NSArray *)usr
{
    [ctrl dismissViewControllerAnimated:YES completion:nil];
    
    groupsArray = [NSMutableArray array];

    for (NSMutableDictionary *dic in usr) {
        [dic removeObjectForKey:@"selected"];
        [groupsArray addObject:dic];
    }
    
    [self loadGroupView];
    [self.tableView reloadData];
    
    if (gid) {
        NSArray *addArray = [self filtBuffer:groupsArray andBuffer:originalArray];
        NSArray *delArray = [self filtBuffer:originalArray andBuffer:groupsArray];
        if ([addArray count]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in addArray) {
                NSDictionary *d = [NSDictionary dictionary];
                if([dic objectForKey:@"userName"]){
                    d = @{@"userName": [dic objectForKey:@"userName"],@"userId": [dic objectForKey:@"userId"]};
                }
                else{
                    d = @{@"userName": [dic objectForKey:@"customerName"],@"userId": [dic objectForKey:@"userId"]};
                }
                [array addObject:d];
            }
            addGroupUsers = [array JSONRepresentation];
        }
        if ([delArray count]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic in delArray) {
                NSDictionary *d = [NSDictionary dictionary];
                if([dic objectForKey:@"userName"]){
                    d = @{@"userName": [dic objectForKey:@"userName"],@"userId": [dic objectForKey:@"userId"]};
                }
                else{
                    d = @{@"userName": [dic objectForKey:@"customerName"],@"userId": [dic objectForKey:@"userId"]};
                }

                [array addObject:d];
            }
            deleteGroupUsers = [array JSONRepresentation];
        }
        
        if ( addGroupUsers || deleteGroupUsers || [addGroupUsers length] || [deleteGroupUsers length]) {
            [self updateGroup];
        }
    }

}

#pragma mark loadData

- (void)createGroup
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, CREATE_GROUP_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:tf_name.text forKey:@"groupName"];
    [req setParam:groupUsers forKey:@"groupUsers"];
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
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    
    [SVProgressHUD showSuccessWithStatus:@"创建成功"];
    gid = [[json objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDidAdd" object:self];
    [self performSelector:@selector(popToMsgView) withObject:nil afterDelay:1.0f];
    
}

- (void)loadGroupDetail
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GROUP_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.gid forKey:@"groupId"];
    [req setHTTPMethod:@"POST"];
	
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadDetail:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoadDetail: (NSNotification *)notify
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
    
    detailDict = [json objectForKey:@"data"];
    gName = [detailDict objectForKey:@"groupName"];
    groupsArray = [detailDict objectForKey:@"groupUsers"];
    [self loadGroupView];
    [self.tableView reloadData];
}

- (void)updateGroup
{
    [SVProgressHUD showWithStatus:@"修改群用户中..."];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPDATE_GROUP_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.gid forKey:@"groupId"];
    if ([addGroupUsers length]) {
        [req setParam:addGroupUsers forKey:@"addGroupUsers"];
    }
    if ([deleteGroupUsers length]){
        [req setParam:deleteGroupUsers forKey:@"deleteGroupUsers"];
    }
    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUpdateGroup:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onUpdateGroup: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD dismissWithError:[[json objectForKey:@"data"] objectForKey:@"msg"]];
		return;
	}
    [SVProgressHUD dismissWithSuccess:@"修改成功!"];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [self.view hideToastActivity];
    [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

#pragma mark -

- (void)loadGroupView
{
    if (groupView) {
        [groupView removeFromSuperview];
        groupView = nil;
    }
    
    groupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IOS7?320:300,([groupsArray count]/6 +1)*50)];
    
    for (int i = 0; i < [groupsArray count]; i++) {
        NSDictionary *dic = [groupsArray objectAtIndex:i];
        UrlImageButton *btn = [[UrlImageButton alloc] initWithFrame:CGRectMake((10 + 40)*(i % 6) + 10 , (5 + 40)*(i / 6) + 5, 40,40)];
        [btn setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dic objectForKey:@"pictureId"]]];
        btn.tag = i + 1;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn addTarget:self action:@selector(btn_pic_click:) forControlEvents:UIControlEventTouchUpInside];
        [groupView addSubview:btn];
    }
    
    UIButton *btn_add = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_add setImage:[UIImage imageNamed:@"img49"] forState:UIControlStateNormal];
    btn_add.frame = CGRectMake((10 + 40)*([groupsArray count] % 6) + 10, (5 + 40)*([groupsArray count] / 6) + 5, 40, 40);
    [btn_add addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
    [groupView addSubview:btn_add];
}

- (NSArray *)filtBuffer:(NSArray *)original andBuffer:(NSArray *)src
{
    NSMutableArray *resultBuffer = [NSMutableArray array];
    for (NSDictionary *dic in original) {
        
        BOOL is_contain = NO;
        for (NSDictionary *dict in src) {
            if ([[dic objectForKey:@"userId"] isEqualToString:[dict objectForKey:@"userId"]]) {
                is_contain = YES;
            }
        }
        if (!is_contain) {
            [resultBuffer addObject:dic];
        }
    }
    
    return resultBuffer;
}

- (void)popToMsgView
{
    GroupMsgViewController *ctrl = [[GroupMsgViewController alloc] initWithNibName:@"GroupMsgViewController" bundle:nil];
    ctrl.gid = gid;
    ctrl.gName = tf_name.text;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
