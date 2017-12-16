//
//  CalendarPicker.m
//  CalendarPicker
//
//  Created by 董佳旺 on 2017/12/5.
//  Copyright © 2017年 董佳旺. All rights reserved.
//

#import "CalendarPicker.h"
#import "CalendarDayCell.h"
#import "SignInfoView.h"

@interface CalendarPicker ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *calendarCollectionView;

@property (nonatomic,strong) UIButton *lastBtn;

@property (nonatomic,strong) UIButton *nextBtn;

@property (nonatomic,strong) UILabel *monthLabel;

@property (nonatomic,strong) NSArray *weekArray;

@property (nonatomic,strong) NSDate *currentDate;

@property (nonatomic,strong) NSDate *todayDate;

@property (nonatomic,strong) SignInfoView *signInfoView;

@end

@implementation CalendarPicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
        [self initHeadView];
        
        self.weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        self.currentDate = self.todayDate = [NSDate date];
    }
    return self;
}

- (void)initHeadView {
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 150) / 2, 5, 150, 30)];
    self.monthLabel.textColor = [UIColor darkGrayColor];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.monthLabel];
    
    self.lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastBtn.frame = CGRectMake(self.monthLabel.frame.origin.x - 40, 5, 30, 30);
    [self.lastBtn addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
    [self.lastBtn setImage:[UIImage imageNamed:@"日历左箭头"] forState:UIControlStateNormal];
    [self addSubview:self.lastBtn];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(self.monthLabel.frame.origin.x + self.monthLabel.frame.size.width + 10, 5, 30, 30);
    [self.nextBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn setImage:[UIImage imageNamed:@"日历右箭头"] forState:UIControlStateNormal];
    [self addSubview:self.nextBtn];
}

- (void)lastMonth {
    self.currentDate = [self lastMonth:self.currentDate];
}

- (void)nextMonth {
    self.currentDate = [self nextMonth:self.currentDate];
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    _monthLabel.text = [NSString stringWithFormat:@"%.2ld-%li", (long)[self year:currentDate], (long)[self month:currentDate]];
    [self.calendarCollectionView reloadData];
}

#pragma mark ----dateAction----
/**
 与手机日期间隔天数
 
 @param date 日期
 @return 天数
 */
- (NSInteger)day:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

/**
 与手机日期间隔月数
 
 @param date 日期
 @return 间隔月数
 */
- (NSInteger)month:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

/**
 与手机日期间隔年数
 
 @param date 日期
 @return 年数
 */
- (NSInteger)year:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

/**
 本月第一天是星期几
 
 @param date 日期
 @return 星期
 */
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/**
 今天是本月的第几天
 
 @param date 日期
 @return index
 */
- (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

/**
 上一月

 @param date 当前日期
 @return 新的日期
 */
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 下一月

 @param date 当前日期
 @return 新的日期
 */
- (NSDate*)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 判断是否同一天

 @param date1 日期1
 @param date2 日期2
 @return 结果
 */
- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}


#pragma mark ----UICollectionView----

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarDayCell" forIndexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == 0) {// 星期
        cell.textLabel.text = _weekArray[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.signTypeColor.hidden = YES;
    }
    else {
        NSInteger dayInThisMonth = [self totaldaysInMonth:_currentDate];
        NSInteger firstWeedDay = [self firstWeekdayInThisMonth:_currentDate];
        
        // 如果 index 是本月开始之前的星期位置或者，结束后的星期的位置，就空白
        if (indexPath.row < firstWeedDay || indexPath.row > (firstWeedDay + dayInThisMonth - 1)) {
            cell.textLabel.text = @"";
            cell.signTypeColor.hidden = YES;
            cell.canSelect = NO;
        }
        else {
            NSInteger day = indexPath.row - firstWeedDay + 1;
            cell.textLabel.text = [NSString stringWithFormat:@"%.0ld", (long)day];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.signTypeColor.backgroundColor = [UIColor redColor];
            cell.signTypeColor.hidden = NO;
            cell.canSelect = YES;
            
            if ([self isSameDay:_currentDate date2:_todayDate]) {
                if (day == [self day:_currentDate]) {// 今天
                    cell.textLabel.backgroundColor = [UIColor redColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                }
                else if (day > [self day:_currentDate]) {// 当月超出当前日期
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.canSelect = NO;
                }
            }
            else if ([_todayDate compare:_currentDate] == NSOrderedAscending) {// 超出当前日期
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.canSelect = NO;
            }
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarDayCell *cell = (CalendarDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self showSignInfoViewWithCellFrame:cell.frame];
}

- (void)showSignInfoViewWithCellFrame:(CGRect)cellRect {
    CGRect showFrame = CGRectMake(cellRect.origin.x - 30 + cellRect.size.width / 2, cellRect.origin.y - 35, 200, 70);
    if (showFrame.size.width + showFrame.origin.x > self.bounds.size.width) {
        showFrame.origin.x -= ((showFrame.size.width + showFrame.origin.x) - self.bounds.size.width);
    }
    CGPoint cellPoint = CGPointMake(cellRect.origin.x + cellRect.size.width / 2, cellRect.origin.y);
    SignInfoView *infoView = [[SignInfoView alloc] initWithFrame:self.bounds withInfoRect:showFrame withCellPoint:cellPoint.x];
    [self addSubview:infoView];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger dayInThisMonth = [self totaldaysInMonth:_currentDate];
        NSInteger firstWeedDay = [self firstWeekdayInThisMonth:_currentDate];
        
        if (indexPath.row >= firstWeedDay && indexPath.row <= (firstWeedDay + dayInThisMonth - 1)) {
             NSInteger day = indexPath.row - firstWeedDay + 1;
            if ([self isSameDay:_currentDate date2:_todayDate]) {
                if (day <= [self day:_currentDate]) {// 今天
                    return YES;
                }
            }
            else if ([_todayDate compare:_currentDate] == NSOrderedDescending) {// 以前的日期。倒序
                return YES;
            }
        }
    }
    return NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _weekArray.count;
    }
    return 42;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 10, 0);
}


-(UICollectionView *)calendarCollectionView {
    if (!_calendarCollectionView) {
        CGFloat itemW = self.bounds.size.width / 7;
        CGFloat itemH = (self.bounds.size.height - 55) / 7;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemH);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _calendarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, self.bounds.size.width, self.bounds.size.height - 45) collectionViewLayout:layout];
        [_calendarCollectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:@"CalendarDayCell"];
        _calendarCollectionView.backgroundColor = [UIColor clearColor];
        _calendarCollectionView.delegate = self;
        _calendarCollectionView.dataSource = self;
        [self addSubview:_calendarCollectionView];
    }
    return _calendarCollectionView;
}


#pragma mark ----signInfoView----

- (SignInfoView *)signInfoView {
    if (!_signInfoView) {
        _signInfoView = [[SignInfoView alloc] initWithFrame:CGRectZero];
        _signInfoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_signInfoView];
    }
    return _signInfoView;
}

@end
