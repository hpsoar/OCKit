//
//  ModelTableViewController.m
//  WordList
//
//  Created by HuangPeng on 12/7/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "ModelTableViewController.h"

@implementation ModelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellFactory = [NICellFactory new];
    
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    
    [self.actions forwardingTo:self];
    
    self.tableView.delegate = self.actions;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.model == nil) {
        [self resetModel];
    }
}

- (void)resetModel {
    _model = [[NIMutableTableViewModel alloc] initWithDelegate:self.cellFactory];
    self.tableView.dataSource = self.model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellFactory tableView:tableView heightForRowAtIndexPath:indexPath model:self.model];
}

@end
