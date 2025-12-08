import { store } from '../store/store';

/**
 * @deprecated Use redux store instead, redux thunk check and refresh tokens and cookies at app loading, see My-Music-App/src/App.js
 * Currently this function return auth state of user, and if user is authenticated, it sets loggedStatus to true and redirects to home page
 */
export const isLoggedIn = async (loggedStatus, setLoggedStatus, navigate) => {
  const storeState = store.getState();

  // There is result from checking else, because if thunk cannot refresh tokens, it will throw an error at initial app loading
  if (storeState.user.isAuthenticated) {
    setLoggedStatus(true);
    navigate('/');
  } else {
    setLoggedStatus(false);
  }
};
