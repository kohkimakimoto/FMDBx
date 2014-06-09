//
//  FMXCsv.m
//  FMDBx
//
//  Created by KohkiMakimoto on 6/9/14.
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

// ====================================================
// The Code that parses CSV file refers `NTYCSVTable`.
// see https://github.com/naoty/NTYCSVTable
// ====================================================
//
// NTYCSVTable
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Naoto Kaneko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "FMXCsvTable.h"

@implementation FMXCsvTable

+ (void)foreachFileName:(NSString *)fileName process:(void (^)(NSArray *))process
{
    [self foreachFileName:fileName columnSeparator:@"," process:process];
}

+ (void)foreachFileName:(NSString *)fileName columnSeparator:(NSString *)separator process:(void (^)(NSArray *))process
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self foreachURL:url columnSeparator:separator process:process];
}

+ (void)foreachURL:(NSURL *)url process:(void (^)(NSArray *))process
{
    [self foreachURL:url columnSeparator:@"," process:process];
}

+ (void)foreachURL:(NSURL *)url columnSeparator:(NSString *)separator process:(void (^)(NSArray *))process
{
    NSString *csvString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    csvString = [csvString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
}

@end
