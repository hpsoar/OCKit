//
//  ModelTableViewController.h
//  WordList
//
//  Created by HuangPeng on 12/7/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "NICellFactory.h"
#import "NIMutableTableViewModel.h"
#import "NITableViewActions.h"

@interface ModelTableViewController : RefreshTableViewController {
}
@property (nonatomic, readonly) NIMutableTableViewModel *model;
@property (nonatomic, readonly) NITableViewActions *actions;
@property (nonatomic, readonly) NICellFactory *cellFactory;

- (void)resetModel;

@end
