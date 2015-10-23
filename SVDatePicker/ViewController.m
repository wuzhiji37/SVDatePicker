//
//  ViewController.m
//  SVDatePicker
//
//  Created by 吴智极 on 15/10/22.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "ViewController.h"
#import "SVDatePicker.h"
@interface ViewController ()
{
    SVDatePicker *datePicker;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datePicker = [[SVDatePicker alloc] init];
    datePicker.layer.borderColor = [UIColor blackColor].CGColor;
    datePicker.layer.borderWidth = 2;
    datePicker.titleLabel.text = @"哈哈哈哈";
    
    [datePicker.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    datePicker.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [datePicker.commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    datePicker.commitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:datePicker];
    
    [datePicker setMaxYear:2016 maxMonth:6 maxDay:12];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                          fromDate:[NSDate date]];
    [datePicker setSelectYear:[comps year] selectMonth:[comps month] selectDay:[comps day]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
