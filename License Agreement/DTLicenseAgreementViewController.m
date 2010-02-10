//
//  DTLicenseAgreementViewController.m
//  DTKit
//
//  Created by Daniel Tull on 25.04.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DTLicenseAgreementViewController.h"


@implementation DTLicenseAgreementViewController

@synthesize webView;

- (id)init {
	if (!(self = [self initWithNibName:@"DTLicenseAgreementView" bundle:nil]))
		return nil;
	
	self.title = @"Source License";
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *webString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"license" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
	[self.webView loadHTMLString:webString baseURL:nil];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[webView release]; webView = nil;
    [super dealloc];
}


@end
