//
//  FMXQuery.h
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXModel.h"

@class FMXModel;

typedef NS_ENUM(NSInteger, FMXQueryCondition) {
    FMXQueryEqual = 0,
    FMXQueryNotEqual,
    FMXQueryGreaterThan,
    FMXQueryLessThan,
    FMXQueryGreaterEqual,
    FMXQueryLessEqual,
    FMXQueryLike,
    FMXQueryNotLike,
    FMXQueryIn,
    FMXQueryNotIn
};

@interface FMXQuery : NSObject

@property (assign, nonatomic, readonly) Class modelClass;

- initWithModelClass:(Class)aClass;

- (FMXModel *)modelByPrimaryKey:(id)primaryKeyValue;

/*
TODO:
- (FMXQuery *)queryWithWhere:(NSString *)columnName value:(id)value;

- (FMXQuery *)queryWithWhere:(NSString *)columnName condition:(FMXQueryCondition)condition value:(id)value;

- (FMXModel *)model;

- (NSArray *)models;
*/

@end
