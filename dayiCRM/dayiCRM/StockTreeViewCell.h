//
//  StockTreeViewCell.h
//  dayiCRM
//
//  Created by Fang on 14-6-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface StockTreeViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *lb_year;
@property (nonatomic,retain) IBOutlet UIImageView *im_triangle;
@property (retain,strong) TreeViewNode *treeNode;

- (void)setUpTitleLableAndImg;

@end
