//
//  FMXQuery.h
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXModel.h"

@class FMXModel;

@interface FMXQuery : NSObject

@property (assign, nonatomic, readonly) Class modelClass;

- initWithModelClass:(Class)aClass;

- (FMXModel *)modelByPrimaryKey:(id)primaryKeyValue;

- (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

- (FMXModel *)modelWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;

- (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

- (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy;

- (NSArray *)modelsWhere:(NSString *)conditions parameters:(NSDictionary *)parameters orderBy:(NSString *)orderBy limit:(NSInteger)limit;

- (NSInteger)countWhere:(NSString *)conditions parameters:(NSDictionary *)parameters;

@end
