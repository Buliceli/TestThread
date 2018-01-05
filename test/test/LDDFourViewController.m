//
//  LDDFourViewController.m
//  test
//
//  Created by 李洞洞 on 5/1/18.
//  Copyright © 2018年 Minte. All rights reserved.
//

#import "LDDFourViewController.h"

@interface LDDFourViewController ()

@end

@implementation LDDFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
{
    NSLog(@"****当前线程是:%@---通知是:%@***",[NSThread currentThread],noti);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"当前线程是:%@---通知是:%@",[NSThread currentThread],noti);
    });
}
@end
