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

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

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
  CALayer *layer = [CALayer layer];
  [layer setBounds:self.imageView.bounds];
  [layer setPosition:self.imageView.center];
  _drawer = [[LayerDrawer alloc] initWithLayer:layer];
	[_drawer addObserver:self forKeyPath:@"clipped" options:NSKeyValueObservingOptionNew context:NULL];
  [[self.imageView layer] addSublayer:layer];
 }


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  if([keyPath isEqualToString:@"clipped"]){
    BOOL val = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    if(val){
      [self.clipButton setTitle:@"Unclip" forState:UIControlStateNormal];
    }else{
      [self.clipButton setTitle:@"Clip" forState:UIControlStateNormal];
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
  UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self.drawer drawImage:originalImage];
  
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
    CGPoint point = [touch locationInView:self.view];
    point = [self.view convertPoint:point toView:self.imageView];
 		[self.drawer addPoint:point];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  if(_insideView ){
    _insideView = NO;
  }
}

#pragma mark ---

@end
