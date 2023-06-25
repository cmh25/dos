#ifndef _8253_H
#define _8253_H
#ifdef __cplusplus
extern "C" {
#endif 
  void Sound(short freq);
  void Delay(short del);
  void NoSound();
#ifdef __cplusplus
}
#endif 
#endif /* _8253_H */