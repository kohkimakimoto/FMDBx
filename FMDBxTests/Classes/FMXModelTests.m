//
//  FMXModelTests.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/25/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FMDB.h>
#import "FMDBx.h"
#import "FMXTestMigration.h"
#import "FMXUser.h"

@interface FMXModelTests : XCTestCase

@end

@implementation FMXModelTests

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

- (void)testSaveAndFind
{
    FMXUser *user = [[FMXUser alloc] init];
    user.name = @"kohki makimoto";
    user.age = @(33);
    user.createdAt = [NSDate date];
    user.updatedAt = [NSDate date];
    
    FMXUser *retUser = (FMXUser *)[FMXUser modelByPrimaryKey:@(1)];
    XCTAssertNil(retUser);

    // insert
    [user save];

    FMXUser *retUser2 =(FMXUser *)[FMXUser modelByPrimaryKey:@(1)];
    XCTAssertEqualObjects(user.name, retUser2.name);
    XCTAssertEqualObjects(user.age, retUser2.age);

    FMXUser *retUser3 =(FMXUser *)[[FMXUser query] modelByPrimaryKey:@(1)];
    XCTAssertEqualObjects(user.name, retUser3.name);
    XCTAssertEqualObjects(user.age, retUser3.age);
    
    // update
    user.age = @(44);
    [user save];
    
    FMXUser *retUser4 =(FMXUser *)[FMXUser modelByPrimaryKey:@(1)];
    XCTAssertEqualObjects(@(44), retUser4.age);
    
    // delete
    [user delete];
    
    FMXUser *retUser5 = (FMXUser *)[FMXUser modelByPrimaryKey:@(1)];
    XCTAssertNil(retUser5);
}

@end
