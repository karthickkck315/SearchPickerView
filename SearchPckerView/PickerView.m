//  PickerView.m


#import "PickerView.h"

@implementation PickerView
@synthesize arrRecords,delegate;


-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrRecords = arrValues;
    }
    return self;

}
-(void)showPicker {
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification object:nil];
    
    self.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor clearColor];
    
    copyListOfItems = [[NSMutableArray alloc] init];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height-216, self.frame.size.width, 216)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;

    toolView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-256, self.frame.size.width, 44)];
    toolView.userInteractionEnabled = true;
    toolView.backgroundColor = [UIColor lightGrayColor];
    
    txtSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 7, 240, 31)];
    txtSearch.tag = 1;
    txtSearch.barStyle = UIBarStyleBlackTranslucent;
    txtSearch.backgroundColor = [UIColor clearColor];
    txtSearch.delegate = self;
    txtSearch.userInteractionEnabled = true;
    [toolView addSubview:txtSearch];
    
    for (UIView *subview in txtSearch.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton addTarget:self
               action:@selector(btnDoneClick)
     forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.frame = CGRectMake(self.frame.size.width-100, 0, 100.0, 44.0);
    [toolView addSubview:doneButton];
    
    [self addSubview:pickerView];
    [self addSubview:toolView];
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
 
    searching = NO;
	letUserSelectRow = NO;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
    
		searching = YES;
		letUserSelectRow = YES;
    
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;

	}
	
	[pickerView reloadAllComponents];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
//    [self btnDoneClick];
    [searchBar resignFirstResponder];
}

- (void) searchTableView {
	
	NSString *searchText = txtSearch.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];

	
	for (NSString *sTemp in self.arrRecords)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0){
			[copyListOfItems addObject:sTemp];
        }
	}
    [pickerView reloadAllComponents];
	
	searchArray = nil;
}

-(void)keyboardWillShowNotification:(NSNotification *)notification{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width);
    pickerView.frame = CGRectMake(0, self.frame.size.height-(216+height), self.frame.size.width, 216);
    //picketToolbar.frame = CGRectMake(0, self.frame.size.height-(256+height), self.frame.size.width, 44);
    toolView.frame = CGRectMake(0, self.frame.size.height-(256+height), self.frame.size.width, 44);
}

-(void)keyboardWillHideNotification:(id)sender{

    pickerView.frame = CGRectMake(0.0, self.frame.size.height-216, self.frame.size.width, 216);
    //picketToolbar.frame = CGRectMake(0, self.frame.size.height-256, self.frame.size.width, 44);
    toolView.frame = CGRectMake(0, self.frame.size.height-256, self.frame.size.width, 44);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)btnDoneClick {
    
    NSString *strSelectedValue;
    
    if (searching ) {
        
        if (copyListOfItems.count > 0) {
            
            strSelectedValue = [copyListOfItems objectAtIndex:[pickerView selectedRowInComponent:0]];
            int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
                [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
            }
            
        }else{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
                [self.delegate selectedRow:-1 withString:@"NOT FOUND"];
            }
        }
        
    }else{
        
        strSelectedValue = [arrRecords objectAtIndex:[pickerView selectedRowInComponent:0]];
        int selectedIndex = [self.arrRecords indexOfObject:strSelectedValue];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRow:withString:)]) {
            [self.delegate selectedRow:selectedIndex withString:strSelectedValue];
        }
    }
    
    [self removeFromSuperview];

}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (searching) {
        return copyListOfItems.count;
    }else{
        return self.arrRecords.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (searching) {
        return [copyListOfItems objectAtIndex:row];
    }else{
        return [self.arrRecords objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
           
}

@end
