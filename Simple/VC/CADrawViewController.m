//
//  CADrawViewController.m
//  Simple
//
//  Created by ehsy on 16/5/30.
//  Copyright © 2016年 ehsy. All rights reserved.
//

#import "CADrawViewController.h"
#import "CGView.h"

#define WIDTH 10
#define HEIGHT 10
#define DEPTH 10
#define SIZE 100
#define SPACING 150
#define CAMERA_DISTANCE 500
#define PERSPECTIVE(z) (float)CAMERA_DISTANCE/(z + CAMERA_DISTANCE)

@interface CADrawViewController ()

{
    NSMutableSet *recyclePool;

    UIScrollView *scrollView;
}
@end

@implementation CADrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self layoutViews];
    [self layoutOtherViews];
    
    
}


- (void)layoutViews
{
    CGView *cView = [[CGView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:cView];
}

- (void)layoutOtherViews
{
    recyclePool = [NSMutableSet set];
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    //set content size
    scrollView.contentSize = CGSizeMake((WIDTH - 1)*SPACING, (HEIGHT - 1)*SPACING);
    
    //set up perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    scrollView.layer.sublayerTransform = transform;
    
//    //create layers
//    for (int z = DEPTH - 1; z >= 0; z--) {
//        for (int y = 0; y < HEIGHT; y++) {
//            for (int x = 0; x < WIDTH; x++) {
//                //create layer
//                CALayer *layer = [CALayer layer];
//                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
//                layer.position = CGPointMake(x*SPACING, y*SPACING);
//                layer.zPosition = -z*SPACING;
//                //set background color
//                layer.backgroundColor = [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1].CGColor;
//                //attach to scroll view
//                [scrollView.layer addSublayer:layer];
//            }
//        }
//    }
//    
//    //log
//    NSLog(@"displayed: %i", DEPTH*HEIGHT*WIDTH);
}

- (void)viewDidLayoutSubviews
{
    [self updateLayers];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateLayers];
}

- (void)updateLayers {
    
    //calculate clipping bounds
    CGRect bounds = scrollView.bounds;
    bounds.origin = scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE/2, -SIZE/2);
    //add existing layers to pool
    [recyclePool addObjectsFromArray:scrollView.layer.sublayers];
    //disable animation
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    //create layers
    NSInteger recycled = 0;
    NSMutableArray *visibleLayers = [NSMutableArray array];
    for (int z = DEPTH - 1; z >= 0; z--)
    {
        //increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z*SPACING);
        adjusted.size.height /= PERSPECTIVE(z*SPACING);
        adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2; adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
        for (int y = 0; y < HEIGHT; y++) {
            //check if vertically outside visible rect
            if (y*SPACING < adjusted.origin.y ||
                y*SPACING >= adjusted.origin.y + adjusted.size.height)
            {
                continue;
            }
            for (int x = 0; x < WIDTH; x++) {
                //check if horizontally outside visible rect
                if (x*SPACING < adjusted.origin.x ||
                    x*SPACING >= adjusted.origin.x + adjusted.size.width)
                {
                    continue;
                }
                //recycle layer if available
                CALayer *layer = [recyclePool anyObject]; if (layer)
                {
                    
                    recycled ++;
                    [recyclePool removeObject:layer]; }
                else
                {
                    layer = [CALayer layer];
                    layer.frame = CGRectMake(0, 0, SIZE, SIZE); }
                //set position
                layer.position = CGPointMake(x*SPACING, y*SPACING); layer.zPosition = -z*SPACING;
                //set background color
                layer.backgroundColor =
                [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1].CGColor;
                //attach to scroll view
                [visibleLayers addObject:layer]; }
        } }
    [CATransaction commit]; //update layers
    scrollView.layer.sublayers = visibleLayers;
    //log
    NSLog(@"displayed: %lu/%i recycled: %li",
          (unsigned long)[visibleLayers count], DEPTH*HEIGHT*WIDTH, (long)recycled);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
