//
//  CallViewController.m
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "CallViewController.h"
#import "TelTableViewCell.h"

@interface CallViewController ()

@end

@implementation CallViewController {
    NSArray *_allKeys;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"快递选择";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readPlistFile];
    [self initTableView];
    
    UIEdgeInsets inset;
    inset.left = 10;
    [_tableView setSeparatorInset:inset];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- data
- (void)readPlistFile
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"expressList" ofType:@"plist"];
    NSArray *data = [[NSArray alloc]initWithContentsOfFile:path];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *array = mDict[[obj objectForKey:@"index"]];
        if (!array) {
            array = [NSMutableArray array];
        }
        [array addObject:obj];
        mDict[[obj objectForKey:@"index"]] = array;
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    [self addHotData:array];
    
    NSArray *keyArray = [mDict allKeys];
    keyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *obj1Str = (NSString *)obj1;
        NSString *obj2Str = (NSString *)obj2;
        return [obj1Str compare:obj2Str options:NSCaseInsensitiveSearch];
    }];
    
    for (NSString *key in keyArray) {
        NSDictionary *dict = @{@"index":key, @"list":[(NSMutableArray *)mDict[key] copy]};
        [array addObject:dict];
    }
    _allKeys = keyArray;
    self.data = [array copy];
}

- (void)addHotData:(NSMutableArray *)array {
    //这里的字典中的array自己填写(快递公司信息)
    NSDictionary *itemDict1 = @{@"code":@"ems",@"name":@"EMS",@"tel":@"11183"};
    NSDictionary *itemDict2 = @{@"code":@"huitong",@"name":@"汇通快递",@"tel":@"400-956-5656"};
    NSDictionary *itemDict3 = @{@"code":@"shentong",@"name":@"申通快递",@"tel":@"95543"};
    NSDictionary *itemDict4 = @{@"code":@"shunfeng",@"name":@"顺丰速运",@"tel":@"400-811-1111"};
    NSDictionary *itemDict5 = @{@"code":@"tiantian",@"name":@"天天快递",@"tel":@"400-188-8888"};
    NSDictionary *itemDict6 = @{@"code":@"yuantong",@"name":@"圆通速递",@"tel":@"021-69777888"};
    NSDictionary *itemDict7 = @{@"code":@"yunda",@"name":@"韵达快递",@"tel":@"400-821-6789"};
    NSDictionary *itemDict8 = @{@"code":@"youzhengguonei",@"name":@"邮政国内小包",@"tel":@"11185"};
    NSDictionary *itemDict9 = @{@"code":@"zhaijisong",@"name":@"宅急送",@"tel":@"400-678-9000"};
    NSDictionary *itemDict10 = @{@"code":@"zhongtong",@"name":@"中通速递",@"tel":@"400-827-0270"};
    
    NSArray *itemArray = @[itemDict1,itemDict2,itemDict3,itemDict4,itemDict5,itemDict6,itemDict7,itemDict8,itemDict9,itemDict10];
    NSDictionary *dict = @{@"index":@"热门", @"list":itemArray};
    [array addObject:dict];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.data objectAtIndex:section];
    
    return [(NSArray *)dict[@"list"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

//显示右侧索引如:ABC
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dataDac = [self.data objectAtIndex:section];
    NSString *keys = [dataDac objectForKey:@"index"];
    return keys;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identityCell = @"cell";
    TelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identityCell];
    if (!cell) {
        cell = [[TelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identityCell];
    }
    
    NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
    NSDictionary *dataDac = [dict[@"list"] objectAtIndex:indexPath.row];
    NSString *expName = [dataDac objectForKey:@"name"];
    NSString *expImage = [dataDac objectForKey:@"code"];
    NSString *expTel = [dataDac objectForKey:@"tel"];
    
    cell.textLabel.text = expName;
    cell.detailTextLabel.text = expTel;
    UIImageView *expView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:expImage]];
    [cell.imageView setImage:expView.image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
    NSDictionary *dataDac = [dict[@"list"] objectAtIndex:indexPath.row];
    NSString *expTel = [dataDac objectForKey:@"tel"];    
    [self dialPhoneNumber:expTel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"#"];
    [array addObjectsFromArray:_allKeys];
    return [array copy];
}

#pragma mark -- other
//拨打电话
- (void)dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark -- MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
