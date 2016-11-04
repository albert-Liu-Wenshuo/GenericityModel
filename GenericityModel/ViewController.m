//
//  ViewController.m
//  GenericityModel
//
//  Created by albert on 2016/11/4.
//  Copyright © 2016年 albert. All rights reserved.
//

#import "ViewController.h"
#import "YTQ_BaseModel.h"
#import "YTQ_TestModel.h"
#import "YYModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@",dic);
    
    
    [YTQ_BaseModel setDataClass:[YTQ_TestModel class]];
    
    YTQ_BaseModel<YTQ_TestModel *> *model = [YTQ_BaseModel<YTQ_TestModel *> yy_modelWithJSON:dic];
    
    NSLog(@"%@",model.data.name);
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
