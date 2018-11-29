//
//  PickerView.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

-(void)selectedRow:(int)row withString:(NSString *)text;

@end

@interface PickerView : UIView<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UISearchControllerDelegate,UITextFieldDelegate>{
    
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    UISearchBar *txtSearch;
//    UITextField *txtSearch;
    NSArray *arrRecords;
    UIActionSheet *aac;
    UIView *toolView;
    
    NSMutableArray *copyListOfItems;
    BOOL searching;
	BOOL letUserSelectRow;
    
    id <PickerViewDelegate> delegate;
    
}


@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, retain) id <PickerViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues;
-(void)showPicker;
- (void)searchTableView;
-(void)btnDoneClick;
@end
