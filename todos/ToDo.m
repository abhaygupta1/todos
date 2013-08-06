//
//  ToDo.m
//  todos
//
//  Created by  on 8/5/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "ToDo.h"

@implementation ToDo

-  (id)initWithTodoItem: (NSString *) todoItem {
    self = [super init];
    
    if (self != nil) {
        self.todoItem = todoItem;
    }
    return self;
}


- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.todoItem forKey:@"ToDo"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *todoItem = [decoder decodeObjectForKey:@"ToDo"];
    return [self initWithTodoItem:todoItem];
}

+ (NSMutableArray *) initTodoList {
    NSMutableArray *todoList;
    todoList = [NSKeyedUnarchiver unarchiveObjectWithFile: @"/tmp/todos"];
    return todoList;
}

+ (void) saveTodoList: (NSMutableArray *)todoList {
    [NSKeyedArchiver archiveRootObject: todoList toFile:@"/tmp/todos"];
}

+ (NSMutableArray *) fakeTodoList {
    NSMutableArray *todoList = [NSMutableArray array];
    [todoList addObject: [[ToDo alloc] initWithTodoItem:@"Item1"]];
    [todoList addObject: [[ToDo alloc] initWithTodoItem:@"Item2"]];
    [todoList addObject: [[ToDo alloc] initWithTodoItem:@"Item3"]];
    
    return todoList;
}


@end
