//
//  FMXCsvTableTests.m
//  FMDBx
//
//  Created by KohkiMakimoto on 6/9/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FMDBx.h"
#import "FMXTestMigration.h"
#import "FMXUser.h"
#import "FMXTestMigration2.h"

@interface FMXCsvTableTests : XCTestCase

@end

@implementation FMXCsvTableTests

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

- (void)testForeachFileName
{
    [FMXCsvTable foreachFileName:@"users.csv" columnSeparator:@"," process:^(NSDictionary *row){
        NSNumber *idNumber = (NSNumber *)[row objectForKey:@"id"];
        if ([idNumber isEqualToNumber:@(1)]) {
            XCTAssertEqualObjects(@"Kohki Makimoto1", [row objectForKey:@"name"]);
            XCTAssertEqualObjects(@(34), [row objectForKey:@"age"]);
        }
        
        if ([idNumber isEqualToNumber:@(2)]) {
            XCTAssertEqualObjects(@"Kohki Makimoto2", [row objectForKey:@"name"]);
            XCTAssertEqualObjects(@(35), [row objectForKey:@"age"]);
        }
    }];
    
    [FMXCsvTable foreachFileName:@"users.csv" process:^(NSDictionary *row) {
        [FMXUser createWithValues:row];
    }];
    
    FMXUser *user = (FMXUser *)[FMXUser modelByPrimaryKey:@1];
    XCTAssertEqualObjects(@"Kohki Makimoto1", user.name);
}

- (void)testWithMigration
{
    [[FMXDatabaseManager sharedInstance] destroyDefaultDatabase];
    [[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"default.sqlite"
                                                               migration:[[FMXTestMigration2 alloc] init]];
}

@end
