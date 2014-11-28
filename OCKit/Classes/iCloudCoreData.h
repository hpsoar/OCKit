//
//  iCloudCoreData.h
//  ProductHunt
//
//  Created by HuangPeng on 11/28/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "CoreData.h"
#import "UbiquityStoreManager.h"

@interface iCloudCoreData : CoreData

- (id)initWithModelName:(NSString *)modelName storeURL:(NSString *)storeURL;

- (id)initWithUbiquityStoreManager:(UbiquityStoreManager*)ubiquityStoreManager;

@property (nonatomic, readonly) UbiquityStoreManager *ubiquityStoreManager;

@end
