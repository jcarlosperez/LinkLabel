//
//  UITapGestureRecognizer+LabelLinks.h
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface UIGestureRecognizer (LabelLinks)

- (int)indexOfCharacterTouchedInLabel:(UILabel *)label;

@end

@interface UILabel (LabelLinks)

- (int)indexOfCharacterAtPoint:(CGPoint)point;

@end
