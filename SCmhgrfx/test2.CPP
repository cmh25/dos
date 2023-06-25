//test2.cpp    

#include "scmhgrfx.h" 
#include <conio.h>
        
short x1=5;
short y1=20;
short x2=795;
short y2=20;
short x3=780;
short y3=500; 
short color=1;               

int main()
{            
	SetMode(0x103);
	getch();       
	       
	while(!kbhit())
	{
    	SetStartAddr(0);
     	//Draw on page1
     	Fill(0,600,0);   
     	Triangle(390,20+600,20,500+600,780,500+600,4);
        Line(x1,y1+600,x2,y2+600,1);
    	SetStartAddr(600); 
    	//y1+=2;
    	//y2+=2;
    	//Draw on page0
    	Fill(0,0,0); 
    	Triangle(390,20,20,500,780,500,4);
        Line(x1,y1,x2,y2,1);
        //y1+=2;
        //y2+=2;
	}   
	
	getch();
    SetMode(3);
	return 0;
}
