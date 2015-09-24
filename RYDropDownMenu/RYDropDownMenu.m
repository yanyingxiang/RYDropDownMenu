//
//  RYDropDownMenu.m
//  DropDownMenu
//
//  Created by 燕颖祥 on 15/9/21.
//  Copyright (c) 2015年 嗖嗖快跑. All rights reserved.
//

#import "RYDropDownMenu.h"

#define ScreenWidth             [UIScreen mainScreen].bounds.size.width
#define ScreenHeight            [UIScreen mainScreen].bounds.size.height
#define TitleHeight             40
#define IndicatorImageWidth     12
#define IndicatorImageHeight    6.5
#define ImageXPadding           5
#define ImageYPadding           (TitleHeight - IndicatorImageHeight)/2
#define RowHeight               44

@interface RYDropDownMenu() <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *items;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *indicatorImage;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIControl *control;
@property (assign, nonatomic) BOOL openStatus;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@end

CGFloat menuWidth;
CGFloat menuHeight;

@implementation RYDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(0, 0, 200, TitleHeight)];
    if (self)
    {
        _items = items;
        menuWidth = frame.size.width;
        menuHeight = (_items.count * RowHeight>frame.size.height)?frame.size.height:_items.count * RowHeight;
        if (_items.count > 5)
        {
            //设置最多显示的cell数目，如果大于5，frame.size.height失效
            menuHeight = 5 * RowHeight;
        }
        _openStatus = NO;
        
        [self initTitleView];
        if (items.count != 0)
        {
            [self initControl];
            [self initTableView];
        }
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
}

- (void)initTitleView
{
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, TitleHeight)];
    [self addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, menuWidth - IndicatorImageWidth - ImageXPadding, TitleHeight)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text = _items[0];
    [_titleView addSubview:_titleLabel];

    if (_titleLabel.text.length != 0)
    {
        CGSize size = [self getTitleSize:_titleLabel.text];
        _titleLabel.frame = CGRectMake(0, 0, size.width, TitleHeight);
        _titleView.frame = CGRectMake(0, 0, size.width + IndicatorImageWidth + ImageXPadding, TitleHeight);
        self.frame = _titleView.frame;
    }
    
    _indicatorImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame) + ImageXPadding, ImageYPadding, IndicatorImageWidth, IndicatorImageHeight)];
    _indicatorImage.image = [UIImage imageNamed:@"down"];
    [_titleView addSubview:_indicatorImage];
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTouchUpInside:)];
    [_titleView addGestureRecognizer:labelTapGestureRecognizer];
}

- (void)initControl
{
    _control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    [_control addTarget:self action:@selector(changeOpenStatus) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].windows[[UIApplication sharedApplication].windows.count - 1];
    [window.rootViewController.view addSubview:_control];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((ScreenWidth - menuWidth)/2, 65, menuWidth, 0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIWindow *window = [UIApplication sharedApplication].windows[[UIApplication sharedApplication].windows.count - 1];
    [window.rootViewController.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"resueIdentifier";
    UITableViewCell *cell;
    
    if (indexPath.row == _items.count - 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lastCell"];
        
    }else
    {
        if (indexPath.row == 0)
        {
            if (_lastIndexPath == nil || _lastIndexPath == [NSIndexPath indexPathForRow:0 inSection:0])
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCells"];
                UIImageView *selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
                selectImage.frame = CGRectMake(self.frame.size.width - 100, 12, 20, 20);
                cell.accessoryView = selectImage;
                _lastIndexPath = indexPath;
            }else
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCell"];
            }
            
        }else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
            }
            if (_lastIndexPath != indexPath)
            {
                cell.accessoryView = nil;
            }else
            {
                UIImageView *selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
                selectImage.frame = CGRectMake(self.frame.size.width - 100, 12, 20, 20);
                cell.accessoryView = selectImage;
            }
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, RowHeight - 0.5, ScreenWidth - 20, 0.5)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell addSubview:lineView];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.textLabel.text = _items[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select"]];
    selectImage.frame = CGRectMake(self.frame.size.width - 100, 12, 20, 20);
    
    long int newRow = [indexPath row];
    long int oldRow = (_lastIndexPath !=nil)?[_lastIndexPath row]:-1;
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
    
    if (newRow != oldRow)
    {
        newCell.accessoryView = selectImage;
        oldCell.accessoryView = nil;
        _lastIndexPath = indexPath;
    }
    
    _titleLabel.text = _items[indexPath.row];
    if (_titleLabel.text.length != 0)
    {
        CGSize size = [self getTitleSize:_titleLabel.text];
        _titleLabel.frame = CGRectMake(0, 0, size.width, TitleHeight);
        _indicatorImage.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + ImageXPadding, ImageYPadding, IndicatorImageWidth, IndicatorImageHeight);
        _titleView.frame = CGRectMake(0, 0, size.width + IndicatorImageWidth + ImageXPadding, TitleHeight);
        self.frame = _titleView.frame;
    }
    
    [self changeOpenStatus];
    [_delegate didSelectItemAtIndex:indexPath.row];
}

-(void)gestureTouchUpInside:(UITapGestureRecognizer *)recognizer
{
    [self changeOpenStatus];
}

- (CGSize)getTitleSize:(NSString *)title
{
    UIFont *font = [UIFont systemFontOfSize:16];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, TitleHeight)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (void)changeOpenStatus
{
    if (_openStatus)
    {
        [self closeDropDownMenu];
        _indicatorImage.image = [UIImage imageNamed:@"down"];
    }else
    {
        [self openDropDownMenu];
        _indicatorImage.image = [UIImage imageNamed:@"up"];
    }
    _openStatus = !_openStatus;
}

- (void)openDropDownMenu
{
    _control.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [UIView animateWithDuration:0.15 animations:^{
        
        _tableView.frame = CGRectMake((ScreenWidth - menuWidth)/2, 65, menuWidth, menuHeight);
        
    }completion:^(BOOL finished) {
        
    }];
}

- (void)closeDropDownMenu
{
    [UIView animateWithDuration:0.15 animations:^{
        
        _tableView.frame = CGRectMake((ScreenWidth - menuWidth)/2, 65, menuWidth, 0);

    }completion:^(BOOL finished) {
        
        _control.frame = CGRectMake(0, 0, ScreenWidth, 0);

    }];
}

@end
