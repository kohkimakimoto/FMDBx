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
#import "FMXHoge.h"

@interface FMXQueryTests : XCTestCase

@end

@implementation FMXQueryTests

- (void)setUp
{
    [super setUp];
    [[FMXDatabaseManager sharedManager] registerDefaultDatabaseWithPath:@"default.sqlite"
                                                               migration:[[FMXTestMigration alloc] init]];
}

- (void)tearDown
{
    [[FMXDatabaseManager sharedManager] destroyDefaultDatabase];
    [super tearDown];
}

- (void)testDefault
{
    for (int i = 0; i < 10; i++) {
        FMXUser *user = [[FMXUser alloc] init];
        user.name = [NSString stringWithFormat:@"KohkiMakimoto%d", i];
        user.age = @(i);
        user.createdAt = [NSDate date];
        user.updatedAt = [NSDate date];
        [user save];
    }
    
    FMXUser *user2 = (FMXUser *)[[FMXUser query] modelWhere:@"name = :name" parameters:@{@"name": @"KohkiMakimoto0"}];
    XCTAssertEqualObjects(@(1), user2.id);
    XCTAssertFalse(user2.isNew);
    
    NSArray *users = [[FMXUser query] modelsWhere:@"name like :name" parameters:@{@"name": @"KohkiMakimoto%"}];
    for (FMXUser *user3 in users) {
        NSLog(@"%@", user3.name);
    }
    XCTAssertEqual(10, users.count);
}

- (void)testGettingNullValue
{
    FMXHoge *hoge = [[FMXHoge alloc] init];
    hoge.id = @(1);
    [hoge save];
    
    FMXHoge *rHoge = (FMXHoge *)[[FMXHoge query] modelByPrimaryKey:@(1)];
    XCTAssertEqualObjects(@(1), rHoge.id);
    XCTAssertEqualObjects(nil, rHoge.textField);
    XCTAssertEqualObjects(nil, rHoge.integerField);
    XCTAssertEqualObjects(nil, rHoge.doubleField);
    XCTAssertEqualObjects(nil, rHoge.dateField);
}

@end
