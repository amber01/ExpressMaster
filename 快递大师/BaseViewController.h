//
//  BaseViewController.h
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate,
UINavigationControllerDelegate>

@property (nonatomic,assign)BOOL isBackButton;

@end
