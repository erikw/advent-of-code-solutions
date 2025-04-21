#!/usr/bin/env python3
import fileinput
from pprint import pprint
from enum import Enum
from collections import namedtuple, defaultdict


class Direction(Enum):
    RIGHT = 1j
    LEFT = -1j
    UP = -1
    DOWN = 1


class Tile(Enum):
    EMPTY = "."
    MIRROR_SLASH = "/"
    MIRROR_BSLASH = "\\"
    SPLITTER_BAR = "|"
    SPLITTER_DASH = "-"
    ENERGIZED = "#"


DIRECTION_SYM = {
    Direction.RIGHT: ">",
    Direction.LEFT: "<",
    Direction.UP: "^",
    Direction.DOWN: "v",
}


Ray = namedtuple("Ray", ["pos", "dir"])


def read_grid():
    return [l.rstrip("\n") for l in fileinput.input()]


def print_grid(grid):
    print("\n".join(grid))
    print()


def print_grid_rays(grid, grid_rays):
    for row in range(len(grid)):
        for col in range(len(grid[0])):
            pos = complex(row, col)
            if grid[row][col] != Tile.EMPTY.value:
                print(grid[row][col], end="")
            else:
                if len(grid_rays[pos]) == 1:
                    dir = list(grid_rays[pos])[0].dir
                    print(DIRECTION_SYM[dir], end="")
                elif len(grid_rays[pos]) > 1:
                    print(len(grid_rays[pos]), end="")
                else:
                    print(grid[row][col], end="")
        print()
    print()


def print_grid_energized(grid, grid_rays):
    for row in range(len(grid)):
        for col in range(len(grid[0])):
            pos = complex(row, col)
            if len(grid_rays[pos]) > 0:
                print(Tile.ENERGIZED.value, end="")
            else:
                print(Tile.EMPTY.value, end="")
        print()
    print()


def step_ray(grid, grid_rays, ray):
    rays = []
    pos_next = ray.pos + ray.dir.value
    if 0 <= pos_next.real < len(grid) and 0 <= pos_next.imag < len(grid[0]):
        match grid[int(pos_next.real)][int(pos_next.imag)]:
            case Tile.EMPTY.value:
                dir_next = ray.dir
                rays.append(Ray(pos_next, dir_next))
            case Tile.MIRROR_SLASH.value:
                dir_next = Direction(ray.dir.value.conjugate() * -1j)
                rays.append(Ray(pos_next, dir_next))
                #   ^
                # > /   (0, 1) -> (-1, 0)
                #
                # / <   (0, -1) -> (1, 0)
                # v
                #
                #   v
                # < /   (1, 0) -> (0, -1)
                #
                #  / >  (-1, 0) -> (0, 1)
                #  ^
            case Tile.MIRROR_BSLASH.value:
                dir_next = Direction((ray.dir.value.conjugate() * 1j))
                rays.append(Ray(pos_next, dir_next))
                # > \   (0, 1) -> (1, 0)
                #   v
                #
                # ^
                # \ <   (0, -1) -> (-1, 0)
                #
                #   v
                #   \ >  (1, 0) -> (0, 1)
                #
                # < \   (-1, 0) -> (0, -1)
                #   ^
            case Tile.SPLITTER_BAR.value:
                if ray.dir in [Direction.LEFT, Direction.RIGHT]:
                    rays.append(Ray(pos_next, Direction.UP))
                    rays.append(Ray(pos_next, Direction.DOWN))
                else:
                    rays.append(Ray(pos_next, ray.dir))
                #   ^
                # > |   (0, 1) -> (-1, 0), (1, 0)
                #   v
                #
                #  ^
                #  | <   (0, -1) -> (-1, 0), (1, 0)
                #  v
                #
                #   v
                #   |   (1, 0) -> (1, 0)
                #   v
                #
                #   ^
                #   |   (-1, 0) -> (-1, 0)
                #   ^
            case Tile.SPLITTER_DASH.value:
                if ray.dir in [Direction.UP, Direction.DOWN]:
                    rays.append(Ray(pos_next, Direction.LEFT))
                    rays.append(Ray(pos_next, Direction.RIGHT))
                else:
                    rays.append(Ray(pos_next, ray.dir))
                # > - >  (0, 1) -> (0, 1)
                #
                # < - <   (0, -1) -> (0, -1)
                #
                #    v
                #  < - >  (1, 0) -> (0, -1), (0, 1)
                #
                # < - >   (-1, 0) -> (0, -1), (0, 1)
                #   ^
    rays_uniq = list(filter(lambda r: r not in grid_rays[r.pos], rays))
    for ray_uniq in rays_uniq:
        grid_rays[ray_uniq.pos].add(ray_uniq)
    return rays_uniq


def trace_rays(grid):
    rays = [ Ray((0 - 1j), Direction.RIGHT) ] # Start one col outside to account for mirrors/splitters on (0, 0)
    grid_rays = defaultdict(set)  # (x,y) -> set(Ray), Rays going though this position.
    while rays:
        rays_next = []
        for ray in rays:
            rays_next.extend(step_ray(grid, grid_rays, ray))
        rays = rays_next
    return grid_rays


def grid_energized(grid_rays):
    return list(filter(lambda i: len(i[1]) > 0, grid_rays.items()))


def main():
    grid = read_grid()
    # print_grid(grid)

    grid_rays = trace_rays(grid)
    # print_grid_rays(grid, grid_rays)
    # print_grid_energized(grid, grid_rays)

    print(len(grid_energized(grid_rays)))


if __name__ == "__main__":
    main()
