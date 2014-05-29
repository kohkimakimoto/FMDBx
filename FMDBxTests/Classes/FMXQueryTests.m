//
//  FMXQueryTests.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/29/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FMDB.h>
#import "FMDBx.h"
#import "FMXTestMigration.h"
#import "FMXUser.h"

@interface FMXQueryTests : XCTestCase

@end

@implementation FMXQueryTests

- (void)setUp
{
    [super setUp];
    [[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"default.sqlite"
                                                               migration:[[FMXTestMigration alloc] init]];
}

- (void)tearDown
{
    [[FMXDatabaseManager sharedInstance] destroyDefaultDatabase];
    [super tearDown];
}

- (void)testDefault
{
    
    
}

@end
