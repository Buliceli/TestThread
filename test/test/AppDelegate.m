//
//  AppDelegate.m
//  test
//
//  Created by 李洞洞 on 4/1/18.
//  Copyright © 2018年 Minte. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LDDViewController.h"
#import "LDSecViewController.h"
#import "LDDThrViewController.h"
#import "LDDFourViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[LDDFourViewController alloc]init]];
    self.window.rootViewController =nav;
    [self.window makeKeyAndVisible];
    [self setUpNav];
    return YES;
    
}
- (void)setUpNav
{

    
    //导航栏样式
    UINavigationBar * navBar = [UINavigationBar appearance];
    [navBar
     setBackgroundImage:[self creatUIImageWithColor:[UIColor colorWithRed:32 / 255.0 green:203 / 255.0 blue:128 / 255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    
    [navBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName : [UIColor whiteColor]  }];
    
    [navBar setShadowImage:[UIImage new]];
    
    //返回按钮样式//nav_back
#if 1 //iOS 11上有问题 返回按钮是系统默认的返回箭头 你设置的下面的图片已被平铺iOS11以下没问题
    UIImage* image = [[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    
    [[UIBarButtonItem appearance]
     setBackButtonBackgroundImage:image
     forState:UIControlStateNormal
     barMetrics:UIBarMetricsDefault];
#endif
#if 0   //在iOS 11上可以在iOS 11以下返回箭头和返回文字间距过大
    UIImage *backButtonImage = [[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UINavigationBar * item = [UINavigationBar appearance];
    item.backIndicatorImage = backButtonImage;
    item.backIndicatorTransitionMaskImage = backButtonImage;
    
//    UIOffset offset = [UIDevice currentDevice].systemVersion.floatValue >= 11.0 ? UIOffsetMake(0, 0) : UIOffsetMake(-8, 2);
//#warning UIOffsetMake(-8, 2)这个值是目测的....
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:offset forBarMetrics:UIBarMetricsCompact];
#endif
}
- (UIImage*)creatUIImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
