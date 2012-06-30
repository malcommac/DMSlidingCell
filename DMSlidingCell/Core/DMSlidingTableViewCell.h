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

#import <UIKit/UIKit.h>

enum {
    DMSlidingTableViewCellSwipeRight        = UISwipeGestureRecognizerDirectionRight,   // Reveal backgroundView only with a right swipe
    DMSlidingTableViewCellSwipeLeft         = UISwipeGestureRecognizerDirectionLeft,    // Reveal backgroundView only with a left swipe
    DMSlidingTableViewCellSwipeBoth         = -1,                                       // Reveal backgroundView is allowed both with right and left swipe
    DMSlidingTableViewCellSwipeNone         = -2                                        // Reveal is not active
}; typedef NSInteger DMSlidingTableViewCellSwipe;

enum {
    DMEventTypeWillOccurr   = 0,            // Posted event will occour
    DMEventTypeDidOccurr    = 1             // Posted event just occurred
}; typedef NSUInteger DMEventType;

typedef void (^DMSlidingTableViewCellEventHandler)(DMEventType eventType, BOOL backgroundRevealed, DMSlidingTableViewCellSwipe swipeDirection);

@interface DMSlidingTableViewCell : UITableViewCell {
    
}

@property (copy)                DMSlidingTableViewCellEventHandler          eventHandler;                   // Event delegate handler via blocks
@property (nonatomic,assign)    DMSlidingTableViewCellSwipe                 swipeDirection;                 // Allowed swipe-to-reveal direction

@property (readonly)            DMSlidingTableViewCellSwipe                 lastSwipeDirectionOccurred;     // Last swipe occurred
@property (nonatomic,readonly)  BOOL                                        backgroundIsRevealed;           // YES if backgroundView is visible

// Reveal or hide backgroundView
- (void) setBackgroundVisible:(BOOL) revealBackgroundView;

// Toggle backgroundView visibility by animating cell top view to set direction (works even if it's not allowed to swipeDirection, so be careful)
- (BOOL) toggleCellStatus;

@end
