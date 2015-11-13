//
//  AgeGroupViewController.m
//  dayiCRM
//
//  Created by Fang on 14-5-27.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "AgeGroupViewController.h"

@interface AgeGroupViewController ()

@end

@implementation AgeGroupViewController
@synthesize delegate,ageGroup;

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
    
    self.title = @"选择年龄段";
    
   UIBarButtonItem *btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
    self.navigationItem.leftBarButtonItem = btn_cancel;

    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"20岁以下";
            break;
        case 1:
           cell.textLabel.text  = @"20岁-29岁";
            break;
        case 2:
            cell.textLabel.text  = @"30岁-39岁";
            break;
        case 3:
            cell.textLabel.text = @"40岁-45岁";
            break;
        case 4:
            cell.textLabel.text = @"46岁-50岁";
            break;
        case 5:
            cell.textLabel.text = @"51岁-55岁";
            break;
        case 6:
            cell.textLabel.text = @"56岁-60岁";
            break;
        case 7:
            cell.textLabel.text = @"61岁-65岁";
            break;
        case 8:
            cell.textLabel.text = @"66岁-70岁";
            break;
        case 9:
            cell.textLabel.text = @"70岁以上";
            break;
        default:
            break;
    }

    if ([ageGroup integerValue]-1 == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ageGroup = [NSString stringWithFormat:@"%d",indexPath.row+1];
    [self.tableView reloadData];
    [delegate ageGroupDidSelected:ageGroup];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
