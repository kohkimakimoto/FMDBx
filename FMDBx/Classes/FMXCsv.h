//
//  FMXCsv.h
//  FMDBx
//
//  Created by KohkiMakimoto on 6/9/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMXCsv : NSObject

+ (void)foreachFileName:(NSString *)fileName action:(void (^)(NSArray *row))action;
+ (void)foreachURL:(NSURL *)url action:(void (^)(NSArray *row))action;

@end
