//
//  FMXTestMigration.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/25/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXTestMigration.h"

@implementation FMXTestMigration

- (void)migrate
{
    [self upToVersion:1 action:^(FMDatabase *db){
        [db executeUpdate:@""
         "create table users ("
         "  id integer primary key autoincrement,"
         "  name text not null,"
         "  age integer not null,"
         "  is_male BOOL not null,"
         "  created_at integer not null,"
         "  updated_at integer not null"
         ")"
         ];
    }];
}

@end
