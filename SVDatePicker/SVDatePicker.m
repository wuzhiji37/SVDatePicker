//
//  SVDatePicker.m
//  SVAlarm
//
//  Created by 吴智极 on 15/10/22.
//  Copyright © 2015年 吴智极. All rights reserved.
//

#import "SVDatePicker.h"

#define     YEAR_BEGIN          1970
#define     YEAR_END            2050
#define     YEAR_DEFAULT        2000
#define     HEIGHT_PICKER       68
#define     WIDTH_SELECTOR      10
#define     COLOR_SELECT        [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]
#define     COLOR_SELECTED      [UIColor colorWithRed:255/255.0 green:106/255.0 blue:153/255.0 alpha:1]
#define     COLOR_ALPHA         [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.3]
#define     COLOR_BUTTON        [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]
#define     LEAP(year)          ((year%4==0&&year%100!=0)||year%400==0)?1:0

int days[2][12] = {{31,28,31,30,31,30,31,31,30,31,30,31},{31,29,31,30,31,30,31,31,30,31,30,31}};
@implementation SVDatePicker
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 256, [UIScreen mainScreen].bounds.size.width, 256)];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.height >= 256) {
        frame.size.height = 256;
    } else if (frame.size.height >= 220) {
        frame.size.height = 220;
    } else {
        frame.size.height = 202;
    }
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        [self setMinYear:YEAR_BEGIN minMonth:1 minDay:1];
        [self setMaxYear:YEAR_END maxMonth:12 maxDay:31];
        [self setSelectYear:YEAR_DEFAULT selectMonth:1 selectDay:1];
        _pickerFont = [UIFont systemFontOfSize:12];
        _pickerNumFont = [UIFont systemFontOfSize:25];
        _pickerColor_selected = COLOR_SELECTED;
//        [[UIPickerView appearance] setBackgroundColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1]];
        CGFloat titleHeight = 40;
        CGFloat pickerHeight = self.frame.size.height - titleHeight;
        yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(WIDTH_SELECTOR, titleHeight, self.frame.size.width/3-WIDTH_SELECTOR, pickerHeight)];
        yearPicker.delegate = self;
        yearPicker.dataSource = self;
        [self addSubview:yearPicker];
        
        monthPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.frame.size.width/3, titleHeight, self.frame.size.width/3, pickerHeight)];
        monthPicker.delegate = self;
        monthPicker.dataSource = self;
        [self addSubview:monthPicker];
        
        dayPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.frame.size.width/3*2, titleHeight, self.frame.size.width/3, pickerHeight)];
        dayPicker.delegate = self;
        dayPicker.dataSource = self;
        [self addSubview:dayPicker];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, titleHeight+20)];
        titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, self.frame.size.width-200, titleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:_titleLabel];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame= CGRectMake(20, 10, 80, titleHeight);
        [_cancelBtn setTitleColor:COLOR_BUTTON forState:UIControlStateNormal];
        [titleView addSubview:_cancelBtn];
        
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.frame= CGRectMake(self.frame.size.width-100, 10, 80, titleHeight);
        [_commitBtn setTitleColor:COLOR_BUTTON forState:UIControlStateNormal];
        [titleView addSubview:_commitBtn];
        
        UIView *selectView_up = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.frame.size.height, WIDTH_SELECTOR, (pickerHeight-HEIGHT_PICKER)/2.0-20)];
        selectView_up.backgroundColor = COLOR_SELECT;
        selectView_up.userInteractionEnabled = NO;
        [self addSubview:selectView_up];
        
        UIView *alphaView_up = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_SELECTOR, titleView.frame.size.height, self.frame.size.width-WIDTH_SELECTOR, (pickerHeight-HEIGHT_PICKER)/2.0-20)];
        alphaView_up.backgroundColor = COLOR_ALPHA;
        alphaView_up.userInteractionEnabled = NO;
        [self addSubview:alphaView_up];
        
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHeight+(pickerHeight-HEIGHT_PICKER)/2.0, WIDTH_SELECTOR, HEIGHT_PICKER)];
        selectedView.backgroundColor = COLOR_SELECTED;
        selectedView.userInteractionEnabled = NO;
        [self addSubview:selectedView];
        
        
        UIView *selectView_down = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-(pickerHeight-HEIGHT_PICKER)/2.0, WIDTH_SELECTOR, (pickerHeight-HEIGHT_PICKER)/2.0-20)];
        selectView_down.backgroundColor = COLOR_SELECT;
        selectView_down.userInteractionEnabled = NO;
        [self addSubview:selectView_down];
        
        UIView *alphaView_down = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_SELECTOR, self.frame.size.height-(pickerHeight-HEIGHT_PICKER)/2.0, self.frame.size.width-WIDTH_SELECTOR, (pickerHeight-HEIGHT_PICKER)/2.0-20)];
        alphaView_down.backgroundColor = COLOR_ALPHA;
        alphaView_down.userInteractionEnabled = NO;
        [self addSubview:alphaView_down];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        
        
        
        [self addLineFrom:CGPointMake(0, titleHeight+20) to:CGPointMake(self.frame.size.width, titleHeight+20) width:0.5];
        [self addLineFrom:CGPointMake(0, self.frame.size.height-20) to:CGPointMake(self.frame.size.width, self.frame.size.height-20) width:0.5];
        
        [self addLineFrom:CGPointMake(self.frame.size.width/3, titleHeight+20) to:CGPointMake(self.frame.size.width/3, self.frame.size.height-20) width:0.5];
        [self addLineFrom:CGPointMake(self.frame.size.width/3*2, titleHeight+20) to:CGPointMake(self.frame.size.width/3*2, self.frame.size.height-20) width:0.5];
        NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
        NSLog(@"yearPicker = %@",NSStringFromCGRect(yearPicker.frame));
        NSLog(@"monthPicker = %@",NSStringFromCGRect(monthPicker.frame));
        NSLog(@"dayPicker = %@",NSStringFromCGRect(dayPicker.frame));
        NSLog(@"titleView= %@",NSStringFromCGRect(titleView.frame));
        NSLog(@"bottomView = %@",NSStringFromCGRect(bottomView.frame));
    }
    return self;
}
//- (void)setFrame:(CGRect)frame {
//    yearPicker.frame = CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height-50);
//    monthPicker.frame = CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height-50);
//    dayPicker.frame = CGRectMake(self.frame.size.width/3*2, 0, self.frame.size.width/3, self.frame.size.height-50);
//}
- (void)setMinYear:(NSUInteger)minYear
          minMonth:(NSUInteger)minMonth
            minDay:(NSUInteger)minDay {
    _minYear = minYear;
    _minMonth = minMonth;
    _minDay = minDay;
    minDays = minYear*10000+minMonth*100+minDay;
}
- (void)setMaxYear:(NSUInteger)maxYear
          maxMonth:(NSUInteger)maxMonth
            maxDay:(NSUInteger)maxDay {
    _maxYear = maxYear;
    _maxMonth = maxMonth;
    _maxDay = maxDay;
    maxDays = maxYear*10000+maxMonth*100+maxDay;
}
- (void)setSelectYear:(NSUInteger)selectYear
          selectMonth:(NSUInteger)selectMonth
            selectDay:(NSUInteger)selectDay {
    _selectYear = selectYear;
    _selectMonth = selectMonth;
    _selectDay = selectDay;
    [yearPicker reloadAllComponents];
    [monthPicker reloadAllComponents];
    [dayPicker reloadAllComponents];
    [yearPicker selectRow:_selectYear-YEAR_BEGIN inComponent:0 animated:YES];
    [monthPicker selectRow:_selectMonth-1 inComponent:0 animated:YES];
    while (_selectDay > [self pickerView:dayPicker numberOfRowsInComponent:0]) {
        _selectDay--;
    }
    [dayPicker selectRow:_selectDay-1 inComponent:0 animated:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == yearPicker) {
        return YEAR_END-YEAR_BEGIN+1;
    } else if (pickerView == monthPicker) {
        return 12;
    } else {
        return days[LEAP(_selectYear)][_selectMonth-1];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return HEIGHT_PICKER-2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{

    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc]init];
    }
    pickerLabel.font = _pickerFont;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    NSString *pickerString;
    NSMutableAttributedString *pickerAttriString;
    if (pickerView == yearPicker) {
        if (row == _selectYear - YEAR_BEGIN) {
            pickerLabel.textColor = _pickerColor_selected;
            pickerLabel.backgroundColor = [UIColor whiteColor];
        } else {
            pickerLabel.textColor = [UIColor grayColor];
            pickerLabel.backgroundColor = [UIColor clearColor];

        }
        pickerString = [NSString stringWithFormat:@"%ld年", YEAR_BEGIN + row];
    } else if (pickerView == monthPicker) {
        if (row == _selectMonth-1) {
            pickerLabel.textColor = _pickerColor_selected;
            pickerLabel.backgroundColor = [UIColor whiteColor];
        } else {
            pickerLabel.textColor = [UIColor grayColor];
            pickerLabel.backgroundColor = [UIColor clearColor];
        }
        pickerString = [NSString stringWithFormat:@"%ld月", row+1];
    } else {
        if (row == _selectDay-1) {
            pickerLabel.textColor = _pickerColor_selected;
            pickerLabel.backgroundColor = [UIColor whiteColor];
        } else {
            pickerLabel.textColor = [UIColor grayColor];
            pickerLabel.backgroundColor = [UIColor clearColor];
        }
        pickerString = [NSString stringWithFormat:@"%ld日", row+1];
    }
    pickerAttriString = [[NSMutableAttributedString alloc] initWithString:pickerString attributes:@{NSFontAttributeName:_pickerFont}];
    [pickerAttriString addAttribute:NSFontAttributeName value:_pickerNumFont range:NSMakeRange(0, pickerAttriString.length-1)];
    pickerLabel.attributedText = pickerAttriString;
    return pickerLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == yearPicker) {
        _selectYear = YEAR_BEGIN + row;
    } else if (pickerView == monthPicker) {
        _selectMonth = row+1;
    } else {
        _selectDay = row+1;
    }
    
    selectDays = _selectYear*10000+_selectMonth*100+_selectDay;
    NSLog(@"%@:%@:%@",@(minDays),@(selectDays),@(maxDays));
    if (selectDays < minDays) {
        _selectYear = _minYear;
        _selectMonth = _minMonth;
        _selectDay = _minDay;
    } else if (selectDays > maxDays) {
        _selectYear = _maxYear;
        _selectMonth = _maxMonth;
        _selectDay = _maxDay;
    }
    [yearPicker reloadAllComponents];
    [monthPicker reloadAllComponents];
    [dayPicker reloadAllComponents];
    [yearPicker selectRow:_selectYear-YEAR_BEGIN inComponent:0 animated:YES];
    [monthPicker selectRow:_selectMonth-1 inComponent:0 animated:YES];
    while (_selectDay > [self pickerView:dayPicker numberOfRowsInComponent:0]) {
        _selectDay--;
    }
    [dayPicker selectRow:_selectDay-1 inComponent:0 animated:YES];
    NSLog(@"%@-%@-%@",@(_selectYear),@(_selectMonth),@(_selectDay));
}
- (void)addLineFrom:(CGPoint)pointA to:(CGPoint)pointB width:(CGFloat)width
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = width;
    lineShape.lineCap = kCALineCapRound;
    lineShape.strokeColor = COLOR_SELECT.CGColor;
    CGPathMoveToPoint(linePath, NULL, pointA.x, pointA.y);
    CGPathAddLineToPoint(linePath, NULL, pointB.x, pointB.y);
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [self.layer addSublayer:lineShape];
}
@end
