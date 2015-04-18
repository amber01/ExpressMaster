//
//  SharedExpName.h
//  快递大师
//
//  Created by amber on 15/3/5.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedExpName : NSObject

@property (nonatomic,copy)    NSString  *expressName;
@property (nonatomic,copy)    NSString  *expCode;
@property (nonatomic,retain)  NSArray   *data;
@property (nonatomic,copy)    NSString  *printStr;
@property (nonatomic,copy)    NSString  *expID;
@property (nonatomic,copy)    NSString  *status;
@property (nonatomic,copy)    NSString  *expTime;
@property (nonatomic,copy)    NSString  *expContent;

@property (nonatomic,copy)    NSString  *expTempCode;
@property (nonatomic,copy)    NSString  *expressTempName;


+(SharedExpName *)sharedExpressInfo;

@end
