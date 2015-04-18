//
//  ResultTableViewCell.m
//  快递大师
//
//  Created by amber on 15/3/7.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "ResultTableViewCell.h"

@implementation ResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    //self.textLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    self.textLabel.frame = CGRectMake(90, 5, ScreenWidth - 100, 60);
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;  //自动换行
    self.textLabel.numberOfLines = 0;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
