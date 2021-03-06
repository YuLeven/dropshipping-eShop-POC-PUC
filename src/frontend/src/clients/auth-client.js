import ApolloClient from "apollo-boost";

const headers = () => {
  const token = localStorage.getItem("token");
  return token ? { authorization: `Bearer ${token}` } : {};
};

const authClient = new ApolloClient({
  uri: process.env.REACT_APP_AUTH_URL,
  fetchOptions: {
    credentials: "include"
  },
  request: async operation => {
    operation.setContext({
      headers: headers()
    });
  }
});

export default authClient;
