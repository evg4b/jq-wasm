import * as jqWasm from '../libs/jq/jq';

let jqModule = null;

// @ts-ignore
const jqWasmFn = jqWasm.default ?? jqWasm;

const loadModule = (): Promise<any> => {
  return jqModule
    ? Promise.resolve(jqModule)
    : jqWasmFn().then(m => {
      jqModule = m;
      return m;
    });

};

export const jq = (json: string, filter: string): Promise<string> => {
  return loadModule().then(mm => mm.exec(json, filter));
};

