//
//  SignInfoView.m
//  CalendarPicker
//
//  Created by 董佳旺 on 2017/12/5.
//  Copyright © 2017年 董佳旺. All rights reserved.
//

#import "SignInfoView.h"

@interface SignInfoView ()

@property (nonatomic) CGRect infoRect;

@property (nonatomic,assign) CGFloat arrowCenterX;

@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation SignInfoView

- (instancetype)initWithFrame:(CGRect)frame withInfoRect:(CGRect)infoRect withCellPoint:(CGFloat)cellOrginX {
    self = [super initWithFrame:frame];
    if (self) {
        _infoRect = infoRect;
        _arrowCenterX = cellOrginX;
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIView alloc] initWithFrame:infoRect];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundView.layer.borderWidth = 0.3;
        [self addSubview:self.backgroundView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, infoRect.size.width-5, 20)];
        self.timeLabel.textColor = [UIColor darkTextColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
        self.timeLabel.text = @"签到时间：2017-09-09 12:00:01";
        [self.backgroundView addSubview:self.timeLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y, self.timeLabel.frame.size.width - 5, 20)];
        self.stateLabel.textColor = [UIColor darkTextColor];
        self.stateLabel.font = [UIFont systemFontOfSize:12.0];
        self.stateLabel.text = @"签到状态: 正常";
        [self.backgroundView addSubview:self.stateLabel];
        
        self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.stateLabel.frame.origin.y + self.stateLabel.frame.size.height, self.timeLabel.frame.size.width - 5, 20)];
        self.remarkLabel.textColor = [UIColor darkTextColor];
        self.remarkLabel.font = [UIFont systemFontOfSize:12.0];
        self.remarkLabel.text = @"备注: 无";
        [self.backgroundView addSubview:self.remarkLabel];
        
        // 覆盖三角形底边的 layer，灰色
        UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(cellOrginX - 9.5, infoRect.origin.y + infoRect.size.height - 0.5, 19, 1)];
        whiteLine.backgroundColor = [UIColor whiteColor];
        [self.layer addSublayer:whiteLine.layer];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

//绘制带箭头的矩形
-(void)drawArrowRectangle:(CGFloat)centerX {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = 0.5;
    
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(centerX - 10, _infoRect.size.height + _infoRect.origin.y)];
    
    [path addLineToPoint:CGPointMake(centerX, _infoRect.size.height + _infoRect.origin.y + 10)];
    
    [path addLineToPoint:CGPointMake(centerX + 10, _infoRect.size.height + _infoRect.origin.y)];
    
    //关闭path
    [path closePath];
    
    // 白色三角形
    [[UIColor whiteColor] setFill];
    [path fill];
    
    [[UIColor lightGrayColor] setStroke];
    [path stroke];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawArrowRectangle:_arrowCenterX];
}

@end
