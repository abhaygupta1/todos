//
//  TableViewController.m
//  todos
//
//  Created by  on 8/5/13.
//  Copyright (c) 2013 com.yahoo. All rights reserved.
//

#import "TableViewController.h"
#import "CustomCell.h"
#import "ToDo.h"

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *todoList;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, assign) BOOL inAddMode;

@end

@implementation TableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.todoList = [ToDo initTodoList];
        [ToDo saveTodoList:self.todoList];
        
        self.editButton = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self
                           action:@selector(onEditButton)];
        self.navigationItem.leftBarButtonItem = self.editButton;
        self.doneButton = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                           action:@selector(onDoneButton)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                  action:@selector(onAddButton)];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UINib *customNib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"CustomCell"];
    [self setInAddMode:NO]; 
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void) onDoneButton {
    [self.view endEditing:YES];
    [self.tableView setEditing:NO animated:NO];
    self.navigationItem.leftBarButtonItem = self.editButton;
    
}

- (void) onEditButton {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem = self.doneButton;
}

- (void) onAddButton {
    static NSString *cellIdentifier = @"CustomCell";
    [self setInAddMode:YES];
    
    CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setShowsReorderControl:YES];
    [cell.todoItem setEnabled:YES];
    
    ToDo *todoItem = [[ToDo alloc] initWithTodoItem:@""];
    [self.todoList insertObject:todoItem atIndex:0];
    cell.textLabel.text = (NSString *)[self.todoList[0] todoItem];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *cellIdentifier = @"CustomCell";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.todoItem.delegate = self;
    [cell setShowsReorderControl:YES];
    if ([self inAddMode]) {
        [cell.todoItem setEnabled:YES];
        [cell.todoItem becomeFirstResponder];
    }
    else
        [cell.todoItem setEnabled:NO];
    cell.todoItem.text = (NSString *)[self.todoList[indexPath.row] todoItem];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to beeditable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.todoList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [ToDo saveTodoList:self.todoList];


    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSObject *toDoItem = self.todoList[fromIndexPath.row];
    [self.todoList removeObjectAtIndex:fromIndexPath.row];
    [self.todoList insertObject:toDoItem atIndex:toIndexPath.row];
    [ToDo saveTodoList:self.todoList];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.enablesReturnKeyAutomatically = YES;
    
    // your code here
    
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self setInAddMode:NO];
    [(ToDo *)(self.todoList[0]) setTodoItem: textField.text];
    [ToDo saveTodoList:self.todoList];
    [textField resignFirstResponder];
}

@end
