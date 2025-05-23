// Common JavaScript helpers
// NOTE arrow functions does not bind 'this': https://www.w3schools.com/js/js_arrow_function.asp
//
// Import like this:
// * Just prototypes:
//import "../../utils/commons.js";
// * prototypes + exports (classes, functions):
//import { DefaultObject } from "../../utils/commons.js";

// ===== Object =====
// Filter on key/value like Array.filter.
// Ref: https://stackoverflow.com/a/37616104/265508
Object.filter = function (obj, predicate) {
  return Object.fromEntries(Object.entries(obj).filter(predicate));
};

Object.prototype.values = function () {
  return Object.values(this);
};

Object.prototype.keys = function () {
  return Object.keys(this);
};

Object.prototype.entries = function () {
  return Object.entries(this);
};

// ===== Number =====

// Inclusive range check.
Number.prototype.inRange = function (a, b) {
  return this >= a && this <= b;
};

Number.prototype.abs = function () {
  return Math.abs(this);
};

Number.prototype.floor = function () {
  return Math.floor(this);
};

Number.prototype.ceil = function () {
  return Math.ceil(this);
};

// ===== Array =====
// Ref: https://stackoverflow.com/a/10249772/265508
Array.prototype.eachSlice = function (size, callback) {
  for (let i = 0, l = this.length; i < l; i += size) {
    callback.call(this, this.slice(i, i + size));
  }
};

// Ref: https://stackoverflow.com/a/57477913/265508
//Array.prototype.eachCons = function (num) {
//  return Array.from({ length: this.length - num + 1 }, (_, i) =>
//    this.slice(i, i + num)
//  );
//};
Array.prototype.eachCons = function (num, callback) {
  for (let i = 0; i < this.length - num + 1; i++) {
    callback.call(this, this.slice(i, i + num));
  }
};

// Ref: https://stackoverflow.com/a/17428705/265508
Array.prototype.transpose = function () {
  return this[0].map((x, i) => this.map((y) => y[i]));
};

// Ref: https://stackoverflow.com/a/1669222
Array.prototype.max = function () {
  return Math.max.apply(null, this);
};

// Ref: https://stackoverflow.com/a/1669222
Array.prototype.min = function () {
  return Math.min.apply(null, this);
};

Array.prototype.minmax = function () {
  return [this.min(), this.max()];
};

// Count number of element for which the predicate is true.
Array.prototype.count = function (predicate) {
  return this.filter(predicate).length;
};

// Sum elements.
Array.prototype.sum = function () {
  return this.reduce((sum, e) => sum + e, 0);
};

// Multiply elements.
Array.prototype.mul = function () {
  return this.reduce((prod, e) => prod * e, 1);
};

// ===== Set =====
Set.prototype.intersection = function (other) {
  return new Set([...this].filter((e) => other.has(e)));
};

// ===== Classes =====
// An object with default value.
// Ref: https://stackoverflow.com/a/44622467/265508
export class DefaultObject {
  constructor(defaultValue) {
    return new Proxy(
      {},
      {
        get: (target, name) => (name in target ? target[name] : defaultValue),
      }
    );
  }
}

// A map with default value.
// Modified https://stackoverflow.com/a/51321724/265508
// that does not populate all keys that were unset when getting.
export class DefaultMap extends Map {
  constructor(defaultFunc, entries) {
    super(entries);
    this.default = defaultFunc;
  }

  get(key) {
    return this.has(key) ? super.get(key) : this.default();
  }
}

// ===== Utility functions =====

// Create integer range with start (inclusive), end (exclusive)
// Ref: https://stackoverflow.com/a/44957114/265508
export const range = (start, stop, step = 1) =>
  Array(Math.ceil((stop - start) / step))
    .fill(start)
    .map((x, y) => x + y * step);

// Repeated function invocations.
export const repeat = function (times, func) {
  for (let t = 0; t < times; t++) {
    func(t);
  }
};
