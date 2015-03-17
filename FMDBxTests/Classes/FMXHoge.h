//
//  FMXHoge.h
//  FMDBx
//
//  Created by KohkiMakimoto on 3/17/15.
//  Copyright (c) 2015 KohkiMakimoto. All rights reserved.
//

#import "FMXModel.h"

@interface FMXHoge : FMXModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *textField;
@property (strong, nonatomic) NSNumber *integerField;
@property (strong, nonatomic) NSNumber *doubleField;
@property (assign, nonatomic) BOOL boolField;
@property (strong, nonatomic) NSDate *dateField;

@end
