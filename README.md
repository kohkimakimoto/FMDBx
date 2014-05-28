# FMDBx

An extension of [FMDB](https://github.com/ccgus/fmdb). Provides ORM and migration functionality.

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

Database Manager:`FMXDatabaseManager` class is a singleton instance that manages sqlite database files
and FMDatabase instance connecting them.
This class also manages database schema status via migration object.

#### Register a database

```Objective-C
[[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"database.sqlite" migration:nil];
```

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
         "  age integer not null,"
         "  created_at integer not null,"
         "  updated_at integer not null"
         ")"
         ];
    }];
}

@end
```

Register database with instance of migration class.

```Objective-C
[[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"database.sqlite" 
                                                           migration:[[MyMigration alloc] init]];
```

#### Get a FMDatabase instance from a registered database

```Objective-C
FMDatabase *db = [[FMXDatabaseManager sharedInstance] defaultDatabase];
[db open];

// your code for databse operations

[db close];
```

### ORM

Object relational mapper designed to Active record. 
**This functionality is under the development.**

#### Define Model class. 

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

### Insert, update and delete

```Objective-C
MyUser *user = [[MyUser alloc] init];
user.name = @"kohki makimoto";
user.age = @(33);

// insert
[user save];

// update
user.age = @(44);
[user save];


// delete
[user delete];
```

### Find by primary key

```Objective-C
MyUser *user = (MyUser *)[MyUser modelByPrimaryKey:@(1)];
```

