//
//  CallViewController.h
//  快递大师
//
//  Created by amber on 15/3/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"

@interface CallViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView      *_tableView;
    UIWebView        *phoneCallWebView;
}

@property (nonatomic,retain)NSArray *data;
@property (nonatomic,retain)NSDictionary *dataDac;
@property (nonatomic,copy)  NSString  *keys;

@end
