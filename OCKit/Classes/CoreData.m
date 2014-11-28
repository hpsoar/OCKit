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
    NSManagedObjectModel *model = [CoreData managedObjectModelWithName:modelName];
    NSPersistentStoreCoordinator *coordinator = [CoreData persistentStoreCoordinatorWithStoreURL:[NSURL URLWithString:storeURL] model:model];
    return [self initWithModel:model persistentStoreCoordinator:coordinator];
}

- (id)initWithModel:(NSManagedObjectModel *)model persistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    self = [super init];
    if (self) {
        __managedObjectModel = model;
        __persistentStoreCoordinator = persistentStoreCoordinator;
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
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

+ (NSManagedObjectModel *)managedObjectModelWithName:(NSString *)name {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithStoreURL:(NSURL *)storeURL model:(NSManagedObjectModel *)model {
    NSError *error = nil;
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
