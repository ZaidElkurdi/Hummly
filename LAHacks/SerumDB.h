//
//  SerumDB.h
//  Serum
//
//  Created by Aryaman Sharda on 3/7/14.
//  Copyright (c) 2014 Aryaman Sharda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@interface SerumDB : NSObject
{
    sqlite3 *database;
}

//Hello, Zaid. I am your father.

@property (nonatomic,retain) NSString *state;
+(SerumDB *)database;
-(NSArray *)getAllHighSchools;
@end
