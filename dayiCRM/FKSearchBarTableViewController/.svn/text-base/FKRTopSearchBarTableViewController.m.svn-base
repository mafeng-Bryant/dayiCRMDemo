//
//  FKRTopSearchBarTableViewController.m
//  TableViewSearchBar
//
//  Created by Fabian Kreiser on 10.02.13.
//  Copyright (c) 2013 Fabian Kreiser. All rights reserved.
//

#import "FKRTopSearchBarTableViewController.h"

@implementation FKRTopSearchBarTableViewController

#pragma mark - Initializer

- (id)initWithSectionIndexes:(BOOL)showSectionIndexes
{
    if ((self = [super initWithSectionIndexes:showSectionIndexes])) {
        self.title = @"Top Search Bar";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     SearchBar at the top:
     The search bar scrolls along with the table view, but always stays at the top if the table view is scrolled up.
    */
    
    // We add a fake tableHeaderView so that the table view automatically snaps to the search bar.
    // Note: UITableView only snaps to the tableHeaderView, if the view is a UISearchBar!
    UIView *headerView = [[UISearchBar alloc] initWithFrame:self.searchBar.frame];
    headerView.hidden = YES;
    self.tableView.tableHeaderView = headerView;

    [self.tableView addSubview:self.searchBar];

    // The search bar is hidden when the view becomes visible the first time
    self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.tableView scrollRectToVisible:self.searchBar.frame animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) { // Don't do anything if the search table view get's scrolled
        if (scrollView.contentOffset.y < 44) {
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds) - MAX(scrollView.contentOffset.y, 0), 0, 0, 0);
        } else {
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        }
        
        CGRect searchBarFrame = self.searchBar.frame;
        searchBarFrame.origin.y = MIN(scrollView.contentOffset.y, 0);
        
        self.searchBar.frame = searchBarFrame;
    }
}

@end