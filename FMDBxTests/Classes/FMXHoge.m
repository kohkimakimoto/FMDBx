//
//  FMXHoge.m
//  FMDBx
//
//  Created by KohkiMakimoto on 3/17/15.
//  Copyright (c) 2015 KohkiMakimoto. All rights reserved.
//

#import "FMXHoge.h"

@implementation FMXHoge

+ (void)defaultTableMap:(FMXTableMap *)table {
    [table hasIntIncrementsColumn:@"id"];
    [table hasStringColumn:@"text_field"];
    [table hasIntColumn:@"integer_field"];
    [table hasBoolColumn:@"bool_field"];
    [table hasDoubleColumn:@"double_field"];
    [table hasDateColumn:@"date_field"];
}

@end
