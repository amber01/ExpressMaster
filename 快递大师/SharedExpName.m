//
//  SharedExpName.m
//  快递大师
//
//  Created by amber on 15/3/5.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "SharedExpName.h"

@implementation SharedExpName

+(SharedExpName *)sharedExpressInfo
{
    static SharedExpName *shareExpName = nil;
    static dispatch_once_t predicate;
    if (!shareExpName) {
        dispatch_once(&predicate, ^{
            shareExpName = [[SharedExpName alloc]init];
        });
    }
    return shareExpName;
}

@end
