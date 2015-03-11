//
//  FMXDatabaseManagerTests.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/25/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FMDB.h>
#import "FMDBx.h"
#import "FMXTestMigration.h"

@interface FMXDatabaseManagerTests : XCTestCase

@end

@implementation FMXDatabaseManagerTests

- (void)setUp
{
    [super setUp];
    [[FMXDatabaseManager sharedManager] registerDefaultDatabaseWithPath:@"default.sqlite"
                                                               migration:[[FMXTestMigration alloc] init]];
}

- (void)tearDown
{
    //[[FMXDatabaseManager sharedInstance] destroyDefaultDatabase];
    [super tearDown];
}

- (void)testDefault
{
    NSFileManager *fm = [NSFileManager defaultManager];

    NSString *path = [[[FMXDatabaseManager sharedManager] defaultConfiguration] databasePathInDocuments];
    XCTAssertTrue([fm fileExistsAtPath:path]);
    
    FMDatabase *db = [[FMXDatabaseManager sharedManager] defaultDatabase];
    if (db) {
        XCTAssertTrue(YES);
    } else {
        XCTAssertTrue(NO);
    }
}

@end
