//
//  FMXHelpersTests.m
//  FMDBx
//
//  Created by KohkiMakimoto on 5/25/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FMDBx.h"

@interface FMXHelpersTests : XCTestCase

@end

@implementation FMXHelpersTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertEqualObjects(@"aaa_bbb_ccc", FMXSnakeCaseFromCamelCase(@"aaaBbbCcc"));
    XCTAssertEqualObjects(@"aaa_bbb_ccc", FMXSnakeCaseFromCamelCase(@"AaaBbbCcc"));
    XCTAssertEqualObjects(@"my_name_is_kohki_makimoto", FMXSnakeCaseFromCamelCase(@"MyNameIsKohkiMakimoto"));
    
    XCTAssertEqualObjects(@"AaaBbbCcc", FMXUpperCamelCaseFromSnakeCase(@"aaa_bbb_ccc"));
    XCTAssertEqualObjects(@"MyNameIsKohkiMakimoto", FMXUpperCamelCaseFromSnakeCase(@"my_name_is_kohki_makimoto"));

    XCTAssertEqualObjects(@"aaaBbbCcc", FMXLowerCamelCaseFromSnakeCase(@"aaa_bbb_ccc"));
    XCTAssertEqualObjects(@"myNameIsKohkiMakimoto", FMXLowerCamelCaseFromSnakeCase(@"my_name_is_kohki_makimoto"));
    
    XCTAssertEqualObjects(@"users", FMXDefaultTableNameFromModelName(@"FMXUser"));
    XCTAssertEqualObjects(@"articles", FMXDefaultTableNameFromModelName(@"Article"));

}

@end
