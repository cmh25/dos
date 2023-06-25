msdos vga 2d graphing program

What it can do:
   -Graph functions of the form f(x)=x or y=x.
    You need only enter the right side of the equation.  In fact,
    if you enter the 'y=', Grapher will not function properly.
            
   -Any of the following symbols may be used: 0-9 + - * / ^ [ ( ) ] x X . 
             
     Notes on symbols:

         -In a fraction, both the numerator and denominator
          must be fully enclosed in parentheses if either 
          consists of more than one term.

         -Parentheses() and brackets[] serve the same function
          and may be used interchangeably.

         -Parentheses(and brackets) may be nested to any depth.

         -252 characters is the most that can be entered for a 
          single equation(this should be more than enough as 
          far as I know).

         -Any expression inside parentheses may be raised 
          to a power. ex: (1x^2-1x+1)^2

         -Any 'x' value must have a coeffecient, even if it is '1'.

         -Any 'x' value may have a decimal coeffecient.

         -An exponent may be an entire expression inside 
          parentheses.  ex: 5^(2+3) These parentheses may also 
          be nested to any depth that you can dream up; but 
          cannot contain an 'x', a decimal value, or a fraction
          resulting in a decimal value.

         -'x' cannot be an exponent.

What it cannot do:
   -Graph trig functions
   -Graph square root or absolute value functions
   -Graph any other kind of stuff I don't know about.

Examples:
1x^4-10x^2+(1x/4)
(1x^2+1)/(1x^2-5)
(1x^2-5x-5)/(1x^2+5x+5)
1x^(5-3)
(1x-.5x)^2

Push ENTER when you are done entering your function.  
Enter 'q' or 'Q' at the equation screen to quit.

# 20230124
Built in dosbox 0.74-3 with masm 6.11.
ml grapher.asm
