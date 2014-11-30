//
//  CoreData.m
//  WordList
//
//  Created by HuangPeng on 11/25/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "CoreData.h"

@interface CoreData ()
@end

@implementation CoreData
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (id)initWithModelName:(NSString *)modelName storeURL:(NSString *)storeURL {
    return [self initWithModelName:modelName storeURL:storeURL ubiquitousContentName:nil];
}

- (id)initWithModelName:(NSString *)modelName storeURL:(NSString *)storeURL ubiquitousContentName:(NSString *)ubiquitousContentName {
    self = [super init];
    if (self) {
        __managedObjectModel = [self managedObjectModelWithName:modelName];
        
        storeURL = [Utility filepath:storeURL];
        __persistentStoreCoordinator = [self persistentStoreCoordinatorWithStoreURL:[NSURL fileURLWithPath:storeURL isDirectory:NO] model:__managedObjectModel ubiquitousContentName:ubiquitousContentName];
    }
    return self;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        __managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModelWithName:(NSString *)name {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithStoreURL:(NSURL *)storeURL model:(NSManagedObjectModel *)model ubiquitousContentName:(NSString *)ubiquitousContentName {
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSDictionary *options;
    if (ubiquitousContentName) {
        options = @{ NSPersistentStoreUbiquitousContentNameKey: ubiquitousContentName };
    }
    [self registeriCloudNotificationsForPersistentStoreCoordinator:persistentStoreCoordinator];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

- (void)registeriCloudNotificationsForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)psc {
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
             object:psc];
    
    [dc addObserver:self
           selector:@selector(storesWillChange:)
               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:psc];
    
    [dc addObserver:self
           selector:@selector(storesDidChange:)
               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
             object:psc];
}

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification *)notification {
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:notification];
        
        // you may want to post a notification here so that which ever part of your app
        // needs to can react appropriately to what was merged.
        // An exmaple of how to iterate over what was merged follows, although I wouldn't
        // recommend doing it here. Better handle it in a delegate or use notifications.
        // Note that the notification contains NSManagedObjectIDs
        // and not NSManagedObjects.
        NSDictionary *changes = notification.userInfo;
        NSMutableSet *allChanges = [NSMutableSet new];
        [allChanges unionSet:changes[NSInsertedObjectsKey]];
        [allChanges unionSet:changes[NSUpdatedObjectsKey]];
        [allChanges unionSet:changes[NSDeletedObjectsKey]];
        
        for (NSManagedObjectID *objID in allChanges) {
            // do whatever you need to with the NSManagedObjectID
            // you can retrieve the object from with [moc objectWithID:objID]
            NSLog(@"object: %@",[moc objectWithID:objID]);
        }
    }];
}

- (void)storesDidChange:(NSNotification *)notification {
    NIDPRINT(@"%@", notification.userInfo);
}

- (void)storesWillChange:(NSNotification *)notification {
    NIDPRINT(@"%@", notification.userInfo);
}

#pragma mark -


- (id)entityWithName:(NSString *)name {
    return [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
}

- (id)insertObjectForEntityWithName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
}

- (void)deleteObject:(id)object {
    [self.managedObjectContext deleteObject:object];
}

- (NSArray *)queryFromEntityWithName:(NSString *)name withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:name];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:fetch error:&error];
    if (error) {
        return nil;
    }
    else {
        return results;
    }
}

- (id)queryOneFromEntityWithName:(NSString *)name withPredicate:(NSPredicate *)predicate {
    NSArray *results = [self queryFromEntityWithName:name withPredicate:predicate];
    if (results.count > 0) {
        return results.firstObject;
    }
    return nil;
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptor:(NSSortDescriptor*)sortDescriptor batchSize:(NSInteger)batchSize {
    NSArray *sorters = sortDescriptor == nil ? nil : @[ sortDescriptor ];
    return [self fetchRequestForEntity:entityName predicate:predicate sortDescriptors:sorters batchSize:20];
}

- (NSFetchRequest *)fetchRequestForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors batchSize:(NSInteger)batchSize {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:[self entityWithName:entityName]];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setFetchBatchSize:batchSize];
    
    return fetchRequest;
}

@end
