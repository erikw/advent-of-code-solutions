#!/usr/bin/env python3
import fileinput
from pprint import pprint
from python_mermaid.diagram import MermaidDiagram, Node, Link


MODULE_BUTTON = "button"
MODULE_BROADCASTER = "broadcaster"
MODULE_FINAL = "rx"

STATE_ON = True
STATE_OFF = False

TYPE_UNTYPED = '-'
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
    pprint(mod_conf)

    nodes = {
        MODULE_FINAL: Node(MODULE_FINAL, f'{TYPE_UNTYPED}{MODULE_FINAL}')
    }
    links = []
    for name, module in mod_conf.items():
        nodes[name] = Node(name, f'{module["type"]}{name}')

    for name, module in mod_conf.items():
        for dest_name in module["dest_names"]:
            links.append(Link(nodes[name], nodes[dest_name]))

    chart = MermaidDiagram(
        title="Module Configuration",
        nodes=nodes.values(),
        links=links
    )
    print(chart) # Paste output at https://mermaid.live/
    # More specifically accessible here:
    # https://mermaid.live/edit#pako:eNptVrmS2zoQ_BUVqqxI2lpJK-2agRM7deTM5gtI8RIPkIIgFq2t_ffXMwMQdNlZNwgM5uoB39W5z3IVqe12G2t7sW0erb732b3NV197XVzKu0nspdex5h2lSYZqFWsz_YrV1kyx-i_W6d3aXtOCIF4cUyx8GlMmA5NBSGlB1qVlUtX0paqZPDIij0y-GP5imJiSiCmZ2IKILcT0wKYHuXTiS8Uty8QK0RURXTG5nYnczkzOTM5CrOYzEkLBpgsxXfG2SrYZjse44PjLIF9S0yfZObnZ3HBCApUI2f5D7OsbJULfhLAVLVY6jrCTCKeRyDTKzZwvI_mynBUrWSnZ21K8rR9E6oeQlkkrKSK_1qO4U1-J1FcmDZ1ZN3Km5EtLubRkd0pxJ2OSCWnIwKdGDLQNkbaRe25cCgmutfxFSq5bDlvc6bjKncsOm34ULpNEUld_Nm3E9JW3XWWbYUeNONrypa1cWnRcvk6qTAbWZzFQ8JlCzljOm3UNxG0ySptURNaVkJbz1oo7DW9r5EvKBlIx0HJ92nohjBWU82W17ASIQxbhD7QhGAWGNASjIlCGYORzxvAFIhGMwKCRsG5KwYgECgn2PYYQIBbBKMuM6ew4CUZVIRvBqMmMyY6u3NmJBBTWPYbUoaWw7jF6FbISjOaaMboBCnN7UhJY2GNcTqCNGUMNkJq7q_pDaS7A4h-L6J-_F6G_vxchPcgz-OAx2gRKFYwJNmO0wozTBca8mHG5xAs70CIEH_I_45q0H2L3mOxMY1j3uKG61yHnHmO0YTi49TPNhuB__XD-1wGTzboN_o8m9GF9dTWaaES4BBYBQ8gzzhbrlGSPx8VZzGBMl5CHsgg2Pab8Zz52sul8wJjHlAl58xhPBgaOqwXtcTrCJJgx2dRtiKtzMeJRweARfOUWCvXymPtwce-MDU2jYN9jPCAYTM5-EzD77PzEUzJjOlt0Dl9pWgUte4yRPWM8NmFPGXC32ENy8JhiLMaQf49Zj0OwOVahlzwm-1UV5obH5KfHeMxnTDrymOriMc2rdtFXTRVy6zEeLIzTkCuPMd4xWf1-tVGluWQqsuaeb1SXmy4hqt5jvVrFylZ5l8cqAswSejNi_YEzQ6J_9n3nj5n-XlYqKpL2BnYfssTm3y4J_nDmLcnd9j9-6_N8JNdZbr72d21VtNsd2KaK3tWkou3u7fXp-Hx4Ox1f97vDaaN-q2j__PS2-_z6utudDi-HE7Z8bNSDndg_HY6n0_7t8-748rw_vJyOG5VnF9ub7_JHxj9mH_8DJh0Aag



if __name__ == '__main__':
	main()
