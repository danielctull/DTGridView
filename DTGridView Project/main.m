//
//  main.m
//  DTGridView
//
//  Created by Daniel Tull on 10.02.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
#if __has_feature(objc_arc)
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, nil);
    }
#else
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
#endif
}
