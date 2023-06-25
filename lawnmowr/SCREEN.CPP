//Screen.cpp

#include "screen.h"

CScreen::CScreen(short page0start,short page1start, short page0pagefactor,
				 short page1pagefactor)
	{
		m_Page0Start=page0start;
		m_Page1Start=page1start;
		m_Page0PageFactor=page0pagefactor;
		m_Page1PageFactor=page1pagefactor;
		SetStartAddr(m_Page0Start);
		m_CurrentPage=0;
	}

void CScreen::SwapBuffers()
	{
		m_CurrentPage=!m_CurrentPage;
		if(m_CurrentPage == 0)
			SetStartAddr(m_Page0Start);
		if(m_CurrentPage == 1)
			SetStartAddr(m_Page1Start);
	}

short CScreen::GetBackBuffer()
	{
		return !m_CurrentPage;
	}

short CScreen::GetPage0PageFactor()
	{
		return m_Page0PageFactor;
	}

short CScreen::GetPage1PageFactor()
	{
		return m_Page1PageFactor;
	}