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

### Register database

```Objective-C
[[FMXDatabaseManager sharedInstance] registerDefaultDatabaseWithPath:@"database.sqlite" migration:nil];
```

### Register database with migration class

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



