//
//  ResultsViewController.h
//  快递大师
//
//  Created by amber on 15/3/6.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "DateConvertManager.h"
typedef void (^MyBlock) (void);

@interface ResultsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_tableView;
    UIView          *headView;
    UIView          *linkView;
    DateConvertManager *dateConverManager;
}

@property(nonatomic,copy) MyBlock myBlock;


@end