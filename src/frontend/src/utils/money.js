export function formatMoney(string) {
  return '$' + parseFloat(string).toFixed(2);
}

export function formatCCValue(value) {
  let v = value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
  let matches = v.match(/\d{4,16}/g);
  let match = (matches && matches[0]) || '';
  let parts = [];

  for (let i = 0, len = match.length; i < len; i += 4) {
    parts.push(match.substring(i, i + 4));
  }

  if (!parts.length) return value;
  return parts.join(' ');
}