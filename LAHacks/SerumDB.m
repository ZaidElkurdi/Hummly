//
//  SerumDB.m
//  Serum
//
//  Created by Aryaman Sharda on 3/7/14.
//  Copyright (c) 2014 Aryaman Sharda. All rights reserved.
//

#import "SerumDB.h"

@implementation SerumDB
@synthesize state;
static SerumDB * database;

//Hello, Zaid. I am your father.

+(SerumDB *)database
{
    if(database == nil)
    {
        database = [[SerumDB alloc]init];
    }
    return database;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        NSString * sqliteDb  = [[NSBundle mainBundle] pathForResource:@"LAHacks" ofType:@"sqlite"];
        
        if(sqlite3_open([sqliteDb UTF8String], &database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database");
        }
    }
    
    return self;
}
-(NSArray *)getAllSongs
{
    NSMutableArray * returnArray = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM LAHacks";
    sqlite3_stmt * statement;

    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char * highSchoolName = (char *) sqlite3_column_text(statement, 0);
            NSString *schoolName = [[NSString alloc] initWithUTF8String:highSchoolName];
        
            NSString *finalReturn = [NSString stringWithFormat:@"%@",schoolName];
            [returnArray addObject:finalReturn];
        }
        
        sqlite3_finalize(statement);
    }
    
    return returnArray;
}

@end
