#include "8253.h"

int main() {
    /* do ra mi fa so la di do */
    Sound(262); Delay(10);
    Sound(294); Delay(10);
    Sound(330); Delay(10);
    Sound(349); Delay(10);
    Sound(392); Delay(10);
    Sound(440); Delay(10);
    Sound(494); Delay(10);
    Sound(523); Delay(10);
    NoSound();
    Delay(100);
    /* some where over the rainbow */
    Sound(220); Delay(80); /* A */
    Sound(440); Delay(80); /* ^A */
    Sound(415); Delay(40); /* ^G# */
    Sound(330); Delay(20); /* ^E */
    Sound(370); Delay(20); /* ^F# */
    Sound(415); Delay(40); /* ^G# */
    Sound(440); Delay(40); /* ^A */
    /* way up high */
    Sound(220); Delay(80); /* A */
    Sound(370); Delay(80); /* ^F# */
    Sound(330); Delay(160); /* ^E */
    NoSound();
    return 0;
}