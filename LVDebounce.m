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

+ (void)fireAfter:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo {
    @synchronized(self) {
        NSArray *eventKey = @[target, NSStringFromSelector(aSelector)];
        if ([timers objectForKey:eventKey]) {
            NSTimer *timer = [timers objectForKey:eventKey];
            
            if ([timer respondsToSelector:@selector(invalidate)])
                [timer invalidate];
            
            [timers removeObjectForKey:eventKey];
        }
        
        [timers setObject:[NSTimer scheduledTimerWithTimeInterval:seconds target:target selector:aSelector userInfo:userInfo repeats:NO]
                   forKey:eventKey];
    }
}


static NSString * const LVFlagForArgumentWiseDebouncer = @"LVFlagForArgumentWiseDebouncer";

+ (void)fireAfter:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector withObject:(id)anArgument
{
    if (!target || !aSelector) {
        return;
    }
    
    @synchronized(self) {
        NSMutableArray *eventKey = [NSMutableArray arrayWithArray:@[LVFlagForArgumentWiseDebouncer, target, NSStringFromSelector(aSelector)]];
        
        if (anArgument) {
            [eventKey addObject:anArgument];
        }
        
        if ([timers objectForKey:eventKey]) {
            NSTimer *timer = [timers objectForKey:eventKey];
            
            if ([timer respondsToSelector:@selector(invalidate)])
                [timer invalidate];
            
            [timers removeObjectForKey:eventKey];
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"target": target,
                                                                                        @"selector": NSStringFromSelector(aSelector)}];
        if (anArgument)
        {
            [userInfo setObject:anArgument forKey:@"object"];
        }
        
        SEL targetSelector = @selector(handleArgumentWiseDebouncingWithUserInfo:);
        [timers setObject:[NSTimer scheduledTimerWithTimeInterval:seconds target:[self class] selector:targetSelector userInfo:userInfo repeats:NO]
                   forKey:eventKey];
    }
}


+ (void)handleArgumentWiseDebouncingWithUserInfo:(NSTimer *)timer {
    NSDictionary *userInfo = timer.userInfo;
    
    id target = userInfo[@"target"];
    SEL selector = NSSelectorFromString(userInfo[@"selector"]);
    id object = nil;
    if (userInfo[@"object"]) {
        object = userInfo[@"object"];
    }
    
    [target performSelector:selector withObject:object];
}

@end
