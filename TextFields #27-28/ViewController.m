//
//  ViewController.m
//  TextFields #27-28
//
//  Created by Евгений Глухов on 08.05.15.
//  Copyright (c) 2015 EG. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (assign, nonatomic) int currentNumberOfField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[self.mainTextFields objectAtIndex:0] becomeFirstResponder];
    // при запуске курсор ставится на первое поле (name)
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setStandardLabels:(UITextField*) textField withCounter:(int) counter {
    // метод ставит лейблы по умолчанию, если в соответствующий textfield ничего не написано, то есть длина текста равняется 0
    
    if ([textField.text length] == 0) {
        
        switch (counter) {
                
            case 0:
                
                [[self.mainLabels objectAtIndex:0] setText:@"Name"];
                
                break;
                
            case 1:
                
                [[self.mainLabels objectAtIndex:1] setText:@"Surname"];
                
                break;
                
            case 2:
                
                [[self.mainLabels objectAtIndex:2] setText:@"Nickname"];
                
                break;
                
            case 3:
                
                [[self.mainLabels objectAtIndex:3] setText:@"Password"];
                
                break;
                
            case 4:
                
                [[self.mainLabels objectAtIndex:4] setText:@"Age"];
                
                break;
                
            case 5:
                
                [[self.mainLabels objectAtIndex:5] setText:@"Phone number"];
                
                break;
                
            case 6:
                
                [[self.mainLabels objectAtIndex:6] setText:@"email"];
                
                break;
                
            default:
                break;
        }
        
    }

    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField { // метод вызывается при нажатии кнопки return
    
    if ([textField isEqual:[self.mainTextFields objectAtIndex:self.currentNumberOfField]] && self.currentNumberOfField != 6) {
        
        self.currentNumberOfField++;
        
        [[self.mainTextFields objectAtIndex:self.currentNumberOfField] becomeFirstResponder];
        // следующее поле становится активным
    }
    
    else {
        
        [[self.mainTextFields objectAtIndex:self.currentNumberOfField] resignFirstResponder];
        // убирание фокуса с текущего (т.е. последнего) поля
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField { // метод вызывается, как только курсор ставится в textfield
    
    self.currentNumberOfField = (int)[self.mainTextFields indexOfObject:textField]; // индекс поля в массиве, по которому кликнули
    
    for (int i = 0; i < [self.mainTextFields count]; i++) {
        
        if ([[[self.mainTextFields objectAtIndex:i] text] length] == 0) {
            
            [self setStandardLabels:[self.mainTextFields objectAtIndex:i] withCounter:i];
            // Проверка всех текстфилдов, пустые ли они, если да, ставятся лейблы по умолчанию
        }
        
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField { // метод вызывается при нажатии clear button
    
    textField.text = @"";
    
    [self setStandardLabels:textField withCounter:self.currentNumberOfField];
    // также выставляем умолчания
    
    return NO;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { // метод вызывается при каждом изменении строки
    
    if ([textField isEqual:[self.mainTextFields objectAtIndex:5]]) {
        // Если мы находимся в поле ввода номера телефона...
        
        // Вывод в лейблы написанного в текстовых полях
        int i = (int)[self.mainTextFields indexOfObject:textField];
        
        NSString* checkString = [textField.text stringByAppendingString:string];
        
        if ([string length] != 1) { // условие, когда удаляем символы
            
            checkString = [checkString substringToIndex:[checkString length] - 1];
            
        }
        
        // код для форматирования номера телефона. // ====== код Алексея ======
        
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
        if ([components count] > 1) { // Если components будет содержать символ, тогда он будет разделением для чисел, тогда ничего не выводим, так как будет 2 объекта в массиве, нужны только числа
            
            return NO;
            
        }
        
        NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
        
        newString = [validComponents componentsJoinedByString:@""];
        
        NSMutableString* resultString = [NSMutableString string];
        
        static const int localNumberMaxLength = 7;
        static const int areaCodeMaxLength = 3;
        static const int countryCodeMaxLength = 3;
        
        // Делаем локальный номер (ХХХ-ХХХХ)
        
        NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
        
        if (localNumberLength > 0) {
            
            NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
            
            [resultString appendString:number];
            
            if ([resultString length] > 3) {
                
                [resultString insertString:@"-" atIndex:3];
                
            }
            
        }
        
        // Делаем код региона (ХХХ)
        
        if ([newString length] > localNumberMaxLength) {
            
            NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
            
            NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
            
            NSString* area = [newString substringWithRange:areaRange];
            
            area = [NSString stringWithFormat:@"(%@) ", area];
            
            [resultString insertString:area atIndex:0];
            
        }
        
        // Делаем код страны (+ХХХ)
        
        if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
            
            NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
            
            NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
            
            NSString* countryCode = [newString substringWithRange:countryCodeRange];
            
            countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
            
            [resultString insertString:countryCode atIndex:0];
            
        }
        
        if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
            
            return NO;
            
        }
        
        textField.text = resultString;
        
        // === код Алексея закончен! ===
        
        [[self.mainLabels objectAtIndex:i] setText:resultString];
        
        return NO;

        
    }
    
    else if ([textField isEqual:[self.mainTextFields objectAtIndex:6]]) {
        
        // код для разумного ввода email адреса!
        
        // Вывод в лейблы написанного в текстовых полях
        int i = (int)[self.mainTextFields indexOfObject:textField];
        
        NSString* checkString = [textField.text stringByAppendingString:string];
        
        if ([string length] != 1) { // условие, когда удаляем символы
            
            checkString = [checkString substringToIndex:[checkString length] - 1];
            
        }
        
        NSCharacterSet* atSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
        NSCharacterSet* illegalSet = [NSCharacterSet characterSetWithCharactersInString:@" !#$%^&*()=+\"№;:?[]~`|{}/'"];
    
        NSArray* atComponents = [checkString componentsSeparatedByCharactersInSet:atSet];
        NSArray* illegalComponents = [checkString componentsSeparatedByCharactersInSet:illegalSet];
        
        if ([atComponents count] > 2 || [illegalComponents count] > 1) { // собака вводится только один раз (по аналогии с цифрами в номере телефона в коде Алексея), а также нельзя вводить недопустимые символы (illegal set)
            
            return NO;
            
        }
    
        [[self.mainLabels objectAtIndex:i] setText:checkString];
        
        return [checkString length] <= 19; // длина email не больше 19 символов
        
    }
    
    else {
        
        // Вывод в лейблы написанного в текстовых полях
        int i = (int)[self.mainTextFields indexOfObject:textField];
        
        NSString* checkString = [textField.text stringByAppendingString:string];
        
        if ([string length] != 1) { // условие, когда удаляем символы
            
            checkString = [checkString substringToIndex:[checkString length] - 1];
            
        }
        
        [[self.mainLabels objectAtIndex:i] setText:checkString];
        
        return YES;
        
    }
    
}

@end
