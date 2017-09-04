//
//  NSMutableAttributedString+RemoveAttributes.h
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (RemoveAttributes)

- (void)removeAttributes;

- (void)removeAttributesInRange:(NSRange)range;

@end
