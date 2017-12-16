//
//  SignInfoView.h
//  CalendarPicker
//
//  Created by 董佳旺 on 2017/12/5.
//  Copyright © 2017年 董佳旺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInfoView : UIView

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *stateLabel;

@property (nonatomic,strong) UILabel *remarkLabel;

- (instancetype)initWithFrame:(CGRect)frame withInfoRect:(CGRect)infoRect withCellPoint:(CGFloat)cellOrginX;


@end
