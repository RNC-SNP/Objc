//
//  RLCoreDataManager.m
//  UseCoreData
//
//  Created by RincLiu on 5/6/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLCoreDataManager.h"

@implementation RLCoreDataManager

#pragma mark - Init Core Data objects:

-(NSManagedObjectModel*)getManagedObjectModel
{
    if(_mamagedObjectModel == nil)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UserModel" withExtension:@"momd"];
        _mamagedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    }
    return _mamagedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSPersistentStoreCoordinator*)getPersistentStoreCoordinator
{
    if(_persistentStoreCoordinator == nil)
    {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserModel.sqlite"];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self getManagedObjectModel]];
        NSError *err = nil;
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&err])
        {
            NSLog(@"Init PersistentStoreCoordinator failed: %@,%@", err, [err userInfo]);
        }
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext*)getManagedObjectContext
{
    if(_mamagedObjectContext == nil)
    {
        NSPersistentStoreCoordinator *coordinator = [self getPersistentStoreCoordinator];
        if(coordinator != nil)
        {
            _mamagedObjectContext = [[NSManagedObjectContext alloc]init];
            [_mamagedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _mamagedObjectContext;
}

-(void)saveManagedObjectContext
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    NSError *err =nil;
    if(context != nil && [context hasChanges] && ![context save:&err])
    {
        NSLog(@"Save ManagedObjectContext failed: %@,%@", err, [err userInfo]);
        abort();
    }
}

#pragma  mark - SQLite operation methods:

-(NSMutableArray*)getUserListByPageSize:(int)pageSize andOffset:(int)currentPage
{
    NSMutableArray *result = nil;
    
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setFetchLimit:pageSize];
    [request setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *err =nil;
    result = [[context executeFetchRequest:request error:&err]mutableCopy];
    if(result == nil)
    {
        NSLog(@"Failed to query: %@",err);
    }
    return result;
}

-(void)updateUserEmail:(NSString*)email byName:(NSString*)name
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    
    NSError *err =nil;
    NSArray *result = [context executeFetchRequest:request error:&err];
    
    for(UserEntity *user in result)
    {
        user.email = email;
    }
    
    if(![context save:&err])
    {
        NSLog(@"Failed to update:%@",err);
    }
}

-(void)addUserWithName:(NSString*)name andEmail:(NSString*)email
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    UserEntity *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserEntity" inManagedObjectContext:context];
    
    newUser.name = name;
    newUser.email = email;
    
    NSError *err =nil;
    if(![context save:&err])
    {
        NSLog(@"Failed to add:%@",err);
    }
}

-(void)deleteUserByName:(NSString*)name
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    
    NSError *err =nil;
    NSArray *result = [context executeFetchRequest:request error:&err];
    
    if(!err && result && [result count])
    {
        for(UserEntity *user in result)
        {
            [context deleteObject:user];
        }
        
        if(![context save:&err])
        {
            NSLog(@"Failed to delete:%@",err);
        }
    }
}

@end
