//
//  FMXQuery.m
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXQuery.h"
#import "FMXModel.h"
#import "FMXTableMap.h"
#import "FMXColumnMap.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface FMXQuery ()

@property (readwrite) Class modelClass;

@end

@implementation FMXQuery

- (id)initWithModelClass:(Class)aClass
{
    self = [super init];
    if (self) {
        self.modelClass = aClass;
    }
    return self;
}

- (FMXModel *)modelByPrimaryKey:(id)primaryKeyValue
{
    FMXModel *model = nil;
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from `%@` where `%@` = ?",
                                        table.tableName,
                                        table.primaryKeyName], primaryKeyValue];
    if ([rs next]) {
        model = [self.modelClass modelWithResultSet:rs];
    }
    [db close];
    
    return model;
}

- (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    FMXModel *model = nil;
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ limit 1",
                     table.tableName,
                     [self validatedConditionsString:conditions]];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    if ([rs next]) {
        model = [self.modelClass modelWithResultSet:rs];
    }
    [db close];
    
    return model;
}

- (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy
{
    if (orderBy == nil) {
        return [self modelWhere:conditions parameters:parameters];
    }
    
    FMXModel *model = nil;
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@ limit 1",
                     table.tableName,
                     [self validatedConditionsString:conditions],
                     orderBy
                     ];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    if ([rs next]) {
        model = [self.modelClass modelWithResultSet:rs];
    }
    [db close];
    
    return model;
}

- (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@",
                     table.tableName,
                     [self validatedConditionsString:conditions]];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    while ([rs next]) {
        [models addObject:[self.modelClass modelWithResultSet:rs]];
    }
    [db close];
    
    return models;
}

- (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy
{
    if (orderBy == nil) {
        return [self modelsWhere:conditions parameters:parameters];
    }
    
    NSMutableArray *models = [[NSMutableArray alloc] init];
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@",
                     table.tableName,
                     [self validatedConditionsString:conditions],
                     orderBy
                     ];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    while ([rs next]) {
        [models addObject:[self.modelClass modelWithResultSet:rs]];
    }
    [db close];
    
    return models;
}


- (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy limit:(NSInteger)limit
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select * from `%@` where %@ order by %@ limit %ld",
                     table.tableName,
                     [self validatedConditionsString:conditions],
                     orderBy,
                     (long)limit
                     ];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    while ([rs next]) {
        [models addObject:[self.modelClass modelWithResultSet:rs]];
    }
    [db close];
    
    return models;
}

- (NSInteger)countWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    NSInteger count = 0;
    
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self.modelClass];
    FMDatabase *db = [[FMXDatabaseManager sharedInstance] databaseForModel:self.modelClass];
    
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select count(*) as count from `%@` where %@",
                     table.tableName,
                     [self validatedConditionsString:conditions]];
    FMResultSet *rs = [db executeQuery:sql withParameterDictionary:parameters];
    
    if ([rs next]) {
        count = [rs intForColumn:@"count"];
    }
    
    [db close];
    
    return count;
}

- (NSString *)validatedConditionsString:(NSString *)conditions
{
    if (conditions == nil || [conditions isEqualToString:@""]) {
        conditions = [NSString stringWithFormat:@"1 = 1"];
    }
    
    return conditions;
}

@end
