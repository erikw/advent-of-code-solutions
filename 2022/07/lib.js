import { DefaultObject } from "../../utils/commons.js";

const removeLastDir = function (path) {
  return path.replace(/(.*\/)[^/]+\/$/, "$1");
};

const sumUpSizes = function (sizes, sizes_individual, base_path) {
  let path = base_path;
  while (path != "/") {
    path = removeLastDir(path);
    sizes[path] += sizes_individual[base_path];
  }
};

export const dir_sizes_from_terminal_session = function (termsession) {
  const sizes = new DefaultObject(0);

  let path = "/";
  let lineno = 0;

  // ASSUMPTION the user won't ls the same dir more than once.
  while (lineno < termsession.length) {
    if (termsession[lineno].startsWith("$ cd")) {
      const dest = termsession[lineno].split(" ").at(-1);
      switch (dest) {
        case "/":
          path = "/";
          break;
        case "..":
          path = removeLastDir(path);
          break;
        default:
          path += `${dest}/`;
      }
      lineno++;
    } else {
      lineno++;
      while (
        lineno < termsession.length &&
        !termsession[lineno].startsWith("$")
      ) {
        const first = termsession[lineno].split(" ")[0];
        if (first != "dir") {
          sizes[path] += Number.parseInt(first, 10);
        }
        lineno++;
      }
    }
  }

  const sizes_individual = { ...sizes };
  Object.keys(sizes)
    .sort((a, b) => b.length - a.length)
    .forEach((path) => {
      sumUpSizes(sizes, sizes_individual, path);
    });

  return sizes;
};
