//
//  StockCheckViewController.m
//  dayiCRM
//
//  Created by Fang on 14/10/22.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockCheckViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"

@interface StockCheckViewController ()

@end

@implementation StockCheckViewController
@synthesize dataDict,productName,reportId,result,isUnCheck;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"库存盘点";
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
    
    NSLog(@"%@",dataDict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(1 == section)
        return 3;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = [NSString stringWithFormat:@"cell_%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    UIFont *textFont = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (0 == indexPath.section) {
        if (im_avatar) {
            [im_avatar removeFromSuperview];
            im_avatar = nil;
        }
        im_avatar = [[UrlImageView alloc] initWithFrame:CGRectMake(10, 5, 65, 65)];
        [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dataDict objectForKey:@"productImage"]]];
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
        lb_name.text = [NSString stringWithFormat:@"%@ %@",productName,[dataDict objectForKey:@"productPici"]];
        [cell.contentView addSubview:lb_name];
    }
    
    else if (1 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"账面数量";
                if (!lb_originalJian) {
                    lb_originalJian = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 50, 34)];
                    lb_originalJian.textAlignment = NSTextAlignmentRight;
                    lb_originalJian.textColor = [UIColor blackColor];
                    lb_originalJian.font = textFont;
                    lb_originalJian.textAlignment = NSTextAlignmentCenter;
                    lb_originalJian.backgroundColor = [UIColor clearColor];
                    lb_originalJian.text = [dataDict objectForKey:@"productBigNumber"];
                    [cell.contentView addSubview:lb_originalJian];
                }
                if (!lb_originalBig) {
                    lb_originalBig = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 15, 34)];
                    lb_originalBig.textAlignment = NSTextAlignmentRight;
                    lb_originalBig.textColor = [UIColor blackColor];
                    lb_originalBig.font = textFont;
                    lb_originalBig.textAlignment = NSTextAlignmentCenter;
                    lb_originalBig.backgroundColor = [UIColor clearColor];
                    lb_originalBig.text = [dataDict objectForKey:@"productBigUnitName"];
                    [cell.contentView addSubview:lb_originalBig];
                }

                if (!lb_originalUnit) {
                    lb_originalUnit = [[UILabel alloc] initWithFrame:CGRectMake(225, 5, 50, 34)];
                    lb_originalUnit.textAlignment = NSTextAlignmentRight;
                    lb_originalUnit.textColor = [UIColor blackColor];
                    lb_originalUnit.font = textFont;
                    lb_originalUnit.textAlignment = NSTextAlignmentCenter;
                    lb_originalUnit.backgroundColor = [UIColor clearColor];
                    lb_originalUnit.text = [dataDict objectForKey:@"productSmallNumber"];
                    [cell.contentView addSubview:lb_originalUnit];
                }
                if (!lb_originalSmall) {
                    lb_originalSmall = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 15, 34)];
                    lb_originalSmall.textAlignment = NSTextAlignmentRight;
                    lb_originalSmall.textColor = [UIColor blackColor];
                    lb_originalSmall.font = textFont;
                    lb_originalSmall.textAlignment = NSTextAlignmentCenter;
                    lb_originalSmall.backgroundColor = [UIColor clearColor];
                    lb_originalSmall.text = [dataDict objectForKey:@"productSmallUnitName"];
                    [cell.contentView addSubview:lb_originalSmall];
                }

                break;
            case 1:
                cell.textLabel.text = @"实盘数量";
                if (!tf_checkJian) {
                    tf_checkJian = [[UITextField alloc] initWithFrame:CGRectMake(140, 5, 50, 34)];
                    tf_checkJian.textAlignment = NSTextAlignmentRight;
                    tf_checkJian.textColor = [UIColor blackColor];
                    tf_checkJian.font = textFont;
                    tf_checkJian.delegate = self;
                    tf_checkJian.keyboardType = UIKeyboardTypeNumberPad;
                    tf_checkJian.textAlignment = NSTextAlignmentCenter;
                    tf_checkJian.backgroundColor = [UIColor clearColor];
                    tf_checkJian.placeholder = @"请填写";
                    tf_checkJian.returnKeyType = UIReturnKeyDone;
                    if([[dataDict objectForKey:@"pieceRealNumber"] length] && !isUnCheck){
                        tf_checkJian.text = [dataDict objectForKey:@"pieceRealNumber"];
                    }
                    [cell.contentView addSubview:tf_checkJian];
                }
                if (!lb_checkBig) {
                    lb_checkBig = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 15, 34)];
                    lb_checkBig.textAlignment = NSTextAlignmentRight;
                    lb_checkBig.textColor = [UIColor blackColor];
                    lb_checkBig.font = textFont;
                    lb_checkBig.textAlignment = NSTextAlignmentCenter;
                    lb_checkBig.backgroundColor = [UIColor clearColor];
                    lb_checkBig.text = [dataDict objectForKey:@"productBigUnitName"];
                    [cell.contentView addSubview:lb_checkBig];
                }
                
                if (!tf_checkUnit) {
                    tf_checkUnit = [[UITextField alloc] initWithFrame:CGRectMake(225, 5, 50, 34)];
                    tf_checkUnit.textAlignment = NSTextAlignmentRight;
                    tf_checkUnit.textColor = [UIColor blackColor];
                    tf_checkUnit.font = textFont;
                    tf_checkUnit.textAlignment = NSTextAlignmentCenter;
                    tf_checkUnit.backgroundColor = [UIColor clearColor];
                    tf_checkUnit.delegate = self;
                    tf_checkUnit.keyboardType = UIKeyboardTypeNumberPad;
                    tf_checkUnit.returnKeyType = UIReturnKeyDone;
                    tf_checkUnit.placeholder = @"请填写";
                    if([[dataDict objectForKey:@"realNumber"] length] && !isUnCheck){
                        tf_checkUnit.text = [dataDict objectForKey:@"realNumber"];
                    }
                    [cell.contentView addSubview:tf_checkUnit];
                }
                if (!lb_checkSmall) {
                    lb_checkSmall = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 15, 34)];
                    lb_checkSmall.textAlignment = NSTextAlignmentRight;
                    lb_checkSmall.textColor = [UIColor blackColor];
                    lb_checkSmall.font = textFont;
                    lb_checkSmall.textAlignment = NSTextAlignmentCenter;
                    lb_checkSmall.backgroundColor = [UIColor clearColor];
                    lb_checkSmall.text = [dataDict objectForKey:@"productSmallUnitName"];
                    [cell.contentView addSubview:lb_checkSmall];
                }

                break;
            case 2:
                cell.textLabel.text = @"盘点结果";
                if (!lb_checkResult) {
                    lb_checkResult = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 90, 34)];
                    lb_checkResult.textColor = [UIColor blackColor];
                    lb_checkResult.textAlignment = NSTextAlignmentRight;
                    lb_checkResult.font = textFont;
                    lb_checkResult.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:lb_checkResult];
					[self caculatorStaus];
                }
                break;
            default:
                break;
        }
    }
    
    else if (2 == indexPath.section){
        cell.textLabel.text = @"备注";
        if (!tf_remark) {
            tf_remark = [[UITextField alloc] initWithFrame:CGRectMake(70, 5, 220, 34)];
            tf_remark.textColor = [UIColor blackColor];
            tf_remark.textAlignment = NSTextAlignmentRight;
            tf_remark.font = textFont;
            tf_remark.backgroundColor = [UIColor clearColor];
            tf_remark.delegate = self;
            tf_remark.returnKeyType = UIReturnKeyDone;
            tf_remark.placeholder = @"请填写";
			if([[dataDict objectForKey:@"remark"] length] && !isUnCheck){
				tf_remark.text = [dataDict objectForKey:@"remark"];
			}
            [cell.contentView addSubview:tf_remark];
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
    if (2 == section) {
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (2 != section) {
        return nil;
    }
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIImage *bg = [UIImage imageNamed:@"btn3"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    UIImage *stretchableImage = [bg resizableImageWithCapInsets:insets];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 300, 44);
    [btn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    btn.center = footView.center;
    [btn addTarget:self action:@selector(btn_certain_click:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    return footView;
}


#pragma mark -
#pragma mark event handle

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_certain_click:(id)sender
{
    [tf_checkUnit resignFirstResponder];
    [tf_checkJian resignFirstResponder];

    if([result length] == 0 ||
       [tf_checkJian.text length] == 0 ||
       [tf_checkUnit.text length] == 0){
        [self.view makeToast:@"还没有输入实测数据或者实测数据输入不完整"];
        return;
    }
    
    [self loadData];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self caculatorStaus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)caculatorStaus
{
	if([tf_checkJian.text length] && [tf_checkUnit.text length]){
		if ([tf_checkJian.text isEqualToString:[dataDict objectForKey:@"productBigNumber"]]&&
			[tf_checkUnit.text isEqualToString:[dataDict objectForKey:@"productSmallNumber"]]){
			lb_checkResult.text = @"正常";
			lb_checkResult.textColor = [UIColor blackColor];
			result = @"Y";
		}
		else{
			lb_checkResult.text = @"不正常";
			lb_checkResult.textColor = dayiColor;
			result = @"N";
		}
	}

}

#pragma mark - loadData
- (void)loadData
{
    [SVProgressHUD showWithStatus:@"上传数据中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, HANDLE_REPORT_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    if(reportId){
        [req setParam:reportId forKey:@"reportId"];
    }
    [req setParam:[dataDict objectForKey:@"productId"] forKey:@"productId"];
    [req setParam:[dataDict objectForKey:@"productBigNumber"] forKey:@"productBigNumber"];
    [req setParam:[dataDict objectForKey:@"productSmallNumber"] forKey:@"productSmallNumber"];

    [req setParam:tf_checkJian.text forKey:@"pieceRealNumber"];
    [req setParam:tf_checkUnit.text forKey:@"realNumber"];
    [req setParam:result forKey:@"result"];
    if([tf_remark.text length])
        [req setParam:tf_remark.text forKey:@"remark"];
    [req setParam:productName forKey:@"productName"];

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
    NSLog(@"%@",json);
    
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [SVProgressHUD dismiss];
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    
    if ([[json objectForKey:@"data"] objectForKey:@"reportId"]) {
        [SVProgressHUD dismissWithSuccess:@"上传成功!"];
        [[NSUserDefaults standardUserDefaults] setObject:[[json objectForKey:@"data"] objectForKey:@"reportId"] forKey:@"reportId"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stockCheckDidChange" object:nil];
		[self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0f];
    }
    else{
        [SVProgressHUD dismissWithError:[[json objectForKey:@"data"] objectForKey:@"msg"]];
    }
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"上传失败!"];

    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (void)popViewController
{
	[self.navigationController popViewControllerAnimated:YES];
}
@end
