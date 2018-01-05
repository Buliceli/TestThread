//
//  LDSecViewController.m
//  test
//
//  Created by 李洞洞 on 5/1/18.
//  Copyright © 2018年 Minte. All rights reserved.
//

#import "LDSecViewController.h"

@interface LDSecViewController ()<NSMachPortDelegate>
@property(nonatomic,strong)NSMutableArray * notificationsQueue;//存储子线程发出的通知的队列
@property(nonatomic,strong)NSThread * mainThread;//处理通知事件的预期线程
@property(nonatomic,strong)NSLock * lock;//用于对通知队列加锁的锁对象,避免线程冲突
@property(nonatomic,strong)NSMachPort * machPort;//用于向期望线程发送信号的通信端口
@end

@implementation LDSecViewController
//对相关的成员属性进行赋值
- (void)setUpThreadSupport
{
    if (self.notificationsQueue) {
        return;
    }
    self.notificationsQueue = [NSMutableArray array];
    self.lock = [[NSLock alloc]init];
    self.mainThread = [NSThread currentThread];
    self.machPort = [[NSMachPort alloc]init];
    self.machPort.delegate = self;
    [[NSRunLoop currentRunLoop]addPort:self.machPort forMode:NSRunLoopCommonModes];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setUpThreadSupport];
    
    //往通知中心添加观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:@"MyName" object:nil];
    //创建子线程,在子线程中发送通知
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MyName" object:nil];
    });
}
- (void)handleNotification:(NSNotification*)noti
{
    if ([NSThread currentThread] == _mainThread) {
        NSLog(@"处理通知的线程 = %@",[NSThread currentThread]);
    }else{//在子线程中收到通知后,将收到的通知放入到队列中存储,然后给主线程的RunLoop发送处理通知的消息
        NSLog(@"转发通知的线程 = %@",[NSThread currentThread]);
        [self.lock lock];
        [self.notificationsQueue addObject:noti];//将其他线程发过来的通知不做处理,入队列暂存
        [self.lock unlock];
        //通过MachPort给处理通知的主线程发送通知,使其处理队列中所暂存的队列
        [self.machPort sendBeforeDate:[NSDate date] components:nil from:nil reserved:0];
    }
}
- (void)handleMachMessage:(void *)msg
{
    //在子线程中对notificationsQueue队列操作时，需要加锁，保持队列中数据的正确性
    [self.lock lock];
    
    //依次取出队列中所暂存的Notification，然后在当前线程中处理该通知
    while ([self.notificationsQueue count]) {
        NSNotification *notification = [self.notificationsQueue objectAtIndex:0];
        
        [self.notificationsQueue removeObjectAtIndex:0]; //取出队列中第一个值
        
        [self.lock unlock];
        [self handleNotification:notification];    //处理从队列中取出的通知
        [self.lock lock];
        
    };
    
    [self.lock unlock];
}
@end
