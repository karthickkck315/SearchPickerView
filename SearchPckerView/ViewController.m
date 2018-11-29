//
//  ViewController.m
//  SearchPckerView
//
//  Created by karthick on 10/5/17.
//  Copyright © 2017 Com. All rights reserved.
//

#import "ViewController.h"
#import "PickerView.h"
@interface ViewController ()<PickerViewDelegate,UITextFieldDelegate>
{
    PickerView *bankNameListPicker;
    UITextField *textField;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"Select";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    
}

-(void)showPickerView{
    [self.view endEditing:YES];
    
    NSMutableArray *shoppingList = [NSMutableArray arrayWithObjects:@"Eggs", @"Milk",@"Shop",@"Shopped",@"Shopping",@"Show",@"Water",@"tree",nil];
    bankNameListPicker = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withNSArray:shoppingList];
    bankNameListPicker.delegate = self;
    [self.view addSubview:bankNameListPicker];
    [bankNameListPicker showPicker];
    textField.inputView = bankNameListPicker;
    
}
#pragma mark PickerViewDelegate
-(void)selectedRow:(int)row withString:(NSString *)text{
    
    NSLog(@"Selected=%d & Selected Text=%@",row,text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)textFieldDidBeginEditing:(UITextField *)textFields{
    
        [self showPickerView];
        [self animateTextField:textFields up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textFields{
        [self animateTextField:textFields up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
@end
