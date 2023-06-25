//triatest.cpp

#include <conio.h>
#include <dos.h>
#include "triangle.h"

CScreen aScreen(0x32,0x96,160,480);

int main()
{
	//Set mode 12h
	SetMode(18);
	//Set split screen to start on scan line 319
	SetSplitScreen(319);
	//Clear all video memory to get rid of mystery dots
	Fill(0,(unsigned short)65535,0);
	//Fill split screen area with red
	Fill(0,12800,4);     
	CTriangle mytriangle(150,60,100,160,200,160,1,&aScreen);  
	CTriangle atriangle(100,160,150,260,200,160,2,&aScreen);
	CTriangle linetriangle(0,160,100,160,639,160,9,&aScreen);
	mytriangle.Show();
	atriangle.Show(); 
	linetriangle.Show();
	aScreen.SwapBuffers(); 
	getch();      
	int i=0;
	int j=0;  
	double rval = 2;
	short x=200;
	short y=160; 
	short xadd = 100;
	for(;;)
	{	     
		while(j<4)
		{
			while(i<90)
			{           
			
				mytriangle.Erase();  
				atriangle.Erase();
				mytriangle.Rotate(x,160,2); 
				atriangle.Rotate(x,160,2);	
				mytriangle.Show();          
				atriangle.Show(); 
				linetriangle.Show();
				aScreen.SwapBuffers();
							
				if(kbhit())   
				{         
					SetMode(3);
					return 0;
				}
				
				i++;
			}   
			x+=xadd;    
			i=0;
			j++;
		}
		x-=xadd;
		xadd*=(-1);
		j=0;     
	}
}      

