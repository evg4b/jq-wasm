class IO {
  stdinBuffer = [];
  stdoutBuffer = [];
  stderrBuffer = [];

  encoder = new TextEncoder()
  decoder = new TextDecoder()

  stdinCursor = 0;

  constructor() {
    this.stdin = this.stdin.bind(this)
    this.stdout = this.stdout.bind(this)
    this.stderr = this.stderr.bind(this)
  }

  loadStdin(text) {
    this.stdinBuffer = this.encoder.encode(text)
    this.stdinCursor = 0
  }

  stdin() {
    if (this.stdinCursor < this.stdinBuffer.length) {
      return this.stdinBuffer[this.stdinCursor++];
    }

    return null
  }

  stdout(char) {
    if (char) {
      this.stdoutBuffer.push(char)
    }
  }

  loadStdout() {
    return this._load(this.stdoutBuffer);
  }

  stderr(char) {
    if (char) {
      this.stderrBuffer.push(char)
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
    return this.decoder.decode(new Uint8Array(buffer))
      .trim();
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
          reject(new Error(io.loadStderr()))
        } else {
          resolve(io.loadStdout())
        }
      } catch (error) {
        reject(error);
      } finally {
        io.flush();
      }
    });
  }
});

