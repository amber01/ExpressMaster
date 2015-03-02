//
//  BaseNavigationController.m
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self customNavigationView];
}

-(void)customNavigationView
{
    //自定义title
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dictColor = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationBar.titleTextAttributes = dictColor;
    
    //自定义view颜色
    UIImage *image = [UIImage imageNamed:@"NavBarView"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
