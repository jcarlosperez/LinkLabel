//
//  UITapGestureRecognizer+LabelLinks.m
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import "UITapGestureRecognizer+LabelLinks.h"

@implementation UIGestureRecognizer (LabelLinks)

- (int)indexOfCharacterTouchedInLabel:(UILabel *)label {
    CGPoint locationOfTouchInLabel = [self locationInView:label];
    return [label indexOfCharacterAtPoint:locationOfTouchInLabel];
}

@end

@implementation UILabel (LabelLinks)

- (int)indexOfCharacterAtPoint:(CGPoint)point {
    if(self.attributedText == nil) {
        return nil;
    }
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    textContainer.lineFragmentPadding = 0;
    textContainer.lineBreakMode = self.lineBreakMode;
    textContainer.maximumNumberOfLines = self.numberOfLines;
    textContainer.size = self.bounds.size;
    
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    
    if(!CGRectContainsPoint(textBoundingBox, point)) {
        return nil;
    }
    
    CGPoint textContainerOffset = CGPointMake((self.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, (self.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(point.x - textContainerOffset.x, point.y - textContainerOffset.y);
    
    int indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer inTextContainer:textContainer fractionOfDistanceBetweenInsertionPoints:nil];
    return indexOfCharacter;
}

@end
