# FMDBx

[![Build Status](https://travis-ci.org/kohkimakimoto/FMDBx.svg?branch=master)](https://travis-ci.org/kohkimakimoto/FMDBx)

An extension of [FMDB](https://github.com/ccgus/fmdb). Providing ORM and migration functionality.

## Warnings

**This software is under the development stage. The functionality is not enough.**

## Requirements

* iOS 7.0
* Xcode5

> Note: I am testing this product on the above condition.

## Installation

You can install FMDBx via [CocoaPods](http://cocoapods.org).
Add the following line to your Podfile.

```
pod 'FMDBx', :git => 'https://github.com/kohkimakimoto/FMDBx.git'
```

## Usage

### Database Manager

Database Manager:`FMXDatabaseManager` class is a singleton instance that manages sqlite database files and FMDatabase instances connecting them.

#### Register a database

```Objective-C
[[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"database.sqlite" migration:nil];
```

#### Get a FMDatabase instance from a registered database

```Objective-C
FMDatabase *db = [[FMXDatabaseManager sharedInstance] defaultDatabase];
[db open];

// your code for databse operations

[db close];
```

### Migration

`FMXDatabaseManager` can have a migration object to initialize and migrate database schema.

#### Register a database with a migration class

Create your migration class.

```Objective-C
@interface MyMigration : FMXDatabaseMigration

@end

@implementation MyMigration

- (void)migrate
{
    [self upToVersion:1 action:^(FMDatabase *db){
        [db executeUpdate:@""
         "create table users ("
         "  id integer primary key autoincrement,"
         "  name text not null,"
         "  age integer not null"
         ")"
         ];
    }];

    [self upToVersion:2 action:^(FMDatabase *db){
        // ... schema changes for version 2       
    }];

    [self upToVersion:3 action:^(FMDatabase *db){
        // ... schema changes for version 3       
    }];

    // ...etc
}

@end
```

Register database with an instance of migration class.

```Objective-C
[[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"database.sqlite" 
                                                           migration:[[MyMigration alloc] init]];
```

### ORM

It is designed to active record.
**This is under the development. It doesn't have enough functionality.**

#### Define model class. 

```Objective-C
@interface MyUser : FMXModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;

@end

@implementation MyUser

- (void)schema:(FMXTableMap *)table
{
    [table hasIntIncrementsColumn:@"id"];   // defines as primary key.
    [table hasStringColumn:@"name"];
    [table hasIntColumn:@"age"];
}

@end
```

#### Insert, update and delete

```Objective-C
MyUser *user = [[MyUser alloc] init];
user.name = @"kohki Makimoto";
user.age = @(34);

// insert
[user save];

// update
user.age = @(44);
[user save];

// delete
[user delete];
```

#### Find by primary key

```Objective-C
MyUser *user = (MyUser *)[MyUser modelByPrimaryKey:@(1)];
NSLog(@"Hello %@", user.name);
```

#### Find by where conditions

You can get a model.

```Objective-C
FMXUser *user = (FMXUser *)[[FMXUser query] modelWhere:@"name = :name" parameters:@{@"name": @"Kohki Makimoto"}];
```

You can get multiple models

```Objective-C
FMXUser *user = (FMXUser *)[[FMXUser query] modelsWhere:@"age = :age" parameters:@{@"name": @34}];
```

