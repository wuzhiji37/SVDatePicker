//
//  SVDatePicker.h
//  SVAlarm
//
//  Created by 吴智极 on 15/10/22.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVDatePicker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSUInteger      minDays, maxDays,selectDays;
    UIPickerView    *yearPicker;
    UIPickerView    *monthPicker;
    UIPickerView    *dayPicker;

}
@property (nonatomic, readonly) NSUInteger  minYear;
@property (nonatomic, readonly) NSUInteger  minMonth;
@property (nonatomic, readonly) NSUInteger  minDay;
@property (nonatomic, readonly) NSUInteger  selectYear;
@property (nonatomic, readonly) NSUInteger  selectMonth;
@property (nonatomic, readonly) NSUInteger  selectDay;
@property (nonatomic, readonly) NSUInteger  maxYear;
@property (nonatomic, readonly) NSUInteger  maxMonth;
@property (nonatomic, readonly) NSUInteger  maxDay;

// 标题label
@property (nonatomic, readonly) UILabel     *titleLabel;

// 取消button
@property (nonatomic, readonly) UIButton    *cancelBtn;

// 确定button
@property (nonatomic, readonly) UIButton    *commitBtn;

// 汉字字体
@property (nonatomic, retain)   UIFont      *pickerFont;

// 数字字体
@property (nonatomic, retain)   UIFont      *pickerNumFont;

// 选中颜色
@property (nonatomic, retain)   UIColor     *pickerColor_selected;

// 设置年月日最小值
// 默认1970-01-01
- (void)setMinYear:(NSUInteger)minYear
          minMonth:(NSUInteger)minMonth
            minDay:(NSUInteger)minDay;

// 设置年月日最大值
// 默认2050-12-31
- (void)setMaxYear:(NSUInteger)maxYear
          maxMonth:(NSUInteger)maxMonth
            maxDay:(NSUInteger)maxDay;

// 设置初始现实的年月日
// 默认2000-01-01
- (void)setSelectYear:(NSUInteger)selectYear
          selectMonth:(NSUInteger)selectMonth
            selectDay:(NSUInteger)selectDay;
@end
