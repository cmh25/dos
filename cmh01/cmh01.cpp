//cmh01.cpp

#include <conio.h>
#include <stdlib.h>
#include <stdio.h>
#include "cmhgrfx.h"  

void waitkey();

short linelist[4000];
short* plinelist=&linelist[0]; 

short color=0;
short x1=0;
short y1=0;
short x2=0;
short y2=0;
short x3=0;
short y3=0;

int main()
{
	SetMode(18);    
	getch();
	while(!kbhit())
	{    
		color++;
		x1=(rand()>>8); 
		y1=(rand()>>8);
		x2=(rand()>>8);
		y2=(rand()>>8);
		x3=(rand()>>8);
		y3=(rand()>>8); 
		x1*=4;
		y1*=3;
		x2*=4;
		y2*=3;
		x3*=4;
		y3*=3;  
		Fpoly(color,3,plinelist,x1,y1,x2,y2,x3,y3);	
	}   
	SetMode(3);     
	return 0;
}    