//
//  FMXModel.m
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXModel.h"

@implementation FMXModel

- (id)init
{
    self = [super init];
    if (self) {
        self.isNew = YES;
    }
    return self;
}

- (void)schema:(FMXTableMap *)table
{
    // You need to override the method at the subclass.
}

/**
 *  Find a model by the primary key.
 *
 *  @param primaryKeyValue primary key value
 *
 *  @return model object
 */
+ (FMXModel *)modelByPrimaryKey:(id)primaryKeyValue
{
    return [[self query] modelByPrimaryKey:primaryKeyValue];
}

+ (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    return [[self query] modelWhere:conditions parameters:parameters];
}

+ (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters
{
    return [[self query] modelsWhere:conditions parameters:parameters];
}

+ (FMXModel *)modelWithResultSet:(FMResultSet *)rs
{
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self];
    
    NSDictionary *columns = table.columns;
    FMXModel *model = [[self alloc] init];
    model.isNew = NO;
    
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

+ (FMXModel *)modelWithValues:(NSDictionary *)values
{
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:self];
    NSDictionary *columns = table.columns;

    FMXModel *model = [[self alloc] init];
    
    // TODO:
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd'T'HH:mm:ssZ"];
    
    for (id key in [columns keyEnumerator]) {
        FMXColumnMap *column = [columns objectForKey:key];
        id value = values[column.name];
        
        if (column.type == FMXColumnMapTypeInt) {
            // Nothing to do;
        } else if (column.type == FMXColumnMapTypeLong) {
            // Nothing to do;
        } else if (column.type == FMXColumnMapTypeDouble) {
            // Nothing to do;
        } else if (column.type == FMXColumnMapTypeString) {
            // Nothing to do;
        } else if (column.type == FMXColumnMapTypeBool) {
            // Nothing to do;
        } else if (column.type == FMXColumnMapTypeDate && [value isKindOfClass:[NSString class]]) {
            value = [formatter dateFromString:value];
        } else if (column.type == FMXColumnMapTypeData) {
            // Nothing to do;
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

+ (FMXModel *)createWithValues:(NSDictionary *)values;
{
    return [self createWithValues:values database:nil];
}

+ (FMXModel *)createWithValues:(NSDictionary *)values database:(FMDatabase *)db
{
    FMXModel *model = [self modelWithValues:values];
    [model saveWithDatabase:db];
    return model;
}

/**
 *  Get a query object.
 *
 *  @return query object
 */
+ (FMXQuery *)query
{
    return [[FMXDatabaseManager sharedInstance] queryForModel:self];
}

/**
 *  Save
 */
- (void)save
{
    [self saveWithDatabase:nil];
}

- (void)saveWithDatabase:(FMDatabase *)db
{
    if (self.isNew) {
        [self insertWithDatabase:db];
    } else {
        [self updateWithDatabase:db];
    }
}

/**
 *  Insert
 */
- (void)insertWithDatabase:(FMDatabase *)db
{
    if (!self.isNew) {
        return;
    }
    
    BOOL isPrivateConnection = NO;
    if (!db) {
        isPrivateConnection = YES;
        db = [[FMXDatabaseManager sharedInstance] databaseForModel:[self class]];
    }
    
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:[self class]];
    NSDictionary *columns = table.columns;
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (id key in [columns keyEnumerator]) {
        FMXColumnMap *column = [columns objectForKey:key];
        id value = [self valueForKey:column.propertyName] ?: NSNull.null;
        
        if ([column.name isEqualToString:table.primaryKeyName] && value == NSNull.null) {
            // Skip to set value and field set of primary key when the primary key is empty.
            // If the primary key has autoincrements attribute. It'OK.
            continue;
        }
        
        [fields addObject:column.name];
        [values addObject:value];
    }
    
    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"insert into `%@` ", table.tableName];
    [query appendFormat:@"(`%@`) values (%@?)",
     [fields componentsJoinedByString:@"`,`"],
     [@"" stringByPaddingToLength:((fields.count - 1) * 2) withString:@"?," startingAtIndex:0]
     ];
    
    if (isPrivateConnection) {
        [db open];
        [db beginTransaction];
    }
    
    [db executeUpdate:query withArgumentsInArray:values];
    
    // Update primary key after insert.
    SEL selector = FMXSetterSelectorFromColumnName(table.primaryKeyName);
    if ([self respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:@([db lastInsertRowId])];
        #pragma clang diagnostic pop
    }

    self.isNew = NO;
    
    if (isPrivateConnection) {
        [db commit];
        [db close];
    }
}

/**
 *  Update
 */
- (void)updateWithDatabase:(FMDatabase *)db
{
    if (self.isNew) {
        return;
    }
    
    BOOL isPrivateConnection = NO;
    if (!db) {
        isPrivateConnection = YES;
        db = [[FMXDatabaseManager sharedInstance] databaseForModel:[self class]];
    }
    
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:[self class]];
    if (![self valueForKey:[table columnForPrimaryKey].propertyName]) {
        return;
    }
    NSDictionary *columns = table.columns;
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (id key in [columns keyEnumerator]) {
        FMXColumnMap *column = [columns objectForKey:key];
        id value = [self valueForKey:column.propertyName] ?: NSNull.null;
        
        if ([column.name isEqualToString:table.primaryKeyName]) {
            // Skip to set value and field set of primary key.
            continue;
        }
        
        [fields addObject:column.name];
        [values addObject:value];
    }
    
    // The primary key value needs to be last value.
    [values addObject:[self valueForKey:[table columnForPrimaryKey].propertyName] ?: NSNull.null];
    
    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"update `%@` set ", table.tableName];
    [query appendFormat:@"`%@` = ? ", [fields componentsJoinedByString:@"`=?,`"]];
    [query appendFormat:@"where `%@` = ?", table.primaryKeyName];
    
    if (isPrivateConnection) {
        [db open];
        [db beginTransaction];
    }
    
    [db executeUpdate:query withArgumentsInArray:values];
    
    if (isPrivateConnection) {
        [db commit];
        [db close];
    }

}

- (void)delete
{
    [self deleteWithDatabase:nil];
}

/**
 *  Delete
 */
- (void)deleteWithDatabase:(FMDatabase *)db
{
    if (self.isNew) {
        return;
    }
    
    BOOL isPrivateConnection = NO;
    if (!db) {
        isPrivateConnection = YES;
        db = [[FMXDatabaseManager sharedInstance] databaseForModel:[self class]];
    }
    
    FMXTableMap *table = [[FMXDatabaseManager sharedInstance] tableForModel:[self class]];
    if (![self valueForKey:[table columnForPrimaryKey].propertyName]) {
        return;
    }

    // Build query
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"delete from `%@` ", table.tableName];
    [query appendFormat:@"where `%@` = ?", table.primaryKeyName];
    
    if (isPrivateConnection) {
        [db open];
        [db beginTransaction];
    }
    
    [db executeUpdate:query, [self valueForKey:[table columnForPrimaryKey].propertyName]];
    
    if (isPrivateConnection) {
        [db commit];
        [db close];
    }
}

@end
