export function formatMoney(string) {
  return '$' + parseFloat(string).toFixed(2);
}