//
//  ContactsListViewController.h
//  dayiCRM
//
//  Created by Fang on 14-9-10.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactsListViewController;

@protocol ContactsListViewControllerDelegate <NSObject>

- (void)contactsListViewController:(ContactsListViewController *)ctrl didSelectedUsrArrary:(NSArray *)usr;

@end

@interface ContactsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *buffer;
    NSMutableArray *usrArray;
    NSMutableArray *bufferTmp;
    NSMutableArray *selectedArray;
    id<ContactsListViewControllerDelegate>delegate;

}

@property(nonatomic,retain)id<ContactsListViewControllerDelegate>delegate;
@property(nonatomic,retain)NSMutableArray *selectedArray;

- (void)setupSelectedArray:(NSArray *)array;

@end
