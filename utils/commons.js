// Common JavaScript helpers
// NOTE arrow functions does not bind 'this': https://www.w3schools.com/js/js_arrow_function.asp
//
// Import like this:
// * Just prototypes
//   import "../../utils/commons.js";
// * classes
//   import { DefaultObject } from "../../utils/commons.js";

// ===== Object =====
// Filter on key/value like Array.filter.
// Ref: https://stackoverflow.com/a/37616104/265508
Object.filter = function (obj, predicate) {
  return Object.fromEntries(Object.entries(obj).filter(predicate));
};

// ===== Array =====
// Ref: https://stackoverflow.com/a/10249772/265508
Array.prototype.eachSlice = function (size, callback) {
  for (var i = 0, l = this.length; i < l; i += size) {
    callback.call(this, this.slice(i, i + size));
  }
};

// Ref: https://stackoverflow.com/a/57477913/265508
Array.prototype.eachCons = function (num) {
  return Array.from({ length: this.length - num + 1 }, (_, i) =>
    this.slice(i, i + num)
  );
};

// Ref: https://stackoverflow.com/a/17428705/265508
Array.prototype.transpose = function () {
  return this[0].map((x, i) => this.map((y) => y[i]));
};

// ===== Set =====
Set.prototype.intersection = function (other) {
  return new Set([...this].filter((e) => other.has(e)));
};

// A map/dict/hash with default value.
// Ref: https://stackoverflow.com/a/44622467/265508
export class DefaultObject {
  constructor(defaultVal) {
    return new Proxy(
      {},
      {
        get: (target, name) => (name in target ? target[name] : defaultVal),
      }
    );
  }
}
