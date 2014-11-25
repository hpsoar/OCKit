//
//  PHTableViewController.h
//  ProductHunt
//
//  Created by HuangPeng on 11/4/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "NIMutableTableViewModel.h"
#import "NITableViewActions.h"
#import "NICellFactory.h"

@interface OCTableViewController: RefreshTableViewController
@property (nonatomic, readonly) NIMutableTableViewModel *model;
@property (nonatomic, readonly) NITableViewActions *actions;
@property (nonatomic, readonly) NICellFactory *cellFactory;

@property (nonatomic) BOOL allowLoadMore;
@property (nonatomic) BOOL allowDragRefresh;

- (void)resetModel;

- (void)resetModelState;

- (void)loadModel;

- (void)reloadTableView;

- (void)stopRefreshing;
@end
