//
//  FMXUserModel.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/25/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXUser.h"

@implementation FMXUser

- (void)schema:(FMXTableMap *)table
{
    [table hasIntIncrementsColumn:@"id"];
    [table hasStringColumn:@"name"];
    [table hasIntColumn:@"age"];
    [table hasDataColumn:@"created_at"];
    [table hasDataColumn:@"updated_at"];
}

@end
