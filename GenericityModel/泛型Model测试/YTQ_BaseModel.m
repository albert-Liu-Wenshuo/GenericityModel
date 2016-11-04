//
//  YTQ_BaseModel.m
//  PMWeatherDemo
//
//  Created by albert on 2016/11/4.
//  Copyright © 2016年 albert. All rights reserved.
//

#import "YTQ_BaseModel.h"
#import "YTQ_TestModel.h"
#import "YYModel.h"

static Class dataClass;

static NSArray *classArr;


@interface YTQ_BaseModel ()


@end

@implementation YTQ_BaseModel


+ (void)setDataClass:(Class)class{
    if (dataClass) {
        dataClass = nil;
    }
    dataClass = class;
}

+ (void)setDataClassArr:(NSArray *)array{
    if (classArr) {
        classArr = nil;
    }
    classArr = array;
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    if (dataClass) {
        _data = [[dataClass class] yy_modelWithJSON:[dic valueForKey:@"data"]];
        dataClass = nil;
    }
    if (classArr) {
        
        NSMutableArray *array = [NSMutableArray array];
        NSArray *itemDicArr = [dic valueForKey:@"data"];
        
        if (classArr.count == 1) {
            
            for (NSInteger i = 0; i < itemDicArr.count; i++) {
                [array addObject:[(Class)classArr.firstObject yy_modelWithJSON:itemDicArr[i]]];
            }
            
        }else{
            
            for (NSInteger i = 0; i < itemDicArr.count; i++) {
                [array addObject:[(Class)classArr[i] yy_modelWithJSON:itemDicArr[i]]];
            }
            
        }
        
        _data = array;
        classArr = nil;
        
    }
    
    
    
    return YES;
}

@end
