//
//  ViewController.m
//  LinkLabel Demo
//
//  Created by Juan Carlos Perez on 9/3/17.
//  Copyright © 2017 Juan Carlos Perez. All rights reserved.
//

#import "LinkLabel.h"
#import "ViewController.h"

@interface ViewController () <LinkLabelInteractionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *text = @"This is some text, which incidentally includes a link you may find interesting";
    NSRange fullRange = NSMakeRange(0, text.length);
    NSRange linkRange = [text rangeOfString:@"includes a link"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:fullRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:fullRange];
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://google.com"] range:linkRange];
    
    NSDictionary *linkTextAttributes = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                         NSForegroundColorAttributeName : [UIColor greenColor]
                                         };
    
    NSDictionary *highlightedLinkTextAttributes = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                                    NSForegroundColorAttributeName : [UIColor redColor]
                                                    };
    
    LinkLabel *label = [LinkLabel new];
    label.numberOfLines = 0;
    label.attributedText = attributedString;
    label.linkTextAttributes = linkTextAttributes;
    label.highlightedLinkTextAttributes = highlightedLinkTextAttributes;
    label.interactionDelegate = self;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LinkLabelInteractionDelegate

- (void)didSelectLinkLabel:(LinkLabel *)linkLabel withURL:(NSURL *)url {
    NSLog(@"didSelectLinkLabel withURL: %@", url.absoluteString);
}


@end
