# FMDBx

An extension of [FMDB](https://github.com/ccgus/fmdb) to provide ORM and migration functionality for your iOS application.

## Requirements

* iOS 7.0 or later
* Xcode5 or later
* ARC

> Note: I am testing this product on the above condition.

## Installation

You can install FMDBx via [CocoaPods](http://cocoapods.org).
Add the following line to your Podfile.

```
pod 'FMDBx'
```

## Usage

* [Database Manager](#database-manager)
* [Migration](#migration)
* [ORM](#orm)
* [Import data from CSV](#import-data-from-csv)

### Database Manager

Database Manager:`FMXDatabaseManager` class is a singleton instance that manages sqlite database files and FMDatabase instances connecting them. You can get it the following code.

```
FMXDatabaseManager *manager = [FMXDatabaseManager sharedManager];
```

#### Register a database

At first, you need to register a database that is used in your app to Database Manager.

```Objective-C
[[FMXDatabaseManager sharedManager] registerDefaultDatabaseWithPath:@"database.sqlite" migration:nil];
```

At the above example, you don't need to place `database.sqlite` file by hand. 
`FMXDatabaseManager` class automatically create initial empty `database.sqlite` file in the `NSDocumentDirectory` if it doesn't exist.

#### Get a FMDatabase instance from a registered database

```Objective-C
FMDatabase *db = [[FMXDatabaseManager sharedManager] defaultDatabase];
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
         "  age integer not null,"
         "  is_male BOOL not null,"
         "  created_at integer not null,"
         "  updated_at integer not null"
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

Register a database with an instance of migration class. It runs migration tasks.

```Objective-C
[[FMXDatabaseManager sharedManager] registerDefaultDatabaseWithPath:@"database.sqlite" 
                                                           migration:[[MyMigration alloc] init]];
```

### ORM

It is designed like ActiveRecord.

#### Define a model class

You need to define model classes for each tables.
By default, a model class automatically maps a table which is named pluralized class name without prefix.(It's not strict. Just add `s` end of the term). 

For example, `ABCUser` model class maps `users` table at default.

```Objective-C
@interface ABCUser : FMXModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;
@property (assign, nonatomic) BOOL isMale;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@end
```

You need to define `tableMap` method like the following to map each properties with table columns.

```Objective-C
@implementation ABCUser

+ (void)defaultTableMap:(FMXTableMap *)table {

    [table hasIntIncrementsColumn:@"id"];   // defines as a primary key.
    [table hasStringColumn:@"name"];
    [table hasIntColumn:@"age"];
    [table hasBoolColumn:@"is_male"];
    [table hasDateColumn:@"created_at"];
    [table hasDateColumn:@"updated_at"];

}

@end
```

The model class needs primary key. So you need to define primary key configuration. Please see below example.

```Objective-C
[table hasIntIncrementsColumn:@"id"];

// or

[table hasIntColumn:@"id" withPrimaryKey:YES];
```

If you want to change a mapped table name from a default,
you can specify table name like the following.

```Objective-C
@implementation ABCUser

- (void)defaultTableMap:(FMXTableMap *)table
{
    [table setTableName:@"custom_users"];
}

@end
```

#### Insert, update and delete

You can use a model class to insert, update and delete data.

```Objective-C
ABCUser *user = [[ABCUser alloc] init];
user.name = @"Kohki Makimoto";
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
ABCUser *user = (ABCUser *)[ABCUser modelByPrimaryKey:@(1)];
NSLog(@"Hello %@", user.name);
```

#### Find by where conditions

You can get a model.

```Objective-C
ABCUser *user = (ABCUser *)[ABCUser modelWhere:@"name = :name" parameters:@{@"name": @"Kohki Makimoto"}];
```

You can get multiple models.

```Objective-C
NSArray *users = [ABCUser modelsWhere:@"age = :age" parameters:@{@"age": @34}];
for (ABCUser *user in users) {
    NSLog(@"Hello %@!", user.name);
}
```

#### Count records by where conditions

```Objective-C
# Count all users.
NSInteger count = [ABCUser count];

# Count users whose name is 'Kohki Makimoto'.
NSInteger count = [ABCUser countWhere:@"name = :name" parameters:@{@"name": @"Kohki Makimoto"}];
```

### Import data from CSV 

You can add some data in your migration task or other places.

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
         "  is_male BOOL not null,"
         "  created_at integer not null,"
         "  updated_at integer not null"
         ")"
         ];

        [FMXCsvTable foreachFileName:@"users.csv" process:^(NSDictionary *row) {
            [ABCUser createWithValues:row database:db];
        }];
    }];
}

@end
```

CSV file is like the following. The header line is must.

```
id,name,age,is_male,created_at,updated_at
1,Kohki Makimoto1,34,1,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
2,Kohki Makimoto2,35,1,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
3,Kohki Makimoto3,36,0,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
4,Kohki Makimoto4,37,0,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
5,Kohki Makimoto5,38,1,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
6,Kohki Makimoto6,39,1,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
7,Kohki Makimoto7,40,0,2010-12-01T21:35:43+0900,2010-12-01T21:35:43+0900
```

