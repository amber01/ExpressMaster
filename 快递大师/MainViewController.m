//
//  ViewController.m
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark -- UITabBarView
- (void)initTableView
{
    searchVC = [[SearchViewController alloc]init];
    callVC = [[CallViewController alloc]init];
    historyVC = [[HistoryViewController alloc]init];
    
    //自定义item按钮
    UITabBarItem *searchItem =[[UITabBarItem alloc]initWithTitle:@"快递查询" image:nil tag:1];
    [searchItem setFinishedSelectedImage:[UIImage imageNamed:@"search_tabView_selected"]withFinishedUnselectedImage:[UIImage imageNamed:@"search_tabView"]];
    //searchItem.image = [UIImage imageNamed:@"search_tabView"];
    //searchItem.selectedImage = [UIImage imageNamed:@"kd_search_tab_selected"];
    BaseNavigationController *searchNav = [[BaseNavigationController alloc]initWithRootViewController:searchVC];
    //self.tabBar.tintColor = [UIColor redColor];  //改变tabBar上的按钮文字颜色
    searchVC.tabBarItem = searchItem;

    UITabBarItem *callItem =[[UITabBarItem alloc]initWithTitle:@"叫快递" image:[UIImage imageNamed:@"cell_tabView"] tag:2];
    BaseNavigationController *callNav = [[BaseNavigationController alloc]initWithRootViewController:callVC];
    callVC.tabBarItem = callItem;
    
    UITabBarItem *historyItem =[[UITabBarItem alloc]initWithTitle:@"快递跟踪" image:nil tag:3
                            ];
    [historyItem setFinishedSelectedImage:[UIImage imageNamed:@"history_tabView_selected"]withFinishedUnselectedImage:[UIImage imageNamed:@"history_tabView"]];
    BaseNavigationController *historyNav = [[BaseNavigationController alloc]initWithRootViewController:historyVC];
    historyVC.tabBarItem = historyItem;
    
    NSArray *array = @[searchNav,callNav,historyNav];
    [self setViewControllers:array animated:YES];
}



#pragma mark -- UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //NSLog(@"item:%d",item.tag);
    switch (item.tag) {
        case 1:
            self.selectedIndex = 0;
            break;
        case 2:
            self.selectedIndex = 1;
            break;
        case 3:
            self.selectedIndex = 2;
            break;
        default:
            break;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

#pragma mark MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
