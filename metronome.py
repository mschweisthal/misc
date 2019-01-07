#!/usr/bin/python

import sys
import time
from threading import Thread


class Metronome(Thread):

    def __init__(self, bpm, beat_count):
        super().__init__()
        self.bpm = bpm
        self.beat_count = beat_count

    def run(self):
        while True:
            for beat in range(0, self.beat_count):
                print(beat+1)
                sys.stdout.write('\a')
                sys.stdout.flush()
                time.sleep(60.0/self.bpm)
            print('\n')


def main():
    bpm = 120
    beat_count = 4
    metronome = Metronome(bpm, beat_count)
    metronome.start()


if __name__ == '__main__':
    main()
