//
//  PHTableViewController.m
//  ProductHunt
//
//  Created by HuangPeng on 11/4/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "OCTableViewController.h"

@interface OCTableViewController()
@property (nonatomic) NSInteger page;
@end

@implementation OCTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    if (self.allowDragRefresh) {
        self.headerView = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    }
    
    if (self.allowLoadMore) {
        self.footerView = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    }
}

- (void)refresh {
    [super refresh];
    
    [self resetModel];
    
    self.page = 0;
    
    [self loadModelAtPage:self.page];
}

- (void)loadMore {
    [super loadMore];
    
    self.page++;
    [self loadModelAtPage:self.page];
}

- (void)loadModelAtPage:(NSInteger)page {
    
}

@end
