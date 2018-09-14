export function truncateString(string, length) {
  return (string.length > length) ?
    `${string.substr(0, length - 1)}...` :
    string;
}