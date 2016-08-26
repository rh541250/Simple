//
//  KVOObject.m
//  Simple
//
//  Created by renhong on 16/8/26.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "KVOTarget.h"

@interface KVOTarget()
{
    int age;
}

- (int)age;
- (void)setAge:(int)newAge;

@end

@implementation KVOTarget

- (id)init
{
    self = [super init];
    if (self) {
        age = 10;
    }
    return self;
}

- (int)age
{
    return age;
}

- (void)setAge:(int)newAge
{
    [self willChangeValueForKey:@"age"];
    age = newAge;
    [self didChangeValueForKey:@"age"];
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"age"]) {
        return  NO;
    }else{
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

@end
