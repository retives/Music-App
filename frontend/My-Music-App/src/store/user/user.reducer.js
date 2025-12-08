import { createSlice } from '@reduxjs/toolkit';

import * as thunks from './user.thunks';

const getItemFromLocalStorage = (key) => {
  const item = localStorage.getItem(key);
  return item ? JSON.parse(item) : null;
};

/** Initial state of user slice
 * @type {{loading: boolean, isAuthenticated: boolean, isRehydrated: boolean, error: null | string, accessToken: null | string, accessExpiresAt: null | string, refreshToken: null | string, refreshExpiresAt: null | string, isRemembered: boolean | null, displayName: null | string, email: nulll | string }}
 */
const INITIAL_STATE = {
  loading: false,
  isAuthenticated: false,
  isRehydrated: false,
  error: null,
  loginError: null,
  accessToken: null,
  accessExpiresAt: null,
  refreshToken: null,
  refreshExpiresAt: null,
  isRemembered: false,
  credentials: {
    exp: null,
    ruid: null,
    uid: null,
    id: null,
    email: null,
    nickname: null,
    picture: null,
  },
};

export const userSlice = createSlice({
  name: 'user',
  initialState: INITIAL_STATE,
  reducers: {
    rehydrateTokens: (state) => {
      state.isRehydrated = true;
      state.isRemembered = getItemFromLocalStorage('isRemembered');
      if (state.isRemembered) {
        state.accessToken = getItemFromLocalStorage('accessToken');
        state.accessExpiresAt = getItemFromLocalStorage('accessExpiresAt');
        state.refreshToken = getItemFromLocalStorage('refreshToken');
        state.refreshExpiresAt = getItemFromLocalStorage('refreshExpiresAt');
      }
    },
    setIsRemembered: (state, action) => {
      state.isRemembered = action.payload;
    },
    clearError: (state) => {
      state.error = null;
    },
    clearLoginError: (state) => {
      state.loginError = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(thunks.loginUser.pending, thunks.loginUserPending)
      .addCase(thunks.loginUser.fulfilled, thunks.loginUserFulfilled)
      .addCase(thunks.loginUser.rejected, thunks.loginUserRejected)
      .addCase(thunks.refreshUser.pending, thunks.refreshUserPending)
      .addCase(thunks.refreshUser.fulfilled, thunks.refreshUserFulfilled)
      .addCase(thunks.refreshUser.rejected, thunks.refreshUserRejected)
      .addCase(thunks.logoutUser.pending, thunks.logoutUserPending)
      .addCase(thunks.logoutUser.fulfilled, thunks.logoutUserFulfilled)
      .addCase(thunks.logoutUser.rejected, thunks.logoutUserRejected);
  },
});

export const { setIsRemembered, rehydrateTokens, clearError, clearLoginError } =
  userSlice.actions;

export const userReducer = userSlice.reducer;
