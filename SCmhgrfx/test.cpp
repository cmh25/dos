//test.cpp

#include "scmhgrfx.h"
#include <stdio.h>    
#include <conio.h>

short x1;
short y1;
short x2;
short y2;
short x3;
short y3;   

void rotate();

int main()
{
	SetMode(0x103);  
  getch();
	
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=5;
    y2=500;
    x3=300;
    y3=5;
    
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=300;
    y2=500;
    x3=300;
    y3=5; 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=5;
    y2=500;
    x3=300;
    y3=500; 
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=300;
    y1=5;
    x2=5;
    y2=500;
    x3=300;
    y3=500; 
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=5;
    y2=500;
    x3=300;
    y3=250; 
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=250;
    x2=300;
    y2=500;
    x3=300;
    y3=5;  
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=250;
    y2=500;
    x3=500;
    y3=5;
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=250;
    y1=5;
    x2=5;
    y2=500;
    x3=500;
    y3=500;  
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=500;
    y1=5;
    x2=100;
    y2=20;
    x3=5;
    y3=500; 
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0); 
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=500;
    y1=5;
    x2=5;
    y2=300;
    x3=100;
    y3=500;  
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=500;
    y2=500;
    x3=400;
    y3=50;   
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();
    
    ////////////////////////////////////////////////////////////////////          
    x1=5;
    y1=5;
    x2=300;
    y2=500;
    x3=500;
    y3=400;  
    rotate(); 
    rotate();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4);
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,1);
    getch();
    Line(x1,y1,x2,y2,4); 
    Line(x2,y2,x3,y3,4);
    Line(x3,y3,x1,y1,4); 
    getch();
    Triangle(x1,y1,x2,y2,x3,y3,0);
    getch();

getch();
	SetMode(3);
	return 0;
}

void rotate()
{
	short tempx=x1;
	short tempy=y1;
	x1=x2;
	y1=y2;
	x2=x3;
	y2=y3;
	x3=tempx;
	y3=tempy;
}