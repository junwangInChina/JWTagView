//
//  SortViewController.m
//  JWTagView
//
//  Created by wangjun on 16/9/11.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "SortViewController.h"

#import "JWTagView/JWTagView.h"

@interface SortViewController ()

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JWTagView *tagView = [[JWTagView alloc] init];
    tagView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:tagView];
    tagView.tagComplete = ^(NSString *tapTag, BOOL seleted){
        NSLog(@"点击 %@ %@",tapTag,seleted?@"选中":@"取消选中");
    };
    
    NSArray *tags = @[@"飞狐外传",@"雪山飞狐",@"连城诀",@"天龙八部",@"射雕英雄传",@"白马啸西风",@"鹿鼎记",@"笑傲江湖",@"书剑恩仇录",@"神雕侠侣",@"侠客行",@"倚天屠龙记",@"碧血剑",@"鸳鸯刀"];
    JWTagConfig *config = [JWTagConfig config];
    config.tagBorderColor = [UIColor orangeColor];
    config.tagBorderWidth = 0.5;
    config.tagCanPanSort = YES;
    config.tagAutoUpdateHeight = NO;
    config.tagDeleteImage = nil;
    config.tagKeepSeleted = YES;
    config.tagInsideHorizontalMargin = 10;
    
    [tagView addTags:tags];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
