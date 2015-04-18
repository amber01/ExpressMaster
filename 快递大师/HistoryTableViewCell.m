//
//  HistoryTableViewCell.m
//  快递大师
//
//  Created by amber on 15/3/11.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    self.textLabel.frame = CGRectMake(65, 5, 300, 20);
    
    //当前cell中的图片显示为原型
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 20;
    
    //cell中显示的图片大小
    [self.imageView setFrame:CGRectMake(15, 40/2, 40, 40)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.frame = CGRectMake(65, 55, 300, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
