//
//  SelectExpressViewController.h
//  快递大师
//
//  Created by amber on 15/3/4.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectExpressViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView      *_tableView;
}

@property (nonatomic,retain)NSArray *data;
@property (nonatomic,retain)NSDictionary *dataDac;
@property (nonatomic,copy)  NSString  *keys;

@end


