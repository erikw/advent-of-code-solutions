#!/usr/bin/env python3
import fileinput
from collections import deque
import math


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
        MODULE_BUTTON: {"type": TYPE_UNTYPED, "dest_names": [MODULE_BROADCASTER], "input_names": []},
        MODULE_FINAL: {"type": TYPE_UNTYPED, "dest_names": [], "input_names": []},
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
            mod_conf[name] = {"type": type, "dest_names": destination_names, "input_names": []}
        elif type == TYPE_FLIPFLOP:
            mod_conf[name] = {"type": type, "dest_names": destination_names, "state": STATE_OFF, "input_names": []}
        elif type == TYPE_CONJUNCTION:
            mod_conf[name] = {"type": type, "dest_names": destination_names, "input_mem": {}, "input_names": []}

    for name in mod_conf:
        for dest_name in mod_conf[name]["dest_names"]:
            if dest_name in mod_conf and mod_conf[dest_name]["type"] == TYPE_CONJUNCTION:
                mod_conf[dest_name]["input_mem"][name] = PULSE_LOW
            if dest_name in mod_conf:
                mod_conf[dest_name]["input_names"].append(name)

    return mod_conf


def find_min_presses(mod_conf):
    """
    # h/t https://www.reddit.com/r/adventofcode/comments/18mmfxb/comment/ke5a5fc/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    # With manual analysis of output from mermaid.py, it is concluded that for my input:
    # * rx is connected as: [&lr, &nl, &vr, &gt] -> &jq -> rx
    # * further it can be seen that those earlier 4 conjunctions all go to a different sub graph, namely the 4 subgraphs branching from module broadcaster.
    # * assume those sub-graphs have their own cycles, and that the first time a low input arrives at them, the number of presses up til that point is the cycle (this is universaily not the case, as the presses leading up to the first low signal could be an init sequence before the network has stabilized). Why low signal? Because all last nodes are inverters 4& -> 1& -> rx, meaning low to first level mean low to rx.
    # * thus period(rx) = lcd(period(&lr), period(&nl), period(&vr), period(&jq))
    """
    assert len(mod_conf[MODULE_FINAL]["input_names"]) == 1
    module_prev = mod_conf[MODULE_FINAL]["input_names"][0]

    assert len(mod_conf[module_prev]["input_names"]) == 4
    modules_pprev = mod_conf[module_prev]["input_names"]

    presses = 0
    periods = {}
    while len(periods) < len(modules_pprev):
        presses += 1

        final_mod_pulses = [0, 0]
        pulses = deque([(MODULE_BUTTON, PULSE_LOW, MODULE_BROADCASTER)])

        while pulses:
            name_from, pulse, name_to = pulses.popleft()

            if name_to in modules_pprev and pulse == PULSE_LOW and name_to not in periods:
                periods[name_to] = presses

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


    return math.lcm(*periods.values())

def main():
    mod_conf = read_module_configuration()
    presses = find_min_presses(mod_conf)
    print(presses)

if __name__ == '__main__':
	main()
