//
//  ViewController.m
//  CalendarPicker
//
//  Created by 董佳旺 on 2017/12/5.
//  Copyright © 2017年 董佳旺. All rights reserved.
//

#import "ViewController.h"
#import "CalendarPicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CalendarPicker *calendar = [[CalendarPicker alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width - 20, 300)];
    [self.view addSubview:calendar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
