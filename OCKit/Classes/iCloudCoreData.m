//
//  iCloudCoreData.m
//  ProductHunt
//
//  Created by HuangPeng on 11/28/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "iCloudCoreData.h"

@implementation iCloudCoreData

- (id)initWithModelName:(NSString *)modelName storeURL:(NSString *)storeURL {
    NSManagedObjectModel *model = [CoreData managedObjectModelWithName:modelName];
    UbiquityStoreManager *ubiquityStoreManager = [[UbiquityStoreManager alloc] initWithManagedObjectModel:model localStoreURL:[NSURL URLWithString:storeURL] containerIdentifier:nil additionalStoreOptions:nil];
    return [self initWithUbiquityStoreManager:ubiquityStoreManager];
}

- (id)initWithUbiquityStoreManager:(UbiquityStoreManager*)ubiquityStoreManager {
    self = [super initWithModel:ubiquityStoreManager.managedObjectModel persistentStoreCoordinator:ubiquityStoreManager.persistentStoreCoordinator];
    if (self) {
        _ubiquityStoreManager = ubiquityStoreManager;
    }
    return self;
}

@end
