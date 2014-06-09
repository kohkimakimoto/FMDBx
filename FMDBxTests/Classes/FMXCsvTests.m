//
//  FMXCsvTests.m
//  FMDBx
//
//  Created by KohkiMakimoto on 6/9/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FMDBx.h"
#import "FMXTestMigration.h"
#import "FMXUser.h"

@interface FMXCsvTests : XCTestCase

@end

@implementation FMXCsvTests

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

- (void)testExample
{

}

@end
