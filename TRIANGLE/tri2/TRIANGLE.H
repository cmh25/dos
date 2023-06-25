//Triangle.h
//Triangle class definition

#ifndef TRIANGLE_H
#define TRIANGLE_H

#include "screen.h"
#include "cmhgrfx.h"

class CTriangle
{
	public:
		CTriangle(
			short v1x,
			short v1y,
			short v2x,
			short v2y,
			short v3x,
			short v3y,
			short color,
			CScreen* pScreen);
		void Show();
		void Erase();
		void Move(short xmove,short ymove);
		void MoveToX(short x);
		void MoveToY(short y);
		void ClipTo(); 
		void Rotate(short x,short y,double degrees);
		
	protected:

	private:
		CScreen* m_pScreen;
		short m_v1x;
		short m_v1y;
		short m_v2x;
		short m_v2y;
		short m_v3x;
		short m_v3y; 
		double m_v1xx;
		double m_v1yy;
		double m_v2xx;
		double m_v2yy;
		double m_v3xx;
		double m_v3yy;
		short m_color;
		//Old coords saved for erasing after a move
		short m_oldx10;
		short m_oldx20;
		short m_oldx30;
		short m_oldy10;
		short m_oldy20;
		short m_oldy30;
		short m_oldx11;
		short m_oldx21;
		short m_oldx31;
		short m_oldy11;
		short m_oldy21;
		short m_oldy31;
};  

#endif
