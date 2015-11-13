//
//  PaymentTypeListViewController.m
//  dayiCRM
//
//  Created by Fang on 14-7-24.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "PaymentTypeListViewController.h"

@interface PaymentTypeListViewController ()

@end

@implementation PaymentTypeListViewController
@synthesize srcDelegate,buffer;

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
    self.title = @"支付方式";
    
    UIBarButtonItem *btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
    self.navigationItem.leftBarButtonItem = btn_cancel;
    

}

- (void)setUpBuffer:(NSArray *)arrary
{
    buffer = [NSArray arrayWithArray:arrary];
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
    static NSString *cell_id = @"empty_cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.font = font;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [dic objectForKey:@"text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (srcDelegate && [srcDelegate respondsToSelector:@selector(PaymentTypeListViewController:didSelectedIndex:)]) {
        [self.srcDelegate PaymentTypeListViewController:self didSelectedIndex:indexPath.row];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
