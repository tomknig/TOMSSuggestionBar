# TOMSSuggestionBar
Smoothly animated suggestions for text inputs with super easy CoreData hook.
The main approach of this project is to make ![Apples keyboard suggestion bar](http://www.apple.com/ios/ios8/quicktype/) accessible for developers.
With TOMSSuggestionBar you can easily mimic its appearance and behavior but provide your custom datasource.

## Demo

![Screen1](demo.gif)

## Installation with CocoaPods

TOMSMorphingLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

#### Podfile

```ruby
platform :ios, '7.0'
pod "TOMSSuggestionBar", "~> 0.1.0"
```

## Quick Start

Simply instantiate TOMSSuggestionBar and subscribe a textField to the suggestions.
The following suggestionBar would suggest `name` values of instances of type `Person` which was defined in `Model.xcdatamodeld`.

```objective-c
TOMSSuggestionBar *suggestionBar = [[TOMSSuggestionBar alloc] init];
[suggestionBar subscribeTextInputView:self.textField
       toSuggestionsForAttributeNamed:@"name"
                        ofEntityNamed:@"Person"
                         inModelNamed:@"Model"];
```

## Customization

A suggestionBar can be instantiate with an alternative number of suggestionFields.

```objective-c
TOMSSuggestionBar *suggestionBar = [[TOMSSuggestionBar alloc] initWithNumberOfSuggestionFields:5];
```

## Author

[Tom König](http://github.com/TomKnig) [@TomKnig](https://twitter.com/TomKnig)

## License

TOMSSuggestionBar is available under the MIT license. See the LICENSE file for more info.
