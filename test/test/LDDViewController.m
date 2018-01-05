//
//  LDDViewController.m
//  test
//
//  Created by 李洞洞 on 5/1/18.
//  Copyright © 2018年 Minte. All rights reserved.
//

#import "LDDViewController.h"

@interface LDDViewController ()<NSMachPortDelegate>
@property(nonatomic,strong)NSMachPort * handelEventMachPort;
@end

@implementation LDDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //往通知中心添加观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:@"MyName" object:nil];
    //创建子线程,在子线程中发送通知
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"MyName" object:nil];
    });
}
- (void)handleNotification:(NSNotification*)noti
{
    NSLog(@"处理通知方法的线程:%@",[NSThread currentThread]);
    /*
     虽然是在主线程中添加的观察者，但是如果在子线程中发出通知，那么就在该子线程中处理通知所关联的方法
     */
}
#pragma mark 将子线程发出的通知通过MachPort转发到主线程中进行处理




































- (void)addMachPortToMainRunLoop
{
    self.handelEventMachPort = [[NSMachPort alloc]init];
    self.handelEventMachPort.delegate = self;
    [[NSRunLoop mainRunLoop]addPort:self.handelEventMachPort forMode:NSRunLoopCommonModes];
}
/*
 实现NSMachPortDelegate代理中相关的方法,当在其他线程中调用上述的MachPort对象发送消息时，会在主线程中执行下方的代理方法
 */
- (void)handleMachMessage:(void *)msg
{
    NSLog(@"%@",[NSThread currentThread]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread currentThread].name = @"MySubThread";
        NSLog(@"send Event sub thread %@",[NSThread currentThread]);
        //往主线程的RunLoop中发送事件
        [self.handelEventMachPort sendBeforeDate:[NSDate date] msgid:100 components:nil from:nil reserved:0];
    });
    /*
     点击屏幕时，会开启一个新的子线程，我们将这个开启的子线程命名为“MySubThread”。在这个子线程中我们调用了与主线程关联的MachPort对象发送消息。然后在主线程中执行该MachPort对象的相关回调方法
     */
}
@end
