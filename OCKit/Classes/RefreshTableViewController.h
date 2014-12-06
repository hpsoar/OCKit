//
//  RefreshTableViewController.h
//  Demo
//
//  Created by HuangPeng on 11/2/14.
//
//

#import <UIKit/UIKit.h>
#import "OCViewController.h"

@interface ActivityView : UIView

- (void)updateWithOffset:(CGFloat)offset;

- (BOOL)shouldRefreshWithOffset:(CGFloat)offset;
- (BOOL)shouldLoadMoreWithOffset:(CGFloat)offset;

- (void)startActivity;

- (void)stopActivity;

@property (nonatomic, strong) NSString *pullHint;
@property (nonatomic, strong) NSString *releaseHint;
@property (nonatomic, strong) NSString *loadingHint;

@end

@interface RefreshTableViewController : OCViewController <UITableViewDataSource, UITableViewDelegate>

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
