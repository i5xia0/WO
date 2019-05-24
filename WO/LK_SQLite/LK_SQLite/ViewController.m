//
//  ViewController.m
//  LK_SQLite
//
//  Created by linke on 2019/5/21.
//  Copyright © 2019 LK. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@property FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.拼接数据库存放的沙盒路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:@"student.sqlite"];
    // 1.通过路径创建数据库
    self.db = [FMDatabase databaseWithPath:sqlFilePath];
    // 2.打开数据库
    if ([self.db open]) {
        NSLog(@"打开成功");
        BOOL success = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER DEFAULT 1)"];
        if (success) {
            NSLog(@"创建表成功");
        } else {
            NSLog(@"创建表失败");
        }
    } else {
        NSLog(@"打开失败");
    }
    
//    [self insertData];
    
    [self deleteData];
    
    [self updateData];
    
    [self selectData];
    
}

- (void)insertData {
    // 1.插入数据
    static NSInteger age = 10;
    for (int i = 0; i < 20; i++) {
        age++;
        BOOL success = [self.db executeUpdate:@"INSERT INTO t_student (id, name, age) VALUES (?, ?, ?);", @(i), @"jack", @(age)];
        if (success) {
            NSLog(@"插入成功");
        } else {
            NSLog(@"插入失败");
        }
    }
}
- (void)deleteData {
    // 2.删除数据
    BOOL success = [self.db executeUpdate:@"DELETE FROM t_student WHERE age > 20 AND age < 25;"];
    if (success) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}
- (void)updateData {
    // 3.修改数据
    BOOL success = [self.db executeUpdate:@"UPDATE t_student SET name = 'liwx' WHERE age > 12 AND age < 15;"];
    if (success) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
}
- (void)selectData {
    // 4.查询数据
    FMResultSet *result = [self.db executeQuery:@"SELECT id, name, age FROM t_student WHERE age > 10;"];
    while ([result next]) {
        int ID = [result intForColumnIndex:0];
        NSString *name = [result stringForColumnIndex:1];
        int age = [result intForColumn:@"age"];
        NSLog(@"ID: %d, name: %@, age: %d", ID, name, age);
    }
}
@end
