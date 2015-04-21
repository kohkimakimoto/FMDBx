//
//  FMXModel.h
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXDatabaseManager.h"
#import "FMXDatabaseConfiguration.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMXHelpers.h"
#import "FMXTableMap.h"
#import "FMXColumnMap.h"
#import "FMXQuery.h"

@interface FMXModel : NSObject

@property (assign, nonatomic) BOOL isNew;

+ (void)defaultTableMap:(FMXTableMap *)table;

+ (void)overrideTableMap:(FMXTableMap *)table;

+ (FMXModel *)modelByPrimaryKey:(id)primaryKeyValue;

+ (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

+ (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;

+ (FMXModel *)modelWithResultSet:(FMResultSet *)rs;

+ (FMXModel *)modelWithValues:(NSDictionary *)values;

+ (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

+ (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;

+ (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy limit:(NSInteger)limit;

+ (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy limit:(NSInteger)limit offset:(NSInteger)offset;

+ (NSInteger)countWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

+ (NSInteger)count;

+ (FMXModel *)createWithValues:(NSDictionary *)values;

+ (FMXModel *)createWithValues:(NSDictionary *)values database:(FMDatabase *)db;

+ (FMXQuery *)query;

- (void)save;
- (void)saveWithDatabase:(FMDatabase *)db;

- (void)delete;
- (void)deleteWithDatabase:(FMDatabase *)db;

@end
