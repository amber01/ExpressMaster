//
//  NetworkModel.m
//  快递大师
//
//  Created by amber on 15/3/6.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "NetworkModel.h"

@implementation NetworkModel

- (void)initExpNumber:(NSString *)number expCompany:(NSString *)companyID andDelegate:(id)delegate
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.kuaidiapi.cn/rest/?uid=%@&key=%@&ord=desc&order=%@&id=%@",UID,KEY,number,companyID];
    NSURL *url = [NSURL URLWithString:urlStr];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.delegate = delegate;
    [_request setTimeOutSeconds:20];
    [_request setRequestMethod:@"GET"];
    [_request startAsynchronous];
}

@end
