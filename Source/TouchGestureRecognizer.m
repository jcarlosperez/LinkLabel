//
//  TouchGestureRecognizer.m
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import "TouchGestureRecognizer.h"

@implementation TouchGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if(self.state == UIGestureRecognizerState.possible) {
    self.state = UIGestureRecognizerState.began;
  }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.state = UIGestureRecognizerState.changed;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.state = UIGestureRecognizerState.ended;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.state = UIGestureRecognizerState.cancelled;
}
@end
