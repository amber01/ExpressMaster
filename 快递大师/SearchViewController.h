//
//  SearchViewController.h
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "ZBarSDK.h"
#import "SharedExpName.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"

@interface SearchViewController : BaseViewController <UITextFieldDelegate,ZBarReaderDelegate,CustomIOS7AlertViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UITextField           * numTextField;
    UIButton              * clearBtn;
    UIView                * camereView;
    NSTimer               * timer;
    UILabel               * label;

    UIImageView           * resultImage;
    UITextView            * resultText;
    SharedExpName         * shareInfo;

    MBProgressHUD         * progress;

    UILabel               * allScoreLabel;
    UILabel               * currentScoreLabel;

    UIView                * view;

    int                   *points;          //当前总的积分
    int                   currentSearch;    //查询次数
    NSString              * searcTitle;
    UILabel               * btnLabel;
    UIButton              * searchBtn;

    NSInteger firstScore; //新手大礼包2000积分
    NSTimer               * scoreTime;
}

@property (nonatomic,copy)NSString    *expName;
@property (nonatomic,retain)NSArray   *data;

@end
