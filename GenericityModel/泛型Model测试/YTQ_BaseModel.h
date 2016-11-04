//
//  YTQ_BaseModel.h
//  PMWeatherDemo
//
//  Created by albert on 2016/11/4.
//  Copyright © 2016年 albert. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 实现泛型的思想
    1. 通过一个方法将类型标示传递进来
    2. 根据传来的字符串动态的设置标示为泛型类型
    3. ...
 */

@interface YTQ_BaseModel<T> : NSObject

//@property (nonatomic , assign)Class dataClass;

@property (nonatomic , copy)NSString *message;

@property (nonatomic , copy)NSString *success;

@property (nonatomic , retain)T data;

+ (void)setDataClass:(Class)class;

+ (void)setDataClassArr:(NSArray *)array;

@end
