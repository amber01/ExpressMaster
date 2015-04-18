//
//  ExpressInfo.h
//  快递大师
//
//  Created by amber on 15/3/9.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressInfo : NSObject<NSCopying>

@property (nonatomic,copy) NSString  *expName;
@property (nonatomic,copy) NSString  *expID;
@property (nonatomic,copy) NSString  *expOrder;
@property (nonatomic,copy) NSString  *expTime;
@property (nonatomic,copy) NSString  *expContent;
@property (nonatomic,assign) int       expStatus;

@end
