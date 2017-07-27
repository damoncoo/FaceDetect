//
//  FEImageView.m
//  FeiliEmotion
//
//  Created by Darcy on 2017/7/26.
//  Copyright © 2017年 Nathan Ou. All rights reserved.
//

#import "FEImageView.h"

#pragma mark - FLWeakProxy

@interface FLWeakProxy : NSObject

@property (nonatomic, weak) id target;

@end

@implementation FLWeakProxy

#pragma mark Life Cycle

// This is the designated creation method of an `FLWeakProxy` and
// as a subclass of `NSProxy` it doesn't respond to or need `-init`.
+ (instancetype)weakProxyForObject:(id)targetObject
{
    FLWeakProxy *weakProxy = [[FLWeakProxy alloc]init];
    weakProxy.target = targetObject;
    return weakProxy;
}

#pragma mark Forwarding Messages

- (id)forwardingTargetForSelector:(SEL)selector
{
    // Keep it lightweight: access the ivar directly
    return _target;
}


#pragma mark - NSWeakProxy Method Overrides
#pragma mark Handling Unimplemented Methods

- (void)forwardInvocation:(NSInvocation *)invocation
{
    // Fallback for when target is nil. Don't do anything, just return 0/NULL/nil.
    // The method signature we've received to get here is just a dummy to keep `doesNotRecognizeSelector:` from firing.
    // We can't really handle struct return types here because we don't know the length.
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    // We only get here if `forwardingTargetForSelector:` returns nil.
    // In that case, our weak target has been reclaimed. Return a dummy method signature to keep `doesNotRecognizeSelector:` from firing.
    // We'll emulate the Obj-c messaging nil behavior by setting the return value to nil in `forwardInvocation:`, but we'll assume that the return value is `sizeof(void *)`.
    // Other libraries handle this situation by making use of a global method signature cache, but that seems heavier than necessary and has issues as well.
    // See https://www.mikeash.com/pyblog/friday-qa-2010-02-26-futures.html and https://github.com/steipete/PSTDelegateProxy/issues/1 for examples of using a method signature cache.
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}


@end


static const NSInteger RefreshFrequency = 5;

@interface FEImageView()

@property (nonatomic, assign, readwrite) NSUInteger currentFrameIndex;

@property (nonatomic, assign, readwrite) CGFloat timeElapse;

@end

@implementation FEImageView

- (void)startAnimation {
    if (!self.images.count) {
        return;
    }
    
    self.totalImageCount = self.images.count;
    if (self.totalImageCount == 1) {
        self.image = self.images.firstObject;
        return;
    }
    
    self.isAnimating = YES;
    if (self.images) {
        // Lazily create the display link.
        if (!self.displayLink) {
            // It is important to note the use of a weak proxy here to avoid a retain cycle. `-displayLinkWithTarget:selector:`
            // will retain its target until it is invalidated. We use a weak proxy so that the image view will get deallocated
            // independent of the display link's lifetime. Upon image view deallocation, we invalidate the display
            // link which will lead to the deallocation of both the display link and the weak proxy.
            FLWeakProxy *weakProxy = [FLWeakProxy weakProxyForObject:self];
            self.displayLink = [CADisplayLink displayLinkWithTarget:weakProxy selector:@selector(displayDidRefresh:)];
            
            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        
        // Note: The display link's `.frameInterval` value of 1 (default) means getting callbacks at the refresh rate of the display (~60Hz).
        // Setting it to 2 divides the frame rate by 2 and hence calls back at every other display refresh.
        self.displayLink.frameInterval = RefreshFrequency;
        self.displayLink.paused = NO;
        self.timeElapse = 0;
    }
}

- (void)stopAnimation {
    
    self.isAnimating = NO;
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)displayDidRefresh:(CADisplayLink *)displayLink
{
    if (self.currentFrameIndex >= self.images.count - 1) {
        self.currentFrameIndex = 0;
    }
    self.timeElapse += (RefreshFrequency/60.0);
    self.currentFrameIndex = (NSInteger)(self.timeElapse/(self.totalDuration/self.images.count))%self.images.count;
    
    UIImage *image = [self.images objectAtIndex:self.currentFrameIndex];
    self.image = image;
    
    [self.layer setNeedsDisplay];
}

- (void)displayLayer:(CALayer *)layer
{
    layer.contents = (__bridge id)self.image.CGImage;
}


@end
