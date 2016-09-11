//
//  ViewController.m
//  JWTagView
//
//  Created by wangjun on 16/9/11.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "ViewController.h"

#import "BaseUseController.h"
#import "SortViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)basePage:(id)sender {
    
    BaseUseController *baseController = [[BaseUseController alloc] init];
    [self.navigationController pushViewController:baseController animated:YES];
}

- (IBAction)sortPage:(id)sender {
    
    SortViewController *sortController = [[SortViewController alloc] init];
    [self.navigationController pushViewController:sortController animated:YES];
}

@end
