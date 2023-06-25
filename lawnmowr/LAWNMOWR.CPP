//lawnmower.cpp

#include <conio.h>
#include <dos.h>
#include "triangle.h"

void MoveRight();
void MoveLeft();
void MoveUp();
void MoveDown();

CScreen aScreen(0x32,0x96,160,480);
CTriangle mytriangle(1,1,1,25,25,25,1,&aScreen);
CTriangle atriangle(1,1,25,25,25,1,1,&aScreen);

extern "C" {
  void Sound(short);
  void NoSound();
}

int direction = 0;
short xmove = 0;
short ymove = 0;

short leftx = 1;
short rightx = 25;
short topy = 1;
short botty = 25;
int soundhz = 30;


int main()
{
	//Set mode 12h
	SetMode(18);
	//Set split screen to start on scan line 319
	SetSplitScreen(319);
	//Clear all video memory to get rid of mystery dots
	Fill(0,(unsigned short)65535,2);
	//Fill split screen area with red
	Fill(0,12800,4);
	mytriangle.Show();
	atriangle.Show();
	aScreen.SwapBuffers();
	mytriangle.Show();
	atriangle.Show();
	aScreen.SwapBuffers();

	for(;;)
	{
		mytriangle.Erase();
		atriangle.Erase();

		if(leftx<=2 && xmove<0)
			xmove = 0;
		if(rightx>=637 && xmove>0)
			xmove = 0;
		if(topy<=2 && ymove<0)
			ymove = 0;
		if(botty>=317 && ymove>0)
			ymove = 0;

		if(xmove!=0 || ymove!=0)
			Sound(soundhz);
		mytriangle.Move(xmove,ymove);
		atriangle.Move(xmove,ymove);
		leftx+=xmove;
		rightx+=xmove;
		topy+=ymove;
		botty+=ymove;
		mytriangle.Show();
		atriangle.Show();
		aScreen.SwapBuffers();
		NoSound();
		soundhz = 30;

		if(kbhit())
		{
			mytriangle.Erase();
			atriangle.Erase();
			mytriangle.Show();
			atriangle.Show();
			aScreen.SwapBuffers();
			direction = getch();
			switch(direction)
			{
				case 72:
					//Move up
					xmove = 0;
					ymove = -2;
					break;
				case 80:
					//Move down
					xmove = 0;
					ymove = 2;
					break;
				case 77:
					//Move right
					xmove = 2;
					ymove = 0;
					break;
				case 75:
					//Move left
					xmove = -2;
					ymove = 0;
					break;
				case 27:
					//Esc
					SetMode(3);
					return 0;
				default:
					break;
			}
		}
	}
}



