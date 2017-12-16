//
//  CalendarDayCell.h
//  CalendarPicker
//
//  Created by 董佳旺 on 2017/12/5.
//  Copyright © 2017年 董佳旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDayCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *textLabel;

@property (nonatomic,strong) UIView *signTypeColor;

@property (nonatomic,assign) BOOL canSelect;

@end
