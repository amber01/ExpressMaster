//
//  SearchViewController.m
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectExpressViewController.h"
#import "NetworkModel.h"
#import "ResultsViewController.h"
#import "FMDatabase.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"快递查询";
        
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
            
            /*
            //取本地UserDefaults的值
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            firstScore = [userDefaults integerForKey:@"firstScore"];
             */
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self inputNumTextFieldView];
    [self selectExpressView];
    //[self showNaviItem];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    shareInfo = [SharedExpName sharedExpressInfo];
    self.expName = shareInfo.expressName;
    
    if (self.expName.length == 0) {
        label.text = @"选择对应快递公司";
    }else{
        label.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        label.text = self.expName;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reloadText) userInfo:nil repeats:YES];
}

#pragma mark -- UI
- (void)inputNumTextFieldView
{
    numTextField = [[UITextField alloc]initWithFrame:CGRectMake(15,50, ScreenWidth - 30, 40)];
    [numTextField setBorderStyle:UITextBorderStyleRoundedRect]; //外框类型
    numTextField.placeholder = @"输入快递单号查询"; //默认显示的字
    numTextField.secureTextEntry = NO; //是否以密码形式显示
    numTextField.keyboardType = UIKeyboardTypeNumberPad; //键盘显示类型
    //numTextField.clearsOnBeginEditing = NO;
    numTextField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
    
    numTextField.delegate = self;
    //自定义边框颜色
    numTextField.layer.borderWidth = 1.2f;
    numTextField.layer.borderColor = [[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]CGColor];
    numTextField.layer.cornerRadius = 5;
    numTextField.clipsToBounds = YES;
    //placeholder字体大小
    //[numTextField setValue:[UIFont fontWithName:@"Arial" size:17]forKeyPath:@"_placeholderLabel.font"];
    
    //左侧条码图片
    UIImageView *barcodeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Barcode_image"]];
    barcodeImage.frame = CGRectMake(13, 12, 47/2, 37/2);
    
    UIView *barcodeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    barcodeView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    numTextField.leftView = barcodeView; //添加一个视图在左侧
    numTextField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:numTextField];
    [self addToolBarlOnKeyboard];
    [barcodeView addSubview:barcodeImage];
    //右侧相机按钮
    camereView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIButton *camereBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    camereBtn.frame = CGRectMake(25, 11, 52/2, 37/2);
    [camereBtn setImage:[UIImage imageNamed:@"Camera_image"] forState:UIControlStateNormal];
    [camereBtn addTarget:self action:@selector(readBarcodeAction) forControlEvents:UIControlEventTouchUpInside];
    [camereView addSubview:camereBtn];
    numTextField.rightViewMode =UITextFieldViewModeAlways;
    numTextField.rightView = camereView;
    
    //右侧清除文字按钮
    clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(0, 13, 15, 15);
    [clearBtn setImage:[UIImage imageNamed:@"clear_btn"] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    
    //查询按钮
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(15,210, ScreenWidth - 30, 40);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"NavBarView"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    
    //[searchBtn setTitle:searcTitle forState:UIControlStateNormal];
    btnLabel.text = searcTitle;
    btnLabel.textColor = [UIColor whiteColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 3;
    [searchBtn addSubview:btnLabel];
    [self.view addSubview:searchBtn];
}

- (void)showNaviItem
{
    UIBarButtonItem *taskItem = [[UIBarButtonItem alloc]initWithTitle:@"任务" style:UIBarButtonItemStyleDone target:self action:@selector(taskAction)];
    //改变字体大小
    [taskItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],UITextAttributeFont,nil] forState:UIControlStateNormal];
    taskItem.tintColor = [UIColor whiteColor];
    NSArray *liftItems = @[taskItem];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义按钮
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"tips_info_btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myInfoItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = myInfoItem;
    
    UIBarButtonItem *likeItem = [[UIBarButtonItem alloc]initWithTitle:@"帮助" style:UIBarButtonItemStyleDone target:self action:@selector(helpAction)];
    likeItem.tintColor = [UIColor whiteColor];
    [likeItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    NSArray *rightItems = @[likeItem,myInfoItem];
    [self.navigationItem setRightBarButtonItems:rightItems];
    [self.navigationItem setLeftBarButtonItems:liftItems];
}

- (void)customaAlertView
{
    view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.45];
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIView *loginView = [[UIView alloc]init];
    loginView.frame = CGRectMake(48/2, ScreenHeight/2-100-20, 540/2+15, 415/2+20);
    UIImageView *loginImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 540/2, 415/2)];
    loginImageView.image = [UIImage imageNamed:@"customa_alert_image"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(540/2-25, 7, 75/2, 75/2);
    [closeBtn setImage:[UIImage imageNamed:@"firstLogin_close_btn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginImageView];
    [loginView addSubview:closeBtn];
    
    
    UILabel *allScore = [[UILabel alloc]initWithFrame:CGRectMake(60/2, 80, 120, 25)];
    UILabel *currentScore = [[UILabel alloc]initWithFrame:CGRectMake(60/2, 110, 120, 25)];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(60/2, 140, 210, 60)];
    tipsLabel.lineBreakMode = UILineBreakModeWordWrap;  //自动换行
    tipsLabel.numberOfLines = 0;

    allScore.textColor = [UIColor grayColor];
    currentScore.textColor = [UIColor grayColor];
    tipsLabel.textColor = [UIColor redColor];
    allScore.font = [UIFont systemFontOfSize:15];
    currentScore.font = [UIFont systemFontOfSize:15];
    tipsLabel.font = [UIFont systemFontOfSize:15];
    allScore.text = @"当前积分:";
    currentScore.text = @"可查询次数:";
    tipsLabel.text = @"tips:做任务可以获得更多的查询积分哦，赶快去做任务吧~";
    
    allScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(97, 80, 120, 25)];
    currentScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(112, 110, 120, 25)];
    allScoreLabel.textColor = [UIColor colorWithRed:246/255.0 green:50/255.0 blue:211/255.0 alpha:1];
    currentScoreLabel.textColor = [UIColor colorWithRed:246/255.0 green:50/255.0 blue:211/255.0 alpha:1];
    allScoreLabel.font = [UIFont systemFontOfSize:15];
    currentScoreLabel.font = [UIFont systemFontOfSize:15];
    
    *points += firstScore;
    currentSearch = *points * 0.1;  //查询次数


    allScoreLabel.text = [NSString stringWithFormat:@"%d", *points];
    currentScoreLabel.text = [NSString stringWithFormat:@"%d",currentSearch];
    //free(points);  //释放
    
    [loginView addSubview:allScore];
    [loginView addSubview:currentScore];
    [loginView addSubview:tipsLabel];
    [loginView addSubview:allScoreLabel];
    [loginView addSubview:currentScoreLabel];
    [view addSubview:loginView];
    [self.view.window addSubview:view];
}

//自定义alertView
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540/2+20, 423/2+20)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 540/2, 423/2)];
    [imageView setImage:[UIImage imageNamed:@"customa_alert_image"]];
    [demoView addSubview:imageView];
    return demoView;
}


- (void)selectExpressView
{
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(14, 120, ScreenWidth - 28, 40);
    //[selectBtn setImage:[UIImage imageNamed:@"select_express"] forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"select_express"]forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"select_express"]forState:UIControlStateHighlighted];
    [selectBtn addTarget:self action:@selector(selectExpAction) forControlEvents:UIControlEventTouchUpInside];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(58, 5, 180, 30)];
    label.textColor = [UIColor grayColor];
    [selectBtn addSubview:label];
    [self.view addSubview:selectBtn];
    
    /*
     UIView *view  = [[[NSBundle mainBundle]loadNibNamed:@"SelectExpView" owner:self options:nil]lastObject];
     view.frame = CGRectMake(0, 200, 211, 40);
     [self.view addSubview:view];
     */
}

#pragma mark -- data


- (void) addToolBarlOnKeyboard {
    
    //分隔栏视图
    NSArray *segmentedAarray = @[@"数字",@"字母"];
    UISegmentedControl *segmentedView = [[UISegmentedControl alloc]initWithItems:segmentedAarray];
    segmentedView.selectedSegmentIndex = 0;
    segmentedView.frame = CGRectMake(20, 7, 140, 30);
    [segmentedView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged]; //点击事件
    
    //在键盘上添加toolbar工具条  点击工具条中的按钮回收键盘
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar addSubview:segmentedView];
    [toolBar setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"style:UIBarButtonItemStyleDone  target:self action:@selector(doneButtonIsClicked)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    //关键的代码，不写的话不会在键盘上面显示工具条
    [numTextField setInputAccessoryView:toolBar];
    [toolBar setItems:buttonsArray];
}

#pragma mark -- action
//点击完成时调用
- (void)doneButtonIsClicked {
    numTextField.layer.borderWidth = 1.2f;
    numTextField.layer.borderColor = [[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]CGColor];
    numTextField.layer.cornerRadius = 5;
    numTextField.clipsToBounds = YES;
    [numTextField resignFirstResponder];
}

- (void)readBarcodeAction
{
    numTextField.layer.borderWidth = 1.2f;
    numTextField.layer.borderColor = [[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]CGColor];
    numTextField.layer.cornerRadius = 5;
    numTextField.clipsToBounds = YES;
    
    //调用相机
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate =  self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    //+
    [self setOverlayPickerView:reader];
    //+
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [self.navigationController presentViewController:reader animated:YES completion:^{
        
    }];
}

- (void)selectExpAction
{
    SelectExpressViewController *selectExpVC = [[SelectExpressViewController alloc]init];
    BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:selectExpVC];
    [self.navigationController presentViewController:baseNav animated:YES completion:^{
    }];
}

- (void)clearAction
{
    numTextField.text = @"";
}

- (void)reloadText
{
    if (numTextField.text.length > 0) {
        [camereView addSubview:clearBtn];
    }else{
        [clearBtn removeFromSuperview];
    }
}

- (void)searchAction
{
    shareInfo = [SharedExpName sharedExpressInfo];
    if (numTextField.text.length < 4) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的快递单号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alerView show];
    }else if (numTextField.text.length >= 4 && shareInfo.expCode.length == 0){
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择对应的快递公司" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alerView show];
    }else{
        progress = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
        progress.labelText = @"请稍后,快递正在查询中...";
        [self.view.window addSubview:progress];
        [progress setMode:MBProgressHUDModeIndeterminate];   //圆盘的扇形进度显示
        progress.taskInProgress = YES;
        [progress show:YES];   //显示
        //progress.dimBackground = YES;   //是否显示提示的页面背景层遮罩
        NetworkModel *network = [[NetworkModel alloc]init];
        [network initExpNumber:numTextField.text expCompany:shareInfo.expCode andDelegate:self];
    }
}

- (void)taskAction
{
    /*
    [YouMiWall showOffers:YES didShowBlock:^{
        //NSLog(@"有米积分墙已显示");
    } didDismissBlock:^{
        [self initScore];
    }];
    */
    
    
    
    //NSLog(@"做任务");
}

- (void)helpAction
{
    UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"帮助提醒" message:@"\n1. 10积分可查询1次，积分越多查询次数就越多哦 \t\t\t\t\t\t\n2. 做任务可获得更多查询积分哦, 赶快去做任务吧 \t\t\t\t\t\t" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"做任务", nil];
    alertView.tag = 200;
    [alertView show];
}

- (void)infoAction
{
    NSLog(@"个人信息");
    [self customaAlertView];
}

- (void)closeAction
{
    [view removeFromSuperview];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    numTextField.layer.borderWidth = 1.2f;
    numTextField.layer.borderColor = [[UIColor colorWithRed:0/255.0 green:168/255.0 blue:225/255.0 alpha:1]CGColor];
    numTextField.layer.cornerRadius = 5;
    numTextField.clipsToBounds = YES;
}


//placeholder字体大小
#pragma mark SegmentedControl actionct
-(void)segmentAction:(UISegmentedControl *)segmented{
    NSInteger index = segmented.selectedSegmentIndex;
    //NSLog(@"index %d", index);
    switch (index) {
        case 0:
            numTextField.keyboardType = UIKeyboardTypeNumberPad; //键盘显示类型
            [numTextField reloadInputViews];
            break;
        case 1:
            numTextField.keyboardType = UIKeyboardTypeAlphabet; //键盘显示类型
            [numTextField setAutocorrectionType:UITextAutocorrectionTypeNo]; //关闭字母联想
            [numTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];//关闭首字母大写
            [numTextField reloadInputViews];
            break;
        default:
            break;
    }
}

#pragma mark -- 扫码
- (void)setOverlayPickerView:(ZBarReaderViewController *)reader
{
    //清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    line.backgroundColor = [UIColor redColor];
    [reader.view addSubview:line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    upView.alpha = 0.6;
    upView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将取景框对准二维码/条码图片，离手机摄像头10CM左右，系统会自动识别";
    [upView addSubview:labIntroudction];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    leftView.alpha = 0.6;
    leftView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    rightView.alpha = 0.6;
    rightView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 120)];
    downView.alpha = 0.6;
    downView.backgroundColor = [UIColor blackColor];
    [reader.view addSubview:downView];
    
    //用于取消操作的button
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.alpha = 0.4;
    [cancelButton setFrame:CGRectMake(20, 390, 280, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
}

- (void) imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results)
        break;
    numTextField.text = symbol.data;
    resultImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


//取消button方法
- (void)dismissOverlayView:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -- ASIHTTPRquestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *responseData = [request responseData];
    NSDictionary  *dataDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    self.data = [dataDic objectForKey:@"data"];
    NSString *stauts = [dataDic objectForKey:@"status"];
    NSString *expID = [dataDic objectForKey:@"order"];
    shareInfo = [SharedExpName sharedExpressInfo];
    shareInfo.expID = expID;
    [progress hide:YES];
    
    //NSLog(@"stauts:%@",stauts);
    
    //int tempStauts = [stauts intValue];
    if ([stauts integerValue] == 1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该单号暂无记录,请确认单号或快递公司是否正确" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else if ([stauts integerValue] == -1){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"待查询,在批量查询中才会出现的状态" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    
    NSMutableArray *dateArr = [[NSMutableArray alloc]init];
    NSMutableArray *contentArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.data.count; i ++) {
        NSDictionary *dic = [self.data objectAtIndex:i];
        NSString *str = [dic objectForKey:@"content"];
        NSString *timeStr = [dic objectForKey:@"time"];
        
        //将字符串转为数组
        //NSArray *expInfo = [str componentsSeparatedByString:NSLocalizedString(@"\n", nil)];
        //NSArray *expTime = [timeStr componentsSeparatedByString:@"\n"];
        [dateArr addObject:timeStr];
        [contentArr addObject:str];
    }
    
    NSString *timeStr = dateArr[0];
    NSString *contentStr = contentArr[0];
    
    //NSLog(@"content:%@",contentStr);
    
    shareInfo.expTime = timeStr;
    shareInfo.status = stauts;
    shareInfo.expContent = contentStr;
    
    /*
    points = [YouMiPointsManager  pointsRemained];
    *points += firstScore;
    currentSearch = *points * 0.1;  //查询次数
     */
    
    //if (currentSearch > 0) {
        if (self.data.count >= 1) {
            ResultsViewController *resultVC = [[ResultsViewController alloc]init];
            shareInfo.data = self.data;
            [self createdSqlite];
            [self setHidesBottomBarWhenPushed:YES];
            [self doneButtonIsClicked];
            
            /*
            if (firstScore != 0) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setInteger:*points - 10 forKey:@"firstScore"];
                //取本地UserDefaults的值
                firstScore = [userDefaults integerForKey:@"firstScore"];
                points = [YouMiPointsManager  pointsRemained];
                *points += firstScore;
                currentSearch = *points * 0.1;  //查询次数
            }
             */
            
            /*
            //查询按钮
            searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            searchBtn.frame = CGRectMake(15,210, ScreenWidth - 30, 40);
            [searchBtn setBackgroundImage:[UIImage imageNamed:@"NavBarView"] forState:UIControlStateNormal];
            NSString *tempTitle = [NSString stringWithFormat:@"查询(%d)",currentSearch];
            btnLabel.text = tempTitle;
            btnLabel.textColor = [UIColor whiteColor];
            btnLabel.textAlignment = NSTextAlignmentCenter;
            [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
            searchBtn.layer.masksToBounds = YES;
            searchBtn.layer.cornerRadius = 3;
            [searchBtn addSubview:btnLabel];
            [self.view addSubview:searchBtn];
            [YouMiPointsManager spendPoints:10];
            */
            
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    /*
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"你当前的积分少于100,无法再继续查询,赶快去做任务获取更多积分吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"做任务", nil];
        alertView.tag = 201;
        [alertView show];
    }
     */
}

- (void)createdSqlite
{
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"expressInfo.sqlite"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    //创建表（FMDB中只有update和query操作，出了查询其他都是update操作）
    [database executeUpdate:@"create table expressInfo (expName text,expID text,expOrder text PRIMARY KEY,expTime text,expContent text,expStatus text)"];
    
    //插入数据
    //将insert改为replace，然后在要比较的字段里面加一个REIMARY KEY 就可以了，如：expOrder text PRIMARY KEY，就可以可以判断是否重复插入了
    BOOL insert = [database executeUpdate:@"replace into expressInfo values (?,?,?,?,?,?)",shareInfo.expressName,shareInfo.expCode,shareInfo.expID,shareInfo.expTime,shareInfo.expContent,shareInfo.status];
    
    if (insert) {
        NSLog(@"插入成功");
    }
    [database close];
}

//点击按钮后执行查询操作
- (void)queryButtonTapped {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"expressInfo.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return;
    }
    
    //不需要像Android中那样关闭Cursor关闭FMResultSet，因为相关的数据库关闭时，FMResultSet也会被自动关闭
    FMResultSet *resultSet = [database executeQuery:@"select * from expressInfo"];
    while ([resultSet next]) {
        NSString *expName = [resultSet stringForColumn:@"expName"];
        NSString *expID = [resultSet stringForColumn:@"expID"];
        NSString *expOrder = [resultSet stringForColumn:@"expOrder"];
        NSString *expTime = [resultSet stringForColumn:@"expTime"];
        NSString *expContent = [resultSet stringForColumn:@"expContent"];
        NSString *expStatus = [resultSet stringForColumn:@"expStatus"];
        
        //NSLog(@"expName:%@,expID:%@,expOrder:%@,expTime:%@,expContent:%@,expStatus:%@",expName,expID,expOrder,expTime,expContent,expStatus);
        
    }
    
    [database close];
    //这里也不需要release
    //    [database release];
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    [progress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络请求超时,请确认网络是否正常" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark -- 有米广告
/*
- (void)youMiShowView
{
    // 320x50
    YouMiView *adView320x50=[[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:self];
    adView320x50.frame = CGRectMake(0, ScreenHeight - 163, CGRectGetWidth(adView320x50.bounds), CGRectGetHeight(adView320x50.bounds));
    adView320x50.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [adView320x50 start];
    [self.view addSubview:adView320x50];
}
*/

#pragma mark -- UIAlertViewDelegate
- (void)willPresentAlertView:(UIAlertView *)alertView{
    if (alertView.tag == 200) {
        for (UIView *tempView in alertView.subviews) {
            
            if ([tempView isKindOfClass:[UILabel class]]) {
                // 当该控件为一个 UILabel 时
                UILabel *tempLabel = (UILabel *) tempView;
                
                if ([tempLabel.text isEqualToString:alertView.message]) {
                    // 调整对齐方式
                    tempLabel.textAlignment = UITextAlignmentLeft;
                    // 调整字体大小
                    [tempLabel setFont:[UIFont systemFontOfSize:15.0]];
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200 || alertView.tag == 201) {
        if (buttonIndex == 1) {
        }
    }
}


#pragma mark -- other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScore{
    *points += firstScore;
    currentSearch = *points * 0.1;  //查询次数
    
    //查询按钮
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(15,210, ScreenWidth - 30, 40);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"NavBarView"] forState:UIControlStateNormal];
    NSString *tempTitle = [NSString stringWithFormat:@"查询(%d)",currentSearch];
    btnLabel.text = tempTitle;
    btnLabel.textColor = [UIColor whiteColor];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 3;
    [searchBtn addSubview:btnLabel];
    [self.view addSubview:searchBtn];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [timer invalidate];
}

@end
