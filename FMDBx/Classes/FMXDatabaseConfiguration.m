//
//  FMXDatabaseConfigration.m
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXDatabaseConfiguration.h"

@implementation FMXDatabaseConfiguration

/**
 *  Setup new database configuration with database path.
 *
 *  @param databasePath database path
 *  @return FMXDatabaseConfiguration instance.
 */
- (id)initWithDatabasePath:(NSString *)databasePath
{
    self = [super init];
    if (self) {
        self.databasePath = databasePath;
        
        // Set a database file path in the documents directory.
        NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.databasePathInDocuments = [dir stringByAppendingPathComponent:databasePath];
        
        // Initialize database file.
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:self.databasePathInDocuments]) {
            // The database file is not found in the documents directory. Create empty database file.
            [fm createFileAtPath:self.databasePathInDocuments contents:nil attributes:nil];
            NSLog(@"[FMDBx] Create initial database file: %@", self.databasePathInDocuments);
        }
    }
    return self;
}

/**
 *  Get a FMDatabase instance.
 *
 *  @return FMDatabase instance.
 */
-(FMDatabase *)database
{
    return [FMDatabase databaseWithPath:self.databasePathInDocuments];
}

@end
