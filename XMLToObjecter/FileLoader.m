//
//  FileLoader.m
//  XMLToObjecter
//
//  Created by 한인택 on 13. 9. 25..
//  Copyright (c) 2013년 tegine. All rights reserved.
//

#import "FileLoader.h"

@implementation FileLoader {
    
}

+ (NSString*) fileOpen:(NSString *)path{
 
    NSError *err = nil;
    
    NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if(!contents) {
        //handle error
    }
    return contents;
}
@end
