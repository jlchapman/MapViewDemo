// Copyright 2010 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

#import "MapViewDemoViewController.h"

@implementation MapViewDemoViewController

@synthesize mapView = _mapView;
@synthesize dynamicLayer = _dynamicLayer;
@synthesize searchPopover;
@synthesize searchViewController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set the delegate for the map view
	self.mapView.layerDelegate = self;
	
	//create an instance of a tiled map service layer
	AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:kTiledMapServiceURL]];
	
	//Add it to the map view
	[self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
	
	//create an instance of a dynmaic map layer
	self.dynamicLayer = [[AGSDynamicMapServiceLayer alloc] initWithURL:[NSURL URLWithString:kDynamicMapServiceURL]];
	
	//set visible layers
	self.dynamicLayer.visibleLayers = [NSArray arrayWithObjects:[NSNumber numberWithInt:2], nil];
	
	//name the layer. This is the name that is displayed if there was a property page, tocs, etc...
	[self.mapView addMapLayer:self.dynamicLayer withName:@"Dynamic Layer"];
	
	//set transparency
	self.dynamicLayer.opacity = 0.2;
    
    AGSSpatialReference *sr = [AGSSpatialReference spatialReferenceWithWKID:102100];
    sr = sr;    //stupid way to get rid of the warning
	double xmin, ymin, xmax, ymax;
    
    xmin = -12499380.2686831;
	ymin = 4821682.06706507;
	xmax = -12337555.4867002;
	ymax = 4957095.82330925;
    
    // zoom to the United States
	AGSEnvelope *env = [AGSEnvelope envelopeWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:sr];
	[self.mapView zoomToEnvelope:env animated:YES];
    
    searchViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil ];
    
    // Setup the popover for use in the detail view.
    searchPopover = [[UIPopoverController alloc] initWithContentViewController:searchViewController];
    searchPopover.popoverContentSize = CGSizeMake(240., 560.);
    searchPopover.delegate = (id)self;
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.mapView = nil;
	self.dynamicLayer = nil;
}


- (void)dealloc {
	
}

- (IBAction)opacitySliderValueChanged:(id)sender {
	// set the layer's opacity based on the value of the slider
	self.dynamicLayer.opacity = ((UISlider *)sender).value;
}

- (IBAction)Popup:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
	if (searchPopover.popoverVisible == NO) {
        searchViewController.passString = @"This is a test";
        [searchPopover presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}


#pragma mark AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView*)mapView {

	// comment to disable the GPS on start up
	[self.mapView.locationDisplay startDataSource];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
}

@end
