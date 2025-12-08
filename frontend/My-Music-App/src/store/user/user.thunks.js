import { createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';
import { LOGIN_URL, LOGOUT_URL, REFRESH_URL } from '../constants';
import jwt_decode from 'jwt-decode';
import { capitalizeWords } from '../helpers';

const setLocalStorage = (key, value) =>
  localStorage.setItem(key, JSON.stringify(value));

const cleanLocalStorage = () => {
  [
    'accessToken',
    'accessExpiresAt',
    'refreshToken',
    'refreshExpiresAt',
    'isRemembered',
  ].forEach((key) => localStorage.removeItem(key));
};

/** Login Thunk. Accepts user login data and returns a promise with user data.
 * @param {Object} userData - user login data as object {email, password}
 */
export const loginUser = createAsyncThunk('user/login', async (userData) => {
  try {
    const response = await axios.post(LOGIN_URL, userData);
    return response.data;
  } catch (error) {
    throw error.response.data.errors;
  }
});

export const loginUserPending = (state) => {
  state.loading = true;
  state.isAuthenticated = false;
  state.loginError = null;
};

export const loginUserFulfilled = (state, action) => {
  state.loading = false;
  state.isAuthenticated = true;
  state.accessToken = action.payload.access;
  state.accessExpiresAt = action.payload.access_expires_at;
  state.refreshToken = action.payload.refresh;
  state.refreshExpiresAt = action.payload.refresh_expires_at;
  const {
    exp,
    ruid,
    uid,
    user_id: id,
    user_email: email,
    user_nickname: nickname,
    user_picture: picture,
  } = jwt_decode(action.payload.access);

  state.credentials = {
    exp,
    ruid,
    uid,
    id,
    email,
    nickname: capitalizeWords(nickname),
    picture: JSON.parse(picture),
  };

  setLocalStorage('accessToken', state.accessToken);
  setLocalStorage('accessExpiresAt', state.accessExpiresAt);
  setLocalStorage('refreshToken', state.refreshToken);
  setLocalStorage('refreshExpiresAt', state.refreshExpiresAt);
  setLocalStorage('isRemembered', state.isRemembered);
};

export const loginUserRejected = (state, action) => {
  state.loading = false;
  state.isAuthenticated = false;
  state.loginError = action.error.message;
};

export const refreshUser = createAsyncThunk(
  'user/refreshAuth',
  async (_, { getState }) => {
    const refreshToken = getState().user.refreshToken;
    try {
      const response = await axios.post(REFRESH_URL, null, {
        headers: {
          'X-Refresh-Token': `${refreshToken}`,
        },
      });
      return response.data;
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
// TODO: pending status same as login, maybe we can use the same reducer
export const refreshUserPending = (state) => {
  state.loading = true;
  state.isAuthenticated = false;
  state.error = null;
};
export const refreshUserFulfilled = (state, action) => {
  state.loading = false;
  state.isAuthenticated = true;
  state.accessToken = action.payload.access;
  state.accessExpiresAt = action.payload.access_expires_at;
  const {
    exp,
    ruid,
    uid,
    user_id: id,
    user_email: email,
    user_nickname: nickname,
    user_picture: picture,
  } = jwt_decode(action.payload.access);

  state.credentials = {
    exp,
    ruid,
    uid,
    id,
    email,
    nickname: capitalizeWords(nickname),
    picture: JSON.parse(picture),
  };
  setLocalStorage('accessToken', state.accessToken);
  setLocalStorage('accessExpiresAt', state.accessExpiresAt);
};

export const refreshUserRejected = (state, action) => {
  state.loading = false;
  state.isAuthenticated = false;
  state.error = action.error;
  cleanLocalStorage();
};

export const logoutUser = createAsyncThunk(
  'user/logout',
  async (messageObj, { getState }) => {
    const accessToken = getState().user.accessToken;
    const headersList = {
      Accept: '*/*',
      Authorization: `Bearer ${accessToken}`,
    };

    const reqOptions = {
      url: `${LOGOUT_URL}`,
      method: 'DELETE',
      headers: headersList,
    };
    try {
      const response = await axios.request(reqOptions);
      return response.data;
    } catch (error) {
      throw error.response.data.errors;
    }
  }
);
export const logoutUserPending = (state, action) => {
  state.loading = true;
  state.error = null;
};
export const logoutUserFulfilled = (state, action) => {
  state.loading = false;
  state.isAuthenticated = false;
  state.accessToken = null;
  state.accessExpiresAt = null;
  state.refreshToken = null;
  state.refreshExpiresAt = null;
  state.isRemembered = false;
  cleanLocalStorage();
};
export const logoutUserRejected = (state, action) => {
  state.loading = false;
  state.error = action.error;
};
