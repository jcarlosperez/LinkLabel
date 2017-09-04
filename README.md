# LinkLabel
UILabel with custom hyperlink styling, optional interaction delegate, minimal setup

![](http://i.imgur.com/fjHOieW.png)


## What’s up
Creating a UILabel with attributed text, links appear blue and underlined, and in most cases you don’t want them to be. It’s pretty awkward and a time-kill to try and make them simply be styled the way you desire.

LinkLabel makes this all easy. *Without any extra code*, links appear the same colour as the rest of your text, but underlined. It’s what the default *should* be.

If you want to add custom styling, that’s super simple, too. Same as you would specify attributes for your attributedText, any attributes you want to be different about your links, you add to LinkLabel’s `linkTextAttributes`, and `highlightedLinkTextAttributes`.

## Install Manually
1. Drag contents of `Source` folder into your Xcode project.

## Usage
Create a label using `LinkLabel`, instead of UILabel.

```
LinkLabel *myLabel = [[LinkLabel alloc] init];
```

Setup attributed text, including `NSLinkAttributeName`, as normal.

```
NSString *text = @"This is some text, which incidentally includes a link you may find interesting";
NSRange fullRange = NSMakeRange(0, text.length);
NSRange linkRange = [text rangeOfString:@"includes a link"];

NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:fullRange];
[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:fullRange];
[attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"https://google.com"] range:linkRange];
```

To make it easier to respond to link taps, I’ve added in an interaction delegate. Adopt `LinkLabelInteractionDelegate`, and then implement the delegate function:

```
label.interactionDelegate = self
```

```
#pragma mark - LinkLabelInteractionDelegate

- (void)didSelectLinkLabel:(LinkLabel *)linkLabel withURL:(NSURL *)url {
    NSLog(@"didSelectLinkLabel withURL: %@", url.absoluteString);
}

```

## Original Credit

Created by [Andrew Hart](http://twitter.com/AndrewProjDent), for TwIM.

[ProjectDent.com](http://ProjectDent.com)

[@ProjectDent](http://twitter.com/ProjectDent)
