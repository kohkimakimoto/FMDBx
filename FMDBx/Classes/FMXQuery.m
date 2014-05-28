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
#import "FMDB.h"

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

@end
