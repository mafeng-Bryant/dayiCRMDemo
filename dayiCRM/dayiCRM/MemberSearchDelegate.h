//
//  MemberSearchDelegate.h
//  dayiCRM
//
//  Created by Fang on 14-9-12.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberSearchDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
{
    UIViewController		*__unsafe_unretained view_controller;
	UITableView				*__unsafe_unretained tableView;
	
	NSMutableArray				*buffer;
    NSString                    *keyword;
    NSMutableArray *bufferTmp;


}

@property (nonatomic, unsafe_unretained) UIViewController *view_controller;
@property (nonatomic, unsafe_unretained) UITableView *tableView;
@property (nonatomic, copy) NSString *keyword;

- (id) initWithTableView:(UITableView *)tableview;

- (void) search;



@end
