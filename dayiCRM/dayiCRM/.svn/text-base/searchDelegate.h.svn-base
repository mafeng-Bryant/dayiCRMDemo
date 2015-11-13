//
//  searchDelegate.h
//  dayiCRM
//
//  Created by Fang on 14-4-15.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>
{
    UIViewController		*__unsafe_unretained view_controller;
	UITableView				*__unsafe_unretained tableView;
	
	NSMutableArray				*buffer;
    NSString                    *keyword;
    
    NSUInteger  pageIndex;
    NSString *type;
    NSDictionary *inventoryData;
    NSDictionary *talkData;
    NSDictionary *memberData;

    NSMutableArray				*inventorybuffer;
	NSMutableArray				*talkbuffer;
	NSMutableArray				*memberbuffer;


}

@property (nonatomic, unsafe_unretained) UIViewController *view_controller;
@property (nonatomic, unsafe_unretained) UITableView *tableView;
@property (nonatomic, copy) NSString *keyword;

- (id) initWithTableView:(UITableView *)tableview;

- (void) search;

@end
