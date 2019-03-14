# PopupCurrencyPicker

PopupCurrencyPicker is a clean and easy-to-use control which is meant for showing the list of available currency symbols.

![PopupCurrencyPicker](http://i.imgur.com/kKLAMbY.png)

## PopupCurrencyPicker

## Installation

## Manually

**Important note: if your project doesn't use ARC**: you must add the **-fobjc-arc** compiler flag to PopupCurrencyPicker.h,PopupCurrencyPicker.m,PopupCurrencyPickerDelegate.h in Target Settings > Build Phases > Compile Sources.

Drag the CurrencyPicker/PopupCurrencyPicker folder into your project.

## Usage

(see sample Xcode project)

## Show the PopupCurrencyPicker

```objective-c
        self.currencyPickr = [[PopupCurrencyPicker alloc] init];
        self.currencyPickr.delegate = self;
        [self.currencyPickr showFromView:self.view];
```        
Hiding the Currency Picker

```objective-c
        [self.currencyPickr hide];
```
        
## Observing PopupCurrencyPicker Delegate Methods

* Confirm to the PopupCurrencyPicker Delegate <PopupCurrencyPickerDelegate>

```objective-c
-(void)popupCurrencyPickerWillShow:(PopupCurrencyPicker *)currencyPicker animated:(BOOL)animated
{
    
}

-(void)popupCurrencyPickerWillHide:(PopupCurrencyPicker *)currencyPicker animated:(BOOL)animated
{
    
}

-(void)popupCurrencyPickerDidShow:(PopupCurrencyPicker *)currencyPicker animated:(BOOL)animated
{
    
}

-(void)popupCurrencyPickerDidHide:(PopupCurrencyPicker *)currencyPicker animated:(BOOL)animated
{
    
}
-(void)popupCurrencyPicker:(PopupCurrencyPicker *)currencyPicker didSelectCurrency:(NSArray *)currencyArray
{

}
```

## Currency Array

Currency Array Hold the follwing Information

* Index 0 : Currency Code
* Index 1 : Currency Symbol
* Index 2 : Currency Name
* Index 3 : Combination of Above 3 (Complete Title For PickerView)

_Currencies are stored in the pList file present in the App Bundle. Feel free to modify that file :)_

## License

Feel free to use this on any of your projects. Attribution is the right thing to do, but not mandatory.

## Inspired From : 
 
This library is merge of two other libraries, It is made in order to make the best out of it :) 

* https://github.com/SimonFairbairn/CurrencyPicker
* https://github.com/livefront/popupdatepicker-ios

_Thanks to you Guys, You rock. Hope you appreciate my efforts :) All Credits goes to you guys. :)_

_ Do Visit me at : [Codeoi.com](http://www.codeoi.com)_
