export function isUserLogged() {
  return localStorage.getItem('token') != null;
}