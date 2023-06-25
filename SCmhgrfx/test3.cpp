//test3.cpp

#include "scmhgrfx.h"
#include "screen.h"
#include <conio.h>

short x1=200;
short y1=100;
short x2=100;
short y2=400;
short x3=400;
short y3=400;
short x4=600;
short y4=100;

int main()
{             
	CScreen* pscreen=new CScreen; 
	getch();
	           
	pscreen->SetColor(1);                                  
	while(!kbhit())
	{                 
               
        pscreen->SetColor(1);
		pscreen->DrawTriangle(x1,y1,x2,y2,x3,y3);
		pscreen->SetColor(4);
		pscreen->DrawTriangle(x1,y1,x3,y3,x4,y4);
		pscreen->Swap();

		x1+=100;
		x2+=100;
		x3+=100;
		x4+=100;	 
	}
	
	SetMode(3);
	return 0;
}