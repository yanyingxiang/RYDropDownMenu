//
//  RYDropDownMenu.h
//  DropDownMenu
//
//  Created by 燕颖祥 on 15/9/21.
//  Copyright (c) 2015年 嗖嗖快跑. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYDropDownMenuDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface RYDropDownMenu : UIView

@property (weak, nonatomic) id<RYDropDownMenuDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

@end

