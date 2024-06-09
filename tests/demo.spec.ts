// @ts-expect-error
import { jq } from '../dist';

it('should export jq function', () => expect(jq).toBeDefined());

const a = `{ "demo": "123" }`;
const filter = `.demo`;

it('should export jq as function', async () => {
  const res = await jq(a, filter);
  expect(res).toEqual('"123"');
});
