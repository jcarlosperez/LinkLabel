//
//  LinkLabel.h
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LinkLabelInteractionDelegate;

@interface LinkLabel : UILabel <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSDictionary *highlightedLinkTextAttributes;
@property (strong, nonatomic) NSDictionary *linkTextAttributes;
@property (weak, nonatomic) NSObject <LinkLabelInteractionDelegate> *interactionDelegate;

@end

@protocol LinkLabelInteractionDelegate

- (void)didSelectLinkLabel:(LinkLabel *)linkLabel withURL:(NSURL *)url;

@end
