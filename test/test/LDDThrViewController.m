//
//  LDDThrViewController.m
//  test
//
//  Created by 李洞洞 on 5/1/18.
//  Copyright © 2018年 Minte. All rights reserved.
//

#import "LDDThrViewController.h"

@interface LDDThrViewController ()<NSMachPortDelegate>
@property(nonatomic,strong)NSLock * lock;
@property(nonatomic,strong)NSMachPort * machPort;
@property(nonatomic,strong)NSMutableArray * notificationsQueue;
@end

@implementation LDDThrViewController
- (NSMutableArray *)notificationsQueue
{
    if (!_notificationsQueue) {
        _notificationsQueue = [NSMutableArray array];
    }
    return _notificationsQueue;
}
//- (NSMachPort *)machPort
//{
//    if (!_machPort) {
//        _machPort = [[NSMachPort alloc]init];
//        _machPort.delegate = self;
//        [[NSRunLoop currentRunLoop]addPort:_machPort forMode:NSRunLoopCommonModes];
//    }
//    return _machPort;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    _machPort = [[NSMachPort alloc]init];
    _machPort.delegate = self;
    [[NSRunLoop currentRunLoop]addPort:_machPort forMode:NSRunLoopCommonModes];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*
     主线程监听通知
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LDD:) name:@"Buliceli" object:nil];
        NSLog(@"当前监听通知的线程%@",[NSThread currentThread]);
    });
    
    /*
     子线程中发送通知
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"当前发送通知的线程%@",[NSThread currentThread]);
       
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Buliceli" object:nil];
        
    });
 }
- (void)LDD:(NSNotification*)noti
{//主线程发出的通知 那么处理通知的方法所在的线程就是主线程 子线程发出的通知 那么处理通知所在的线程就是子线程
    
    if ([NSThread currentThread] == [NSThread mainThread]) {
        NSLog(@"本应该在子线程中处理的通知被转发到主线程来处理了+++%@+++",noti);
    }else{
        [self.lock lock];
        [self.notificationsQueue addObject:noti];//将其他线程发过来的通知不做处理,入队列暂存
        [self.lock unlock];
       //通过MachPort给处理通知的主线程发送通知,使其处理队列中所暂存的队列
        //[self.machPort sendBeforeDate:[NSDate date] components:nil from:nil reserved:0];
        [self.machPort sendBeforeDate:[NSDate date] components:nil from:nil reserved:0];
    }
    
}
- (void)handleMachMessage:(void *)msg
{
    [self.lock lock];
    
    //依次取出队列中所暂存的Notification，然后在当前线程中处理该通知
    while ([self.notificationsQueue count]) {
        NSNotification *notification = [self.notificationsQueue objectAtIndex:0];
        
        [self.notificationsQueue removeObjectAtIndex:0]; //取出队列中第一个值
        [self.lock unlock];
        [self LDD:notification];    //处理从队列中取出的通知
        [self.lock lock];
        
    };
    
    [self.lock unlock];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
