//
//  AppDelegate.h
//  XMLToObjecter
//
//  Created by 한인택 on 13. 9. 25..
//  Copyright (c) 2013년 tegine. All rights reserved.
//
// Myname is Intaek, Han. [KOREAN MAN]

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSTextFieldDelegate>{
    NSString *text;
    NSMutableArray *keyArr;
}

@property (assign) IBOutlet NSWindow *window;
//@property (weak) IBOutlet NSView *kAboutWindow;

@property (weak) IBOutlet NSView *kLabel;

@property (weak) IBOutlet NSButton *kPassButton;

@property (weak) IBOutlet NSButton *kXmlToJsonButton;
@property (weak) IBOutlet NSButton *kXmlToXcodeObjButton;
@property (weak) IBOutlet NSButton *kURLGetButton;

@property (weak) IBOutlet NSTextField *kCopyTF;
@property (weak) IBOutlet NSTextField *kOrgTF;
@property (weak) IBOutlet NSTextField *kURLTF;


@end
