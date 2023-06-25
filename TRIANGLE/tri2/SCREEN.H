//Screen.h
//Screen class definition

#ifndef SCREEN_H
#define SCREEN_H

#include "cmhgrfx.h"

class CScreen
{

	protected:

	private:
		short m_CurrentPage;        //Currently displayed page
		short m_Page0Start;    		//High byte of start address
		short m_Page1Start;     	//High byte of start address
		short m_Page0PageFactor;    //Add to ycoords
		short m_Page1PageFactor;	//Add to ycoords

	public:
		CScreen(
			short page0start,
			short page1start,
			short page0pagefactor,
			short page1pagefactor);

		void SwapBuffers();
		short GetBackBuffer();
		short GetPage0PageFactor();
		short GetPage1PageFactor();
};

#endif
