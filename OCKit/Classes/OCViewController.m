//
//  OCViewController.m
//  WordList
//
//  Created by HuangPeng on 12/5/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "OCViewController.h"

@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
        // http://blog.jaredsinclair.com/post/61507315630/wrestling-with-status-bars-and-navigation-bars-on-ios-7
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end
