// Common JavaScript helpers

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

// ===== Set =====
Set.prototype.intersection = function (other) {
  return new Set([...this].filter((e) => other.has(e)));
};
