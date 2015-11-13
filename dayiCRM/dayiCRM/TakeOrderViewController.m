//
//  TakeOrderViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-2.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "TakeOrderViewController.h"
#import "ProductListViewController.h"
#import "PriceListViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "SBJson.h"
#import "OrderStoreDetailViewController.h"

@interface TakeOrderViewController ()

@end

@implementation TakeOrderViewController

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
    self.title = @"快速下单";
    
    productArray = [NSMutableArray arrayWithCapacity:0];
    
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
    self.navigationItem.leftBarButtonItem = btn_cancel;
    productNum = 1;
    discount = @"1.0";
    
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"img40.png"] forToolbarPosition:0 barMetrics:0];
    self.navigationController.toolbar.tintColor = [UIColor clearColor];
	self.navigationController.toolbar.backgroundColor = [UIColor clearColor];
    
    [btn_total_price setTitle:@"总金额:￥0" forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	self.toolbarItems = tool_bar.items;
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2 + productNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < productNum-1 || section == productNum) {
        return 3;
    }
    else if (section == productNum-1){
        return 4;
    }
    else if (section == productNum + 1){
        return 2;

    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"cell_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
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
    cell.textLabel.font = font;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section <= productNum-1) {
        NSDictionary *dic ;
        if ([productArray count] && indexPath.section < [productArray count]) {
            dic = [productArray objectAtIndex:indexPath.section];
        }
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"茶品名称";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                if ([cell.contentView viewWithTag:indexPath.section+indexPath.row+1]) {
                    [[cell.contentView viewWithTag:indexPath.section+indexPath.row+1] removeFromSuperview];
                }
                UILabel *lb_productName = [[UILabel alloc] initWithFrame:CGRectMake(80, 2, 200, 40)];
                lb_productName.textAlignment = NSTextAlignmentRight;
                lb_productName.textColor = [UIColor darkGrayColor];
                lb_productName.font = [UIFont systemFontOfSize:13.0f];
                lb_productName.backgroundColor = [UIColor clearColor];
                if (dic) {
                    lb_productName.text = [dic objectForKey:@"productName"];
                }
                lb_productName.tag = indexPath.section+indexPath.row+1;
                [cell.contentView addSubview:lb_productName];
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"购买数量";
                if ([cell.contentView viewWithTag:indexPath.section+indexPath.row+100]) {
                    [[cell.contentView viewWithTag:indexPath.section+indexPath.row+100] removeFromSuperview];
                }
                UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img33"]];
                iv.frame = CGRectMake(IOS7?190:170, 4, 112, 36);
                iv.tag = indexPath.section+indexPath.row+100;
                [cell.contentView addSubview:iv];
                
                if ([cell.contentView viewWithTag:indexPath.section+indexPath.row+200]) {
                    [[cell.contentView viewWithTag:indexPath.section+indexPath.row+200] removeFromSuperview];
                }
                UIButton *btn_reduce = [UIButton buttonWithType:UIButtonTypeCustom];
                btn_reduce.frame = CGRectMake(IOS7?190:170, 4, 37, 37);
                btn_reduce.tag = indexPath.section+indexPath.row+200;
                btn_reduce.showsTouchWhenHighlighted = YES;
                [btn_reduce addTarget:self action:@selector(btn_reduce_click:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn_reduce];
                
                if ([cell.contentView viewWithTag:indexPath.section+indexPath.row+300]) {
                    [[cell.contentView viewWithTag:indexPath.section+indexPath.row+300] removeFromSuperview];
                }
                UILabel *amounts = [[UILabel alloc] initWithFrame:CGRectMake(IOS7?227:207,4, 37, 37)];
                amounts.tag = indexPath.section+indexPath.row+300;
                amounts.textAlignment = NSTextAlignmentCenter;
                amounts.textColor = [UIColor darkGrayColor];
                amounts.font = [UIFont systemFontOfSize:13.0f];
                amounts.backgroundColor = [UIColor clearColor];
                if (dic) {
                    amounts.text = [dic objectForKey:@"productAmount"];
                }

                [cell.contentView addSubview:amounts];
                
                if ([cell.contentView viewWithTag:indexPath.section+indexPath.row+400]) {
                    [[cell.contentView viewWithTag:indexPath.section+indexPath.row+400] removeFromSuperview];
                }
                UIButton *btn_add = [UIButton buttonWithType:UIButtonTypeCustom];
                btn_add.frame = CGRectMake(IOS7?264:244, 4, 37, 37);
                btn_add.tag = indexPath.section+indexPath.row+400;
                btn_add.showsTouchWhenHighlighted = YES;
                [btn_add addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn_add];
            }
                break;
            case 2:
                cell.textLabel.text = @"茶品单价";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                cell.detailTextLabel.textColor = [UIColor darkGrayColor];
                if (dic) {
                    if ([[dic objectForKey:@"productBigUnitId"] isEqualToString:[dic objectForKey:@"selectedUnit"]]) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@/%@",[dic objectForKey:@"productBigPrice"],[dic objectForKey:@"productBigUnitName"]];
                        
                    }
                    else if ([[dic objectForKey:@"productSmallUnitId"] isEqualToString:[dic objectForKey:@"selectedUnit"]]) {
                       cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@/%@",[dic objectForKey:@"productSmallPrice"],[dic objectForKey:@"productSmallUnitName"]];
                    }

                }
                break;
            case 3:
                cell.textLabel.text = @"";

            {
                if (lb_add) {
                    [lb_add removeFromSuperview];
                    lb_add = nil;
                }
                lb_add = [[UILabel alloc] initWithFrame:CGRectMake(0,5, IOS7?320:300, 30)];
                lb_add.textAlignment = NSTextAlignmentCenter;
                lb_add.textColor = [UIColor lightGrayColor];
                lb_add.font = [UIFont systemFontOfSize:13.0f];
                lb_add.backgroundColor = [UIColor clearColor];
                lb_add.text = @"+ 添加茶品";
                [cell.contentView addSubview:lb_add];
            }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            default:
                break;
        }
        return cell;
    }
    else if (indexPath.section == productNum){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"茶品金额";
                if (lb_amount) {
                    [lb_amount removeFromSuperview];
                    lb_amount = nil;
                }
                
                lb_amount = [[UILabel alloc] initWithFrame:CGRectMake(IOS7?200:180,5, 90, 30)];
                lb_amount.textAlignment = NSTextAlignmentRight;
                lb_amount.textColor = [UIColor darkGrayColor];
                lb_amount.font = [UIFont systemFontOfSize:13.0f];
                lb_amount.backgroundColor = [UIColor clearColor];
                lb_amount.text = amount;
                [cell.contentView addSubview:lb_amount];
                break;
            case 1:
                cell.textLabel.text = @"折扣";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (tf_discount) {
                    [tf_discount removeFromSuperview];
                    tf_discount = nil;
                }
                tf_discount = [[UITextField alloc] initWithFrame:CGRectMake(IOS7?190:170, IOS7?2:10, 100, 40)];
                tf_discount.textColor = [UIColor darkGrayColor];
                tf_discount.font = [UIFont systemFontOfSize:13.0f];
                tf_discount.backgroundColor = [UIColor clearColor];
                tf_discount.textAlignment = NSTextAlignmentRight;
                tf_discount.delegate = self;
                tf_discount.returnKeyType = UIReturnKeyNext;
                tf_discount.text = discount;
                [cell.contentView addSubview:tf_discount];
                break;
            case 2:
                cell.textLabel.text = @"总金额";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (tf_total) {
                    [tf_total removeFromSuperview];
                    tf_total = nil;
                }
                tf_total = [[UITextField alloc] initWithFrame:CGRectMake(IOS7?190:170, IOS7?2:10, 100, 40)];
                tf_total.textColor = [UIColor darkGrayColor];
                tf_total.font = [UIFont systemFontOfSize:13.0f];
                tf_total.backgroundColor = [UIColor clearColor];
                tf_total.textAlignment = NSTextAlignmentRight;
                tf_total.delegate = self;
                tf_total.returnKeyType = UIReturnKeyDone;
                tf_total.text = total;
                [cell.contentView addSubview:tf_total];
                break;
            default:
                break;
        }
        return cell;
    }
    else if (indexPath.section == productNum + 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"订货人";
                if (lb_orderer) {
                    [lb_orderer removeFromSuperview];
                    lb_orderer = nil;
                }
                
                lb_orderer = [[UILabel alloc] initWithFrame:CGRectMake(IOS7?200:180,5, 90, 30)];
                lb_orderer.textAlignment = NSTextAlignmentRight;
                lb_orderer.textColor = [UIColor darkGrayColor];
                lb_orderer.font = [UIFont systemFontOfSize:13.0f];
                lb_orderer.backgroundColor = [UIColor clearColor];
                lb_orderer.text = order;
                [cell.contentView addSubview:lb_orderer];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            case 1:
                cell.textLabel.text = @"备注";
                if (tf_remark) {
                    [tf_remark removeFromSuperview];
                    tf_remark = nil;
                }
                tf_remark = [[UITextField alloc] initWithFrame:CGRectMake(IOS7?80:60, IOS7?2:10, 200, 40)];
                tf_remark.textColor = [UIColor darkGrayColor];
                tf_remark.font = [UIFont systemFontOfSize:13.0f];
                tf_remark.backgroundColor = [UIColor clearColor];
                tf_remark.textAlignment = NSTextAlignmentRight;
                tf_remark.delegate = self;
                tf_remark.returnKeyType = UIReturnKeyDone;
                tf_remark.text = remark;
                [cell.contentView addSubview:tf_remark];
                break;
            default:
                break;
        }
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    seletedIndex = indexPath.section;

    if (indexPath.section < productNum){
        if (indexPath.row == 0) {
            ProductListViewController *ctrl = [[ProductListViewController alloc] initWithStyle:UITableViewStyleGrouped];
            ctrl.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else if (indexPath.row == 2) {
            NSDictionary *dic ;
            if ([productArray count] && indexPath.section < [productArray count]) {
                PriceListViewController *ctrl = [[PriceListViewController alloc] initWithStyle:UITableViewStyleGrouped];
                ctrl.delegate = self;
                dic = [productArray objectAtIndex:indexPath.section];
                ctrl.dic = dic;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
        }
       else if (indexPath.row == 3) {
            productNum += 1;
            [self removeLable];
            [self.tableView reloadData];
        }
    }
    
    else if (indexPath.section == productNum + 1){
        if (0 == indexPath.row) {
            MemberUsrListViewController *ctrl = [[MemberUsrListViewController alloc] initWithSectionIndexes:YES];
            ctrl.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)productListViewController:(ProductListViewController *)ctrl didSelectedProduct:(NSDictionary *)product;
{
    [ctrl dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary *products = [NSMutableDictionary dictionaryWithDictionary:product];
    [products setObject:@"1" forKey:@"productAmount"];
    [products setObject:[product objectForKey:@"productSmallUnitId"] forKey:@"selectedUnit"];
    if ([productArray count]) {
        BOOL is_contain = NO;
        for (int i = 0;i < [productArray count];i++) {
            NSDictionary *dic = [productArray objectAtIndex:i];
            if ([[dic objectForKey:@"productId"]isEqualToString:[products objectForKey:@"productId"]]) {
                [productArray replaceObjectAtIndex:i withObject:products];
                is_contain = YES;
            }
        }
        if (is_contain == NO) {
            if (seletedIndex < [productArray count]) {
                [productArray replaceObjectAtIndex:seletedIndex withObject:products];
            }
            else{
                [productArray addObject:products];
            }

        }
        
    }
    else{
        [productArray addObject:products];
    }
    total = nil;
    [self calculatorTotalPrice];
    [self.tableView reloadData];
}

- (void)priceListViewController:(PriceListViewController*)ctrl didSeletedPrice:(NSString *)price
{
    [ctrl dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:[productArray objectAtIndex:seletedIndex]];
    [dic setObject:price forKey:@"selectedUnit"];
    [productArray replaceObjectAtIndex:seletedIndex withObject:dic];
    total = nil;
    [self calculatorTotalPrice];
    [self.tableView reloadData];

}

- (void)memberUsrListViewController:(MemberUsrListViewController *)ctrl didSelected:(NSDictionary *)person
{
    [ctrl dismissViewControllerAnimated:YES completion:nil];
    order = [person objectForKey:@"customerName"];
    discount = [person objectForKey:@"onlineDiscount"];
    orderId = [person objectForKey:@"userId"];
    total = nil;
    [self calculatorTotalPrice];
}

#pragma mark -
#pragma mark EventHandle

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn_take_order:(id)sender
{
    if ([productArray count] == 0) {
        [self.view.window makeToast:@"还没有选择茶品!"];
        return;
    }
    if ([orderId length] == 0) {
        [self.view.window makeToast:@"还没有选择下单人!"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in productArray) {
        NSString *productPrice;
        if ([[dic objectForKey:@"productBigUnitId"] isEqualToString:[dic objectForKey:@"selectedUnit"]]) {
            productPrice = [dic objectForKey:@"productBigPrice"];
            
         }
        else if ([[dic objectForKey:@"productSmallUnitId"] isEqualToString:[dic objectForKey:@"selectedUnit"]]) {
            productPrice = [dic objectForKey:@"productSmallPrice"];

        }

        NSDictionary *d = @{@"productId": [dic objectForKey:@"productId"],
                            @"productUnitId": [dic objectForKey:@"selectedUnit"],
                            @"productNumber": [dic objectForKey:@"productAmount"],
                            @"productPrice": productPrice};
        [arr addObject:d];
    }
    
    productsString = [arr JSONRepresentation];
    [self takeOrder];

}

- (void)btn_add_click:(id)sender
{
    if ([productArray count] == 0) {
        return;
    }
    total = nil;
    NSUInteger index = [sender tag]%400;
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:[productArray objectAtIndex:index-1]];
    NSUInteger amounts = [[dic objectForKey:@"productAmount"] integerValue]+1;
    [dic setObject:[NSString stringWithFormat:@"%d",amounts] forKey:@"productAmount"];
    [productArray replaceObjectAtIndex:index-1 withObject:dic];
    [self calculatorTotalPrice];
    [self.tableView reloadData];

}

- (void)btn_reduce_click:(id)sender
{
    if ([productArray count] == 0) {
        return;
    }
    NSUInteger index = [sender tag]%200;
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:[productArray objectAtIndex:index-1]];
    NSUInteger amounts = [[dic objectForKey:@"productAmount"] integerValue]-1;
    if (amounts != 0) {
        [dic setObject:[NSString stringWithFormat:@"%d",amounts] forKey:@"productAmount"];
        [productArray replaceObjectAtIndex:index-1 withObject:dic];
    }
    total = nil;
    [self calculatorTotalPrice];
    [self.tableView reloadData];
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
    if ([textField isEqual:tf_discount]) {
        [tf_total becomeFirstResponder];
        discount = tf_discount.text;
        total = nil;
        [self calculatorTotalPrice];
    }
    else if ([textField isEqual:tf_total]) {
        total = tf_total.text;
        discount = [NSString stringWithFormat:@"%.2f",[total floatValue]/[amount floatValue]];
        tf_discount.text = discount;
        [self calculatorTotalPrice];
    }

    else if ([textField isEqual:tf_remark]) {
        remark = tf_remark.text;
    }

    return YES;
}

- (void)removeLable
{
    [lb_amount removeFromSuperview];
    [lb_orderer removeFromSuperview];
    [tf_address removeFromSuperview];
    [tf_discount removeFromSuperview];
    [tf_remark removeFromSuperview];
    [tf_tel removeFromSuperview];
    [tf_total removeFromSuperview];
}

- (void)calculatorTotalPrice
{
    float totalPrice = 0.00f;
    if ([total integerValue]) {
        totalPrice = [total floatValue];
    }
    else{
        for (NSDictionary *dic in productArray) {
            if ([[dic objectForKey:@"productBigUnitId"] isEqualToString:[dic objectForKey:@"selectedUnit"]]) {
                totalPrice +=  [[dic objectForKey:@"productBigPrice"] floatValue]*[[dic objectForKey:@"productAmount"]floatValue];
                
            }
            else if ([[dic objectForKey:@"productSmallUnitId"] isEqualToString:[dic objectForKey:@"selectedUnit"]]) {
                totalPrice +=  [[dic objectForKey:@"productSmallPrice"] floatValue]*[[dic objectForKey:@"productAmount"]floatValue];
            }
        }
        amount = [NSString stringWithFormat:@"%.2f",totalPrice];
        total = [NSString stringWithFormat:@"%.2f",[discount floatValue]*[amount floatValue]];
    }
    [btn_total_price setTitle:[NSString stringWithFormat:@"总金额:￥%@",total] forState:UIControlStateNormal];
    [self.tableView reloadData ];
}

- (void)takeOrder
{
    [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, FAST_TAKE_ORDER];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    
    [req setParam:productsString forKey:@"products"];
    [req setParam:amount forKey:@"orderDetailAmount"];
    [req setParam:discount forKey:@"discount"];
    [req setParam:total forKey:@"totalAmount"];
    [req setParam:orderId forKey:@"userId"];
    if ([remark length]) {
        [req setParam:remark forKey:@"description"];
    }

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
        if([[[json objectForKey:@"data"] objectForKey:@"msg"] length])
            [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        else
            [self.view.window makeToast:@"下单失败!"];
		return;
	}

	if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
		[self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    oid = [[json objectForKey:@"data"] objectForKey:@"orderId"];
    [self.view.window makeToast:@"下单成功!"];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5f];
    
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (void)popViewController
{
    OrderStoreDetailViewController *ctrl = [[OrderStoreDetailViewController alloc] initWithNibName:@"OrderStoreDetailViewController" bundle:nil];
    ctrl.oid = oid;
    ctrl.type = 1;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
