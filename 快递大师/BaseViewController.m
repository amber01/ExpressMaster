//
//  BaseViewController.m
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //if (self.navigationController.viewControllers.count >=2) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //}
}

- (void)preSetNavForSlide
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNaviBack];
}

- (void)customNaviBack
{
    //自定义返回按钮
    //判断当前的控制器是否是根控制器，如果是根控制器就不需要显示返回按钮.这个数组里面放的都是控制器
    NSArray *viewController = self.navigationController.viewControllers;
    if (viewController.count > 1 && self.isBackButton) {  //大于1，不处于根控制器的情况下
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义返回按钮
        button.frame = CGRectMake(0, 0, 30, 40);
        [button setImage:[UIImage imageNamed:@"back_btn_image"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        /**
         *让返回按钮靠左对齐
         *width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backItem,nil];
        //self.navigationItem.leftBarButtonItem = backItem;
    }
}

#pragma mark -- action
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate 在根视图时不响应interactivePopGestureRecognizer手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
        return NO;
    else
        return YES;
}

#pragma mark - navigationDelegate 实现此代理方法也是为防止滑动返回时界面卡死
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark other
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

@end
