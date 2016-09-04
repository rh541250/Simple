//
//  KVOObserver.m
//  Simple
//
//  Created by renhong on 16/8/26.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "KVOObserver.h"

@implementation KVOObserver

- (instancetype)init
{
    if (self = [super init]) {
        [self addObserver];
    }
    return self;
}

- (void)addObserver
{
    KVOTarget *target = [KVOTarget new];
    [target addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)([target class])];
    
    KVOOtherTarget *otherTarget = [KVOOtherTarget new];
    [otherTarget addObserver:self forKeyPath:@"infomation" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)([otherTarget class])];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"age"]) {
        Class class = (__bridge Class)context;
        NSString *className = [NSString stringWithCString:object_getClassName(class) encoding:NSUTF8StringEncoding];
        NSLog(@" >> class: %@, Age changed", className);
        
        NSLog(@" old age is %@", [change objectForKey:@"old"]);
        NSLog(@" new age is %@", [change objectForKey:@"new"]);
    }else if ([keyPath isEqualToString:@"infomation"]){
        Class classInfo = (__bridge Class)context;
        NSString * className = [NSString stringWithCString:object_getClassName(classInfo)
                                                  encoding:NSUTF8StringEncoding];
        NSLog(@" >> class: %@, Information changed", className);
        NSLog(@" old information is %@", [change objectForKey:@"old"]);
        NSLog(@" new information is %@", [change objectForKey:@"new"]);
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
