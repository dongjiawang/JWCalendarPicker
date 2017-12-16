//
//  CalendarDayCell.m
//  CalendarPicker
//
//  Created by 董佳旺 on 2017/12/5.
//  Copyright © 2017年 董佳旺. All rights reserved.
//

#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (UILabel *)textLabel {
    if (!_textLabel) {
        CGFloat labelH = self.bounds.size.height - 10;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - labelH) / 2, 0, labelH, labelH)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_textLabel];
        _textLabel.clipsToBounds = YES;
        _textLabel.layer.cornerRadius = _textLabel.frame.size.height / 2;
    }
    return _textLabel;
}

- (UIView *)signTypeColor {
    if (!_signTypeColor) {
        _signTypeColor = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 5) / 2, self.textLabel.frame.size.height + 2, 5, 5)];
        [self addSubview:_signTypeColor];
        _signTypeColor.clipsToBounds = YES;
        _signTypeColor.layer.cornerRadius = _signTypeColor.frame.size.height / 2;
    }
    return _signTypeColor;
}

@end
