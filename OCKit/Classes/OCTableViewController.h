//
//  PHTableViewController.h
//  ProductHunt
//
//  Created by HuangPeng on 11/4/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "ModelTableViewController.h"

@interface OCTableViewController: ModelTableViewController

@property (nonatomic) BOOL allowLoadMore;
@property (nonatomic) BOOL allowDragRefresh;

- (void)loadModelAtPage:(NSInteger)page;

@end
