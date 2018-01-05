//
//  ViewController.m
//  test
//
//  Created by 李洞洞 on 4/1/18.
//  Copyright © 2018年 Minte. All rights reserved.
//

#import "ViewController.h"
#import "SecController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SecController * sec = [[SecController alloc]init];
    
    [self.navigationController pushViewController:sec animated:YES];
}
@end
