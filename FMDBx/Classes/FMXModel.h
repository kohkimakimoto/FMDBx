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

+ (FMXModel *)modelByPrimaryKey:(id)primaryKeyValue;

+ (FMXModel *)modelWithResultSet:(FMResultSet *)rs;

+ (FMXQuery *)query;


- (void)schema:(FMXTableMap *)table;

- (void)save;

- (void)delete;

@end
