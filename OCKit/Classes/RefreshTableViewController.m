//
//  RefreshTableViewController.m
//  Demo
//
//  Created by HuangPeng on 11/2/14.
//
//

#import "RefreshTableViewController.h"

@interface ActivityView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ActivityView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:self.bounds];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor lightGrayColor];
        [self addSubview:self.title];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.activityIndicator];
        
        self.activityIndicator.center = CGPointMake(self.width / 2 - 60, frame.size.height / 2);
    }
    return self;
}

- (void)updateWithOffset:(CGFloat)offset {
    if (-offset < self.frame.size.height) {
        self.title.text = @"Pull down to refresh...";
    }
    else {
        self.title.text = @"Release to refresh...";
    }
}

- (BOOL)shouldLoadMoreWithOffset:(CGFloat)offset {
    return offset < self.frame.size.height;
}

- (BOOL)shouldRefreshWithOffset:(CGFloat)offset {
    return -offset > self.frame.size.height;
}

- (void)startActivity {
    self.title.text = @"Loading...";
    [self.activityIndicator startAnimating];
}

- (void)stopActivity {
    [self.activityIndicator stopAnimating];
}

@end

@interface RefreshTableViewController ()
@property (nonatomic) BOOL isDragging;
@property (nonatomic) UIView *headerContainer;

@end

@implementation RefreshTableViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canLoadMore = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        // http://blog.jaredsinclair.com/post/61507315630/wrestling-with-status-bars-and-navigation-bars-on-ios-7
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.autoresizesSubviews = YES;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 0)];
    [self.view addSubview:self.headerContainer];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}

- (void)setHeaderView:(ActivityView *)headerView {
    if (_headerView) {
        [_headerView removeFromSuperview];
    }
    _headerView = headerView;
    
    [self.headerContainer addSubview:_headerView];
    [self updateHeaderFrame];
}

- (void)setFooterView:(ActivityView *)footerView {
    _footerView = footerView;
    footerView.hidden = YES;
    
    // TODO: better not use footer
    self.tableView.tableFooterView = footerView;
}

- (void)updateHeaderFrame {
    CGFloat height = MAX(0, -self.tableView.contentOffset.y);
    CGRect frame = CGRectMake(0, 0, self.view.width, height);
    self.headerContainer.frame = frame;
    self.headerContainer.clipsToBounds = YES;
    self.headerView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hahal"];
    cell.contentView.backgroundColor = [UIColor blueColor];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (-scrollView.contentOffset.y < scrollView.contentInset.top) {
        [self unpinHeader];
    }
    
    if (!self.isRefreshing && self.isDragging) {
        [self.headerView updateWithOffset:scrollView.contentOffset.y];
    }
    
    [self updateHeaderFrame];
    
    if (!self.isLoadingMore && self.canLoadMore && scrollView.contentOffset.y > 0) {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        [self.footerView updateWithOffset:scrollPosition];
        if ([self.footerView shouldLoadMoreWithOffset:scrollPosition]) {
            [self loadMore];
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isDragging = NO;
    
    if ([self.headerView shouldRefreshWithOffset:scrollView.contentOffset.y]) {
        [self refresh];
    }
}

- (void)refresh {
    self.isRefreshing = YES;
    [self pinHeader];
    [self.headerView startActivity];
}

- (void)refreshCompleted {
    self.isRefreshing = NO;
    [self unpinHeader];
    [self.headerView stopActivity];
    [self.tableView reloadData];
}

- (void)pinHeader {
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
    }];
}

- (void)unpinHeader {
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }];
}

- (void)loadMore {
    self.isLoadingMore = YES;
    self.footerView.hidden = NO;
   [self.footerView startActivity];
}

- (void)loadMoreCompleted {
    self.isLoadingMore = NO;
    self.footerView.hidden = YES;
    [self.footerView stopActivity];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
}

@end
