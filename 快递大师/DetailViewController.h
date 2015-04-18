//
//  DetailViewController.h
//  快递大师
//
//  Created by amber on 15/3/12.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "DateConvertManager.h"

@interface DetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_tableView;
    UIView          *headView;
    UIView          *linkView;
    DateConvertManager *dateConverManager;
}


@end
