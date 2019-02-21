//
//  ViewController.m
//  CoreDataDemo
//
//  Created by liuzhao on 2019/2/21.
//  Copyright © 2019 liuzhao. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    NSManagedObjectContext * _context;
    NSMutableArray * _dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    self.tableView.estimatedRowHeight = 100;
    
    [self createCodata];
    
    //查询所有数据的请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
}

- (void)createCodata {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *manageModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:manageModel];
    
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coredata1.sqlite"];
    NSLog(@"数据库 path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    if (error) {
        NSLog(@"添加数据库失败:%@",error);
    } else {
        NSLog(@"添加数据库成功");
    }
    
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    _context.persistentStoreCoordinator = store;

}

- (IBAction)insertClicked:(id)sender {
    [self insertData];
}
- (IBAction)delegateClicked:(id)sender {
    [self deleteData];
}
- (IBAction)updateClicked:(id)sender {
    [self updateData];
}
- (IBAction)readClicked:(id)sender {
    [self readData];
}

#pragma mark -- 数据处理

//插入数据
- (void)insertData{
    
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
    Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_context];
    
    //  2.根据表Student中的键值，给NSManagedObject对象赋值
    p.name = [NSString stringWithFormat:@"Name-%d",arc4random()%100];
    p.age = arc4random()%100;
    
    //查询所有数据的请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    //   3.保存插入的数据
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"数据插入到数据库成功");
    }else{
        NSLog(@"%@" ,[NSString stringWithFormat:@"数据插入到数据库失败, %@",error]);
    }
    
}


//删除
- (void)deleteData{
    
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", @(50)];
    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (Person *p in deleArray) {
        [_context deleteObject:p];
    }
    
    //没有任何条件就是读取所有的数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    NSError *error = nil;
    //保存--记住保存
    if ([_context save:&error]) {
        NSLog(@"删除 age < 50 的数据");
    }else{
        NSLog(@"删除数据失败, %@", error);
    }
    
}

//更新，修改
- (void)updateData{
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age > %d", 50];
    request.predicate = pre;
    
    //发送请求
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    //修改
    for (Person *p in resArray) {
        p.name = @"浮云";
    }
    
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    //保存
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"更新所有大于age>50的名字为“浮云”");
    }else{
        NSLog(@"更新数据失败, %@", error);
    }
    
    
}


//读取查询
- (void)readData{
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", 50];
    request.predicate = pre;
    
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    
    //发送查询请求,并返回结果
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    _dataSource = [NSMutableArray arrayWithArray:resArray];
    [self.tableView reloadData];
    
    
    
}

#pragma mark -- UITableDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * celll = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    Person * p = _dataSource[indexPath.row];
    celll.textLabel.text = [NSString stringWithFormat:@" age = %lld \n name = %@ \n ",p.age,p.name];
    celll.textLabel.numberOfLines = 0;
    
    return celll;
}


@end
