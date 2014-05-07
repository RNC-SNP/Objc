//
//  RLCoreDataManager.h
//  UseCoreData
//
//  Created by RincLiu on 5/6/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserEntity.h"

@interface RLCoreDataManager : NSObject

#pragma mark - Core Data properties:

@property (strong, nonatomic) NSManagedObjectModel *mamagedObjectModel;

@property (strong, nonatomic) NSManagedObjectContext *mamagedObjectContext;

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - Init Core Data objects:

-(NSManagedObjectModel*)getManagedObjectModel;

-(NSPersistentStoreCoordinator*)getPersistentStoreCoordinator;

-(NSManagedObjectContext*)getManagedObjectContext;

-(void)saveManagedObjectContext;

#pragma  mark - SQLite operation methods:

-(NSMutableArray*)getUserListByPageSize:(int)pageSize andOffset:(int)currentPage;

-(void)updateUserEmail:(NSString*)email byName:(NSString*)name;

-(void)addUserWithName:(NSString*)name andEmail:(NSString*)email;

-(void)deleteUserByName:(NSString*)name;

@end
