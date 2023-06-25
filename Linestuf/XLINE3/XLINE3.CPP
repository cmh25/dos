#include <cmhgrfx.h>
#include <conio.h>

unsigned int    i			= 0;
unsigned int	xstart  	= 0;
unsigned int	xend		= 639;
unsigned int	ystart		= 0;
unsigned int    yend		= 0;
short xstart2 = 10;
short xend2 = 10;
short ystart2 = 10;
short yend2 = 400;
short xstart3 = 10;
short xend3 = 500;
short ystart3 = 10;
short yend3 = 10;
int 			g			= 0;
short x1=320;
short x2=320;
short x3=320;
short y1=240;
short y2=240;
short xcenter = 320;
short ycenter = 240;
short xrad = 300;
short yrad = 0;
int color = 1;

int main()
{
	SetMode(18);
	//getch();
	while(!kbhit())
	{
i			= 0;
xstart  	= 0;
xend		= 639;
ystart		= 0;
yend		= 0;
g			= 0;
x1=320;
x2=320;
x3=320;
y1=240;
y2=240;
xcenter = 320;
ycenter = 240;
xrad = 300;
yrad = 0;

	while(g<2)
	{
		for(i=0;i<479;i++)
		{
			Line(xstart,ystart,xend,yend,color);
			yend++;
		}
		for(i=0;i<640;i++)
		{
			Line(xstart,ystart,xend,yend,color);
			xend--;
		}
		yend = 0;
		xend = 639;
		//getch();
		color = 4;
		//SetMode(18);
		g++;
	}
	color = 1;
	//getch();
	xstart = 320;
	xend = 320;
	ystart = 240;
	yend = 240;
	for(i=0;i<200;i++)
	{
		Line(xstart,ystart,xend,ystart,2);
		Line(xstart,ystart,xstart,yend,2);
		Line(xend,ystart,xend,yend,2);
		Line(xend,yend,xstart,yend,2);
		xstart--;
		xend++;
		ystart--;
		yend++;
		//getch();
	}
	//getch();
	for(i=0;i<100;i++)
	{
		Line(x1,y1,x3,y2,1);
		Line(x1,y1,x2,y2,1);
		Line(x2,y2,x3,y2,1);
		x2--;
		x3++;
		y1--;
		y2++;
	}
	//getch();
	for(i=0;i<200;i++)
	{
		Circle(320,240,i,5);
	}
	//getch();
	//SetMode(18);
	//getch();

// ellipse is broken somehow
//	for(i=0;i<200;i++)
//	{
//		Ellipse(xcenter,ycenter,xrad,yrad,3);
//		yrad++;
//		//xrad++;
//	}
//	yrad = 200;
//	xrad = 0;
//	//getch();
//	for(i=0;i<200;i++)
//	{
//		Ellipse(xcenter,ycenter,xrad,yrad,0);
//		xrad++;
//	}
//	//getch();
//	//SetMode(18);
xstart2 = 10;
xend2 = 10;
ystart2 = 10;
yend2 = 400;
xstart3 = 10;
xend3 = 500;
ystart3 = 10;
yend3 = 10;
	//getch();
	for(i=0;i<500;i++)
	{
		Line(xstart2,ystart2,xend2,yend2,5);
		xstart2++;
		xend2++;
	}
	//getch();
	//SetMode(18);
	//getch();
	for(i=0;i<400;i++)
	{
		Line(xstart3,ystart3,xend3,yend3,6);
		ystart3++;
		yend3++;
	}
	//getch();
	//SetMode(18);
	}
	SetMode(3);
	return 0;
}


