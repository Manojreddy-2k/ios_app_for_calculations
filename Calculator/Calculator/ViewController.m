//
//  ViewController.h
//  Calculator
//
//  Created by Manoj on 3/5/25.
//

#import "ViewController.h"
#import <math.h>

@interface ViewController ()
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) NSString *currentInput;
@property (nonatomic, assign) double previousNumber;
@property (nonatomic, strong) NSString *currentOperation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentInput = @"0";
    self.previousNumber = 0;
    self.currentOperation = nil;
}

- (void)buttonPressed:(UIButton *)sender {
    NSString *buttonText = sender.titleLabel.text;
    
    if ([buttonText isEqualToString:@"C"]) {
        self.currentInput = @"0";
        self.previousNumber = 0;
        self.currentOperation = nil;
        self.displayLabel.text = @"0";
        
    } else if ([buttonText isEqualToString:@"÷"] ||
               [buttonText isEqualToString:@"×"] ||
               [buttonText isEqualToString:@"-"] ||
               [buttonText isEqualToString:@"+"]) {
        
        self.previousNumber = [self.currentInput doubleValue];
        self.currentInput = @"0";
        self.currentOperation = buttonText;
        
    } else if ([buttonText isEqualToString:@"="]) {
        if (self.currentOperation) {
            double num = [self.currentInput doubleValue];
            double result = 0;
            
            if ([self.currentOperation isEqualToString:@"÷"]) {
                result = self.previousNumber / num;
            } else if ([self.currentOperation isEqualToString:@"×"]) {
                result = self.previousNumber * num;
            } else if ([self.currentOperation isEqualToString:@"-"]) {
                result = self.previousNumber - num;
            } else if ([self.currentOperation isEqualToString:@"+"]) {
                result = self.previousNumber + num;
            }
            
            self.currentInput = [NSString stringWithFormat:@"%f", result];
            self.currentOperation = nil;
            self.displayLabel.text = self.currentInput;
        }
        
    } else if ([buttonText isEqualToString:@"sin"] ||
               [buttonText isEqualToString:@"cos"] ||
               [buttonText isEqualToString:@"tan"]) {
        
        double num = [self.currentInput doubleValue];
        double radians = num * M_PI / 180.0; 
        double result = 0;
        
        if ([buttonText isEqualToString:@"sin"]) {
            result = sin(radians);
        } else if ([buttonText isEqualToString:@"cos"]) {
            result = cos(radians);
        } else if ([buttonText isEqualToString:@"tan"]) {
            result = tan(radians);
        }
        
        self.currentInput = [NSString stringWithFormat:@"%f", result];
        self.displayLabel.text = self.currentInput;
        
    } else {
        if ([self.currentInput isEqualToString:@"0"]) {
            self.currentInput = buttonText;
        } else {
            self.currentInput = [self.currentInput stringByAppendingString:buttonText];
        }
        self.displayLabel.text = self.currentInput;
    }
}

@end

