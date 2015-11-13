//
//  SplitStockViewController.m
//  dayiCRM
//
//  Created by Fang on 14/10/20.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "SplitStockViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface SplitStockViewController ()

@end

@implementation SplitStockViewController
@synthesize dataDict,productName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"拆分";
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (0 == section)
        return 1;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = [NSString stringWithFormat:@"cell_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }

    CGRect textFrame = CGRectMake(200, 5, 100, 34);
    UIFont *textFont = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (0 == indexPath.section) {
        if (im_avatar) {
            [im_avatar removeFromSuperview];
            im_avatar = nil;
        }
        im_avatar = [[UrlImageView alloc] initWithFrame:CGRectMake(10, 5, 65, 65)];
        [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dataDict objectForKey:@"avatarId"]]];
        [cell.contentView addSubview:im_avatar];
        
        if (lb_name) {
            [lb_name removeFromSuperview];
            lb_name = nil;
        }
        lb_name = [[UILabel alloc] initWithFrame:CGRectMake(90,20, 200, 30)];
        lb_name.textAlignment = NSTextAlignmentLeft;
        lb_name.textColor = [UIColor blackColor];
        lb_name.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        lb_name.backgroundColor = [UIColor clearColor];
		lb_name.text = [NSString stringWithFormat:@"%@",productName ];//,[dataDict objectForKey:@"productPici"]];
        [cell.contentView addSubview:lb_name];
    }

    else if (1 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"拆分库存量(件)";
                if(!tf_splitNum){
                    tf_splitNum = [[UITextField alloc] initWithFrame:textFrame];
                    tf_splitNum.placeholder = @"输入拆分件数";
                    tf_splitNum.delegate = self;
                    tf_splitNum.font = textFont;
                    tf_splitNum.backgroundColor = [UIColor clearColor];
                    tf_splitNum.textAlignment = NSTextAlignmentRight;
                    tf_splitNum.returnKeyType = UIReturnKeyDone;
                    [cell.contentView addSubview:tf_splitNum];
                }
                break;
            case 1:
                cell.textLabel.text = @"拆分规则";
                if (!lb_rule) {
                    lb_rule = [[UILabel alloc] initWithFrame:textFrame];
                    lb_rule.textAlignment = NSTextAlignmentRight;
                    lb_rule.textColor = [UIColor blackColor];
                    lb_rule.font = textFont;
                    lb_rule.backgroundColor = [UIColor clearColor];
                    lb_rule.text = [NSString stringWithFormat:@"1件等于%@%@",[dataDict objectForKey:@"unitCount"],[dataDict objectForKey:@"unitName"]];
                    [cell.contentView addSubview:lb_rule];
                    
                }
                break;
            default:
                break;
        }
    }
    
    else if (2 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"原库存量(件)";
                if (!lb_yuankucun) {
                    lb_yuankucun = [[UILabel alloc] initWithFrame:textFrame];
                    lb_yuankucun.textAlignment = NSTextAlignmentRight;
                    lb_yuankucun.textColor = [UIColor blackColor];
                    lb_yuankucun.font = textFont;
                    lb_yuankucun.backgroundColor = [UIColor clearColor];
                    lb_yuankucun.text = [dataDict objectForKey:@"picecInventory"];
                    [cell.contentView addSubview:lb_yuankucun];
                }

                break;
            case 1:
                cell.textLabel.text = @"剩余库存量(件)";
                if (!lb_xinkucun) {
                    lb_xinkucun = [[UILabel alloc] initWithFrame:textFrame];
                    lb_xinkucun.textAlignment = NSTextAlignmentRight;
                    lb_xinkucun.textColor = [UIColor blackColor];
                    lb_xinkucun.font = textFont;
                    lb_xinkucun.backgroundColor = [UIColor clearColor];
                    lb_xinkucun.text = [dataDict objectForKey:@"picecInventory"];
                    [cell.contentView addSubview:lb_xinkucun];
                }
                break;
            default:
                break;
        }
    }

    else if (3 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"原库存量(%@)",[dataDict objectForKey:@"unitName"] ];
                if (!lb_yuankucun_unit) {
                    lb_yuankucun_unit = [[UILabel alloc] initWithFrame:textFrame];
                    lb_yuankucun_unit.textAlignment = NSTextAlignmentRight;
                    lb_yuankucun_unit.textColor = [UIColor blackColor];
                    lb_yuankucun_unit.font = textFont;
                    lb_yuankucun_unit.backgroundColor = [UIColor clearColor];
                    lb_yuankucun_unit.text = [dataDict objectForKey:@"unitInventory"];
                    [cell.contentView addSubview:lb_yuankucun_unit];
                }

                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"新库存量(%@)",[dataDict objectForKey:@"unitName"] ];
                if (!lb_xinkucun_unit) {
                    lb_xinkucun_unit = [[UILabel alloc] initWithFrame:textFrame];
                    lb_xinkucun_unit.textAlignment = NSTextAlignmentRight;
                    lb_xinkucun_unit.textColor = [UIColor blackColor];
                    lb_xinkucun_unit.font = textFont;
                    lb_xinkucun_unit.backgroundColor = [UIColor clearColor];
                    lb_xinkucun_unit.text = [dataDict objectForKey:@"unitInventory"];
                    [cell.contentView addSubview:lb_xinkucun_unit];
                }

                break;
            default:
                break;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 75.0f;
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (3 == section) {
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (3 != section) {
        return nil;
    }
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIImage *bg = [UIImage imageNamed:@"btn3"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认拆分" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 300, 44);
    [btn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    btn.center = footView.center;
    [btn addTarget:self action:@selector(btn_split_click:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    return footView;
}

#pragma mark -
#pragma mark event handle

- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btn_split_click:(id)sender
{
    if ([tf_splitNum.text integerValue] > 0) {
        [self saveData];
    }
    else{
        [self.view.window makeToast:@"请输入数字!"];
    }
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text integerValue] > [[dataDict objectForKey:@"picecInventory"]integerValue]) {
        [self.view.window makeToast:@"拆分数量超过了原库存量"];
    }
    else{
        lb_xinkucun.text = [NSString stringWithFormat:@"%ld",[[dataDict objectForKey:@"picecInventory"]integerValue] - [textField.text integerValue] ];
        
        lb_xinkucun_unit.text = [NSString stringWithFormat:@"%ld",[[dataDict objectForKey:@"unitInventory"]integerValue] + [textField.text integerValue]*[[dataDict objectForKey:@"unitCount"] integerValue]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -

- (void)saveData
{
    [SVProgressHUD showWithStatus:@"上传数据中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL,SPLIT_INVENTORY_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    
    [req setParam:[dataDict objectForKey:@"productId"] forKey:@"productId"];
    [req setParam:tf_splitNum.text forKey:@"splitNumber"];
    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSaveData:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onSaveData: (NSNotification *)notify
{
    RRLoader *loader = (RRLoader *)[notify object];
    
    NSDictionary *json = [loader getJSONData];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
    NSLog(@"%@",json );
    
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [SVProgressHUD dismissWithError:@"保存失败!" afterDelay:1.5f];
        return;
    }
    
    [SVProgressHUD dismissWithSuccess:@"保存成功!" afterDelay:1.5f];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0f];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"stockCheckDidChange" object:nil];

    
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"保存失败!" afterDelay:1.5f];
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
