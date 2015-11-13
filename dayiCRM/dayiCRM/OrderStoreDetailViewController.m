//
//  OrderStoreDetailViewController.m
//  dayiCRM
//
//  Created by Fang on 14-7-14.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "OrderStoreDetailViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "OrderListCell.h"
#import "StoreOrderViewCell.h"
#import "CheckoutListViewController.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "EpsonFormatter.h"
#import "RWHomeCache.h"

#define SERVICE_UUID @"fff0"
#define TX_UUID @"fff1"
#define RX_UUID @"fff2"

@interface OrderStoreDetailViewController ()
@property(nonatomic,strong)IBOutlet UIView *head_view;
@property(nonatomic,strong)IBOutlet UILabel *lb_orderName;
@property(nonatomic,strong)IBOutlet UILabel *lb_time;
@property(nonatomic,strong)IBOutlet UILabel *lb_totalPrice;
@property(nonatomic,strong)IBOutlet UIImageView *im_status;
@property(nonatomic,strong)IBOutlet UIImageView *im_avatar;
@property(nonatomic,strong)IBOutlet UILabel *lb_name;
@property(nonatomic,strong)IBOutlet UIToolbar *tool_bar;
@property(nonatomic,strong)IBOutlet UIButton *btn_total_price;
@property(nonatomic,strong)IBOutlet UIButton *btn_print;
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@end

@implementation OrderStoreDetailViewController
@synthesize oid,type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"订单详情";
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
        
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"img40.png"] forToolbarPosition:0 barMetrics:0];
    self.navigationController.toolbar.tintColor = [UIColor clearColor];
	self.navigationController.toolbar.backgroundColor = [UIColor clearColor];

    devicesList = [NSMutableArray new];

    [self initFootView];
    self.navigationItem.leftBarButtonItem = btn_cancel;
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureTransparentServiceUUID:[self getUuid:SERVICE_UUID] txUUID:[self getUuid:TX_UUID] rxUUID:[self getUuid:RX_UUID]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	self.toolbarItems = self.tool_bar.items;
	[self.navigationController setToolbarHidden:YES animated:YES];
    if (connectedPeripheral) {
        [self disconnectDevice:connectedPeripheral];
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
    if (![[dict objectForKey:@"status"] isEqualToString:@"Finished"]){
        return 1;
    }
    else if ([[dict objectForKey:@"roomName"] length] == 0){
        return 2;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (0 == section) {
        return [detailArray count];
    }
    else if (1 == section){
        if ([[dict objectForKey:@"roomName"] length] == 0) {
            return 1;
        }
        return 4;
    }
    else if (2 == section){
        return 1;
    }
    return 0;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        NSString *CellIdentifier = @"StoreOrderViewCell";
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[detailArray objectAtIndex:indexPath.row] ];
        [dic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
        StoreOrderViewCell *cell = (StoreOrderViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell)
        {
            UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
            
            cell = (StoreOrderViewCell *)uc.view;
            [cell setContent:dic];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    static NSString *cell_id = @"cell";
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (1 == indexPath.section){
        if ([[dict objectForKey:@"roomName"] length] == 0){
            cell.textLabel.text = @"折扣";
            if (!lb_discount) {
                lb_discount = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
                lb_discount.textColor = [UIColor darkGrayColor];
                lb_discount.font = font;
                lb_discount.backgroundColor = [UIColor clearColor];
                lb_discount.textAlignment = NSTextAlignmentRight;
                lb_discount.text = [dict objectForKey:@"discount"];
                [cell.contentView addSubview:lb_discount];
            }
            return cell;
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"包间";
                if (!lb_roomName) {
                    lb_roomName = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
                    lb_roomName.textColor = [UIColor darkGrayColor];
                    lb_roomName.font = font;
                    lb_roomName.backgroundColor = [UIColor clearColor];
                    lb_roomName.textAlignment = NSTextAlignmentRight;
                    lb_roomName.text = [dict objectForKey:@"roomName"];
                    [cell.contentView addSubview:lb_roomName];
                }
                break;
            case 1:
                cell.textLabel.text = @"包间单价";
                if (!lb_roomPrice) {
                    lb_roomPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
                    lb_roomPrice.textColor = [UIColor darkGrayColor];
                    lb_roomPrice.font = font;
                    lb_roomPrice.backgroundColor = [UIColor clearColor];
                    lb_roomPrice.textAlignment = NSTextAlignmentRight;
                    lb_roomPrice.text = [dict objectForKey:@"roomPrice"];
                    [cell.contentView addSubview:lb_roomPrice];
                }
                break;
            case 2:
                cell.textLabel.text = @"包间用时";
                if (!lb_roomHour) {
                    lb_roomHour = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
                    lb_roomHour.textColor = [UIColor darkGrayColor];
                    lb_roomHour.font = font;
                    lb_roomHour.backgroundColor = [UIColor clearColor];
                    lb_roomHour.textAlignment = NSTextAlignmentRight;
                    lb_roomHour.text = [dict objectForKey:@"roomHour"];
                    [cell.contentView addSubview:lb_roomHour];
                }
                break;
            case 3:
                cell.textLabel.text = @"包间费用";
                if (!lb_perHourPrice) {
                    lb_perHourPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
                    lb_perHourPrice.textColor = [UIColor darkGrayColor];
                    lb_perHourPrice.font = font;
                    lb_perHourPrice.backgroundColor = [UIColor clearColor];
                    lb_perHourPrice.textAlignment = NSTextAlignmentRight;
                    lb_perHourPrice.text = [dict objectForKey:@"perHourPrice"];
                    [cell.contentView addSubview:lb_perHourPrice];
                }
                break;
            default:
                break;
        }
    }
    
    else if (2 == indexPath.section){
        cell.textLabel.text = @"折扣";
        if (!lb_discount) {
            lb_discount = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 100, 40)];
            lb_discount.textColor = [UIColor darkGrayColor];
            lb_discount.font = font;
            lb_discount.backgroundColor = [UIColor clearColor];
            lb_discount.textAlignment = NSTextAlignmentRight;
            lb_discount.text = [dict objectForKey:@"discount"];
            [cell.contentView addSubview:lb_discount];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 76;
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 112;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return  self.head_view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (![[dict objectForKey:@"status"] isEqualToString:@"Finished"])
    {
        return 100;
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![[dict objectForKey:@"status"] isEqualToString:@"Finished"])
    {
        return footView;
    }
    return nil;
}

#pragma mark -
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_certain_click:(id)sender
{
    CheckoutListViewController *ctrl = [[CheckoutListViewController alloc] initWithNibName:@"CheckoutListViewController" bundle:nil];
    ctrl.oid = self.oid;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)initFootView
{
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    footView.backgroundColor = [UIColor clearColor];
    footView.userInteractionEnabled = YES;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage: [[UIImage imageNamed:@"btn4"] resizableImageWithCapInsets:UIEdgeInsetsMake(4,4, 4, 4)] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(16.0f, 30, 288, 44);
    [btn1 addTarget:self action:@selector(btn_certain_click:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"结账" forState:UIControlStateNormal];
    [footView addSubview:btn1];
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中"];
    
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,ORDER_STORE_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:self.oid forKey:@"orderId"];
    
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",json);
    
    //login fail
	if (![[json objectForKey:@"success"] boolValue])
    {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        [self.tableView reloadData];
        return;
    }

    dict = [json objectForKey:@"data"];
    if ([[dict objectForKey:@"msg"] length]) {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"]];
        return;
    }
    detailArray = [dict objectForKey:@"detailArray"];
    [self initHeadView];
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void) initHeadView
{
    if ([[dict objectForKey:@"status"] isEqualToString:@"Finished"])
    {
        self.toolbarItems = self.tool_bar.items;
        [self.navigationController setToolbarHidden:NO animated:NO];
        
        [self.btn_total_price setTitle:[NSString stringWithFormat:@"总价:%@",[dict objectForKey:@"receivableAmount"]] forState:UIControlStateNormal];
        [self.btn_total_price setTitleColor:dayiColor forState:UIControlStateNormal];
        
        [self startScan];

    }

    self.lb_orderName.text = [dict objectForKey:@"orderName"];
    self.lb_name.text = [dict objectForKey:@"userName"];

    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *post_date;
    if ([dict objectForKey:@"orderDate"]) {
        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"orderDate"] doubleValue]/1000]];
        self.lb_time.text = post_date;
    }
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"Finished"]) {
        self.im_status.image = [UIImage imageNamed:@"yjz"];
    }
    else
    {
        self.im_status.image = [UIImage imageNamed:@"wjz"];
    }
    
    NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[dict objectForKey:@"avatarId"]];
	UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
	if (avatar_im)
	{
		[self.im_avatar setImage:avatar_im];
	}
	else
	{
		RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
															 parentView:self.im_avatar
															   delegate:self
													   defaultImageName:@"default_pic_avatar"];
		
		[self.im_avatar setImage:r_img];
	}


 }

#pragma mark -
#pragma mark RRRemoteImageDelegate

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
	static UIImage *empty_image = nil;
	
	if (nil == empty_image)
	{
		empty_image = [UIImage imageNamed:@"default_pic_avatar"];
	}
	
	[self.im_avatar setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	[self.im_avatar setImage:newImage];
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

- (IBAction)btn_print_click:(id)sender
{
    if (connectedPeripheral) {
        writeAllowFlag = YES;
        if (connectedPeripheral.connectStaus == MYPERIPHERAL_CONNECT_STATUS_CONNECTED) {
            [self writeFile];
        }
        else if (connectedPeripheral.connectStaus == MYPERIPHERAL_CONNECT_STATUS_CONNECTING){
            [self.view.window makeToast:@"打印机正在连接..." duration:1.0f position:@"center"];
        }
        return;
    }
    
    if (alertView){
        alertView = nil;
    }
    alertView = [[ISSCTableAlertView alloc] initWithCaller:self data:buffer title:@"请选择蓝牙设备" buttonTitle:@"取消" andContext:@"请选择蓝牙设备"];
    [alertView show];
}

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context{
    if ([devicesList count] && row>=0) {
        MyPeripheral *peripheral = [devicesList objectAtIndex:row];
        connectedPeripheral = peripheral;
        [self connectDevice:peripheral];
        [self stopScan];
    }
}

- (void)updateDiscoverPeripherals {
    [super updateDiscoverPeripherals];
    [self resetAlertViewData];
    for (MyPeripheral *peripheral in devicesList) {
        if ([peripheral.advName isEqualToString:@"Dual-SPP"]) {
            connectedPeripheral = peripheral;
            [self connectDevice:peripheral];
            [self stopScan];
        }
    }
}

- (void)sendTransparentData:(NSData *)data {
    NSLog(@"[DataTransparentViewController] sendTransparentData:%@", data);
    CBCharacteristicWriteType writeType = [connectedPeripheral sendTransparentData:data type:CBCharacteristicWriteWithoutResponse];
    
    if (writeAllowFlag) {
        [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(writeFile) userInfo:nil repeats:NO];
    }
}

-(void) writeFile {
    if (![connectedPeripheral.transmit canSendReliableBurstTransmit]) {
        return;
    }
    NSMutableData *data = [NSMutableData alloc];
    
    if ([[self getTransmitData] length] < [connectedPeripheral.transmit transmitSize]) {
        [data appendData:[self getTransmitData]];
    }
    else{
        if (fileReadOffset + [connectedPeripheral.transmit transmitSize] < [[self getTransmitData] length]) {
            [data appendData:[[self getTransmitData] subdataWithRange:NSMakeRange(fileReadOffset, [connectedPeripheral.transmit transmitSize])]];
        }
        else{
            [data appendData:[[self getTransmitData] subdataWithRange:NSMakeRange(fileReadOffset,[[self getTransmitData] length]-fileReadOffset)]];
        }
    }
    
    if ([data length] && fileReadOffset<[[self getTransmitData] length]-1) {
        fileReadOffset += [data length];
        [self sendTransparentData:data];
    }
    else {
        fileReadOffset = 0;
        writeAllowFlag = NO;
        [self.view.window makeToast:@"打印完成!" duration:1.0f position:@"center"];
    }
}

- (NSData *)getTransmitData
{
    RRToken *token = [RRToken getInstance];
    NSString *storeName = [token getProperty:@"storeName"];
    
    NSArray *a = [RWHomeCache readFromFile:@"storeList"];
    NSString *number,*phone;
    for (NSDictionary *dic in a) {
        if ([[dic objectForKey:@"storeName"] isEqualToString:storeName]) {
            number = [dic objectForKey:@"number"];
            phone = [dic objectForKey:@"phone"];
        }
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *post_date;
    if ([dict objectForKey:@"orderDate"]) {
        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"orderDate"] doubleValue]/1000]];
    }

    
    EpsonFormatter *epsonFormatter = [[EpsonFormatter alloc] init] ;
    [epsonFormatter initializePrinter];
    [epsonFormatter selectStandardPrinterMode];
    [epsonFormatter selectCenterJustification];
    [epsonFormatter selectZoomFont];
    [epsonFormatter appendString:storeName];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectNormalFont];
    [epsonFormatter selectLeftJustification];
    [epsonFormatter appendString:@"－－－－－－－－－－－－－－－－"];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[@"门店授权号:" stringByAppendingString:number]];
    [epsonFormatter appendReturnString];
    if ([[dict objectForKey:@"roomName"] length]) {
        [epsonFormatter appendString:[@"包间名称:" stringByAppendingString:[dict objectForKey:@"roomName"]]];
        [epsonFormatter appendReturnString];
    }
    [epsonFormatter appendString:[@"单号:" stringByAppendingString:[dict objectForKey:@"orderName"]]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[@"下单时间:" stringByAppendingString:post_date]];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectBoldStyle];
    [epsonFormatter appendString:@"－－－－－－－－－－－－－－－－"];
    [epsonFormatter cancelBoldStyle];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectNormalFont];
    [epsonFormatter appendString:@"名称      单价     数量     金额"];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectBoldStyle];
    [epsonFormatter appendString:@"－－－－－－－－－－－－－－－－"];
    [epsonFormatter cancelBoldStyle];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectNormalFont];
    for (NSDictionary *dic in detailArray) {
        [epsonFormatter selectLeftJustification];
        [epsonFormatter appendString:[dic objectForKey:@"productName"]];
        [epsonFormatter appendReturnString];
        [epsonFormatter appendString:[dic objectForKey:@"serialNumber"]];
        for (int i = 0; i< 4; i++) {
            [epsonFormatter appendTabString];
        }
        [epsonFormatter appendString:[dic objectForKey:@"unitPrice"]];
        int j = [[dic objectForKey:@"unitPrice"] length];
        for (int i = 0; i< abs(j-8); i++) {
            [epsonFormatter appendTabString];
        }
        [epsonFormatter appendString:[dic objectForKey:@"productNumber"]];
        int k = [[dic objectForKey:@"productNumber"] length];
        for (int i = 0; i< abs(k-8); i++) {
            [epsonFormatter appendTabString];
        }
        [epsonFormatter appendString:[NSString stringWithFormat:@"%.1f",[[dic objectForKey:@"productNumber"] floatValue] *[[dic objectForKey:@"unitPrice"] floatValue]]];
        [epsonFormatter appendReturnString];
    }
    
    [epsonFormatter selectLeftJustification];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectBoldStyle];
    [epsonFormatter appendString:@"－－－－－－－－－－－－－－－－"];
    [epsonFormatter cancelBoldStyle];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectNormalFont];
    if ([[dict objectForKey:@"perHourPrice"] length]) {
        [epsonFormatter appendString:[@"包间费用:" stringByAppendingString:[dict objectForKey:@"perHourPrice"]]];
        [epsonFormatter appendReturnString];
    }
    [epsonFormatter appendString:[NSString stringWithFormat:@"合计份数:%d",[detailArray count]]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[NSString stringWithFormat:@"折扣:%@",[dict objectForKey:@"discount"]]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[NSString stringWithFormat:@"合计金额:%@",[dict objectForKey:@"receivableAmount"]]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:@"－－－－－－－－－－－－－－－－"];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[@"打印时间:" stringByAppendingString:[self getCurrentTime]]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[@"收银员:" stringByAppendingString:[token getProperty:@"loginName"]]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:[@"客服电话:" stringByAppendingString:phone]];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendString:@"顾客签名:"];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter selectCenterJustification];
    [epsonFormatter selectZoomFont];
    [epsonFormatter appendString:@"谢谢惠顾,欢迎再次光临!"];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];
    [epsonFormatter appendReturnString];

    NSData *outputData = epsonFormatter.data;
    return outputData;
}

- (NSString *)getCurrentTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * curTime = [formater stringFromDate:date];
    return  curTime;
}

- (void)isBluetoothEnabled:(BOOL)flag
{
    if (flag) {
        [self startScan];
    }
    else{
        connectedPeripheral = nil;
    }
}

- (void)resetAlertViewData
{
    [buffer removeAllObjects];
    buffer = [NSMutableArray array];
    for (MyPeripheral *peripheral in devicesList) {
        if (peripheral && [peripheral.advName length]) {
            [buffer addObject:peripheral.advName];
        }
    }
    
    [alertView setUpData:buffer];
}

- (NSString *) getUuid: (NSString *)uuid{
    NSMutableString *data= [[NSMutableString alloc] init];
    
    [data setString:uuid];
    if ([data length] == 32) {
        [data insertString:@"-" atIndex:20];
        [data insertString:@"-" atIndex:16];
        [data insertString:@"-" atIndex:12];
        [data insertString:@"-" atIndex:8];
    }
    return data;//[data autorelease];
}


@end
