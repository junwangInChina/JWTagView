//
//  BaseUseController.m
//  JWTagView
//
//  Created by wangjun on 16/9/11.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "BaseUseController.h"

#import "JWTagView/JWTagView.h"

@interface BaseUseController ()

@property (nonatomic, strong) JWTagView *tagView;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) NSInteger addIndex;
@end

@implementation BaseUseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.addIndex = 0;
    [self addNavButton];
    
    self.tags = @[@"飞狐外传",@"雪山飞狐",@"连城诀",@"天龙八部",@"射雕英雄传",@"白马啸西风",@"鹿鼎记",@"笑傲江湖",@"书剑恩仇录",@"神雕侠侣",@"侠客行",@"倚天屠龙记",@"碧血剑",@"鸳鸯刀"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JWTagView *)tagView
{
    if (!_tagView)
    {
        self.tagView = [[JWTagView alloc] init];
        _tagView.frame = CGRectMake(0, 64, self.view.frame.size.width, 0);
        _tagView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_tagView];
        
        JWTagConfig *config = [JWTagConfig config];
        config.tagAutoUpdateHeight = YES;
        config.tagDeleteImage = [UIImage imageNamed:@"delete"];
        
        __weak typeof (self) weakself = self;
        _tagView.tagComplete = ^(NSString *tapTag, BOOL seleted){
            NSLog(@"删除 %@",tapTag);
            [weakself.tagView deleteTag:tapTag];
        };
    }
    return _tagView;
}

- (void)addNavButton
{
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [tempButton addTarget:self action:@selector(addTargetAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addTargetAction:(id)sender
{
    NSInteger randomIndex = arc4random_uniform((self.tags.count));
    NSString *tempTag = [NSString stringWithFormat:@"%@ (%d)",self.tags[randomIndex],self.addIndex];
    [self.tagView addTag:tempTag];
    self.addIndex++;
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
