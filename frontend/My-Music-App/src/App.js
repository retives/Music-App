import React, { useEffect } from 'react';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

import { RouterProvider } from 'react-router-dom';

import { rehydrateTokens } from './store/user/user.reducer';
import { refreshUser } from './store/user/user.thunks';
import { userSelector } from './store/user/user.selector';
import { useDispatch, useSelector } from 'react-redux';
import router from './router/router';

import './App.css';

const HALF_HOUR = 30 * 60 * 1000;

function App() {
  const dispatch = useDispatch();
  const {
    isRemembered,
    isAuthenticated,
    isRehydrated,
    accessToken,
    accessExpiresAt,
    refreshToken,
    refreshExpiresAt,
    loading,
  } = useSelector(userSelector);

  const refreshTimer = React.useRef(null);

  useEffect(() => {
    if (!isRehydrated) dispatch(rehydrateTokens());
  }, [dispatch, isRehydrated]);

  useEffect(() => {
    if (!isRemembered || !isRehydrated) return; // if user is not remembered, or rehydration not ready then we dont need to check anything related to login

    if (!refreshToken || !refreshExpiresAt) return; // if we dont have refresh token, then we can`t refresh access token and can`t login

    const isRefreshExpied = refreshToken
      ? new Date(refreshExpiresAt) < new Date()
      : true;
    if (isRefreshExpied) return; // if refresh token is expired, then we can`t refresh access token and can`t login

    const isAccessExpied = accessToken
      ? new Date(accessExpiresAt) < new Date()
      : true;

    if (isAccessExpied && !isAuthenticated) {
      dispatch(refreshUser()); // if access token is expired, then we need to refresh it, but if user is already authenticated, then we dont need to refresh it
      return;
    }
    // login if all good (both tokens are valid and user is not authenticated)
    if (!isAccessExpied && !isAuthenticated) {
      dispatch(refreshUser());
    }
  }, [
    accessExpiresAt,
    accessToken,
    dispatch,
    isAuthenticated,
    refreshExpiresAt,
    refreshToken,
    isRemembered,
    isRehydrated,
  ]);

  useEffect(() => {
    if (!isAuthenticated || !isRehydrated || loading) return;
    refreshTimer.current = setInterval(() => {
      dispatch(refreshUser());
    }, HALF_HOUR);

    return () => {
      clearInterval(refreshTimer.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isAuthenticated, isRehydrated, loading]);

  return (
    <div className='App'>
      <RouterProvider router={router} />
      <ToastContainer />
    </div>
  );
}
export default App;
