//
//  LVDebounce.m
//  LayerVault
//
//  Created by Kelly Sutton on 7/23/13.
//  Copyright (c) 2013 LayerVault. Licensed under the MIT License.
//

#import "LVDebounce.h"

static NSMutableDictionary *timers = nil;

@implementation LVDebounce

+ (void)initialize {
    if (self == [LVDebounce class]) {
        timers = [NSMutableDictionary dictionary];
    }
}

+ (void)fireAfter:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo runLoop:(NSRunLoop *)runLoop {
    @synchronized(self) {
        NSArray *eventKey = @[target, NSStringFromSelector(aSelector)];
        if ([timers objectForKey:eventKey]) {
            NSTimer *timer = [timers objectForKey:eventKey];

            if ([timer respondsToSelector:@selector(invalidate)])
                [timer invalidate];

            [timers removeObjectForKey:eventKey];
        }

        if(!runLoop){
            runLoop = [NSRunLoop currentRunLoop];
        }

        NSTimer *timer = [NSTimer timerWithTimeInterval:seconds target:target selector:aSelector userInfo:userInfo repeats:NO];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];

        [timers setObject:timer forKey:eventKey];
    }
}

@end
