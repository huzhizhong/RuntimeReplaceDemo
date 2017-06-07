//
//  ViewController.m
//  RuntimeReplaceDemo
//
//  Created by tgjr-Hzz on 2017/6/7.
//  Copyright © 2017年 Hzz. All rights reserved.
//



/*
 iOS runtime 关联对象 block 属性应用 
 目标：使用关联属性，简化代理方法的使用。
 方案：利用关联属性的属性添加方法+自定义block的特性（可以传参数，可以传递函数）。

*/
#import "ViewController.h"
#import <objc/runtime.h>

static void *alertViewKey = "alertViewKey";

@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view.layer insertSublayer:[self gradientLayer] atIndex:0];
    
    UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    lable.text = @"RuntimeReplace";
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 200, self.view.frame.size.width-60, 50);
    [button setTitle:@"title_one" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(showAlertOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonTwo.frame = CGRectMake(30, 280, self.view.frame.size.width-60, 50);
    [buttonTwo setTitle:@"title_one" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    [buttonTwo addTarget:self action:@selector(showAlertTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTwo];

}

#pragma mark --buttonClicked 将block 与 alertOne,alertTwo 关联

- (void) showAlertOne
{
    UIAlertView *alertOne = [[UIAlertView alloc]initWithTitle:@"AlertOne" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __weak ViewController *weakself = self;
    void (^block)(NSInteger) = ^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself methodOne];
        }
    };
    objc_setAssociatedObject(alertOne, alertViewKey, block, OBJC_ASSOCIATION_COPY);//将block 与 alertOne 关联
    [alertOne show];
}

- (void) showAlertTwo
{
    UIAlertView *alertTwo = [[UIAlertView alloc]initWithTitle:@"AlertTwo" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __weak ViewController *weakself = self;
    void (^block)(NSInteger) = ^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakself methodTwo];
        }
    };
    
    objc_setAssociatedObject(alertTwo, alertViewKey, block, OBJC_ASSOCIATION_COPY);
    [alertTwo show];
}

#pragma mark --block自己调用对应方法

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    void(^block)(NSInteger) = objc_getAssociatedObject(alertView, alertViewKey);
    block(buttonIndex);
}

- (void) methodOne
{
    NSLog(@"one_one_one");
}

- (void) methodTwo
{
    NSLog(@"two_two_two");
}

#pragma mark --背景渐变色

- (CAGradientLayer *)gradientLayer {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    // CGColor是无法放入数组中的，必须要转型。
    gradientLayer.colors = @[
                             (__bridge id)[UIColor colorWithRed:78 / 255.0 green:143 / 255.0 blue:1.0 alpha:1.0].CGColor,
                             (__bridge id)[UIColor colorWithRed:39 / 255.0 green:196 / 255.0 blue:254 / 255.0 alpha:1.0].CGColor,
                             (__bridge id)[UIColor colorWithRed:60 / 255.0 green:143 / 255.0 blue:1.0 alpha:1.0].CGColor,
                             ];
    // 颜色分割线
    gradientLayer.locations = @[@0, @0.8,@1.5];
    // 颜色渐变的起点和终点，范围为 (0~1.0, 0~1.0)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, -20, self.view.bounds.size.width, 20 + self.view.bounds.size.height);
    return gradientLayer;
}

@end
