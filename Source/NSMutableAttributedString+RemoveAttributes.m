//
//  NSMutableAttributedString+RemoveAttributes.h
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import "NSMutableAttributedString+RemoveAttributes.h"

@implementation NSMutableAttributedString (RemoveAttributes)

- (void)removeAttributes {
  NSRange range = NSMakeRange(0, self.length);
  [self removeAttributesInRange:range];
}

- (void)removeAttributesInRange:(NSRange)range {
  [string enumerateAttributesInRange:range options:kNilOptions usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    [attrs enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSAttributedStringKey  _Nonnull obj, BOOL * _Nonnull stop) {
        [self removeAttribute:obj range:range];
    }];
  }];
}

@end
