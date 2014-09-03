//
//  PdSettingsViewController.h
//  SARA
//
//  Created by Chris Yanc on 3/20/14.
//
//

#import <UIKit/UIKit.h>

@interface PdSettingsViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    
}
@property (retain, nonatomic) IBOutlet UILabel *PDLabel;
@property (retain, nonatomic) IBOutlet UIButton *SelectNewBtn;
//@property (retain, nonatomic) IBOutlet UIPickerView *SampleRatePicker;
@property (retain, nonatomic) NSArray *BufferSizeArray;
@property (retain, nonatomic) NSArray *SampleRateArray;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

/*
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
*/

@end
