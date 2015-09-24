//
//  ViewController.m
//  RYDropDownMenu
//
//  Created by 燕颖祥 on 15/9/24.
//  Copyright (c) 2015年 嗖嗖快跑. All rights reserved.
//

#import "ViewController.h"
#import "RYDropDownMenu.h"

@interface ViewController ()<RYDropDownMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RYDropDownMenu *menu = [[RYDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) items:@[@"一", @"一二", @"一二三", @"一二三四", @"一二三四五", @"一二三四五六", @"一二三四五六七", @"一二三四五六七八", @"一二三四五六七八九", ]];
    menu.delegate = self;
    self.navigationItem.titleView = menu;
    
}

- (void)didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"didSelectItemAtIndex %ld", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
