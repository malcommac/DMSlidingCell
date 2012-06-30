//
//  DMSlidingTableViewCell.h
//  DMSlidingCell - UITableViewCell subclass that supports slide to reveal features
//                  as like in Twitter and many other programs
//
//  Created by Daniele Margutti on 6/29/12.
//  Software Engineering and UX Designer
//
//  Copyright (c) 2012 Daniele Margutti. All rights reserved.
//  Web:    http://www.danielemargutti.com
//  Email:  daniele.margutti@gmail.com
//  Skype:  daniele.margutti
//
//  HOW TO USE IT:
//  ==============
//  1. Just use this cell as base class for your sliding UITableViewCell
//  2. Put frontmost visible content on cell's contentView and hidden content inside the backgroundView
//  3. Set allowed swipe-to-reveal directions and you're done! The magic is here with a great animation


#import "DMSlidingTableViewCell.h"

#define kDMSlidingCellBounce            20.0f
#define kDMSlidingInAnimationDuration   0.2f
#define kDMSlidingOutAnimationDuration  0.1f

@interface DMSlidingTableViewCell() {
    NSMutableArray*                     associatedSwipeRecognizer;
    DMSlidingTableViewCellSwipe         lastSwipeDirectionOccurred;
    DMSlidingTableViewCellEventHandler  eventHandler;
    BOOL                                isAnimating;
}

- (UIGestureRecognizer *) swipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection) dir;
- (void) setOffsetForView:(UIView *) targetView offset:(CGPoint) offset;

@end

@implementation DMSlidingTableViewCell

@synthesize swipeDirection,lastSwipeDirectionOccurred;
@synthesize eventHandler;
@synthesize backgroundIsRevealed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        swipeDirection = DMSlidingTableViewCellSwipeNone;
        lastSwipeDirectionOccurred = DMSlidingTableViewCellSwipeNone;
        
        UIView *defaultBackgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
        defaultBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        defaultBackgroundView.backgroundColor = [UIColor darkGrayColor];
        self.backgroundView = defaultBackgroundView;
        
        self.swipeDirection = DMSlidingTableViewCellSwipeRight;
    }
    return self;
}

- (void) setSwipeDirection:(DMSlidingTableViewCellSwipe)newSwipeDirection {
    if (newSwipeDirection == swipeDirection) return;
    NSArray* loadedGestures = [self gestureRecognizers];
    [loadedGestures enumerateObjectsUsingBlock:^(UIGestureRecognizer* obj, NSUInteger idx, BOOL *stop) {
        [self removeGestureRecognizer:obj];
    }];
    
    swipeDirection = newSwipeDirection;
    if (swipeDirection != DMSlidingTableViewCellSwipeNone) {
        [self addGestureRecognizer:[self swipeGestureRecognizerWithDirection:
                                    UISwipeGestureRecognizerDirectionLeft]];
        
        [self addGestureRecognizer:[self swipeGestureRecognizerWithDirection:
                                    UISwipeGestureRecognizerDirectionRight]];
    }
}

- (UIGestureRecognizer *) swipeGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection) dir {
    UISwipeGestureRecognizer *swipeG = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleSwipeGesture:)];
    swipeG.direction = dir;
    return swipeG;
}


- (void)handleSwipeGesture:(UISwipeGestureRecognizer *) gesture {
    if (isAnimating)
        return;
    
    UISwipeGestureRecognizerDirection directionMade = gesture.direction;
    UISwipeGestureRecognizerDirection activeSwipe = self.swipeDirection;

    // If we allow both swipe direction allowed swipe used to slide out and bring back the contentView
    // is the last swipe taken: so if you swipe to the right to bring back the contentView you should
    // swipe to left, and viceversa.
    if (activeSwipe == DMSlidingTableViewCellSwipeBoth)
        activeSwipe = lastSwipeDirectionOccurred;
    if (lastSwipeDirectionOccurred == DMSlidingTableViewCellSwipeNone)
        lastSwipeDirectionOccurred = directionMade;
    
    // We can reveal background view only if background is not yet visible and:
    //  - swipe made = allowedSwipe
    //  - allowed swipe is DMSlidingTableViewCellSwipeBoth
    BOOL canRevealBack = ((directionMade == activeSwipe ||
                           self.swipeDirection == DMSlidingTableViewCellSwipeBoth)
                          && self.backgroundIsRevealed == NO);
    // You can hide backgroundView only if it's visible yet and
    // user's swipe is not the allowed (to reveal) swipe set.
    BOOL canHide = (self.backgroundIsRevealed && directionMade != activeSwipe);
    
    if (canRevealBack){
        [self setBackgroundVisible:YES];
        // save user's last swipe direction
        lastSwipeDirectionOccurred = directionMade;
    } else if (canHide) {
        [self setBackgroundVisible:NO];
        if (self.swipeDirection == DMSlidingTableViewCellSwipeBoth)
            lastSwipeDirectionOccurred = DMSlidingTableViewCellSwipeNone;
    }
}

- (BOOL) toggleCellStatus {
    if (lastSwipeDirectionOccurred == DMSlidingTableViewCellSwipeNone)
        return NO;

    [self setBackgroundVisible:(self.backgroundIsRevealed ? NO : YES)];
    return YES;
}

- (BOOL) backgroundIsRevealed {
    // Return YES if cell's contentView is not visible (backgroundView is revealed)
    return (self.contentView.frame.origin.x < 0 ||
            self.contentView.frame.origin.x >= self.contentView.frame.size.width);
}

- (void) setBackgroundVisible:(BOOL) revealBackgroundView {
    if (isAnimating) return;
    CGFloat offset_x = 0.0f;
    CGFloat bounce_distance = kDMSlidingCellBounce;
    CGFloat contentViewWidth = self.contentView.frame.size.width;

    UISwipeGestureRecognizerDirection swipeMade = lastSwipeDirectionOccurred;
    if (swipeMade == UISwipeGestureRecognizerDirectionLeft) {
        offset_x = (revealBackgroundView ? -contentViewWidth : contentViewWidth);
        bounce_distance = (revealBackgroundView ? 0.0f : kDMSlidingCellBounce);
    } else if (swipeMade == UISwipeGestureRecognizerDirectionRight) {
        offset_x = (revealBackgroundView ? contentViewWidth : - contentViewWidth);
        bounce_distance = (revealBackgroundView ? 0.0f : -kDMSlidingCellBounce);
    }
    
    if (eventHandler)
        eventHandler(DMEventTypeWillOccurr,revealBackgroundView,lastSwipeDirectionOccurred);
    
    isAnimating = YES;
    if (revealBackgroundView) {
        [UIView animateWithDuration:kDMSlidingInAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setOffsetForView:self.contentView offset:CGPointMake(offset_x, 0.0f)];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 isAnimating = NO;
                                 if (eventHandler)
                                     eventHandler(DMEventTypeDidOccurr,revealBackgroundView,lastSwipeDirectionOccurred);
                             }
                             
                         }];
    } else {
        [UIView animateWithDuration:kDMSlidingOutAnimationDuration
                              delay:0.0f
                            options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self setOffsetForView:self.contentView offset:CGPointMake(offset_x, 0.0f)];
                         } completion:^(BOOL finished) {
                            [UIView animateWithDuration:kDMSlidingOutAnimationDuration
                                                  delay:0
                                                options:UIViewAnimationCurveLinear
                                             animations:^{
                                                 [self setOffsetForView:self.contentView
                                                                    offset:CGPointMake(bounce_distance, 0.0f)];
                                             } completion:^(BOOL finished) {
                                                 [UIView animateWithDuration:kDMSlidingOutAnimationDuration
                                                                       delay:0.0f
                                                                     options:UIViewAnimationCurveLinear
                                                                  animations:^{
                                                                       
                                                                   } completion:^(BOOL finished) {
                                                                       [self setOffsetForView:self.contentView
                                                                                       offset:CGPointMake(-bounce_distance, 0.0f)];
                                                                       
                                                                        if (eventHandler)
                                                                            eventHandler(DMEventTypeDidOccurr,revealBackgroundView,lastSwipeDirectionOccurred);
                                                                     
                                                                       if (finished)
                                                                           isAnimating = NO;
                                                                   }];
                                              }];
                         }];
    }
}

- (void) setOffsetForView:(UIView *) targetView offset:(CGPoint) offset {
    targetView.frame = CGRectOffset(targetView.frame, offset.x, offset.y);
}

@end
