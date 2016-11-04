GenericityModel

##前言 ： 泛型的概念

    1.泛型是Java中的一个重要特性，使用泛型编程可以使代码获得最大的重要。 
    2.在使用泛型时要指明泛型的具体类型，这样可以避免类型转换。 
    3.泛型类是一个参数类型可变的类；固泛型参数只能是类类型。 

####需要工具：`YYModel`  [链接](https://github.com/walkertop/YYModel---Demo.git) (可以使用pod请求)

使用截图：

![Model使用效果图.png](http://upload-images.jianshu.io/upload_images/1952475-a98ef793d08eb5dc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其中需要注意的是：
1. BaseModel并不是Model的`基类`，他用来存储一些所有Model中通用的部分 -- 在我们的项目中所有的Model都需要有(message , success , data)属性，所以我们将其放置在BaseModel中。
2. <TestModel *>是类似java中泛型的概念，在我们的测试例子中data的数据类型是可变的，使用<T>的方式能够使`编译器`识别data的类型，从而达到使用点语法的目的--(model.data.name)  * name是TestModel的属性 *
3. setDataClass的方式是为了让BaseModel能够真的跟TestModel关联的方法，目的是能够在`运行时`保证data最终获得的数据是我们需要的类型

####实现原理
1. 创建通用类(在本项目中为BaseModel)，并将常用不变属性添加
2. 在通用类中设置两个静态变量用于接受类名、类名数组  * 用于在[self setDataClass/setDataClassArr]的时候接收数据 *
3. 在通用类中导入YYModel头文件并使用 
` // 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。`
       
       - (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
         if (dataClass) {
        //如果声明的是Class的话，使用YYModel将其转化
        _data = [[dataClass class] yy_modelWithJSON:[dic valueForKey:@"data"]];
        //转化后将常量置空以免发生错误的转化
        dataClass = nil;
                 }
         //如果声明的是数组的话判断 -- 数组中都是相同的Model的时候直接转化 数组中Model的类型不同的时候根据classArr中对应的Class分别实现json->Model的转化
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
        //转化后将常量置空以免发生错误的转化
        classArr = nil;
        
        }
         return YES;
        }
4. 实现传递Model类型的方法 -- Model类型数组的方法类似

      + (void)setDataClass:(Class)class;
      + (void)setDataClass:(Class)class
            {
            if (dataClass) {
                dataClass = nil;
                }
            dataClass = class;
            }
5. 需要设计为泛型的属性的设置  
      * 需要注意的是使用<T>的作用是让编译器可以使用泛型的方式识别这个可变类型属性(这里是data属性)调用时的类型
      * 需要使用T来修饰可变类型的属性
      * ** 使用retain修饰data是因为他在运行时的真正类型(NSMutableArray / Model)都是需要retain修饰的 **
      * 最重要的一点是，泛型主要是起到能够让编译器正确的识别类型的作用，真正实现运行时将json于Model对应的是方法：`modelCustomTransformFromDictionary:`

![通用类的.m文件.png](http://upload-images.jianshu.io/upload_images/1952475-ebc15cbe99457ea1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

