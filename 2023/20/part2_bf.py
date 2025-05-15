#!/usr/bin/env python3
import fileinput
from pprint import pprint
from collections import deque
from math import prod


MODULE_BUTTON = "button"
MODULE_BROADCASTER = "broadcaster"
MODULE_FINAL = "rx"

STATE_ON = True
STATE_OFF = False

TYPE_UNTYPED = 'u'
TYPE_FLIPFLOP = '%'
TYPE_CONJUNCTION = '&'

PULSE_HIGH = True
PULSE_LOW = False


def read_module_configuration():
    mod_conf = {
        MODULE_BUTTON: {"type": TYPE_UNTYPED, "dest_names": [MODULE_BROADCASTER]}
    }
    for line in fileinput.input():
        part_name, part_destinations = line.rstrip("\n").split(" -> ")

        if part_name[0] in [TYPE_FLIPFLOP, TYPE_CONJUNCTION]:
            type = part_name[0]
            name = part_name[1:]
        else:
            type = TYPE_UNTYPED
            name = part_name
        destination_names = part_destinations.split(", ")

        if type == TYPE_UNTYPED:
            mod_conf[name] = {"type": type, "dest_names": destination_names}
        elif type == TYPE_FLIPFLOP:
            mod_conf[name] = {"type": type, "dest_names": destination_names, "state": STATE_OFF}
        elif type == TYPE_CONJUNCTION:
            mod_conf[name] = {"type": type, "dest_names": destination_names, "input_mem": {}}

    for name in mod_conf:
        for dest_name in mod_conf[name]["dest_names"]:
            if dest_name in mod_conf and mod_conf[dest_name]["type"] == TYPE_CONJUNCTION:
                mod_conf[dest_name]["input_mem"][name] = PULSE_LOW

    return mod_conf


def push_button(mod_conf):
    final_mod_pulses = [0, 0]
    pulses = deque([(MODULE_BUTTON, PULSE_LOW, MODULE_BROADCASTER)])

    while pulses:
        name_from, pulse, name_to = pulses.popleft()
        # print(f"{name_from} -{"high" if pulse else "low"}-> {name_to}")

        if name_to == MODULE_FINAL:
            final_mod_pulses[bool(pulse)] += 1

        if name_to not in mod_conf:
            continue

        module = mod_conf[name_to]
        if module["type"] == TYPE_UNTYPED:
            for dest_name in module["dest_names"]:
                pulses.append((name_to, pulse, dest_name))
        elif module["type"] == TYPE_FLIPFLOP:
            if pulse == PULSE_LOW:
                module["state"] = not module["state"]
                pulse_out = module["state"]
                for dest_name in module["dest_names"]:
                    pulses.append((name_to, pulse_out, dest_name))
        elif module["type"] == TYPE_CONJUNCTION:
            module["input_mem"][name_from] = pulse
            pulse_out = PULSE_LOW if all(module["input_mem"].values()) else PULSE_HIGH
            for dest_name in module["dest_names"]:
                pulses.append((name_to, pulse_out, dest_name))


    return final_mod_pulses

def main():
    mod_conf = read_module_configuration()

    seen = set()
    presses = 0
    final_mod_pulses = [0, 0]
    while final_mod_pulses != [1, 0]:
        final_mod_pulses = push_button(mod_conf)
        presses += 1

        hash = []
        for name, module in mod_conf.items():
            if module["type"] == TYPE_UNTYPED:
                state = TYPE_UNTYPED
            elif module["type"] == TYPE_FLIPFLOP:
                state = str(module["state"])
            elif module["type"] == TYPE_CONJUNCTION:
                # state = ",".join(f"{k}:{v}" for k, v, in module["input_mem"].items())
                state = ",".join(f"{k}:{module["input_mem"][k]}" for k in sorted(module["input_mem"]))

            hash.append(f"{name}_{state}|")
        hash = "".join(hash)
        # print(hash)
        if hash in seen:
            # NOTE we're not even getting to a cycle before program gets SIGTERM'd.
            print(f"cycle found after {presses} button presses")
        seen.add(hash)

    print(presses)

if __name__ == '__main__':
	main()
