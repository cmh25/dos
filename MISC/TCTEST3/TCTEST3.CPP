#include <cmhgrfx.h>
#include <conio.h>


int main()
{
	short xstart = 430;
	short ystart = 30;
	short xend = 320;
	short yend = 220;
	short xcenter = 320;
	short ycenter = 240;
	short radius = 10;
	short xrad = 300;
	short yrad = 10;

	getch();
	SetMode(18);
	getch();
	Line(10,10,300,300,1);
	getch();
	Line(xstart,ystart,xend,yend,4);
	getch();
	Circle(320,240,100,1);
	getch();
	for(int i=0;i<20;i++)
	{
		Circle(xcenter,ycenter,radius,2);
		radius++;
	}
	getch();
	xstart=10;
	ystart=10;
	xend=600;
	yend=10;
	for(i=0;i<100;i++)
	{
		Line(xstart,ystart++,xend,yend++,4);
	}
	getch();
	SetMode(18);
	getch();
	for(i=0;i<229;i++)
	{
		Ellipse(xcenter,ycenter,xrad,yrad++,5);
	}
	getch();
	SetMode(3);
	getch();

	return 0;
}
