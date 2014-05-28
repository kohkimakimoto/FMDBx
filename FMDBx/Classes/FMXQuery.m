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
        model = [self modelWithResultSet:rs table:table];
    }
    [db close];
    
    return model;
}

- (FMXModel *)modelWithResultSet:(FMResultSet *)rs table:(FMXTableMap *)table
{
    NSDictionary *columns = table.columns;
    FMXModel *model = [[self.modelClass alloc] init];
    
    for (id key in [columns keyEnumerator]) {
        FMXColumnMap *column = [columns objectForKey:key];
        
        id value = nil;
        if (column.type == FMXColumnMapTypeInt) {
            value = [NSNumber numberWithInt:[rs intForColumn:column.name]];
        } else if (column.type == FMXColumnMapTypeLong) {
            value = [NSNumber numberWithLong:[rs longForColumn:column.name]];
        } else if (column.type == FMXColumnMapTypeDouble) {
            value = [NSNumber numberWithDouble:[rs doubleForColumn:column.name]];
        } else if (column.type == FMXColumnMapTypeString) {
            value = [rs stringForColumn:column.name];
        } else if (column.type == FMXColumnMapTypeBool) {
            value = [NSNumber numberWithBool:[rs boolForColumn:column.name]];
        } else if (column.type == FMXColumnMapTypeDate) {
            value = [rs dateForColumn:column.name];
        } else if (column.type == FMXColumnMapTypeData) {
            value = [rs dataForColumn:column.name];
        }
        
        if (value) {
            SEL selector = FMXSetterSelectorFromColumnName(column.name);
            if ([model respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [model performSelector:selector withObject:value];
#pragma clang diagnostic pop
            }
        }
    }
    return model;
}

@end
