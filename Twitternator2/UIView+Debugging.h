//
//  UIView+Debugging.h
//  Twitternator2
//
//  Created by Bernardo Santana on 9/8/15.
//  Copyright (c) 2015 Bernardo Santana. All rights reserved.
//

#import <UIKit/UIKit.h>

// with this you can add a breakpoint and call po view.recursiveDescription() from the lldb
@interface UIView (Debugging)
- (id)recursiveDescription;
@end