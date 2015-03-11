//
//  FMXUserModel.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/25/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXUser.h"

@implementation FMXUser

- (void)tableMap:(FMXTableMap *)table
{
    [table hasIntIncrementsColumn:@"id"];
    [table hasStringColumn:@"name"];
    [table hasIntColumn:@"age"];
    [table hasDateColumn:@"created_at"];
    [table hasDateColumn:@"updated_at"];
}

@end
