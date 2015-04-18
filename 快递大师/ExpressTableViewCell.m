//
//  ExpressTableViewCell.m
//  快递大师
//
//  Created by amber on 15/3/4.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "ExpressTableViewCell.h"

@implementation ExpressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
    
    //当前cell中的图片显示为原型
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 20;
    
    //cell中显示的图片大小
    [self.imageView setFrame:CGRectMake(15, 5, 40, 40)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.detailTextLabel.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
