//
//  FMXTestMigration2.m
//  FMDBx
//
//  Created by KohkiMakimoto on 6/9/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXTestMigration2.h"
#import "FMXCsvTable.h"
#import "FMXUser.h"

@implementation FMXTestMigration2

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
        
        [FMXCsvTable foreachFileName:@"users.csv" process:^(NSDictionary *row) {
            [FMXUser createWithValues:row database:db];
        }];

            
    }];
}

@end
