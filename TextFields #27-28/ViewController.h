//
//  ViewController.h
//  TextFields #27-28
//
//  Created by Евгений Глухов on 08.05.15.
//  Copyright (c) 2015 EG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *mainTextFields;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *mainLabels;

// Массив лейблов и текстфилдов
@end