//
//  RefreshTableViewController.h
//  Demo
//
//  Created by HuangPeng on 11/2/14.
//
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView

- (void)updateWithOffset:(CGFloat)offset;

- (BOOL)shouldRefreshWithOffset:(CGFloat)offset;
- (BOOL)shouldLoadMoreWithOffset:(CGFloat)offset;

- (void)startActivity;

- (void)stopActivity;

@end

@interface RefreshTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ActivityView *headerView;
@property (nonatomic, strong) ActivityView *footerView;

@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadingMore;
@property (nonatomic) BOOL canLoadMore;

- (void)refreshCompleted;

- (void)refresh;

- (void)loadMore;

- (void)loadMoreCompleted;
@end
