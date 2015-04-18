//
//  NetworkModel.h
//  快递大师
//
//  Created by amber on 15/3/6.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface NetworkModel : NSObject<ASIHTTPRequestDelegate>
{
    ASIHTTPRequest    *_request;
}

@property (nonatomic,retain)NSString *data;

- (void)initExpNumber:(NSString *)number expCompany:(NSString *)companyID andDelegate:(id)delegate;


@end
