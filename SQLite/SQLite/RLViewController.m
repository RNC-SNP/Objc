//
//  RLViewController.m
//  SQLite
//
//  Created by RincLiu on 5/12/14.
//  Copyright (c) 2014 Rinc Liu. All rights reserved.
//

#import "RLViewController.h"

#define DATABASE_NAME @"person-info.sqlite"
#define TABLE_NAME @"PERSON_INFO"
#define COLUMN_NAME @"COLUMN_NAME"
#define COLUMN_EMAIL @"COLUMN_EMAIL"

@interface RLViewController ()

@end

@implementation RLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    sqlite3 *db = [self openDatabase];
    
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT)", TABLE_NAME, COLUMN_NAME, COLUMN_EMAIL];
    [self exeSQL:createTableSQL onDB:db];
    
    NSString *insertSQL1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                      TABLE_NAME, COLUMN_NAME, COLUMN_EMAIL, @"Rinc Liu", @"i@RincLiu.com"];
    [self exeSQL:insertSQL1 onDB:db];
    
    NSString *insertSQL2 = [NSString stringWithFormat:
                            @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%@')",
                            TABLE_NAME, COLUMN_NAME, COLUMN_EMAIL, @"Richard Lew", @"i@RichardLew.com"];
    [self exeSQL:insertSQL2 onDB:db];
    
    [self queryOnDB:db];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SQLite operations:

-(sqlite3*)openDatabase
{
    sqlite3 *db;
    // Init SQLite file path:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:DATABASE_NAME];
    // Try to open database.
    // If the db dosn't exist, then it will be created automatically, like in Android.
    if(sqlite3_open([dbPath UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"Open database failed.");
    }
    return db;
}

-(void)exeSQL:(NSString*)sql onDB:(sqlite3*)db
{
    char *err;
    // Execute SQL:
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSLog(@"Execute SQL failed.");
    }
}

-(void)queryOnDB:(sqlite3*)db
{
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_NAME];
    
    sqlite3_stmt * statement;
    
    // Query:
    if(sqlite3_prepare_v2(db, [querySQL UTF8String], -1, &statement, nil) == SQLITE_OK)
    {// Travel result set:
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            //Read data from statement by column index:
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nameStr = [[NSString alloc]initWithUTF8String:name];
            
            char *email = (char*)sqlite3_column_text(statement, 2);
            NSString *emailStr = [[NSString alloc]initWithUTF8String:email];
            
            NSLog(@"name:%@  email:%@",nameStr, emailStr);
        }
    }
    sqlite3_close(db);}

@end
