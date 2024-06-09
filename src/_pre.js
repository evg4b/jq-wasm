function _defineProperty(e, r, t) { return (r = _toPropertyKey(r)) in e ? Object.defineProperty(e, r, { value: t, enumerable: !0, configurable: !0, writable: !0 }) : e[r] = t, e; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == typeof i ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != typeof t || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != typeof i) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
class IO {
  constructor() {
    _defineProperty(this, "stdinBuffer", []);
    _defineProperty(this, "stdoutBuffer", []);
    _defineProperty(this, "stderrBuffer", []);
    _defineProperty(this, "encoder", new TextEncoder());
    _defineProperty(this, "decoder", new TextDecoder());
    _defineProperty(this, "stdinCursor", 0);
    this.stdin = this.stdin.bind(this);
    this.stdout = this.stdout.bind(this);
    this.stderr = this.stderr.bind(this);
  }
  loadStdin(text) {
    this.stdinBuffer = this.encoder.encode(text);
    this.stdinCursor = 0;
  }
  stdin() {
    if (this.stdinCursor < this.stdinBuffer.length) {
      return this.stdinBuffer[this.stdinCursor++];
    }
    return null;
  }
  stdout(char) {
    if (char) {
      this.stdoutBuffer.push(char);
    }
  }
  loadStdout() {
    return this._load(this.stdoutBuffer);
  }
  stderr(char) {
    if (char) {
      this.stderrBuffer.push(char);
    }
  }
  loadStderr() {
    return this._load(this.stderrBuffer);
  }
  flush() {
    this.stdinBuffer = [];
    this.stdoutBuffer = [];
    this.stderrBuffer = [];
    this.stdinCursor = 0;
  }
  _load(buffer) {
    return this.decoder.decode(new Uint8Array(buffer)).trim();
  }
}
const io = new IO();
Object.assign(Module, {
  noInitialRun: true,
  noExitRuntime: true,
  io: io,
  preRun: () => {
    FS.init(io.stdin, io.stdout, io.stderr);
  },
  exec(input, filter) {
    return new Promise((resolve, reject) => {
      try {
        io.loadStdin(input);
        callMain([filter]);
        if (EXITSTATUS) {
          reject(new Error(io.loadStderr()));
        } else {
          resolve(io.loadStdout());
        }
      } catch (error) {
        reject(error);
      } finally {
        io.flush();
      }
    });
  }
});
