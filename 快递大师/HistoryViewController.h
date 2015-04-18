//
//  HistoryViewController.h
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkModel.h"
#import "MBProgressHUD.h"

@interface HistoryViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,
UINavigationControllerDelegate>
{
    UITableView     *_tableView;
    NSMutableData   *data;
    UIView          *view;
    NetworkModel    *netWorkModel;
    MBProgressHUD   *progress;
}

@property (nonatomic,copy) NSString                 *archivingFilePath;
@property (nonatomic,retain) NSMutableDictionary    *dataDic;
@property (nonatomic,retain) NSMutableArray         *dataArr;
@property (nonatomic,retain)NSArray                 *data;

@end
