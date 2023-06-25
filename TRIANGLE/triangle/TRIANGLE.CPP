//Triangle.cpp
//Triangle class implementation
#include "triangle.h"  
#include <math.h>

CTriangle::CTriangle(
			short v1x = 0,
			short v1y = 0,
			short v2x = 0,
			short v2y = 0,
			short v3x = 0,
			short v3y = 0,
			short color = 0,
			CScreen* pScreen = 0)

			{
				m_v1x = m_oldx10 = m_oldx11 = v1x;
				m_v1y = m_oldy10 = m_oldy11 = v1y;
				m_v2x = m_oldx20 = m_oldx21 = v2x;
				m_v2y = m_oldy20 = m_oldy21 = v2y;
				m_v3x = m_oldx30 = m_oldx31 = v3x;
				m_v3y = m_oldy30 = m_oldy31 = v3y; 
				m_v1xx = v1x;
				m_v1yy = v1y;
				m_v2xx = v2x;
				m_v2yy = v2y;
				m_v3xx = v3x;
				m_v3yy = v3y;
				m_color = color;
				m_pScreen = pScreen;
			}

void CTriangle::Show()
	{
		if(m_pScreen->GetBackBuffer() == 0)
		{
			short* pPolyBuffer = new short[3000];
			Fpoly(m_color,3,pPolyBuffer,
				m_v1x,(m_v1y+m_pScreen->GetPage0PageFactor()),
				m_v2x,(m_v2y+m_pScreen->GetPage0PageFactor()),
				m_v3x,(m_v3y+m_pScreen->GetPage0PageFactor()));
			delete pPolyBuffer;
			//Save coords for erasing later
			m_oldx10=m_v1x;
			m_oldy10=m_v1y;
			m_oldx20=m_v2x;
			m_oldy20=m_v2y;
			m_oldx30=m_v3x;
			m_oldy30=m_v3y;
		}
		if(m_pScreen->GetBackBuffer() == 1)
		{
			short* pPolyBuffer = new short[3000];
			Fpoly(m_color,3,pPolyBuffer,
				m_v1x,(m_v1y+m_pScreen->GetPage1PageFactor()),
				m_v2x,(m_v2y+m_pScreen->GetPage1PageFactor()),
				m_v3x,(m_v3y+m_pScreen->GetPage1PageFactor()));
			delete pPolyBuffer;
			//Save coords for erasing later
			m_oldx11=m_v1x;
			m_oldy11=m_v1y;
			m_oldx21=m_v2x;
			m_oldy21=m_v2y;
			m_oldx31=m_v3x;
			m_oldy31=m_v3y;
		}
	}

void CTriangle::Erase()
	{
		if(m_pScreen->GetBackBuffer() == 0)
		{
			short* pPolyBuffer = new short[3000];
			Fpoly(0,3,pPolyBuffer,
				m_oldx10,(m_oldy10+m_pScreen->GetPage0PageFactor()),
				m_oldx20,(m_oldy20+m_pScreen->GetPage0PageFactor()),
				m_oldx30,(m_oldy30+m_pScreen->GetPage0PageFactor()));
			delete pPolyBuffer;
		}
		if(m_pScreen->GetBackBuffer() == 1)
		{
			short* pPolyBuffer = new short[3000];
			Fpoly(0,3,pPolyBuffer,
				m_oldx11,(m_oldy11+m_pScreen->GetPage1PageFactor()),
				m_oldx21,(m_oldy21+m_pScreen->GetPage1PageFactor()),
				m_oldx31,(m_oldy31+m_pScreen->GetPage1PageFactor()));
			delete pPolyBuffer;
		}
	}




void CTriangle::Move(short xmove,short ymove)
	{
		m_v1x+=xmove;
		m_v2x+=xmove;
		m_v3x+=xmove;
		m_v1y+=ymove;
		m_v2y+=ymove;
		m_v3y+=ymove;
	}

void CTriangle::MoveToX(short x)
	{
		int i = m_v1x-x;
		m_v1x-=i;
		m_v2x-=i;
		m_v3x-=i;
	}
void CTriangle::MoveToY(short y)
	{
		int i = m_v1y-y;
		m_v1y-=i;
		m_v2y-=i;
		m_v3y-=i;
	}

void CTriangle::ClipTo()
	{
		//See if rectangle is completely inside clip window
		//It is completely inside
		//It is not completely inside
	}  
	
void CTriangle::Rotate(short x,short y,double degrees)
	{     
		//double xx = m_xx;
		//double yy = m_yy;	
		double xx1;
		double yy1;
		double xx2;
		double yy2;
		double xx3;
		double yy3;      
		
		degrees = degrees*3.14159/180;		                      
		                      
		xx1 = x + (m_v1xx-x)*cos(degrees) - (m_v1yy-y)*sin(degrees);
		yy1 = y + (m_v1xx-x)*sin(degrees) + (m_v1yy-y)*cos(degrees); 
		
		xx2 = x + (m_v2xx-x)*cos(degrees) - (m_v2yy-y)*sin(degrees);
		yy2 = y + (m_v2xx-x)*sin(degrees) + (m_v2yy-y)*cos(degrees);
		
		xx3 = x + (m_v3xx-x)*cos(degrees) - (m_v3yy-y)*sin(degrees);
		yy3 = y + (m_v3xx-x)*sin(degrees) + (m_v3yy-y)*cos(degrees);
		
		//short xxx;
		//short yyy;
		short xxx1;
		short yyy1;
		short xxx2;
		short yyy2;
		short xxx3;
		short yyy3;
		
		//_asm{
		//	fld xx;
		//	fistp xxx;
		//	fld yy;
		//	fistp yyy;
		//}     
		_asm{
			fld xx1
			fistp xxx1
			fld yy1
			fistp yyy1
			fld xx2
			fistp xxx2
			fld yy2 
			fistp yyy2
			fld xx3
			fistp xxx3
			fld yy3
			fistp yyy3
			}     
		
		//m_x = xxx;
		//m_y = yyy;
		//m_xx = xx;
		//m_yy = yy; 
		m_v1x = xxx1;
		m_v1y = yyy1;
		m_v2x = xxx2;
		m_v2y = yyy2;
		m_v3x = xxx3;
		m_v3y = yyy3;
		m_v1xx = xx1;
		m_v1yy = yy1;
		m_v2xx = xx2;
		m_v2yy = yy2;
		m_v3xx = xx3;
		m_v3yy = yy3;
	
	}







