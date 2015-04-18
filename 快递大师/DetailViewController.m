//
//  DetailViewController.m
//  快递大师
//
//  Created by amber on 15/3/12.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "DetailViewController.h"
#import "ResultsViewController.h"
#import "FMDatabase.h"
#import "DetailTableViewCell.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"查询结果";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createdTableView];
    dateConverManager = [[DateConvertManager alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)createdTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 110)];
    headView.backgroundColor = [UIColor colorWithRed:12/255.0 green:206/255.0 blue:206/255.0 alpha:1];
        
    _tableView.tableHeaderView = headView;
    _tableView.allowsSelection = NO;
    _tableView.delaysContentTouches = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //分割线隐藏
    //
    UIImageView *expImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 25, 60, 60)];
    SharedExpName *shareInfo = [SharedExpName sharedExpressInfo];
    expImageView.image = [UIImage imageNamed:shareInfo.expTempCode];
    expImageView.layer.masksToBounds = YES;
    expImageView.layer.cornerRadius = 30;
    
    //
    UILabel *expNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 25, 210, 30)];
    expNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    expNameLabel.textColor = [UIColor whiteColor];
    expNameLabel.text = shareInfo.expressTempName;
    
    UILabel *expCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 57, 210, 30)];
    expCodeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];  //加粗
    expCodeLabel.textColor = [UIColor whiteColor];
    expCodeLabel.text = shareInfo.expID;
    
    [headView addSubview:expNameLabel];
    [headView addSubview:expCodeLabel];
    [headView addSubview:expImageView];
    [self.view addSubview:_tableView];
}


#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SharedExpName *shareInfo = [SharedExpName sharedExpressInfo];
    return shareInfo.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    DetailTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identityCell];
    if (!cell) {
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identityCell];
    }
    
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    }
    
    SharedExpName *shareInfo = [SharedExpName sharedExpressInfo];
    NSDictionary *dic = [shareInfo.data objectAtIndex:indexPath.row];
    NSString *str = [dic objectForKey:@"content"];
    NSString *time = [dic objectForKey:@"time"];
    //NSString *dateStr = [time substringWithRange:NSMakeRange(0,10)];
    NSString *timeStr = [time substringWithRange:NSMakeRange(11,5)];

    NSDate   *date = [dateConverManager convertDateFromString:time];
    //NSLog(@"转换后的时间:%@",date);
    NSString *dateConvert = [dateConverManager compareDate:date];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 7, 50, 30)];
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    dateLabel.text = dateConvert;
    [cell.contentView addSubview:dateLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 27, 60, 30)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    timeLabel.text = timeStr;
    [cell.contentView addSubview:timeLabel];
    
    if (indexPath.row == shareInfo.data.count-1) {
        linkView = [[UIView alloc]initWithFrame:CGRectMake(69, 0, 1, 65/2)];
        linkView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [cell.contentView addSubview:linkView];
        
        
        
    }else if (indexPath.row < shareInfo.data.count){
        linkView = [[UIView alloc]initWithFrame:CGRectMake(69, 0, 1, 65)];
        linkView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [cell.contentView addSubview:linkView];
    }
    
    if ([shareInfo.status integerValue] == 4 && indexPath.row == 0) {
        UIImageView *stautView = [[UIImageView alloc]initWithFrame:CGRectMake(59.5, 23.5, 20, 20)];
        stautView.image = [UIImage imageNamed:@"sucess_image"];
        [cell.contentView addSubview:stautView];
        timeLabel.textColor = [UIColor colorWithRed:19/255.0 green:173/255.0 blue:26/255.0 alpha:1];
        dateLabel.textColor = [UIColor colorWithRed:19/255.0 green:173/255.0 blue:26/255.0 alpha:1];
        cell.textLabel.textColor = [UIColor colorWithRed:19/255.0 green:173/255.0 blue:26/255.0 alpha:1];
    }else if ([shareInfo.status integerValue] == 2 | [shareInfo.status integerValue] == 3 && indexPath.row == 0){
        UIImageView *stautView = [[UIImageView alloc]initWithFrame:CGRectMake(59.5, 23.5, 20, 20)];
        stautView.image = [UIImage imageNamed:@"delivering_image"];
        [cell.contentView addSubview:stautView];
        timeLabel.textColor = [UIColor orangeColor];
        dateLabel.textColor = [UIColor orangeColor];
        cell.textLabel.textColor = [UIColor orangeColor];
    }else{
        UIImageView *stautView = [[UIImageView alloc]initWithFrame:CGRectMake(59.5, 23.5, 20, 20)];
        stautView.image = [UIImage imageNamed:@"deliver_image"];
        cell.textLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        [cell.contentView addSubview:stautView];
    }
    
    cell.textLabel.text = str;
    
    return cell;
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
        
        NSLog(@"expName:%@,expID:%@,expOrder:%@,expTime:%@,expContent:%@,expStatus:%@",expName,expID,expOrder,expTime,expContent,expStatus);
        
    }
    
    [database close];
    //这里也不需要release
    //    [database release];
}


//让指定的方法5s后执行
-(void)chargeSqliteTime:(MyBlock)block
{
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(),^(void){
        //[self createdSqlite]; //要执行的方法
        block ();
    });
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark -- other
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end