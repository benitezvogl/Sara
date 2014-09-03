//
//  MyCanvas.h
//  SARA
//
//  Created by Chris Yanc on 4/27/14.
//
//

#import <UIKit/UIKit.h>

@interface MyCanvas : UIView {
    UIColor *col;
    NSMutableArray *colors;
    int w;
    int h;
    int size;
}

@property(strong, nonatomic)UIColor *col;
@property(strong, nonatomic)NSMutableArray *colors;

-(void)UpdateArray:(NSMutableArray *)arr;
-(void)DrawCircle:(CGRect)rect color:(UIColor*)color;

@end
