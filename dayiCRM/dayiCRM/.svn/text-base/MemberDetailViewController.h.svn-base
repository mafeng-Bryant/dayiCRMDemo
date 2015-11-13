//
//  MemberDetailViewController.h
//  dayiCRM
//
//  Created by Fang on 14-4-21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "LXActionSheet.h"

@interface MemberDetailViewController : UITableViewController<LXActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *uid;
    NSMutableArray *buffer;
    NSDictionary *dict;
    NSArray *history;
    NSString *type;
    NSUInteger selectedIndex;
}

@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *type;

- (void)inviteMember;

@end
