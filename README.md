# SimpleKeyRemapper
A simple key remapper for Mac OS X written in Swift / Objective-C

The app uses Quartz Event Taps to intercept Key presses:

https://developer.apple.com/library/mac/documentation/Carbon/Reference/QuartzEventServicesRef/index.html

The UI allows you to gather a pair of keypresses, input and output - the program stores these pairs.  Then, it detects key presses, and if the keypress matches the input, it replaces it with the output.  It stores the hardware independent keycode and modifier flags - so it works beyond any Cocoa bindings.  The UI is all written in Swift, but the Quartz Event tap code was in objective-C (due to requiring C callbacks)
