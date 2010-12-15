//
//  DTLicenseAgreementViewController.h
//  DTKit
//
//  Created by Daniel Tull on 25.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTLicenseAgreementViewController : UIViewController {
	UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
