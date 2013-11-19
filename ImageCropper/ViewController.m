//
//  ViewController.m
//  ImageCropper
//
//  Created by Sandeep on 02/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import "ViewController.h"
#import "LayerDrawer.h"
#import "ImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SVProgressHUD.h>
#import "SelectionLayer.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, LayerDrawerDelegate>{
  BOOL isOverlayRunning;
}
- (IBAction)showCamera:(id)sender;

@property (nonatomic, strong) UIImage *croppedImage;
@property (nonatomic, strong) LayerDrawer *drawer;
@property (weak, nonatomic) IBOutlet ImageView *imageView;
@property (assign) BOOL insideView;
@property (weak, nonatomic) IBOutlet UIButton *clipButton;



@end

@implementation ViewController


- (void)dealloc{
	[_drawer removeObserver:self forKeyPath:@"clipped"];
  _drawer = nil;
  
}



- (void)viewDidLoad
{
    [super viewDidLoad];
  [self.imageView.layer setDelegate:_drawer];
  SelectionLayer *layer = [SelectionLayer layer];
  [layer setFrame:self.imageView.bounds];
  _drawer = [[LayerDrawer alloc] initWithLayer:layer andDelegate:self];
	[_drawer addObserver:self forKeyPath:@"clipped" options:NSKeyValueObservingOptionNew context:NULL];
  [[self.imageView layer] addSublayer:layer];
 }


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  if([keyPath isEqualToString:@"clipped"]){
    BOOL val = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    if(val){
      [self.clipButton setTitle:@"Unclip" forState:UIControlStateNormal];
      [self.drawer drawMarchingAnts];
    }else{
      [self.clipButton setTitle:@"Clip" forState:UIControlStateNormal];
      [self.drawer removeMarchingAnts];
    }
  }else
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
#pragma mark --- IBActions ---




- (IBAction)resetClip:(id)sender {
	[self.drawer resetClip];
}


- (IBAction)clipDrawing:(UIButton*)sender {
  if([self.drawer clipped]){
    [self.drawer unclipImage];
    
  }else{
  	[self.drawer clipImage];
    self.croppedImage = [self.drawer screenshotLayer];
  }
}

- (IBAction)saveAsImage:(id)sender{
  UIImage *image = [self.drawer screenshotLayer];
	[self saveAsImage:image];
  
}



- (void)saveImage:(UIImage*)image{
  NSData *data = UIImagePNGRepresentation(image);
  
  [SVProgressHUD showWithStatus:@"Saving"];
  ALAuthorizationStatus status =  [ALAssetsLibrary authorizationStatus];
  if(status == ALAuthorizationStatusAuthorized){
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
			dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
      });
    }];
  }else{
    [[[UIAlertView alloc] initWithTitle:@"Permission" message:@"Please set the appropriate setting in Settings for photo access" delegate:nil cancelButtonTitle:@"Oks" otherButtonTitles:nil, nil] show];
  }
}

- (IBAction)choosePhoto:(id)sender {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  [picker setDelegate:self];
  [self presentViewController:picker animated:YES completion:nil];
  
}

#pragma ---

#pragma mark --- UIImagePickerControllerDelegate methods ---

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  [self dismissViewControllerAnimated:YES completion:nil];
  NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
  if(CFStringCompare((__bridge CFStringRef)type, kUTTypeImage, 0) == kCFCompareEqualTo){
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(!isOverlayRunning){
    	[self.drawer drawImage:originalImage];
    }else{
     	[self saveImage:originalImage];
      isOverlayRunning = NO;
    }
  }
  
}

#pragma mark ---

#pragma mark --- Touch related UIResponder methods ---

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  UITouch *touch = [touches anyObject];
  CGPoint point = [touch locationInView:self.view];
  point = [self.view convertPoint:point toView:self.imageView];
  if(CGRectContainsPoint(self.imageView.frame, point)){
    [self.drawer clearAllPoints];
    _insideView = YES;
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  if(_insideView){
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageView];
//    point = [self.view convertPoint:point toView:self.imageView];
 		[self.drawer addPoint:point];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  if(_insideView ){
    _insideView = NO;
  }
}

#pragma mark ---

- (void)layerDrawer:(LayerDrawer *)drawer didCropAndResizeToBoundingBox:(CGRect)rect{
  
}

- (IBAction)showCamera:(id)sender {
  if(self.croppedImage){
    isOverlayRunning = YES;
	UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
  [pickerController setDelegate:self];
  [pickerController setAllowsEditing:YES];
  UIImageView *view  = [[UIImageView alloc] initWithFrame:[[pickerController view] frame]];
    [pickerController setCameraOverlayView:view];
    [view setImage:self.croppedImage];
    [self presentViewController:pickerController animated:YES completion:nil];
  }

}


@end
