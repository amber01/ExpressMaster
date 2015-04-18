//
//  ViewController.h
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
#import "CallViewController.h"
#import "HistoryViewController.h"

@interface MainViewController : UITabBarController<UINavigationControllerDelegate>
{
    SearchViewController   *searchVC;
    CallViewController     *callVC;
    HistoryViewController  *historyVC;
}

@end

