//
//  HistoryViewController.m
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "HistoryViewController.h"
#import "ExpressInfo.h"
#import "FMDatabase.h"
#import "HistoryTableViewCell.h"
#import "ResultsViewController.h"
#import "DetailViewController.h"

#define kArchivingFileKey @"archivingFile"
#define kArchivingDataKey @"ArchivingDataKey"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"快递跟踪";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNaviItem];
    
    [self createdTableView];
    [self setExtraCellLineHidden:_tableView];
    //让cell分割线靠左侧显示
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self readSqliteInfo];
    
    if (view != nil) {
        [view removeFromSuperview];
    }
    
    //判断当前sqlite是否有数据，如果没有数据就显示一个默认视图
    if (self.dataArr.count == 0){
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.tag = 1001;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(ScreenWidth/2 - 40, ScreenHeight /2 - 110, 80, 80);
        UIImage *image = [UIImage imageNamed:@"search_icon"];
        imageView.image = image;
        
        UILabel  *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, ScreenHeight /2 - 20, 200, 40)];
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.text = @"你目前还没有查询的记录";
        [view addSubview:tipsLabel];
        [view addSubview:imageView];
        [self.view addSubview:view];
    }else{
        //UIView *tempView = [self.view viewWithTag:1001];
        [view removeFromSuperview];
    }
}

#pragma mark -- UI
- (void)createdTableView
{
    UIEdgeInsets inset;
    inset.left = 10;
    [_tableView setSeparatorInset:inset];
    _tableView.allowsSelection = NO;  //是否允许选中cell
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)showNaviItem
{
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editAction)];
    editItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:editItem];
}

- (void)showContentText:(HistoryTableViewCell *)cell content:(NSString *)content
{
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.frame = CGRectMake(65, 31, 240, 20);
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    contentLabel.text = content;
    [cell.contentView addSubview:contentLabel];
}

#pragma mark -- data
/**
 *  查询数据库，然后将查询到的结果写到数组里面去
 */
- (void)readSqliteInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"expressInfo.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return;
    }
    
    //不需要像Android中那样关闭Cursor关闭FMResultSet，因为相关的数据库关闭时，FMResultSet也会被自动关闭
    FMResultSet     *resultSet = [database executeQuery:@"select * from expressInfo"];
    if (!self.dataArr) {
        self.dataArr = [[NSMutableArray alloc]init];
    }
    else{
        [self.dataArr removeAllObjects];
    }
    if (!self.dataDic) {
        self.dataDic = [[NSMutableDictionary alloc]init];
    }else{
        [self.dataDic removeAllObjects];
    }
    //self.dataDic = [];
    while ([resultSet next]) {
        [self.dataArr addObject:[resultSet resultDictionary]];
    }
    [database close];
}

#pragma mark -- action
- (void)editAction
{
    [_tableView setEditing:!_tableView.editing animated:YES];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    editItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:editItem];
}

- (void)finishAction
{
    [_tableView setEditing:!_tableView.editing animated:YES];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editAction)];
    editItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:editItem];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    HistoryTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identityCell];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.dataDic = [self.dataArr objectAtIndex:indexPath.row];
    NSString *expName = [self.dataDic objectForKey:@"expName"];
    NSString *expID = [self.dataDic objectForKey:@"expID"];
    NSString *expOrder = [self.dataDic objectForKey:@"expOrder"];
    NSString *expTime = [self.dataDic objectForKey:@"expTime"];
    NSString *expContent = [self.dataDic objectForKey:@"expContent"];
    NSString *expStatus = [self.dataDic objectForKey:@"expStatus"];
    
    //NSLog(@"rowID:%@",expOrder);
    
    NSString *expNameAndOrder = [NSString stringWithFormat:@"%@ %@",expName,expOrder];
    cell.imageView.image = [UIImage imageNamed:expID];
    cell.textLabel.text = expNameAndOrder;
    cell.detailTextLabel.text = expTime;
    
    [self showContentText:cell content:expContent];
    
    if ([expStatus integerValue] == 4) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sucess_image"]];
        imageView.frame = CGRectMake(45, 47, 12, 12);
        [cell.contentView addSubview:imageView];
    }else{
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"delivering_image"]];
        imageView.frame = CGRectMake(45, 47, 12, 12);
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
    NSString *expID = [dic objectForKey:@"expID"];
    NSString *expOrder = [dic objectForKey:@"expOrder"];
    netWorkModel = [[NetworkModel alloc]init];
    [netWorkModel initExpNumber:expOrder expCompany:expID andDelegate:self];
    
    progress = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
    progress.labelText = @"请稍后,快递正在查询中...";
    [self.view.window addSubview:progress];
    [progress setMode:MBProgressHUDModeIndeterminate];   //圆盘的扇形进度显示
    progress.taskInProgress = YES;
    [progress show:YES];   //显示
    //progress.dimBackground = YES;   //是否显示提示的页面背景层遮罩
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//让cell分割线向右对齐
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//删除相关操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary    *tempDic = [self.dataArr objectAtIndex:indexPath.row];
    NSString *expOrder = [tempDic objectForKey:@"expOrder"];
    //NSLog(@"删除的数据是:%@",expOrder);
    //获取Document文件夹下的数据库文件，没有则创建
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"expressInfo.sqlite"];
    
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        NSLog(@"Open database failed");
        return;
    }
    
    //删除
    BOOL result = [database executeUpdate:@"DELETE FROM expressInfo WHERE expOrder = ?",expOrder];
    
    [database close];
    [self.dataArr removeObjectAtIndex:indexPath.row];
    //    [tableView reloadData];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.dataArr.count == 0) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.tag = 1001;
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(ScreenWidth/2 - 40, ScreenHeight /2 - 110, 80, 80);
        UIImage *image = [UIImage imageNamed:@"search_icon"];
        imageView.image = image;
        
        UILabel  *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, ScreenHeight /2 - 20, 200, 40)];
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.text = @"你目前还没有查询的记录";
        [view addSubview:tipsLabel];
        [view addSubview:imageView];
        [self.view addSubview:view];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"手指撮动了");
    return UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//编辑的时候，cell是否可以上下滑动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}

#pragma mark -- ASIHTTPRquestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *responseData = [request responseData];
    NSDictionary  *dataDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    self.data = [dataDic objectForKey:@"data"];
    NSString *stauts = [dataDic objectForKey:@"status"];
    NSString *expID = [dataDic objectForKey:@"order"];
    NSString *expCode = [dataDic objectForKey:@"id"];
    NSString *expName = [dataDic objectForKey:@"name"];
    
    //NSLog(@"stauts:%@",expName);
    
    SharedExpName *shareInfo = [SharedExpName sharedExpressInfo];
    shareInfo = [SharedExpName sharedExpressInfo];
    shareInfo.expTempCode = expCode;
    shareInfo.expID = expID;
    shareInfo.expressTempName = expName;
    
    [progress hide:YES];
    
    if ([stauts integerValue] == 1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该单号暂无记录,请确认单号或快递公司是否正确" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSMutableArray *dateArr = [[NSMutableArray alloc]init];
    NSMutableArray *contentArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.data.count; i ++) {
        NSDictionary *dic = [self.data objectAtIndex:i];
        NSString *str = [dic objectForKey:@"content"];
        NSString *timeStr = [dic objectForKey:@"time"];
        
        [dateArr addObject:timeStr];
        [contentArr addObject:str];
    }
    
    NSString *timeStr = dateArr[0];
    NSString *contentStr = contentArr[0];
    
    shareInfo.expTime = timeStr;
    shareInfo.status = stauts;
    shareInfo.expContent = contentStr;
    
    if (self.data.count >= 1) {
        DetailViewController *resultVC = [[DetailViewController alloc]init];
        shareInfo.data = self.data;
        [self updateSqlite:stauts andExpOrder:expID];

#warning pushViewcontroller新方法
       //[(BaseNavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController] pushViewController:resultVC animated:YES];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:resultVC animated:YES];
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    [progress hide:YES];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络请求超时,请确认网络是否正常" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
}

/**
 *  加载网络时，判断某一个字段有没有更新变化，如expStatus如果变化就执行更新
 *
 *  @param setExpStatus 当前状态，是2还是4
 *  @param setExpOrder  当前的快递号
 */
- (void)updateSqlite:(NSString *)setExpStatus andExpOrder:(NSString *)setExpOrder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"expressInfo.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if (![database open]) {
        return;
    }
    
    //加载网络时，判断某一个字段有没有更新变化，如expStatus如果变化就执行更新，expOrder是一个唯一标示
    BOOL update = [database executeUpdate:@"update expressInfo set expStatus =  ? where expOrder = ?",setExpStatus,setExpOrder];
    
    if(update){
        [_tableView reloadData];
        NSLog(@"有新数据更新");
    }
    
    [database close];

}


#pragma mark -- other

//清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *viewLine = [UIView new];
    viewLine.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:viewLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

@end
