//
//  ToDo.h
//  todos
//
//  Created by  on 8/5/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDo : NSObject

@property (nonatomic, strong) NSString *todoItem;

-  (id)initWithTodoItem: (NSString *) todoItem;
+ (NSMutableArray *) fakeTodoList;
+ (NSMutableArray *) initTodoList;
+ (void) saveTodoList:(NSMutableArray *)todoList;

@end
