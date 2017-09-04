//
//  LinkLabel.h
//  ObjC port of LinkLabel by Andrew Dart
//
//  Created by Juan Carlos Perez on 09/03/2017.
//  Copyright (c) 2017 Juan Carlos Perez. All rights reserved.
//

#import "LinkLabel.h"
#import "NSMutableAttributedString+RemoveAttributes.h"
#import "TouchGestureRecognizer.h"
#import "UITapGestureRecognizer+LabelLinks.h"

@interface Attribute : NSObject

@property (strong, nonatomic) NSString *attributeName;
@property (strong, nonatomic) id value;
@property (strong, nonatomic) NSRange *range;

@end

@implementation Attribute

- (instancetype)initWithAttributeName:(NSString *)attributeName value:(id)value range:(NSRange *)range {
  if(self = [super init]) {
    self.attributeName = attributeName;
    self.value = value;
    self.range = range;
  }
  return self;
}

@end

@interface LinkAttribute : NSObject

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSRange *range;

- (instancetype)initWithURL:(NSURL *)URL range:(NSRange *)range;

@end

@implementation LinkAttribute

- (instancetype)initWithURL:(NSURL *)URL range:(NSRange *)range {
  if(self = [super init]) {
    self.url = URL;
    self.range = range;
  }
  return self;
}
@end

@interface LinkLabel ()

@property (strong, nonatomic) NSArray <LinkAttribute *> *linkAttributes;
@property (strong, nonatomic) NSArray <Attribute *> *standardTextAttributes;
@property (strong, nonatomic) LinkAttribute *highlightedLinkAttribute;

@end

@implementation LinkLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  NSAssert(NO, @"initWithCoder: has not been implemented yet");
}

- (instancetype)initWithFrame:(CGRect)frame {

  _highlightedLinkTextAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
  _linkTextAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};

  if(self = [super initWithFrame:frame]) {
    self.isUserInteractionEnabled = YES;

    TouchGestureRecognizer *touchGestureRecognizer = [[TouchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToLinkLabelTouched:)];
    touchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:touchGestureRecognizer];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToLinkLabelTapped:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];

    [self setupAttributes];
  }

  return self;
}

- (NSAttributedString *)attributedText {
  return super.attributedText;
}

- (NSURL *)urlLinkAtPoint:(CGPoint)point {
  int indexOfCharacter = [self indexOfCharacterAtPoint:point];
  if(indexOfCharacter == nil) {
    return nil;
  }
  for(LinkAttribute *linkAttribute in self.linkAttributes) {
    if(indexOfCharacter >= linkAttribute.range.location && indexOfCharacter <= linkAttribute.range.location + linkAttribute.range.length) {
      return linkAttribute.url;
    }
  }
  return nil;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  if(attributedText == nil) {
    super.attributedText = attributedText;
    return;
  }

  super.attributedText = attributedText;

  if(attributedText != nil) {
    NSRange range = NSMakeRange(0, self.attributedText.length);
    NSMutableAttributedString *mutableAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];

    NSMutableArray *standardAttributes = [NSMutableArray new];
    NSMutableArray *linkAttributes = [NSMutableArray new];

    [self.attributedText enumerateAttributesInRange:range options:kNilOptions usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {

      [attrs enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSAttributedStringKey  _Nonnull attribute, BOOL * _Nonnull stop) {

        if(attribute.key == NSLinkAttributeName) {
          if([attribute.value isKindOfClass:[NSURL class]) {
            LinkAttribute *linkAttribute = [[LinkAttribute alloc] initWithURL:attribute.value range:range];
            [linkAttributes addObject:linkAttribute];
          }
        } else {
          Attribute *attribute = [[Attribute alloc] initWithAttributeName:attribute.key value:attribute.value range:range];
          [standardAttributes addObject:attribute];
        }

      }];

    }];

    self.standardTextAttributes = standardAttributes;
    self.linkAttributes = linkAttributes;

  }

  [self setupAttributes];
}

- (void)setHighlightedLinkTextAttributes:(NSDictionary *)highlightedLinkTextAttributes {
  self.highlightedLinkTextAttributes = highlightedLinkTextAttributes;
  [self setupAttributes];
}

- (void)setHighlightedLinkAttribute:(LinkAttribute *)linkAttribute {
  if(self.highlightedLinkAttribute != linkAttribute) {
    self.highlightedLinkAttribute = linkAttribute;
    [self setupAttributes];
  }
}

- (void)setLinkTextAttributes:(NSDictionary *)linkTextAttributes {
  self.linkTextAttributes = linkTextAttributes;
  [self setupAttributes];
}

- (void)setupAttributes {
  if(self.attributedText == nil) {
    super.attributedText = nil;
    return;
  }

  NSMutableAttributedString *mutableAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
  [mutableAttributedText removeAttributes];

  for(Attribute *attribute in self.standardTextAttributes) {
    [mutableAttributedText addAttribute:attribute.attributeName value:attribute.value range:attribute.range];
  }

  for(LinkAttribute *linkAttribute in self.linkAttributes) {
    if(linkAttribute === self.highlightedLinkAttribute) {
      [self.highlightedLinkTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [mutableAttributedText addAttribute:key value:value range:linkAttribute.range];
      }];
    } else {
      [self.linkTextAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        [mutableAttributedText addAttribute:key value:value range:linkAttribute.range];
      }];
    }
  }
  super.attributedText = mutableAttributedText;
}

- (void)respondtoLinkLabelTapped:(UITapGestureRecognizer *)gestureRecognizer {
  if(self.linkAttributes.count == 0) {
    return;
  }

  int indexOfCharacterTouched = [gestureRecognizer indexOfCharacterTouched:self];

  if(indexOfCharacterTouched) {
    for(LinkAttribute *linkAttribute in self.linkAttributes) {
      if(indexOfCharacterTouched >= linkAttribute.range.location && indexOfCharacterTouched <= linkAttribute.range.location + linkAttribute.range.length) {
        [self.interactionDelegate didSelectLinkLabel:self withURL:linkAttribute.url];
        break;
      }
    }
  }
}

- (void)respondToLinkLabelTouched:(TouchGestureRecognizer *)gestureRecognizer {
  if(self.linkAttributes.count == 0) {
    return;
  }

  if(gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed) {
    int indexOfCharacterTouched = [gestureRecognizer indexOfCharacterTouched:self];

    if(indexOfCharacterTouched) {
      for(LinkAttribute *linkAttribute in self.linkAttributes) {
        if(indexOfCharacterTouched >= linkAttribute.range.location && indexOfCharacterTouched <= linkAttribute.range.location + linkAttribute.range.length) {
          self.highlightedLinkAttribute = linkAttribute;
          return;
        }
      }
    }
    self.highlightedLinkAttribute = nil;
  } else if (gestureRecognizer.state = UIGestureRecognizerState.ended || gestureRecognizer.state = UIGestureRecognizerState.failed || gestureRecognizer.state = UIGestureRecognizerState.cancelled) {
    self.highlightedLinkAttribute = nil;
  }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(NSGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(NSGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

@end
