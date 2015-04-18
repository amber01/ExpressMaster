//
//  ExpressInfo.m
//  快递大师
//
//  Created by amber on 15/3/9.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "ExpressInfo.h"

#define NAME  @"name"
#define ID  @"id"
#define ORDER  @"order"
#define TIME  @"time"
#define CONTENT  @"content"
#define STATUS  @"status"

@implementation ExpressInfo

//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_expName forKey:NAME];
    [aCoder encodeObject:_expID forKey:ID];
    [aCoder encodeObject:_expOrder forKey:ORDER];
    [aCoder encodeObject:_expTime forKey:TIME];
    [aCoder encodeObject:_expContent forKey:CONTENT];
    [aCoder encodeInt:_expStatus forKey:STATUS];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != Nil) {
        self.expName = [aDecoder decodeObjectForKey:NAME];
        self.expID = [aDecoder decodeObjectForKey:ID];
        self.expOrder = [aDecoder decodeObjectForKey:ORDER];
        self.expTime = [aDecoder decodeObjectForKey:TIME];
        self.expContent = [aDecoder decodeObjectForKey:CONTENT];
        self.expStatus = [aDecoder decodeIntForKey:STATUS];
        
    }
    return self;
}

- (NSString *)description
{
    NSString *str = [NSString stringWithFormat:@"name = %@ , id = %@ , order = %@, time = %@, content = %@, status = %i",_expName,_expID,_expOrder,_expTime,_expContent,_expStatus];
    return str;
}

- (id)copyWithZone:(NSZone *)zone
{
    ExpressInfo *copy = [[ExpressInfo alloc]init];
    copy.expName = [self.expName copyWithZone:zone];
    copy.expID = [self.expID copyWithZone:zone];
    copy.expOrder = [self.expOrder copyWithZone:zone];
    copy.expTime = [self.expTime copyWithZone:zone];
    copy.expContent = [self.expContent copyWithZone:zone];
    copy.expStatus = self.expStatus;

    return self;
}


@end
