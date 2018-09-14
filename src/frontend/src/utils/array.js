export function chunkArray(array, size) {
  const chunckedArray = [];

  for (let index = 0; index < array.length; index += size) {
    chunckedArray.push(array.slice(index, index + size));
  }

  return chunckedArray;
}