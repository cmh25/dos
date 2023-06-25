//test4.cpp

#include "scmhgrfx.h" 
#include <conio.h> 
#include <stdlib.h> 
#include <iostream.h>

short color=1;
long count=0;
char string[300]={0};
char* pstring=&string[0];

short x1;
short y1;
short x2;
short y2;
short x3;
short y3;


short randomnumbertable[30000];
short* prand=&randomnumbertable[0];

unsigned char Rand();				

int main()
{            
	SetMode(0x103);
	getch(); 
	
	//seed random number table
	for(short i=0;i<30000;i++)
	{
		randomnumbertable[i]=rand();
	}
  
	while(!kbhit())
	{            
		x1=Rand()*3;
		y1=Rand()*2;
		x2=Rand()*3;
		y2=Rand()*2;
		x3=Rand()*3;
		y3=Rand()*2;  
		
		//Line(x1,y1,x2,y2,color);
		Triangle(x1,y1,x2,y2,x3,y3,color);
		count++;
		color++;		
	}
	getch();
	SetMode(3);
	             
	
	pstring = ltoa(count,pstring,10);
	cout << endl << "Count: ";
	while(*pstring!=0)cout << *pstring++; 
	return 0;
}           

unsigned char Rand()
{
	return *prand++;
	//if(prand>=&randomnumbertable[29999]) 
	//{
	//	//seed random number table
	//	for(short i=0;i<30000;i++)
	//	{
	//		randomnumbertable[i]=rand();
	//	}	 
	//	prand=&randomnumbertable[0];
	//}
	
		
}